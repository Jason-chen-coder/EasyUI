import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

/// 反向代理事件，用于 [LocalhostProxyRule.onEvent] / [LocalhostServerManager] 的可观测回调。
/// 成功时 [errorType] 为 null、[statusCode] 为 upstream 真实状态码；失败时 [statusCode] 为
/// 网关返回给 H5 的状态码（502 / 504）。
class LocalhostProxyEvent {
  final String requestPath;
  final Uri upstreamUri;
  final int? statusCode;

  /// `'timeout'` / `'socket'` / `'other'`，成功时为 null。
  final String? errorType;
  final String? errorMessage;
  final int durationMs;

  const LocalhostProxyEvent({
    required this.requestPath,
    required this.upstreamUri,
    required this.durationMs,
    this.statusCode,
    this.errorType,
    this.errorMessage,
  });

  bool get isSuccess => errorType == null;

  @override
  String toString() =>
      'LocalhostProxyEvent($requestPath → $upstreamUri, '
      'status=$statusCode, error=$errorType, ${durationMs}ms)';
}

/// 反向代理规则：把命中 [prefix] 的请求转发到 [target]。
///
/// 路径策略（互斥，[stripPrefix] 与 [pathRewrite] 不能同时指定）：
/// - 默认（保留前缀）：`/api/users` → `${target}/api/users`
/// - [stripPrefix]: true：`/api/users` → `${target}/users`
/// - [pathRewrite]: '/v2'：`/api/users` → `${target}/v2/users`
class LocalhostProxyRule {
  /// 路径前缀，必须以 '/' 开头；匹配 `path == prefix` 或 `path.startsWith('$prefix/')`。
  final String prefix;

  /// upstream 基址（如 `https://api.example.com`），末尾 '/' 会被规范化掉。
  final String target;

  /// 转发时附加/覆盖的请求头（如 Authorization、X-Tenant 等）。
  final Map<String, String>? headers;

  /// 注入到响应头的 key/value，在转发上游响应头之后 set，会覆盖同名头。
  final Map<String, String>? responseHeaders;

  /// 整体超时（覆盖 `openUrl` 与 `close`，即连接 + 读响应头阶段）。
  final Duration timeout;

  /// 响应体 idle 超时：上游建连成功但写 body 阶段长时间无数据时触发。
  /// 默认 null = 与 [timeout] 一致；显式设为 `Duration.zero` 表示不启用 idle 检测。
  final Duration? idleTimeout;

  /// true → 转发到 upstream 时去掉 [prefix]。与 [pathRewrite] 互斥。
  final bool stripPrefix;

  /// 把 [prefix] 替换为指定路径再拼到 upstream。与 [stripPrefix] 互斥。
  final String? pathRewrite;

  /// 允许 upstream HTTPS 自签名证书。⚠️ 仅限开发环境内网调试，生产请保持 false。
  final bool allowSelfSignedCert;

  /// 单条规则维度的事件回调；与 [H5WebView.onProxyEvent] 同时存在时，rule 级先调用。
  final void Function(LocalhostProxyEvent event)? onEvent;

  const LocalhostProxyRule({
    required this.prefix,
    required this.target,
    this.headers,
    this.responseHeaders,
    this.timeout = const Duration(seconds: 30),
    this.idleTimeout,
    this.stripPrefix = false,
    this.pathRewrite,
    this.allowSelfSignedCert = false,
    this.onEvent,
  });

  /// 稳定 JSON 签名，用于 LocalhostServerManager 比较"是否同配置"。
  /// 用 JSON 而非手拼，避免 header value 含 `|` `;` 等分隔符导致碰撞。
  /// 注意：[onEvent] 是回调引用，不参与签名（业务层切换回调不应触发 server 重启）。
  String _signature() {
    final sortedHeaders =
        headers == null
            ? null
            : (Map<String, String>.fromEntries(
              (headers!.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key))),
            ));
    final sortedRespHeaders =
        responseHeaders == null
            ? null
            : (Map<String, String>.fromEntries(
              (responseHeaders!.entries.toList()
                ..sort((a, b) => a.key.compareTo(b.key))),
            ));
    return jsonEncode({
      'prefix': prefix,
      'target': target,
      'headers': sortedHeaders,
      'responseHeaders': sortedRespHeaders,
      'timeoutMs': timeout.inMilliseconds,
      'idleTimeoutMs': idleTimeout?.inMilliseconds,
      'stripPrefix': stripPrefix,
      'pathRewrite': pathRewrite,
      'allowSelfSignedCert': allowSelfSignedCert,
    });
  }
}

class LocalhostServerManager {
  LocalhostServerManager._();
  static final LocalhostServerManager _instance = LocalhostServerManager._();
  factory LocalhostServerManager() => _instance;

  static LocalhostServerManager get instance => _instance;

