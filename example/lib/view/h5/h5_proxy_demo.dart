import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

/// 反向代理（LocalhostProxyRule）端到端 demo。
///
/// 不依赖真实 H5 资源 —— 内置一个 mock upstream（dart:io HttpServer）跑在 ephemeral
/// port 上，再启动 [LocalhostServerManager] 把 `/api/*` 命中的请求按 demo 选中的路径
/// 策略转给 mock。完整参考文档点 AppBar 右上角 ℹ︎ 按钮查看（用 [EasyMarkdown] 渲染）。
class H5ProxyDemo extends StatefulWidget {
  const H5ProxyDemo({super.key});

  @override
  State<H5ProxyDemo> createState() => _H5ProxyDemoState();
}

class _H5ProxyDemoState extends State<H5ProxyDemo> {
  final _manager = LocalhostServerManager.isolated();
  HttpServer? _upstream;
  String? _proxyBaseUrl;
  String? _upstreamBaseUrl;
  final _events = <LocalhostProxyEvent>[];
  String _pathStrategy = 'preserve'; // preserve | strip | rewrite
  String _testPath = '/api/users/42';
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _spinUp();
  }

  Future<void> _spinUp() async {
    setState(() => _busy = true);
    try {
      _upstream?.close(force: true);
      final up = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      _upstream = up;
      up.listen((req) {
        // mock：回 echo JSON，便于在响应里看到代理 rewrite 后真正打到的路径
        req.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode({
              'mock': 'upstream',
              'upstreamPath': req.uri.path,
              'method': req.method,
              'host': req.headers.host,
            }),
          )
          ..close();
      });
      _upstreamBaseUrl = 'http://127.0.0.1:${up.port}';

      await _manager.stop();
      final base = await _manager.start(
        // 任意空目录都行，本 demo 不需要静态文件
        fileSystemDocumentRoot: Directory.systemTemp.path,
        proxyRules: _buildRules(),
      );
      if (!mounted) return;
      setState(() => _proxyBaseUrl = base);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  List<LocalhostProxyRule> _buildRules() {
    final upstream = _upstreamBaseUrl ?? 'http://127.0.0.1:0';
    return [
      LocalhostProxyRule(
        prefix: '/api',
        target: upstream,
        timeout: const Duration(seconds: 5),
        idleTimeout: const Duration(seconds: 5),
        // 可选：业务级请求头注入
        headers: const {'x-demo-tenant': 'easy-studio'},
        // 可选：响应头注入（演示用）
        responseHeaders: const {'x-via': 'localhost-proxy'},
        stripPrefix: _pathStrategy == 'strip',
        pathRewrite: _pathStrategy == 'rewrite' ? '/v2' : null,
        // 拿到每个请求的 status / 错误类型 / 耗时
        onEvent: (e) {
          if (!mounted) return;
          setState(() {
            _events.insert(0, e);
            if (_events.length > 20) _events.removeRange(20, _events.length);
          });
        },
      ),
    ];
  }

  Future<void> _sendTestRequest() async {
    final base = _proxyBaseUrl;
    if (base == null) return;
    setState(() => _busy = true);
    try {
      final client = HttpClient();
      try {
        final req = await client.getUrl(Uri.parse('$base$_testPath'));
        req.followRedirects = false;
        final resp = await req.close();
        await resp.drain<void>();
      } finally {
        client.close();
      }
    } catch (e) {
      // 代理路径错误会通过 onEvent 上报；这里兜 client 自身错误（URL 解析等）
      debugPrint('[H5ProxyDemo] test request failed: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changeStrategy(String s) async {
    setState(() => _pathStrategy = s);
    // 改了 rule 必须重启 server（签名不同会触发自动重启，但显式调一次更直观）
    await _manager.start(
      fileSystemDocumentRoot: Directory.systemTemp.path,
      proxyRules: _buildRules(),
    );
  }

  @override
  void dispose() {
    _upstream?.close(force: true);
    unawaited(_manager.stop());
    super.dispose();
  }

  void _showDoc() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => Scaffold(
              appBar: AppBar(title: const Text('反向代理参考')),
              body: const EasyMarkdown(text: _proxyDocMarkdown),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('H5 反向代理 Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: '反向代理参考文档',
            onPressed: _showDoc,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _infoCard(),
            const SizedBox(height: 12),
            _strategyPicker(),
            const SizedBox(height: 12),
            _testRequestRow(),
            const SizedBox(height: 12),
            const Text(
              'Proxy 事件（最近 20 条）',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(child: _eventList()),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Proxy baseUrl: ${_proxyBaseUrl ?? '(未启动)'}'),
            Text('Mock upstream: ${_upstreamBaseUrl ?? '(未启动)'}'),
            const SizedBox(height: 4),
            const Text(
              '所有 /api/* 请求会被本地 server 透明转发到 mock upstream，'
              '响应里的 upstreamPath 字段会显示路径策略生效后的真实远端路径。',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _strategyPicker() {
    return Wrap(
      spacing: 8,
      children: [
        for (final s in const [
          ('preserve', '保留前缀'),
          ('strip', 'stripPrefix'),
          ('rewrite', 'pathRewrite=/v2'),
        ])
          ChoiceChip(
            label: Text(s.$2),
            selected: _pathStrategy == s.$1,
            onSelected: (_) => _changeStrategy(s.$1),
          ),
      ],
    );
  }

  Widget _testRequestRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: _testPath)
              ..selection = TextSelection.collapsed(offset: _testPath.length),
            decoration: const InputDecoration(
              labelText: '测试 path',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => _testPath = v,
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _busy || _proxyBaseUrl == null ? null : _sendTestRequest,
          child: const Text('发送'),
        ),
      ],
    );
  }

  Widget _eventList() {
    if (_events.isEmpty) {
      return const Center(
        child: Text('暂无事件，点上面"发送"试一下', style: TextStyle(color: Colors.black45)),
      );
    }
    return ListView.separated(
      itemCount: _events.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) {
        final e = _events[i];
        final color =
            e.isSuccess
                ? Colors.green
                : (e.errorType == 'timeout' ? Colors.orange : Colors.red);
        return ListTile(
          dense: true,
          leading: Icon(
            e.isSuccess ? Icons.check_circle : Icons.error,
            color: color,
            size: 20,
          ),
          title: Text(
            '${e.requestPath}  →  ${e.upstreamUri.path}',
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
          ),
          subtitle: Text(
            'status=${e.statusCode ?? '-'}'
            '${e.errorType != null ? ', error=${e.errorType}' : ''}'
            ', ${e.durationMs}ms',
            style: const TextStyle(fontSize: 11),
          ),
        );
      },
    );
  }
}

/// 反向代理参考文档（Markdown 源），由 [_H5ProxyDemoState._showDoc] 通过
/// [EasyMarkdown] 渲染。raw 字符串避免 `${target}` 这类示例被 Dart 当作字符串
/// 插值解析。
const String _proxyDocMarkdown = r'''
# H5 反向代理（H5WebView + LocalhostProxyRule）

`H5WebView` 内部有一个本地 HTTP server（`LocalhostServerManager`，绑 `127.0.0.1` 不暴露局域网）来托管 H5 静态资源。可以通过 `proxyRules` 把命中前缀的请求由这个 server 透明转发到上游，避免 H5 端踩跨域、Mixed-Content 或 Token 注入的坑。

> 仅在 `assets` / `localFilePath` 模式下生效。`onlineUrl` 模式直接由 WebView 加载远端 URL，不走本地 server。

## 最小用法

```dart
H5WebView(
  appName: 'myApp',
  nameEn: 'My App',
  nameZh: '我的应用',
  bridge: AppBridge(),
  proxyRules: [
    LocalhostProxyRule(
      prefix: '/api',
      target: 'https://api.example.com',
    ),
  ],
)
```

H5 内 `fetch('/api/users')` 就会被本地 server 转给 `https://api.example.com/api/users`（默认保留前缀）。

## LocalhostProxyRule 字段

| 字段 | 类型 | 说明 |
|---|---|---|
| `prefix` | `String` | 路径前缀，必须以 `/` 开头；命中 `path == prefix` 或 `path.startsWith('$prefix/')` |
| `target` | `String` | upstream 基址（如 `https://api.example.com`），末尾 `/` 自动去掉 |
| `headers` | `Map<String,String>?` | 注入到 upstream 请求头（覆盖同名）；典型用例：`Authorization`、`X-Tenant` |
| `responseHeaders` | `Map<String,String>?` | 注入到下行响应头（覆盖同名） |
| `timeout` | `Duration` | 连接 + 读响应头超时，默认 30s |
| `idleTimeout` | `Duration?` | 响应体 idle 超时；`null` = 沿用 `timeout`，`Duration.zero` = 关闭 idle 检测 |
| `stripPrefix` | `bool` | `true` → 转发时去掉 `prefix`（与 `pathRewrite` 互斥） |
| `pathRewrite` | `String?` | 把 `prefix` 替换为指定路径（与 `stripPrefix` 互斥） |
| `allowSelfSignedCert` | `bool` | 允许 upstream HTTPS 自签名证书。⚠️ **仅 dev 用**，生产保持 `false` |
| `onEvent` | `void Function(LocalhostProxyEvent)?` | 单 rule 维度的事件回调；`H5WebView.onProxyEvent` 是 widget 级镜像 |

## 路径策略（互斥三选一）

请求 `/api/users` 命中 `prefix: '/api'` 时：

| 配置 | 转发到 upstream 的路径 |
|---|---|
| 默认（保留前缀） | `${target}/api/users` |
| `stripPrefix: true` | `${target}/users` |
| `pathRewrite: '/v2'` | `${target}/v2/users` |

## 多规则匹配

按 `prefix` 长度倒序匹配，最长前缀优先：

```dart
proxyRules: [
  LocalhostProxyRule(prefix: '/api/v2', target: 'https://api-v2.example.com'),
  LocalhostProxyRule(prefix: '/api',    target: 'https://api.example.com'),
],
// /api/v2/users 命中第一条；/api/users 命中第二条
```

## 观察事件

```dart
H5WebView(
  // ...
  proxyRules: [LocalhostProxyRule(prefix: '/api', target: '...')],
  onProxyEvent: (e) {
    debugPrint('proxy: ${e.requestPath} → ${e.upstreamUri} '
               'status=${e.statusCode} error=${e.errorType} ${e.durationMs}ms');
    // 上报到埋点 / Sentry / 自家 monitoring
  },
)
```

`LocalhostProxyEvent` 字段：`requestPath`、`upstreamUri`、`statusCode`、`errorType`（`'timeout'` / `'socket'` / `'other'` / null）、`errorMessage`、`durationMs`、`isSuccess` getter。

## isolated 选择

| 取值 | 行为 |
|---|---|
| `true`（默认） | 每个 `H5WebView` 各自一个 `LocalhostServerManager`，独立端口 + 独立 proxy 规则；`dispose` 自动 `stop()`。多 H5 路径前缀冲突也不会打架。 |
| `false` | 回退到全局 singleton，多 WebView 共享 server 与端口。**仅当确实需要共享 proxy/cookie 时再用**，否则容易被互相覆盖配置。 |

## 行为细节（已经踩过的坑）

- 透明代理：**不在上游侧跟随 30x**，让 WebView/H5 自己决定（否则会偷吞 Location，30x 改写也无从触发）。
- **30x Location 改写**：上游响应 Location 若指向 `rule.target` 域，会改写为 `http://127.0.0.1:port/<对应本地路径>`，避免内网地址泄露给 H5、避免 WebView 跳过代理直连真实域。
- **Hop-by-hop 头按 RFC 7230 §6.1 过滤**：`Connection`、`Keep-Alive`、`TE`、`Trailer`、`Transfer-Encoding`、`Upgrade`、`Proxy-*`。
- **Host 头重写**为 upstream，vhost 路由能正常工作。
- **Content-Length 走 Dart 自己的 chunked/定长决策**，避免 multipart 上传时与 chunked 撞车。
- **CORS**：上游已带 `Access-Control-Allow-Origin` 则原样透传；缺失才补 `*`，不再硬覆盖上游精细化策略。
- **路径穿越守卫前置于代理匹配**：`/api/../admin` 会被挡在 403，不会传给 upstream 让它归一化绕过。
- **HttpClient 复用**：单实例，连接超时 10s。

## 当前不支持

- **WebSocket 升级**：本地 server 不接管 `Upgrade: websocket`，需 H5 直连 `wss://...` 而不走本地代理。代码里已有 TODO 标注，后续可补。
- **HTTP/2 升级**
- **Secure cookie**：localhost 走 HTTP，浏览器规范上会丢 `Secure` cookie

## 完整接入示例（拷贝改用）

```dart
H5WebView(
  appName: 'myApp',
  nameEn: 'My App',
  nameZh: '我的应用',
  bridge: AppBridge(),
  isolated: true,                    // 多实例不冲突，dispose 自动 stop server
  proxyRules: [
    LocalhostProxyRule(
      prefix: '/api',
      target: 'https://api.example.com',
      headers: {'Authorization': 'Bearer $token'},
      responseHeaders: {'X-Via': 'h5-webview'},
      timeout: const Duration(seconds: 30),
      idleTimeout: const Duration(seconds: 30),
      stripPrefix: true,             // /api/users → upstream /users
      // pathRewrite: '/v2',         // 与 stripPrefix 互斥
      allowSelfSignedCert: false,    // ⚠️ 仅 dev，勿生产
    ),
  ],
  onProxyEvent: (e) {
    // 业务埋点：上报 status / 耗时 / 错误
    debugPrint('proxy event: $e');
  },
)
```
''';
