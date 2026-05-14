import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kDebugMode, kIsWeb;


class EasySimpleH5Page extends StatefulWidget {
  final bool showAppBar;
  final String title;
  final String url;

  const EasySimpleH5Page({
    super.key,
    this.showAppBar = false,
    this.title = '',
    required this.url,
  });

  @override
  State<EasySimpleH5Page> createState() => _EasySimpleH5PageState();
}

class _EasySimpleH5PageState extends State<EasySimpleH5Page>
    with SingleTickerProviderStateMixin {
  late InAppWebViewController? _webViewController;
  bool isLoading = true;
  bool isOffline = false;
  final ValueNotifier<double> _progressNotifier = ValueNotifier<double>(0);
  late AnimationController _progressAnimationController;
  bool _webView2Available = true;

  @override
  void initState() {
    super.initState();
    _progressAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _initWebViewEnvironmentIfNeeded();
  }

  Future<void> _initWebViewEnvironmentIfNeeded() async {
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
        final availableVersion = await WebViewEnvironment.getAvailableVersion();
        if (availableVersion == null) {
          setState(() {
            _webView2Available = false;
          });
          return;
        }
      }
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
      }
    } catch (e, stack) {
      ErrorHandler.instance.logToLocal(
        'initWebViewEnvironment error: $e\n$stack',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Windows 下 WebView2 不可用时，给出提示
    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.windows &&
        !_webView2Available) {
      return Scaffold(
        appBar:
            widget.showAppBar == true
                ? AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  title: Text(
                    widget.title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  iconTheme: const IconThemeData(color: Colors.black),
                )
                : null,
        body: Center(
          child: Text(
            "未检测到 WebView2 运行环境，请安装 Microsoft Edge WebView2 Runtime 后重试。",
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          widget.showAppBar == true
              ? AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  widget.title,
                  style: const TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black),
              )
              : null,
      body: Stack(
        children: [
          SafeInAppWebview(
            initialUrlRequest: URLRequest(url: WebUri(widget.url)),
            onWebViewCreated: (controller) {
              try {
                _webViewController = controller;
              } catch (e, stack) {
                ErrorHandler.instance.logToLocal(
                  'onWebViewCreated error: $e\n$stack',
                );
              }
            },
            onLoadStart: (controller, url) {
              try {
                setState(() {
                  isLoading = true;
                  isOffline = false; // Reset offline status on new load
                });
              } catch (e, stack) {
                ErrorHandler.instance.logToLocal(
                  'onLoadStart error: $e\n$stack',
                );
              }
            },
            onLoadStop: (controller, url) async {
              try {
                setState(() {
                  isLoading = false;
                });
              } catch (e, stack) {
                ErrorHandler.instance.logToLocal(
                  'onLoadStop error: $e\n$stack',
                );
              }
            },
            onLoadError: (controller, url, code, message) {
              try {
                if (!mounted) return;
                setState(() {
                  isLoading = false;
                  // Check if error is related to network connectivity
                  if (code == -1009 || // iOS/macOS offline error
                      code == -2 || // Android offline error
                      message.toLowerCase().contains('offline') ||
                      message.toLowerCase().contains('connection')) {
                    isOffline = true;
                  }
                });
                ErrorHandler.instance.logToLocal(
                  'onLoadError: code=$code, message=$message, url=$url',
                );
              } catch (e, stack) {
                ErrorHandler.instance.logToLocal(
                  'onLoadError handler error: $e\n$stack',
                );
              }
            },
            onProgressChanged: (controller, progress) {
              try {
                _updateProgress(progress / 100);
              } catch (e, stack) {
                ErrorHandler.instance.logToLocal(
                  'onProgressChanged error: $e\n$stack',
                );
              }
            },
          ),
          ValueListenableBuilder<double>(
            valueListenable: _progressNotifier,
            builder: (context, progress, child) {
              return progress < 1.0
                  ? AnimatedOpacity(
                    opacity: progress < 1.0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white70,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                  : const SizedBox.shrink();
            },
          ),
          if (isLoading)
            EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.h5,
              child: SizedBox(),
            ),
          if (isOffline) EasyOfflineViewWidget(),
        ],
      ),
    );
  }

  void _updateProgress(double value) {
    try {
      // Animate the progress change
      Animation<double> animation = Tween<double>(
        begin: _progressNotifier.value,
        end: value,
      ).animate(_progressAnimationController);

      animation.addListener(() {
        _progressNotifier.value = animation.value;
      });

      _progressAnimationController.reset();
      _progressAnimationController.forward();
    } catch (e, stack) {
      ErrorHandler.instance.logToLocal('updateProgress error: $e\n$stack');
    }
  }

  void _safeDisposeWebView() {
    if (_webViewController != null) {
      ErrorHandler.instance.logInfo(
        "WebView dispose → just release controller reference",
      );
      _webViewController = null;
    }
  }

  @override
  void dispose() {
    Future.microtask(() {
      _safeDisposeWebView();
      _progressAnimationController.dispose();
      _progressNotifier.dispose();
    });
    super.dispose();
  }
}