  /// 创建独立（非单例）实例：用于多个 H5 路径前缀冲突（如都用 `/api/*`）但需分别转发到
  /// 不同 upstream 的场景。调用方负责调用 [stop]，否则会泄漏端口。
  factory LocalhostServerManager.isolated() => LocalhostServerManager._();

  HttpServer? _server;
  bool _running = false;
  int _port = 8080;

  /// assets 模式 document root（如 `assets/h5`），通过 rootBundle 加载。
  String? _assetsDocumentRoot;

  /// 文件系统模式 document root，直接从磁盘读。
  String? _fileSystemDocumentRoot;

  /// 反代规则，已按 prefix 长度倒序，匹配时"最长前缀优先"。
  List<LocalhostProxyRule> _proxyRules = const [];

  /// 复用的 HttpClient：首次启动时创建，[stop] 时关闭。
  HttpClient? _httpClient;

  /// 启动本地服务器：同时支持 assets / 文件系统静态资源，以及反代规则。
  ///
  /// - [assetsDocumentRoot]：Flutter assets 路径（如 `assets/h5`），用 rootBundle 读
  /// - [fileSystemDocumentRoot]：文件系统目录路径，直接读磁盘；与 assets 二选一，**优先级更高**
  /// - [port]：偏好端口（默认 8080），不可用时自动顺延邻近端口
  /// - [proxyRules]：反代规则，命中前缀的请求转发到对应 upstream（最长前缀优先），
  ///   未命中走静态文件分支
  ///
  /// 返回 base URL（如 `http://127.0.0.1:8080`）。
  Future<String> start({
    String? assetsDocumentRoot,
    String? fileSystemDocumentRoot,
    int port = 8080,
    List<LocalhostProxyRule>? proxyRules,
  }) async {
    final normalizedRules = _normalizeProxyRules(proxyRules);
    final newProxySig = _proxyRulesSignature(normalizedRules);

    // 同配置复用：proxy 签名 + document root 都一致时直接返回。
    if (_running) {
      final sameProxy = _proxyRulesSignature(_proxyRules) == newProxySig;
      if (sameProxy) {
        if (fileSystemDocumentRoot != null &&
            _fileSystemDocumentRoot == fileSystemDocumentRoot) {
          return baseUrl;
        }
        if (assetsDocumentRoot != null &&
            _fileSystemDocumentRoot == null &&
            _assetsDocumentRoot == assetsDocumentRoot) {
          return baseUrl;
        }
      }
      await stop();
    }

    // 文件系统优先于 assets。
    if (fileSystemDocumentRoot != null) {
      final directory = Directory(fileSystemDocumentRoot);
      if (!await directory.exists()) {
        _log(
          'start() rejected: directory does not exist ($fileSystemDocumentRoot)',
          isError: true,
        );
        throw Exception('Directory does not exist: $fileSystemDocumentRoot');
      }
      _fileSystemDocumentRoot = fileSystemDocumentRoot;
      _assetsDocumentRoot = null;
    } else if (assetsDocumentRoot != null) {
      _assetsDocumentRoot = assetsDocumentRoot;
      _fileSystemDocumentRoot = null;
    } else {
      _log(
        'start() rejected: neither assetsDocumentRoot nor fileSystemDocumentRoot provided',
        isError: true,
      );
      throw Exception(
        'Either assetsDocumentRoot or fileSystemDocumentRoot must be provided',
      );
    }

    _proxyRules = normalizedRules;
    if (_proxyRules.isNotEmpty) {
      _httpClient = _buildHttpClient(_proxyRules);
    }

    // 端口策略：preferred → 邻近端口（pre-check 后逐个 bind）→ ephemeral 兜底。
    if (await _tryStartServer(port)) {
      _log("Successfully started on preferred port $port");
      return baseUrl;
    }

    final int nextAvailablePort = await _findAvailablePort(
      preferred: port + 1,
      range: 19,
    );

    final portsToTry = <int>[nextAvailablePort];
    for (int i = 1; i <= 9; i++) {
      final candidate = nextAvailablePort + i;
      if (candidate != port) {
        // preferred 已试过。
        portsToTry.add(candidate);
      }
    }

    for (final candidate in portsToTry) {
      if (await _tryStartServer(candidate)) {
        _log(
          "Successfully started on port $candidate (preferred: $port was unavailable)",
        );
        return baseUrl;
      }
    }

    // 兜底：让 OS 分配 ephemeral port。
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _server = server;
      _port = server.port;
      _running = true;
      _startRequestHandler(server);
      _log(
        "Started on ephemeral port $_port (mode: ${_fileSystemDocumentRoot != null ? 'file system' : 'assets'})",
      );
      return baseUrl;
    } catch (e) {
      _running = false;
      _server = null;
      _log("Failed to start on ephemeral port: $e", isError: true);
      rethrow;
    }
  }

  /// 文件系统模式启动的向后兼容包装。
  Future<String> startFileSystemServer(
    String directoryPath, {
    int port = 8080,
  }) async {
    return start(fileSystemDocumentRoot: directoryPath, port: port);
  }

  /// 尝试在指定端口绑定，失败返回 false。
  Future<bool> _tryStartServer(int port) async {
    try {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      _server = server;
      _port = port;
      _running = true;
      _startRequestHandler(server);
      _log(
        "Started on port $port (mode: ${_fileSystemDocumentRoot != null ? 'file system' : 'assets'})",
      );
      return true;
    } catch (e) {
      _log("Port $port unavailable: $e", isError: true);
      return false;
    }
  }

  /// 注册统一请求分发：CORS 预检 → 路径穿越守卫 → 反代 → 静态文件。
  void _startRequestHandler(HttpServer server) {
    server.listen((HttpRequest request) async {
      try {
        // CORS preflight。
        if (request.method == 'OPTIONS') {
          request.response
            ..statusCode = HttpStatus.ok
            ..headers.add('Access-Control-Allow-Origin', '*')
            ..headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            ..headers.add('Access-Control-Allow-Headers', 'Content-Type')
            ..close();
          return;
        }

        // 路径穿越守卫，必须在代理匹配之前：否则 `/api/../admin` 会先命中 `/api` 前缀被
        // 原样转给 upstream，upstream 解析归一化成 `/admin` 即绕过"只代理 /api"。
        // pathSegments 已 URL 解码，能挡 `%2e%2e` 这类编码绕过。
        if (request.uri.pathSegments.contains('..')) {
          request.response
            ..statusCode = HttpStatus.forbidden
            ..write('Forbidden: Path traversal not allowed')
            ..close();
          return;
        }

        // 反代命中即转发，不走静态文件分支。
        final proxyRule = _matchProxyRule(request.uri.path);
        if (proxyRule != null) {
          await _handleProxyRequest(request, proxyRule);
          return;
        }

        final requestedPath = request.uri.path;
        final relativePath = Uri.decodeComponent(
          requestedPath.startsWith('/')
              ? requestedPath.substring(1)
              : requestedPath,
        );
        // 上面的守卫已挡住 .. 段；这里仅做斜杠归一化。
        final safePath = path.normalize(relativePath);

        if (_fileSystemDocumentRoot != null) {
          await _handleFileSystemRequest(request, safePath);
        } else if (_assetsDocumentRoot != null) {
          await _handleAssetsRequest(request, safePath);
        } else {
          request.response
            ..statusCode = HttpStatus.internalServerError
            ..write('Server not configured')
            ..close();
        }
      } catch (e) {
        _log("Request handling error: $e", isError: true);
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('Internal server error: $e')
          ..close();
      }
    });
  }

  /// 规范化规则：去掉 prefix / target 末尾斜杠，校验路径策略互斥与 pathRewrite 形态，
  /// 按 prefix 长度倒序（最长前缀优先匹配）。
  List<LocalhostProxyRule> _normalizeProxyRules(
    List<LocalhostProxyRule>? rules,
  ) {
    if (rules == null || rules.isEmpty) return const [];
    final normalized =
        rules.map((rule) {
            final p = rule.prefix;
            if (p.isEmpty || !p.startsWith('/')) {
              _log(
                'rule rejected: prefix must start with "/" (got "$p")',
                isError: true,
              );
              throw ArgumentError(
                'LocalhostProxyRule.prefix must start with "/", got: "$p"',
              );
            }
            if (rule.stripPrefix && rule.pathRewrite != null) {
              _log(
                'rule rejected: stripPrefix and pathRewrite mutually exclusive (prefix=$p)',
                isError: true,
              );
              throw ArgumentError(
                'LocalhostProxyRule.stripPrefix and pathRewrite are mutually '
                'exclusive (prefix=$p)',
              );
            }
            final pr = rule.pathRewrite;
            if (pr != null && (pr.isEmpty || !pr.startsWith('/'))) {
              _log(
                'rule rejected: pathRewrite must start with "/" (got "$pr")',
                isError: true,
              );
              throw ArgumentError(
                'LocalhostProxyRule.pathRewrite must start with "/", got: "$pr"',
              );
            }
            if (pr == '/') {
              // 语义等价 stripPrefix:true，但 _resolveUpstreamRequestPath 会拼出
              // `//rest` 双斜杠路径。在入口阻断，引导用户用语义清晰的 stripPrefix。
              _log(
                'rule rejected: pathRewrite="/" 等价 stripPrefix:true，请改用 stripPrefix (prefix=$p)',
                isError: true,
              );
              throw ArgumentError(
                'LocalhostProxyRule.pathRewrite="/" 等价于 stripPrefix:true，'
                '请直接用 stripPrefix 而非 pathRewrite (prefix=$p)',
              );
            }
            // "/api/" → "/api"，但根 "/" 保留。
            final trimmedPrefix =
                (p.length > 1 && p.endsWith('/'))
                    ? p.substring(0, p.length - 1)
                    : p;
            final trimmedTarget =
                rule.target.endsWith('/')
                    ? rule.target.substring(0, rule.target.length - 1)
                    : rule.target;
            // pathRewrite 同样去掉末尾斜杠（根 '/' 保留）。
            final trimmedRewrite =
                (pr != null && pr.length > 1 && pr.endsWith('/'))
                    ? pr.substring(0, pr.length - 1)
                    : pr;
            return LocalhostProxyRule(
              prefix: trimmedPrefix,
              target: trimmedTarget,
              headers: rule.headers,
              responseHeaders: rule.responseHeaders,
              timeout: rule.timeout,
              idleTimeout: rule.idleTimeout,
              stripPrefix: rule.stripPrefix,
              pathRewrite: trimmedRewrite,
              allowSelfSignedCert: rule.allowSelfSignedCert,
              onEvent: rule.onEvent,
            );
          }).toList()
          ..sort((a, b) => b.prefix.length.compareTo(a.prefix.length));
    return List.unmodifiable(normalized);
  }

  /// 规则集稳定签名，用于判断"是否同配置"。
  String _proxyRulesSignature(List<LocalhostProxyRule> rules) {
    if (rules.isEmpty) return '';
    return rules.map((r) => r._signature()).join(';');
  }

  /// 最长前缀匹配（依赖 [_proxyRules] 已倒序）。
  LocalhostProxyRule? _matchProxyRule(String requestPath) {
    for (final rule in _proxyRules) {
      final p = rule.prefix;
      if (p == '/' || requestPath == p || requestPath.startsWith('$p/')) {
        return rule;
      }
    }
    return null;
  }

  /// Hop-by-hop 请求/响应头：按 RFC 7230 §6.1 处理，转发时不应透传。
  static const _hopByHopHeaders = <String>{
    'connection',
    'keep-alive',
    'proxy-authenticate',
    'proxy-authorization',
    'te',
    'trailer',
    'transfer-encoding',
    'upgrade',
  };

  bool _isHopByHop(String name) =>
      _hopByHopHeaders.contains(name.toLowerCase());

  /// 按规则集装配 HttpClient：若任意 rule 开了 [LocalhostProxyRule.allowSelfSignedCert]，
  /// 注册 [HttpClient.badCertificateCallback]，仅放过这些 rule 对应的 upstream host
  /// （比对 [Uri.parse(rule.target).host]，端口/scheme 不参与，避免开发环境多端口踩坑）。
  /// 其余 host 继续走严格 TLS 校验。
  HttpClient _buildHttpClient(List<LocalhostProxyRule> rules) {
    final client =
        HttpClient()..connectionTimeout = const Duration(seconds: 10);
    final allowedHosts = <String>{};
    for (final r in rules) {
      if (!r.allowSelfSignedCert) continue;
      try {
        final h = Uri.parse(r.target).host;
        if (h.isNotEmpty) allowedHosts.add(h.toLowerCase());
      } catch (_) {
        // target 在 _normalizeProxyRules 外侧未做 Uri 校验；这里失败就跳过。
      }
    }
    if (allowedHosts.isEmpty) return client;

    client.badCertificateCallback = (
      X509Certificate cert,
      String host,
      int port,
    ) {
      final allow = allowedHosts.contains(host.toLowerCase());
      if (allow) {
        _log(
          'Bypassing TLS for self-signed upstream $host:$port (allowSelfSignedCert)',
          isError: true, // 用 error 通道确保生产也能看到这条警告
        );
      }
      return allow;
    };
    return client;
  }

  /// 拼 upstream 路径：base.path + 请求 path（保留前缀策略，"/api" + "/api/users" → "/api/api/users"）。
  String _joinUpstreamPath(String basePath, String requestPath) {
    final b =
        (basePath.isNotEmpty && basePath.endsWith('/'))
            ? basePath.substring(0, basePath.length - 1)
            : basePath;
    return '$b$requestPath';
  }

  /// 敏感字段脱敏：null → `<absent>`；≤12 字符仅露长度；长串露前 6 + 后 4 + 总长。
  String _maskSensitive(String? value) {
    if (value == null) return '<absent>';
    if (value.length <= 12) return '<present:${value.length} chars>';
    return '${value.substring(0, 6)}…${value.substring(value.length - 4)} '
        '(${value.length} chars)';
  }

  /// 透明转发 [request] 到 [rule.target]：
  /// - 路径按 [rule.stripPrefix] / [rule.pathRewrite] 派生；默认保留前缀
  /// - 30x 响应若 Location 指向 upstream 域，改写回 `http://127.0.0.1:port/...`
  /// - 响应体读取 idle 超时由 [rule.idleTimeout] 控制（null → 与 [rule.timeout] 一致；
  ///   `Duration.zero` → 关闭 idle 检测）
  /// - 错误码映射：504（超时）/ 502（socket / 其他）；成功 + 失败均触发 [rule.onEvent]
  ///
  /// TODO: WebSocket upgrade 转发尚未实现
  Future<void> _handleProxyRequest(
    HttpRequest request,
    LocalhostProxyRule rule,
  ) async {
    final stopwatch = Stopwatch()..start();
    final targetBase = Uri.parse(rule.target);
    final resolvedPath = _resolveUpstreamRequestPath(rule, request.uri.path);
    final upstreamUri = targetBase.replace(
      path: _joinUpstreamPath(targetBase.path, resolvedPath),
      query: request.uri.query.isEmpty ? null : request.uri.query,
    );

    final client = _httpClient;
    if (client == null) {
      // 理论上 start() 有规则时已建好；这里兜底防御。
      _log("Proxy client missing, falling back to 502", isError: true);
      _safeFailResponse(request, HttpStatus.badGateway);
      stopwatch.stop();
      _emitProxyEvent(
        rule,
        LocalhostProxyEvent(
          requestPath: request.uri.path,
          upstreamUri: upstreamUri,
          statusCode: HttpStatus.badGateway,
          errorType: 'other',
          errorMessage: 'HttpClient not initialized',
          durationMs: stopwatch.elapsedMilliseconds,
        ),
      );
      return;
    }

    if (kDebugMode) {
      ErrorHandler.instance.logInfo(
        '🔁 [LocalhostProxy] ${request.requestedUri} ==> $upstreamUri',
      );
    }

    try {
      final upstreamReq = await client
          .openUrl(request.method, upstreamUri)
          .timeout(rule.timeout);

      _forwardRequestHeaders(request, upstreamReq, rule, upstreamUri);
      // 透明代理：不在上游侧跟随 30x，让客户端（WebView / H5 fetch）自己决定。
      // 否则代理会偷偷吞掉 Location，30x 改写也无从触发；指向外部域时还会
      // 因 TLS 握手失败把整个请求拖成 502。
      upstreamReq.followRedirects = false;
      if (kDebugMode) _logOutboundAuthHeaders(upstreamReq);

      // GET/HEAD 无 body；其余流式透传请求体。
      if (request.method != 'GET' && request.method != 'HEAD') {
        await upstreamReq.addStream(request);
      }

      final upstreamResp = await upstreamReq.close().timeout(rule.timeout);

      request.response.statusCode = upstreamResp.statusCode;
      _forwardResponseHeaders(upstreamResp, request.response, rule);
      _maybeRewriteLocation(rule, upstreamResp, request.response);

      // body idle 超时：null → 沿用 rule.timeout；Duration.zero → 不启用。
      final idle = rule.idleTimeout ?? rule.timeout;
      final body =
          idle == Duration.zero ? upstreamResp : upstreamResp.timeout(idle);
      // pipe 内部会 close response。
      await body.pipe(request.response);

      stopwatch.stop();
      _emitProxyEvent(
        rule,
        LocalhostProxyEvent(
          requestPath: request.uri.path,
          upstreamUri: upstreamUri,
          statusCode: upstreamResp.statusCode,
          durationMs: stopwatch.elapsedMilliseconds,
        ),
      );
    } on TimeoutException catch (e) {
      stopwatch.stop();
      _log("Proxy timeout: $upstreamUri ($e)", isError: true);
      _safeFailResponse(request, HttpStatus.gatewayTimeout);
      _emitProxyEvent(
        rule,
        LocalhostProxyEvent(
          requestPath: request.uri.path,
          upstreamUri: upstreamUri,
          statusCode: HttpStatus.gatewayTimeout,
          errorType: 'timeout',
          errorMessage: e.toString(),
          durationMs: stopwatch.elapsedMilliseconds,
        ),
      );
    } on SocketException catch (e) {
      stopwatch.stop();
      _log("Proxy socket error: $upstreamUri ($e)", isError: true);
      _safeFailResponse(request, HttpStatus.badGateway);
      _emitProxyEvent(
        rule,
        LocalhostProxyEvent(
          requestPath: request.uri.path,
          upstreamUri: upstreamUri,
          statusCode: HttpStatus.badGateway,
          errorType: 'socket',
          errorMessage: e.toString(),
          durationMs: stopwatch.elapsedMilliseconds,
        ),
      );
    } catch (e) {
      stopwatch.stop();
      _log("Proxy error: $upstreamUri ($e)", isError: true);
      _safeFailResponse(request, HttpStatus.badGateway);
      _emitProxyEvent(
        rule,
        LocalhostProxyEvent(
          requestPath: request.uri.path,
          upstreamUri: upstreamUri,
          statusCode: HttpStatus.badGateway,
          errorType: 'other',
          errorMessage: e.toString(),
          durationMs: stopwatch.elapsedMilliseconds,
        ),
      );
    }
  }

  /// 派生 upstream 请求路径（不含 base.path 部分）：
  /// - 默认（保留前缀）：原样返回
  /// - stripPrefix：去掉 prefix（剩余空 → '/'）
  /// - pathRewrite：把 prefix 替换为指定路径
  String _resolveUpstreamRequestPath(
    LocalhostProxyRule rule,
    String requestPath,
  ) {
    final p = rule.prefix;
    if (!rule.stripPrefix && rule.pathRewrite == null) return requestPath;
    if (p == '/') return requestPath; // 根前缀无可剥可改

    String rest;
    if (requestPath == p) {
      rest = '';
    } else if (requestPath.startsWith('$p/')) {
      rest = requestPath.substring(p.length); // 含前导 '/'
    } else {
      // 防御：匹配器已保证命中，理论不会到这里
      return requestPath;
    }

    if (rule.stripPrefix) {
      return rest.isEmpty ? '/' : rest;
    }
    final rw = rule.pathRewrite!;
    final out = '$rw$rest';
    return out.isEmpty ? '/' : out;
  }

  /// upstream 30x 响应里的 Location 若指向 [rule.target]，改写为指向本地 proxy，
  /// 避免 WebView/fetch 跳过 proxy 直连真实 host（也避免内网地址泄露给 H5）。
  /// 相对 Location 不动（已天然指向本地）。
  void _maybeRewriteLocation(
    LocalhostProxyRule rule,
    HttpClientResponse src,
    HttpResponse dst,
  ) {
    final code = src.statusCode;
    if (code < 300 || code >= 400) return;
    final location = src.headers.value(HttpHeaders.locationHeader);
    if (location == null || location.isEmpty) return;

    final Uri locUri;
    final Uri targetUri;
    try {
      locUri = Uri.parse(location);
      targetUri = Uri.parse(rule.target);
    } catch (_) {
      return;
    }
    // 相对地址：浏览器会用当前 origin（localhost）解析，无需改写。
    if (!locUri.hasScheme) return;
    if (locUri.host.toLowerCase() != targetUri.host.toLowerCase()) return;
    if (targetUri.hasPort && locUri.hasPort && locUri.port != targetUri.port) {
      return;
    }

    // 还原 upstream 路径中的 base.path 部分，再按规则反向重建本地 prefix。
    String upstreamPath = locUri.path;
    final basePath = targetUri.path;
    if (basePath.isNotEmpty &&
        basePath != '/' &&
        upstreamPath.startsWith(basePath)) {
      upstreamPath = upstreamPath.substring(basePath.length);
      if (upstreamPath.isEmpty) upstreamPath = '/';
    }

    String newPath;
    if (rule.stripPrefix) {
      final pre = rule.prefix == '/' ? '' : rule.prefix;
      newPath =
          upstreamPath == '/' ? (pre.isEmpty ? '/' : pre) : '$pre$upstreamPath';
    } else if (rule.pathRewrite != null) {
      final rw = rule.pathRewrite!;
      if (upstreamPath == rw) {
        newPath = rule.prefix;
      } else if (rw == '/' || upstreamPath.startsWith('$rw/')) {
        final rest =
            rw == '/' ? upstreamPath : upstreamPath.substring(rw.length);
        newPath = '${rule.prefix}$rest';
      } else {
        // upstream 跳到了 rewrite 路径以外的位置 — 无对应本地 prefix 可挂，保持原 path。
        newPath = upstreamPath;
      }
    } else {
      // 默认（保留前缀）：upstreamPath 已经含本地 prefix，直接复用。
      newPath = upstreamPath;
    }

    final newLoc = Uri(
      scheme: 'http',
      host: '127.0.0.1',
      port: _port,
      path: newPath,
      query: locUri.hasQuery ? locUri.query : null,
      fragment: locUri.hasFragment ? locUri.fragment : null,
    );
    dst.headers.set(HttpHeaders.locationHeader, newLoc.toString());
  }

  /// 触发 rule 级回调，吞业务回调里的异常以免污染代理主流程。
  void _emitProxyEvent(LocalhostProxyRule rule, LocalhostProxyEvent event) {
    final cb = rule.onEvent;
    if (cb == null) return;
    try {
      cb(event);
    } catch (e) {
      _log('proxy onEvent threw: $e', isError: true);
    }
  }

  /// 透传请求头到 upstream，关键点：
  /// - 剥 hop-by-hop 和 Host（Host 由 [upstreamUri] 重写，远端 vhost 路由依赖）
  /// - Content-Length 走 Dart 的 [HttpClientRequest.contentLength]，避免与 chunked 同时出现
  ///   （multipart/form-data 上传常踩此坑）
  /// - [rule.headers] 末尾覆盖（Authorization、X-Tenant 等业务头）
  void _forwardRequestHeaders(
    HttpRequest src,
    HttpClientRequest dst,
    LocalhostProxyRule rule,
    Uri upstreamUri,
  ) {
    src.headers.forEach((name, values) {
      if (_isHopByHop(name)) return;
      final lower = name.toLowerCase();
      if (lower == 'host') return;
      // Content-Length 必须走 dst.contentLength，否则与 Dart 的 chunked/定长决策冲突。
      if (lower == 'content-length') return;
      for (final v in values) {
        dst.headers.add(name, v);
      }
    });
    // 显式同步：≥0 走定长，-1 走 chunked。与入站一致，避免被 upstream 拒（部分网关不收 chunked）。
    dst.contentLength = src.contentLength;
    dst.headers.host = upstreamUri.host;
    if (upstreamUri.hasPort) {
      dst.headers.port = upstreamUri.port;
    }
    rule.headers?.forEach((k, v) {
      dst.headers.set(k, v);
    });
  }

  /// 透传响应头到入站：
  /// - 剥 hop-by-hop
  /// - 剥 content-length / transfer-encoding（让 Dart HttpResponse 按实际 body 自决）
  /// - CORS：上游已带 ACAO 则原样透传；缺失才兜底补 `*`（不再硬覆盖上游精细化策略）
  /// - 最后注入 [LocalhostProxyRule.responseHeaders]（business 级覆盖）
  void _forwardResponseHeaders(
    HttpClientResponse src,
    HttpResponse dst,
    LocalhostProxyRule rule,
  ) {
    var hasAcao = false;
    src.headers.forEach((name, values) {
      final lower = name.toLowerCase();
      if (_isHopByHop(name)) return;
      if (lower == 'content-length' || lower == 'transfer-encoding') return;
      if (lower == 'access-control-allow-origin') hasAcao = true;
      for (final v in values) {
        dst.headers.add(name, v);
      }
    });
    if (!hasAcao) {
      dst.headers.set('Access-Control-Allow-Origin', '*');
    }
    rule.responseHeaders?.forEach((k, v) {
      dst.headers.set(k, v);
    });
  }

  /// debug：打印 upstream Authorization / Cookie（脱敏）+ 全量 header 名。
  void _logOutboundAuthHeaders(HttpClientRequest upstreamReq) {
    final outboundHeaderNames = <String>[];
    upstreamReq.headers.forEach((name, _) => outboundHeaderNames.add(name));
    ErrorHandler.instance.logInfo(
      '🔑 [LocalhostProxy] outbound headers — '
      'Authorization: ${_maskSensitive(upstreamReq.headers.value(HttpHeaders.authorizationHeader))} | '
      'Cookie: ${_maskSensitive(upstreamReq.headers.value(HttpHeaders.cookieHeader))} | '
      'all: $outboundHeaderNames',
    );
  }

  /// 转发失败时安全写错误码：response 可能已开始（pipe 写过 body），改 status / close 都会抛，
  /// 这里吞异常避免污染日志。
  void _safeFailResponse(HttpRequest request, int statusCode) {
    try {
      request.response.statusCode = statusCode;
    } catch (_) {}
    try {
      request.response.close();
    } catch (_) {}
  }

  /// 文件系统模式：命中文件直接返回；命中目录或 trailing-slash 时回退到 index.html。
  Future<void> _handleFileSystemRequest(
    HttpRequest request,
    String safePath,
  ) async {
    final documentRoot = Directory(_fileSystemDocumentRoot!);
    final file = File(path.join(documentRoot.path, safePath));

    if (await file.exists()) {
      final stat = await file.stat();
      if (stat.type == FileSystemEntityType.directory) {
        final indexFile = File(path.join(file.path, 'index.html'));
        if (await indexFile.exists()) {
          await _serveFileSystemFile(request, indexFile);
          return;
        }
      } else {
        await _serveFileSystemFile(request, file);
        return;
      }
    }

    if (request.uri.path.endsWith('/') || request.uri.path.isEmpty) {
      final indexFile = File(
        path.join(documentRoot.path, safePath, 'index.html'),
      );
      if (await indexFile.exists()) {
        await _serveFileSystemFile(request, indexFile);
        return;
      }
    }

    request.response
      ..statusCode = HttpStatus.notFound
      ..write('File not found: ${request.uri.path}')
      ..close();
  }

  /// assets 模式：通过 rootBundle 加载；目录式路径回退到 index.html。
  Future<void> _handleAssetsRequest(
    HttpRequest request,
    String safePath,
  ) async {
    final assetPath = path
        .join(_assetsDocumentRoot!, safePath)
        .replaceAll('\\', '/');

    try {
      final byteData = await rootBundle.load(assetPath);
      final content = byteData.buffer.asUint8List();
      final extension = path.extension(assetPath).toLowerCase();

      await _serveContent(request, content, extension);
    } catch (e) {
      // 目录式路径（trailing-slash / 无扩展名）回退到 index.html。
      if (request.uri.path.endsWith('/') ||
          request.uri.path.isEmpty ||
          !assetPath.contains('.')) {
        final indexPath = path
            .join(assetPath, 'index.html')
            .replaceAll('\\', '/');
        try {
          final byteData = await rootBundle.load(indexPath);
          final content = byteData.buffer.asUint8List();
          await _serveContent(request, content, '.html');
          return;
        } catch (_) {}
      }

      _log("Asset not found: $assetPath", isError: true);
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Asset not found: ${request.uri.path}')
        ..close();
    }
  }

  /// 读盘并返回，复用 [_serveContent]。
  Future<void> _serveFileSystemFile(HttpRequest request, File file) async {
    final content = await file.readAsBytes();
    final extension = path.extension(file.path).toLowerCase();
    await _serveContent(request, content, extension);
  }

  /// 写出响应：MIME + CORS + Content-Length，一次性 close。
  Future<void> _serveContent(
    HttpRequest request,
    List<int> content,
    String extension,
  ) async {
    final contentType = _getContentType(extension);

    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.parse(contentType)
      ..headers.add('Access-Control-Allow-Origin', '*')
      ..headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
      ..headers.add('Access-Control-Allow-Headers', 'Content-Type')
      ..headers.contentLength = content.length
      ..add(content)
      ..close();
  }

  /// 扩展名 → MIME，未知回退到 application/octet-stream。
  String _getContentType(String extension) {
    switch (extension) {
      case '.html':
        return 'text/html; charset=utf-8';
      case '.js':
        return 'application/javascript; charset=utf-8';
      case '.css':
        return 'text/css; charset=utf-8';
      case '.json':
        return 'application/json; charset=utf-8';
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.svg':
        return 'image/svg+xml';
      case '.ico':
        return 'image/x-icon';
      case '.woff':
        return 'font/woff';
      case '.woff2':
        return 'font/woff2';
      case '.ttf':
        return 'font/ttf';
      case '.eot':
        return 'application/vnd.ms-fontobject';
      case '.mp4':
        return 'video/mp4';
      case '.webm':
        return 'video/webm';
      case '.mp3':
        return 'audio/mpeg';
      case '.wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream';
    }
  }

  String get baseUrl => 'http://127.0.0.1:$_port';
  bool get isRunning => _running;

  /// 向后兼容别名。
  String get fileSystemServerBaseUrl => baseUrl;

  Future<void> stop() async {
    if (_server != null && _running) {
      try {
        await _server?.close(force: true);
        _log("Stopped server on port $_port");
      } catch (e) {
        _log("Error stopping server: $e", isError: true);
      }
    }
    _running = false;
    _server = null;
    _assetsDocumentRoot = null;
    _fileSystemDocumentRoot = null;
    _proxyRules = const [];
    try {
      _httpClient?.close(force: true);
    } catch (_) {}
    _httpClient = null;
  }

  /// 向后兼容别名。
  Future<void> stopFileSystemServer() async {
    await stop();
  }

  /// pre-check：从 [preferred] 起顺延 [range] 个端口找可用的；找不到回 preferred 让调用方走 ephemeral。
  /// 真正权威的可用性检查仍是 [_tryStartServer] 的实际 bind。
  Future<int> _findAvailablePort({
    required int preferred,
    int range = 20,
  }) async {
    if (await _isPortFree(preferred)) {
      return preferred;
    }
    for (int offset = 1; offset <= range; offset++) {
      final candidate = preferred + offset;
      if (await _isPortFree(candidate)) {
        return candidate;
      }
    }
    return preferred;
  }

  /// 试 bind 后立即 close，仅作 pre-check，不持有端口。
  Future<bool> _isPortFree(int port) async {
    try {
      final socket = await ServerSocket.bind(
        InternetAddress.loopbackIPv4,
        port,
        shared: false,
      );
      await socket.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 错误路径始终上报；启停 / 端口尝试这类成功信息只在 debug 输出，避免线上日志噪音。
  void _log(String message, {bool isError = false}) {
    if (isError) {
      ErrorHandler.instance.logError("⚠️ [LocalhostServer] $message");
      return;
    }
    if (kDebugMode) {
      ErrorHandler.instance.logSuccess("✅ [LocalhostServer] $message");
    }
  }
}
