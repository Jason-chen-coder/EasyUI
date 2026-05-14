import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:flutter/material.dart';

import '../../easy_ui.dart';

class EasyRichEditorUploadParams {
  const EasyRichEditorUploadParams({
    required this.baseUrl,
    required this.path,
    required this.sysCategory,
    required this.token,
  });

  final String baseUrl;
  final String path;
  final String sysCategory;
  final String token;

  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'path': path,
      'sysCategory': sysCategory,
      'token': token,
    };
  }
}

class EasyRichEditor extends StatefulWidget {
  const EasyRichEditor({
    super.key,
    this.onChange,
    this.controller,
    this.preview = false,
    this.initialValue = '',
    this.height,
    this.uploadParams,
    this.parentScrollController,
  });

  final ValueChanged<String?>? onChange;
  final EasyRichEditorController? controller;
  final bool preview;
  final String initialValue;
  final double? height;
  final EasyRichEditorUploadParams? uploadParams;
  final ScrollController? parentScrollController;

  @override
  State<EasyRichEditor> createState() => _RichEditorState();
}

class EasyRichEditorController {
  _RichEditorState? _state;

  Future<String?> getValueHtml() async {
    return _state?._fetchValueHtml();
  }

  Future<void> setValueHtml(String html) async {
    await _state?._applyValueHtml(html);
  }

