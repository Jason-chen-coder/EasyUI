import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:easy_ui/easy_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as p;

class UrlParameter {
  final String name;
  final dynamic value;
  UrlParameter({required this.name, required this.value});
}

typedef WebViewCreatedCallback =
    void Function(InAppWebViewController controller);

class H5WebView extends StatefulWidget {
  /// appName should correspond to the folder name under assets/h5, e.g. "app1" or "app2"
  /// The entry point will be assets/h5/<appName>/dist/index.html
  /// This is ignored if onlineUrl or localFilePath is provided
  final String appName;

  final String nameEn;

  final String nameZh;

  /// Optional online URL to load instead of local assets
  /// If provided, appName is ignored and this URL will be loaded directly
  /// Example: 'https://example.com/app' or 'http://localhost:3000'
  final String? onlineUrl;

  /// Optional file system path to load instead of assets
  /// If provided, this will be used with file:// protocol
  /// Example: '/path/to/app/dist/index.html'
  final String? localFilePath;

  /// Bridge instance for this WebView (per-WebView AppBridge)
  /// Use a dedicated instance to avoid multi-WebView event cross-talk
  final AppBridge bridge;

  /// Optional hero tag for shared element transition
  /// If provided, the loading progress indicator will be wrapped in a Hero widget
  final String? heroTag;

  /// Optional hero icon for shared element transition
  /// If provided along with heroTag, this icon will be displayed during loading
  final Widget? heroIcon;
  final bool hideTitle;
  final WebViewCreatedCallback? onWebViewCreated;

  final String token;
  final List<BridgeMethodSpec> extraBridgeMethods;
  final EasyRichEditorUploadParams? uploadParams;
  final void Function(String url)? onLoadStop;
  final void Function(String url, int code, String message)? onLoadError;

  /// 反代规则，命中前缀的请求由本地服务器转发到 upstream。
  /// 仅 assets / localFilePath 模式生效（onlineUrl 不经过本地服务器）。
  final List<LocalhostProxyRule>? proxyRules;

  /// 是否使用独立 server 实例（独立端口、独立 proxyRules）。
  ///
  /// 默认 `true`：每个 H5WebView 各自 new 一个 LocalhostServerManager，dispose 时自动 stop，
  /// 多实例并存且 proxy 路径前缀冲突（如都用 `/api/*`）时也不会打架。
  ///
  /// 传 `false` 回退到 singleton（多 WebView 共享 server）——仅当确实需要共享 proxy/cookie 时才用。
  final bool isolated;

  /// 代理事件回调（成功 + 失败），用于业务层埋点 / 监控。
  /// 仅 assets / localFilePath 模式生效（onlineUrl 不经过本地代理）。
  /// 与单个 [LocalhostProxyRule.onEvent] 同时存在时，rule 级先调用、widget 级后调用，
  /// 任意一边抛异常都被吞掉以免影响代理主流程。
  final void Function(LocalhostProxyEvent event)? onProxyEvent;

  const H5WebView({
    super.key,
    required this.appName,
    required this.nameEn,
    required this.nameZh,
    required this.bridge,
    this.onlineUrl,
    this.token = "",
    this.localFilePath,
    this.hideTitle = false,
    this.heroTag,
    this.heroIcon,
    this.onWebViewCreated,
    this.extraBridgeMethods = const [],
    this.uploadParams,
    this.onLoadStop,
    this.onLoadError,
    this.proxyRules,
    this.isolated = true,
    this.onProxyEvent,
  });

  @override
  H5WebViewState createState() => H5WebViewState();
}

class H5WebViewState extends State<H5WebView> {
  /// 锁定首次构造时的 isolated 选择，避免父 rebuild 切换 widget.isolated 后
  /// dispose 与 manager 实际所属关系错配（漏 stop 独立实例 / 误 stop singleton）。
  late final bool _ownsServer = widget.isolated;

