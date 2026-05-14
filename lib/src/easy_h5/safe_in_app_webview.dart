import 'dart:async';
import 'dart:collection';

import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:window_manager/window_manager.dart';

class SafeInAppWebview extends StatefulWidget {
  // ---- 所有 InAppWebView 的参数都可以加在这里 ----
  final InAppWebViewKeepAlive? keepAlive;
  final URLRequest? initialUrlRequest;
  final InAppWebViewSettings? initialSettings;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;
  final ContextMenu? contextMenu;
  final UnmodifiableListView<UserScript>? initialUserScripts;

  // 所有事件回调
  final void Function(InAppWebViewController controller)? onWebViewCreated;
  final void Function(InAppWebViewController controller, Uri?)? onLoadStart;
  final void Function(InAppWebViewController controller, Uri?)? onLoadStop;
  final void Function(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  )?
  onReceivedError;
  final void Function(
    InAppWebViewController controller,
    Uri? url,
    int code,
    String message,
  )?
  onLoadError;
  final void Function(InAppWebViewController controller, int progress)?
  onProgressChanged;
  final Future<NavigationActionPolicy?> Function(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  )?
  shouldOverrideUrlLoading;
  final void Function(
    InAppWebViewController controller,
    DownloadStartRequest downloadStartRequest,
  )?
  onDownloadStartRequest;
  final void Function(
    InAppWebViewController controller,
    WebUri? url,
    bool? isReload,
  )?
  onUpdateVisitedHistory;
  final void Function(
    InAppWebViewController controller,
    ConsoleMessage consoleMessage,
  )?
  onConsoleMessage;

  const SafeInAppWebview({
    super.key,
    this.keepAlive,
    this.initialUrlRequest,
    this.initialSettings,
    this.gestureRecognizers,
    this.contextMenu,
    this.initialUserScripts,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onLoadError,
    this.onProgressChanged,
    this.shouldOverrideUrlLoading,
    this.onDownloadStartRequest,
    this.onUpdateVisitedHistory,
    this.onConsoleMessage,
  });

  @override
  State<SafeInAppWebview> createState() => _SafeInAppWebviewState();
}

class _SafeInAppWebviewState extends State<SafeInAppWebview>
    with WindowListener {
  InAppWebViewController? _controller;

  // 建议：如果你需要在 Flutter 层也能感知焦点，可以加一个 FocusNode
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (_isDesktop()) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
    if (_isDesktop()) {
      windowManager.removeListener(this);
    }
    _focusNode.dispose(); // 别忘了销毁
    super.dispose();
  }

  bool _isDesktop() {
    return defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux;
  }

  @override
  void onWindowMinimize() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      _controller?.pause();
    }
  }

  @override
  void onWindowRestore() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      _controller?.resume();
    }
  }

  @override
  void onWindowMaximize() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      _controller?.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. 使用 Listener 监听原始触摸事件
    return Listener(
      onPointerDown: (event) {
        FocusScope.of(context).requestFocus(_focusNode);
        ErrorHandler.instance.logInfo(
          "SafeInAppWebview: User touched, requesting focus.",
        );
      },
      child: Focus(
        focusNode: _focusNode,
        // 这里的 onFocusChange 也可以用来做一些额外的逻辑，比如通知 H5
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            ErrorHandler.instance.logInfo("WebView gained focus");
          }
        },
        child: InAppWebView(
          keepAlive: widget.keepAlive,
          initialUrlRequest: widget.initialUrlRequest,
          initialSettings: widget.initialSettings,
          gestureRecognizers: widget.gestureRecognizers,
          contextMenu: widget.contextMenu,
          initialUserScripts: widget.initialUserScripts,

          onWebViewCreated: (controller) {
            _controller = controller;

            ErrorHandler.instance.logInfo(
              "SafeInAppWebview controller ready: $_controller",
            );
            widget.onWebViewCreated?.call(controller);
          },
          // 当WebView获得焦点时
          onWindowFocus: (controller) {
            print('WebView窗口获得焦点');
            _focusNode.requestFocus();
          },
          // 当WebView失去焦点时
          onWindowBlur: (controller) {
            print('WebView窗口失去焦点');
            // 这里可以处理失去焦点时的逻辑
          },
          // ... 其他透传参数保持不变 ...
          onLoadStart: widget.onLoadStart,
          onLoadStop: widget.onLoadStop,
          onReceivedError: widget.onReceivedError,
          onLoadError: widget.onLoadError,
          onProgressChanged: widget.onProgressChanged,
          shouldOverrideUrlLoading: widget.shouldOverrideUrlLoading,
          onDownloadStartRequest: widget.onDownloadStartRequest,
          onUpdateVisitedHistory: widget.onUpdateVisitedHistory,
          onConsoleMessage: widget.onConsoleMessage,
        ),
      ),
    );
  }
}