  /// 保存当前光标位置
  Future<bool> saveSelection() async {
    try {
      final bridge = _state?._bridge;
      if (bridge == null) {
        return false;
      }

      await bridge.invokeJs('richEditor.saveSelection', {});
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 恢复光标位置
  Future<bool> restoreSelection() async {
    try {
      final bridge = _state?._bridge;
      if (bridge == null) {
        return false;
      }

      await bridge.invokeJs('richEditor.restoreSelection', {});
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 在光标位置插入词库
  Future<GlossaryInsertResult> insertGlossary({
    required String html,
    String? id,
    String? name,
    String type = 'html',
  }) async {
    // 恢复光标位置
    await restoreSelection();

    // 等待一小段时间确保光标恢复
    await Future.delayed(const Duration(milliseconds: 50));

    // 执行插入
    final result =
        await _state?._insertGlossary(
          html: html,
          id: id,
          name: name,
          type: type,
        ) ??
        GlossaryInsertResult(success: false, message: 'Editor not initialized');

    return result;
  }

  void _attach(_RichEditorState state) {
    _state = state;
  }

  void _detach(_RichEditorState state) {
    if (_state == state) _state = null;
  }
}

class _RichEditorState extends State<EasyRichEditor> {
  Object? _error;
  Widget richEditorWidget = SizedBox();
  double? _webviewHeight;
  AppBridge? _bridge;
  H5WebView? _richEditorWebViewTemplate;
  AppBridge? _fullScreenBridge;
  bool _didRegisterBridgeListener = false;
  bool _isFullScreenDrawerOpen = false;
  bool _suppressNextFullScreenEvent = false;
  bool _didHandleRendered = false;
  final drawerWrapper = EasyDrawerWrapper();

  static Future<List<H5AppItem>>? _appsFuture;

  Future<List<H5AppItem>> _ensureAppsLoaded(BuildContext context) {
    _appsFuture ??= () async {
      await syncLocalApps(context);
      return handleGetCacheApps(context);
    }();
    return _appsFuture!;
  }

  /// Load all available apps
  Future<void> loadApps(BuildContext context) async {
    try {
      final allApps = await _ensureAppsLoaded(context);
      bool foundRichEditor = false;
      for (var element in allApps) {
        final builtWidget = element.builder(context);
        final h5Widget = builtWidget is H5WebView ? builtWidget : null;
        final isRichEditor =
            element.nameEn == 'Rich Editor' ||
            h5Widget?.appName == 'rich-editor';
        if (!isRichEditor) continue;

        foundRichEditor = true;
        richEditorWidget = builtWidget;
        _bridge = _extractBridge(builtWidget);
        if (_bridge != null && widget.parentScrollController != null) {
          _bridge!.parentScrollController = widget.parentScrollController;
        }
        _richEditorWebViewTemplate = h5Widget;
        _registerBridgeListener();
        _applyUploadParams(widget.uploadParams);
        break;
      }

      if (!foundRichEditor) {
        _error = 'Rich Editor app not found';
        ErrorHandler.instance.logError(
          '[MicroApp] Rich Editor app not found. names=${allApps.map((e) => e.nameEn).toList()}',
        );
      }
    } catch (e) {
      ErrorHandler.instance.logError('[MicroApp] Error loading apps: $e');
      _error = e;
      _appsFuture = null;
    } finally {
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await loadApps(context);
      }
    });
  }

  Future<GlossaryInsertResult> _insertGlossary({
    required String html,
    String? id,
    String? name,
    String type = 'html',
  }) async {
    final bridge = _bridge;
    if (bridge == null) {
      return GlossaryInsertResult(success: false, message: 'Bridge 未初始化');
    }

    final params = {
      'html': html,
      'id': id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name ?? '词库项',
      'type': type,
    };

    try {
      // 调用 H5 端的方法
      final result = await bridge.invokeJs('richEditor.insertGlossary', params);

      // 解析结果
      if (result is Map) {
        final insertResult = GlossaryInsertResult.fromMap(
          Map<String, dynamic>.from(result),
        );

        if (insertResult.success) {
          // 触发 onChange 回调
          final currentHtml = await _fetchValueHtml();
          widget.onChange?.call(currentHtml);
        }

        return insertResult;
      }

      return GlossaryInsertResult(success: false, message: '返回格式错误');
    } catch (e) {
      return GlossaryInsertResult(success: false, message: e.toString());
    }
  }

  @override
  void didUpdateWidget(covariant EasyRichEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
    if (oldWidget.preview != widget.preview) {
      _applyPreview(widget.preview);
    }
    if (oldWidget.uploadParams != widget.uploadParams) {
      _applyUploadParams(widget.uploadParams);
    }
    if (oldWidget.parentScrollController != widget.parentScrollController &&
        _bridge != null) {
      _bridge!.parentScrollController = widget.parentScrollController;
    }
  }

  Future<void> _applyValueHtml(String html) async {
    final bridge = _bridge;
    if (bridge == null) return;
    try {
      await bridge.invokeJs('richEditor.setValueHtml', {'valueHtml': html});
      widget.onChange?.call(html);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _applyPreview(bool preview) async {
    final bridge = _bridge;
    if (bridge == null) return;
    try {
      await bridge.invokeJs('richEditor.setPreview', {'previewOnly': preview});
    } catch (e) {
      print(e);
    }
  }

  Future<void> _applyUploadParams(EasyRichEditorUploadParams? params) async {
    // 获取能力(用于H5获取当前AppBridge的方法列表)
    print("_applyUploadParams params===>${params.toString()}");
    print("_applyUploadParams bridge===>$_bridge");
    final bridge = _bridge;
    if (bridge == null || params == null) return;
    _bridge!.register(
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

  Future<String?> _fetchValueHtml() async {
    final bridge = _bridge;
    if (bridge == null) return null;
    try {
      final result = await bridge.invokeJs('richEditor.getValueHtml');
      final html = _extractValueHtml(result);
      widget.onChange?.call(html);
      if (mounted) {
        setState(() {});
      }
      return html;
    } catch (e) {
      return null;
    }
  }

  String? _extractValueHtml(dynamic result) {
    return result is Map && result['valueHtml'] != null
        ? result['valueHtml'].toString()
        : result?.toString();
  }

  AppBridge? _extractBridge(Widget widget) {
    if (widget is H5WebView) {
      return widget.bridge;
    }
    return null;
  }

  void _registerBridgeListener() {
    final bridge = _bridge;
    if (bridge == null || _didRegisterBridgeListener) return;
    _didRegisterBridgeListener = true;
    bridge.onEvent('richEditor.valueHtmlChanged', (params) {
      final updatedHtml =
          params is Map && params['valueHtml'] != null
              ? params['valueHtml'].toString()
              : params?.toString();
      widget.onChange?.call(updatedHtml);
      if (!mounted) return;
      setState(() {});
    });
    bridge.onEvent('richEditor.rendered', (params) async {
      print('richEditor.rendered: $params');
      if (_didHandleRendered) return;
      _didHandleRendered = true;
      await _applyPreview(widget.preview);
      if (widget.initialValue.isNotEmpty) {
        await widget.controller?.setValueHtml(widget.initialValue);
      }
    });

    bridge.onEvent('richEditor.scrollHeight', (params) {
      print('richEditor.scrollHeight: $params');
      if (params is Map && params['scrollHeight'] != null) {
        final height = double.tryParse(params['scrollHeight'].toString());
        if (height != null && mounted) {
          setState(() {
            _webviewHeight = height;
          });
        }
      }
    });

    bridge.onEvent('richEditor.fullScreenChange', (params) {
      if (_suppressNextFullScreenEvent) {
        _suppressNextFullScreenEvent = false;
        return;
      }
      final isFullScreen = params is Map && params['isFullScreen'] == true;
      if (isFullScreen) {
        _openFullScreenDrawer();
      } else if (_isFullScreenDrawerOpen) {
        drawerWrapper.close();
      }
    });
  }

  @override
  void dispose() {
    if (_didRegisterBridgeListener && _bridge != null) {
      _bridge!.offEvent('richEditor.valueHtmlChanged');
      _bridge!.offEvent('richEditor.rendered');
      _bridge!.offEvent('richEditor.fullScreenChange');
      _didRegisterBridgeListener = false;
    }
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return EasyEmptyView(text: _error.toString());
    // 判断是否正在加载
    final isLoading = richEditorWidget is SizedBox && _bridge == null;

    if (isLoading) {
      return Container(
        width: double.infinity,
        height: widget.height ?? 300,
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF31DA9F)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;

        if (widget.height != null) {
          content = SizedBox(
            width: double.infinity,
            height: widget.height,
            child: richEditorWidget,
          );
        } else if (widget.preview && _webviewHeight != null) {
          content = SizedBox(
            width: double.infinity,
            height: _webviewHeight,
            child: richEditorWidget,
          );
        } else {
          if (constraints.maxHeight.isFinite) {
            content = SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: richEditorWidget,
            );
          } else {
            // Unbounded parent, fall back to a default height to prevent crash
            content = SizedBox(
              width: double.infinity,
              height: 300,
              child: richEditorWidget,
            );
          }
        }
        return content;
      },
    );
    // 调试用
    // return InAppWebView(
    //   initialSettings: InAppWebViewSettings(useHybridComposition: true),
    //   initialUrlRequest: URLRequest(url: WebUri("http://localhost:5173/")),
    //   onConsoleMessage:
    //       (controller, consoleMessage) => ErrorHandler.instance.logInfo(
    //         '[InAppWebView]: ${consoleMessage.message}',
    //       ),
    // );
  }

  Future<void> _openFullScreenDrawer() async {
    if (_isFullScreenDrawerOpen) return;
    final template = _richEditorWebViewTemplate;
    if (template == null) return;

    final currentHtml = await _fetchValueHtml();
    if (!mounted) return;

    final initialHtml = currentHtml ?? '';
    final fullScreenBridge = AppBridge();
    _fullScreenBridge = fullScreenBridge;

    var didApplyInitialHtml = false;
    final fullScreenWebView = H5WebView(
      appName: template.appName,
      nameEn: template.nameEn,
      nameZh: template.nameZh,
      bridge: fullScreenBridge,
      onlineUrl: template.onlineUrl,
      localFilePath: template.localFilePath,
      token: template.token,
      hideTitle: template.hideTitle,
      heroTag: template.heroTag,
      heroIcon: template.heroIcon,
      extraBridgeMethods: template.extraBridgeMethods,
      uploadParams: widget.uploadParams,
      onLoadStop: (_) {
        if (didApplyInitialHtml) return;
        didApplyInitialHtml = true;
        _applyValueHtmlWithRetry(fullScreenBridge, initialHtml);
      },
    );

    _isFullScreenDrawerOpen = true;
    drawerWrapper
        .show(
          context: context,
          barrierDismissible: false,
          child: EasyDrawer(
            bodyPadding: EdgeInsets.only(
              top: 16,
              left: 12,
              right: 12,
              bottom: 24,
            ),
            size: EasyDrawerSize.full,
            header: EasyDrawerTopBar(
              title: '全屏编辑',
              onBackButtonTap: () {
                drawerWrapper.close();
              },
            ),
            body: fullScreenWebView,
          ),
        )
        .then((_) => _handleFullScreenDrawerClosed());
  }

  Future<void> _handleFullScreenDrawerClosed() async {
    if (!_isFullScreenDrawerOpen) return;
    _isFullScreenDrawerOpen = false;

    final bridge = _fullScreenBridge;
    _fullScreenBridge = null;

    if (bridge != null) {
      final fullScreenHtml = await _fetchValueHtmlFromBridge(bridge);
      if (fullScreenHtml != null) {
        await _applyValueHtml(fullScreenHtml);
      }
    }

    _suppressNextFullScreenEvent = true;
    try {
      await _bridge?.invokeJs('richEditor.setFullScreen', {
        'isFullScreen': false,
      });
    } catch (_) {}
  }

  Future<String?> _fetchValueHtmlFromBridge(AppBridge bridge) async {
    try {
      final result = await bridge.invokeJs('richEditor.getValueHtml');
      return _extractValueHtml(result);
    } catch (_) {
      return null;
    }
  }

  Future<void> _applyValueHtmlWithRetry(
    AppBridge bridge,
    String html, {
    int maxAttempts = 3,
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      try {
        await bridge.invokeJs('richEditor.setValueHtml', {
          'valueHtml': html,
        }, const Duration(seconds: 2));
        return;
      } catch (e) {
        if (attempt == maxAttempts - 1) {
          ErrorHandler.instance.logError(
            '[EasyRichEditor] setValueHtml failed: $e',
          );
          return;
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    }
  }
}

/// 词库插入结果类
class GlossaryInsertResult {
  final bool success;
  final String? message;
  final String? glossaryId;
  final String? glossaryName;

  GlossaryInsertResult({
    required this.success,
    this.message,
    this.glossaryId,
    this.glossaryName,
  });

  factory GlossaryInsertResult.fromMap(Map<String, dynamic> map) {
    return GlossaryInsertResult(
      success: map['success'] == true,
      message: map['message']?.toString(),
      glossaryId: map['glossaryId']?.toString(),
      glossaryName: map['glossaryName']?.toString(),
    );
  }

  @override
  String toString() {
    return 'GlossaryInsertResult(success: $success, message: "$message", glossaryId: "$glossaryId", glossaryName: "$glossaryName")';
  }
}