  /// 仅在第一次需要本地 server 时才构造（onlineUrl 模式不会触发）。
  LocalhostServerManager? _serverManagerInstance;
  LocalhostServerManager get _serverManager =>
      _serverManagerInstance ??=
          _ownsServer
              ? LocalhostServerManager.isolated()
              : LocalhostServerManager();
  InAppWebViewController? _controller;
  Key _webViewKey = UniqueKey();
  String? _initialUrl;
  int _progress = 0;
  bool _isLoaded = false;
  int _redirectCount = 0;
  String? _lastUrl;
  bool _isH5Home = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _startServerAndLoad();
      }
    });
  }

  /// 把 widget 级 [H5WebView.onProxyEvent] 注入每条 rule：保留 rule 自带的 onEvent
  /// 先调用，再调 widget 的；任意一边抛异常都被 LocalhostServerManager 那边吞掉。
  /// 当 widget 没传 onProxyEvent 时直接返回原列表，避免无谓拷贝。
  List<LocalhostProxyRule>? _withWidgetEventTap(
    List<LocalhostProxyRule>? rules,
  ) {
    final widgetCb = widget.onProxyEvent;
    if (widgetCb == null || rules == null || rules.isEmpty) return rules;
    return rules
        .map(
          (r) => LocalhostProxyRule(
            prefix: r.prefix,
            target: r.target,
            headers: r.headers,
            responseHeaders: r.responseHeaders,
            timeout: r.timeout,
            idleTimeout: r.idleTimeout,
            stripPrefix: r.stripPrefix,
            pathRewrite: r.pathRewrite,
            allowSelfSignedCert: r.allowSelfSignedCert,
            onEvent: (event) {
              try {
                r.onEvent?.call(event);
              } catch (_) {
                // rule 级异常已被 manager 吞，这里再吞一层防止链式中断
              }
              widgetCb(event);
            },
          ),
        )
        .toList(growable: false);
  }

  Future<void> _startServerAndLoad() async {
    final locale = Localizations.localeOf(context);

    final tappedRules = _withWidgetEventTap(widget.proxyRules);

    String url;
    if (widget.onlineUrl != null) {
      url = widget.onlineUrl!;
    } else if (widget.localFilePath != null) {
      url = await buildLocalFileUrl(
        widget.localFilePath!,
        _serverManager,
        proxyRules: tappedRules,
      );
    } else {
      final baseUrl = await _serverManager.start(
        assetsDocumentRoot: 'assets/h5',
        proxyRules: tappedRules,
      );
      url = '$baseUrl/${widget.appName}/dist/index.html';
    }

    final urlParameters = [
      UrlParameter(name: 'token', value: widget.token),
      UrlParameter(name: 'locale', value: locale.languageCode),
    ];

    url = '$url?${urlParameters.map((e) => '${e.name}=${e.value}').join('&')}';

    setState(() {
      _progress = 0;
      _initialUrl = url;
      _webViewKey = UniqueKey();
    });
    _applyUploadParams(widget.uploadParams);
    if (widget.extraBridgeMethods.isNotEmpty) {
      for (var element in widget.extraBridgeMethods) {
        widget.bridge.register(element);
      }
    }
    if (_controller != null && _initialUrl != null) {
      await _controller!.loadUrl(
        urlRequest: URLRequest(url: WebUri(_initialUrl!)),
      );
    }
  }

  Future<void> _applyUploadParams(EasyRichEditorUploadParams? params) async {
    // 获取能力(用于H5获取当前AppBridge的方法列表)
    print("_applyUploadParams params===>${params.toString()}");
    print("_applyUploadParams bridge===>${widget.bridge}");
    final bridge = widget.bridge;
    if (params == null) return;
    widget.bridge.register(
      BridgeMethodSpec(
        method: 'as.getRichEditorUploadParams',
        handler: (args) async {
          return {
            'baseUrl': params.baseUrl,
            'path': params.path,
            'sysCategory': params.sysCategory,
            'token': params.token,
          };
        },
        description: "获取当前 richEditor编辑器的能力和可用方法列表",
        paramsDescription: '无参数',
      ),
    );
  }

  /// 检查 WebView 历史记录并更新返回状态
  Future<void> _updateBackButtonState() async {
    if (_controller == null) return;

    final history = await _controller!.getCopyBackForwardList();

    if (mounted) {
      setState(() {
        _isH5Home =
            history != null &&
            history.currentIndex != null &&
            history.currentIndex == 0;
      });
    }
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller?.dispose();
      _controller = null;
    }
    // 独立 server 由本 widget 拥有，dispose 时关闭以释放端口；
    // 共享 singleton 不在此关闭，避免影响其它 H5WebView。
    // 用 _serverManagerInstance 而非 getter，避免 onlineUrl 模式下无谓懒构造一个新实例只为 stop。
    final manager = _serverManagerInstance;
    if (_ownsServer && manager != null) {
      unawaited(manager.stop());
    }
    super.dispose();
  }

  /// 使用原生 HttpClient 下载文件，绕过 Dio 的 IOHttpClientAdapter 限制
  Future<void> _downloadFile(String urlString, String outputFilePath) async {
    try {
      // 检查是否是 blob URL
      if (urlString.startsWith('blob:')) {
        throw Exception(
          "检测到 Blob URL，无法直接下载。请在 H5 中使用以下方式：await AppBridge.invoke('as.downloadBlob', [{ base64: 'data:...', filename: 'your-file.xlsx' }]",
        );
      }

      // 处理 file:// 协议的URL
      if (urlString.startsWith('file://')) {
        // 将 file:// URL 转换为文件路径
        final uri = Uri.parse(urlString);
        final sourcePath = uri.toFilePath();

        final sourceFile = File(sourcePath);
        if (!await sourceFile.exists()) {
          throw Exception('源文件不存在: $sourcePath');
        }

        // 直接复制文件
        final destinationFile = File(outputFilePath);
        await destinationFile.parent.create(recursive: true);
        await sourceFile.copy(destinationFile.path);

        ErrorHandler.instance.logInfo('[H5WebView] 文件下载成功: $outputFilePath');
        return;
      }

      // 处理 HTTP/HTTPS URL
      final uri = Uri.parse(urlString);
      final client = HttpClient();

      // 如果是 HTTPS，忽略证书验证（用于开发环境）
      client.badCertificateCallback = (cert, host, port) => true;

      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception("Download failed");
      }

      final file = File(outputFilePath);
      await file.parent.create(recursive: true);
      final sink = file.openWrite();

      int receivedBytes = 0;
      final totalBytes = response.contentLength;

      await response.forEach((List<int> chunk) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        final progress = (receivedBytes / totalBytes * 100).toStringAsFixed(1);
        ErrorHandler.instance.logInfo("下载进度: $progress%");
      });

      await sink.close();
      client.close();

      ErrorHandler.instance.logInfo('[H5WebView] 文件下载成功: $outputFilePath');
    } catch (e) {
      ErrorHandler.instance.logInfo(
        '[H5WebView] Error downloading file: ${e.toString()}',
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    // show a placeholder while computing the initial URL / starting server
    bool showH5Page = _progress >= 100 || _isLoaded;
    Widget loadingWidget = Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: easyTheme.primaryGreen,
        ),
      ),
    );
    if (_initialUrl == null) {
      return loadingWidget;
    }
    if (widget.heroTag != null && widget.heroIcon != null) {
      loadingWidget = Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: easyTheme.primaryGreen,
                ),
              ),
            ),
            //
            // 共享元素过渡 终点 - 显示应用图标
            Center(
              child: Container(
                padding: const EdgeInsets.all(5),
                width: 70,
                height: 70,
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Hero(
                  tag: widget.heroTag!,
                  child: ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: widget.heroIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: widget.hideTitle ? null : _getAppBar(context),
      body: Stack(
        children: [
          SafeInAppWebview(
            key: _webViewKey,
            initialUrlRequest: URLRequest(url: WebUri(_initialUrl!)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useOnLoadResource: true,
              useShouldOverrideUrlLoading: true,
              allowUniversalAccessFromFileURLs: true,
              allowFileAccessFromFileURLs: true,
              allowsInlineMediaPlayback: true,
              useWideViewPort: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
              clearCache: false,
              cacheEnabled: true,
              domStorageEnabled: true,
              databaseEnabled: true,
              supportZoom: false,
              isInspectable: true,
              useHybridComposition: true,
            ),
            initialUserScripts: UnmodifiableListView<UserScript>([
              widget.bridge.userScript,
            ]),
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress;
              });
            },
            onDownloadStartRequest: (controller, request) async {
              _handleDownloadRequest(request);
            },
            onWebViewCreated: (controller) async {
              _controller = controller;
              await widget.bridge.attach(controller);

              if (widget.onWebViewCreated != null) {
                widget.onWebViewCreated!(controller);
              }
            },
            onLoadStart: (c, url) {
              // 检测重定向循环
              if (_lastUrl == url?.toString()) {
                _redirectCount++;
                if (_redirectCount > 5) {
                  ErrorHandler.instance.logInfo(
                    '[H5WebView] Redirect loop detected, stopping load',
                  );
                  _controller?.stopLoading();
                  return;
                }
              } else {
                _redirectCount = 0;
                _lastUrl = url?.toString();
              }
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final uri = navigationAction.request.url;
              if (uri != null) {
                final uriString = uri.toString();
                ErrorHandler.instance.logInfo(
                  '[H5WebView] Navigation to: $uriString',
                );

                // 防止HTTP到HTTPS的循环重定向
                if (_lastUrl != null &&
                    ((_lastUrl!.startsWith('http://') &&
                            uriString.startsWith('https://')) ||
                        (_lastUrl!.startsWith('https://') &&
                            uriString.startsWith('http://')))) {
                  final httpUrl = _lastUrl!
                      .replaceFirst('https://', '')
                      .replaceFirst('http://', '');
                  final newUrl = uriString
                      .replaceFirst('https://', '')
                      .replaceFirst('http://', '');

                  if (httpUrl == newUrl) {
                    _redirectCount++;
                    if (_redirectCount > 3) {
                      ErrorHandler.instance.logInfo(
                        '[H5WebView] Preventing redirect loop between HTTP/HTTPS',
                      );
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (c, url) async {
              if (mounted) {
                setState(() {
                  _isLoaded = true;
                });
              }

              if (widget.onLoadStop != null) {
                widget.onLoadStop!(url?.toString() ?? '');
              }
            },
            onUpdateVisitedHistory: (controller, url, isReload) async {
              // 在历史记录更新时自动更新返回按钮状态
              await _updateBackButtonState();
            },
            onLoadError: (controller, url, code, message) {
              if (widget.onLoadError != null) {
                widget.onLoadError!(url?.toString() ?? '', code, message);
              }
            },
            onConsoleMessage:
                (controller, consoleMessage) => ErrorHandler.instance.logInfo(
                  '[MicroApp H5]: ${consoleMessage.message}',
                ),
          ),

          IgnorePointer(
            ignoring: showH5Page,
            child: AnimatedOpacity(
              opacity: showH5Page ? 0.0 : 1.0,
              duration: Duration(milliseconds: 300),
              child: loadingWidget,
            ),
          ),
        ],
      ),
    );
  }

  void _handleDownloadRequest(DownloadStartRequest request) async {
    final url = request.url.toString();
    final fileName = request.suggestedFilename ?? url.split('/').last;
    String? outputFilePath;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      if (Platform.isAndroid) {
        try {
          await requestFileAccessPermissions();
        } catch (e) {
          ErrorHandler.instance.logError(
            "[H5WebView] File permission denied: $e",
          );
          showToastError(text: "文件访问权限被拒绝");
          return;
        }
      }

      // Android/iOS 上 saveFile 需要提前传入 bytes，这里改为选择目录后自行拼接文件名
      final directoryPath = await FilePicker.platform.getDirectoryPath(
        dialogTitle: "选择保存位置",
      );
      if (directoryPath == null) {
        debugPrint("用户取消保存");
        return;
      }
      outputFilePath = p.join(directoryPath, fileName);
    } else {
      // 桌面端可以直接选择完整路径
      outputFilePath = await FilePicker.platform.saveFile(
        dialogTitle: "选择保存位置",
        fileName: fileName,
      );
      if (outputFilePath == null) {
        debugPrint("用户取消保存");
        return;
      }
    }

    try {
      await _downloadFile(url, outputFilePath);
      showToastOk(text: "文件已保存到: $outputFilePath");
    } catch (e) {
      ErrorHandler.instance.logError("下载失败: ${e.toString()}");

      showToastError(text: "下载失败: ${e.toString()}");
    }
  }

  AppBar _getAppBar(BuildContext context) {
    final locale = Localizations.localeOf(context);
    // 根据当前语言选择应用名称
    final String appName =
        locale.languageCode == 'zh'
            ? widget.nameZh.isNotEmpty
                ? widget.nameZh
                : widget.nameEn
            : widget.nameEn;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        appName,
        style: TextStyle(fontSize: 16, color: Color(0xff333333)),
      ),
      centerTitle: true,
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () async {
                if (_isH5Home == false) {
                  // 如果有历史记录，返回h5首页
                  if (_controller != null && _initialUrl != null) {
                    await _controller!.loadUrl(
                      urlRequest: URLRequest(url: WebUri(_initialUrl!)),
                    );
                  }
                } else {
                  // 如果没有历史记录，返回
                  Navigator.of(context).maybePop();
                }
              },
              icon:
                  _isH5Home
                      ? const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 16,
                        color: Color(0xff666666),
                      )
                      : SvgPicture.asset(
                        width: 22,
                        height: 22,
                        "assets/svgs/ic_micro_app_home.svg",
                        color: const Color(0xff666666),
                        colorFilter: ColorFilter.mode(
                          const Color(0xff666666),
                          BlendMode.srcIn,
                        ),
                      ),
            ),
          ),
        ],
      ),
      leadingWidth: 60,
      actions: [
        Container(
          width: 87,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            // color: Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: Color(0xffEEEEEE), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showToastOk(text: "敬请期待");
                  },
                  child: SvgPicture.asset(
                    width: 18,
                    height: 18,
                    "assets/svgs/ic_micro_app_more.svg",
                    color: Color(0xff333333),
                  ),
                ),
              ),
              Container(width: 1, height: 20, color: Color(0xffEEEEEE)),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).maybePop();
                  },
                  child: SvgPicture.asset(
                    width: 18,
                    height: 18,
                    "assets/svgs/ic_micro_app_return.svg",
                    color: Color(0xff333333),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(color: Color(0xffEEEEEE), height: 1.0),
      ),
    );
  }

  // 提供公共接口供外部调用
  InAppWebViewController? get controller => _controller;
  bool get isLoaded => _isLoaded;
}
