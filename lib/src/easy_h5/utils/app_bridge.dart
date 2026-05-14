import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:easy_ui/src/easy_utils/easy_tool_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import 'common.dart';

typedef BridgeHandler = FutureOr<dynamic> Function(dynamic params);

class BridgeMethodSpec {
  final String method;
  final BridgeHandler handler;
  final String? description;
  final String? paramsDescription;

  const BridgeMethodSpec({
    required this.method,
    required this.handler,
    this.description,
    this.paramsDescription,
  });
}

/// AppBridge：Flutter 与 H5 之间的双向通信桥接
///
/// 这是一个简洁、版本化的双向通信桥接，用于在 Flutter 应用和 H5 页面之间进行通信。
///
/// # 核心功能
/// - **实例化模式**：每个 WebView 使用独立实例，避免多 WebView 串台
/// - **自动注入 JS SDK**：在 WebView 加载时自动注入 `window.AppBridge` 对象供 H5 使用
/// - **双向请求/响应**：支持超时控制和错误处理的请求-响应机制
/// - **双向事件通信**：支持事件的发送和监听
/// - **白名单方法路由**：Flutter 端仅执行已注册的方法
///
/// # Flutter 端使用示例
/// ```dart
/// // 1. 创建桥接实例
/// final bridge = AppBridge();
///
/// // 2. 初始化 - 在 WebView 加载完成后调用
/// await bridge.attach(controller);
///
/// // 3. 注册方法供 H5 调用
/// bridge.register('user.getProfile', (params) async {
///   return {'name': 'John', 'age': 30};
/// },
///   description: '获取用户信息',
///   paramsDescription: '''参数格式：Map（可选）
///
/// 示例：
/// {
///   "userId": "123"  // 用户ID，可选
/// }
///
/// 调用示例：
/// as.user.getProfile({ userId: "123" })
/// as.user.getProfile()  // 不传参数''');
///
/// // 4. 监听 H5 发送的事件
/// bridge.onEvent('app.visibility', (params) {
///   print('应用可见性改变: $params');
/// });
///
/// // 5. 调用 H5 注册的方法
/// try {
///   final result = await bridge.invokeJs('page.getState');
///   print('H5 页面状态: $result');
/// } catch (e) {
///   print('调用失败: $e');
/// }
///
/// // 6. 向 H5 发送事件
/// await bridge.emitEventToJs('app.ready', {
///   'timestamp': DateTime.now().millisecondsSinceEpoch,
///   'version': '1.0'
/// });
/// ```
///
/// # H5 端使用示例
/// ```javascript
/// // 1. 注册方法供 Flutter 调用
/// AppBridge.register('page.getState', async (params) => {
///   return { ready: true, data: {...} };
/// });
///
/// // 2. 监听 Flutter 发送的事件
/// AppBridge.on('app.visibility', (payload) => {
///   console.log('应用可见性改变:', payload);
/// });
///
/// // 3. 调用 Flutter 注册的方法
/// try {
///   const result = await AppBridge.invoke('user.getProfile');
///   console.log('用户信息:', result);
/// } catch (e) {
///   console.error('调用失败:', e);
/// }
///
/// // 4. 向 Flutter 发送事件
/// AppBridge.emit('page.ready', {
///   title: '页面已加载',
///   timestamp: Date.now()
/// });
/// ```
///
/// # 内置方法
/// - `as.getCapabilities()` - 获取当前 AppBridge 的能力和可用方法列表
/// - `as.getInfo()` - 获取设备和应用信息
/// - `as.selectFile(options)` - 打开文件选择器供用户选择文件
/// - `as.downloadBlob(data)` - 下载 Blob 数据到本地文件系统
///
/// # 参数自动解包机制
/// AppBridge 会自动解包单参数调用，简化参数处理：
/// - 当 H5 调用 `as.method(singleArg)` 时
/// - Flutter 端 handler 直接收到 `singleArg`，而不是 `[singleArg]`
/// - 多参数调用时仍然接收数组：`as.method(arg1, arg2)` → `[arg1, arg2]`
/// - 这使得大多数单参数方法无需手动判断和解包参数
///
/// # 注意事项
/// - 所有方法都支持超时控制（默认 10 秒）
/// - 所有参数和返回值应该是可 JSON 序列化的
/// - 建议方法名采用 `domain.action` 的格式以避免冲突
class AppBridge {
  AppBridge({this.version = '1.0'}) {
    // Initialize default handlers immediately when instance is created
    _initDefaultHandlers();
  }

  final String version;
  InAppWebViewController? _controller;

  final Map<String, FutureOr<dynamic> Function(dynamic params)> _routes = {};
  final Map<String, void Function(dynamic params)> _eventListeners = {};

  final Map<String, _PendingRequest> _pendingJsRequests = {};
  final Map<String, String> _methodDescriptions = {};
  final Map<String, String> _methodParamsDescriptions = {};

  /// UserScript that injects the JS SDK at document start.
  UserScript get userScript => UserScript(
    source: _jsSdkSource,
    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
    contentWorld: ContentWorld.PAGE,
  );

  /// Attach to a created webview controller and set up handler.
  Future<void> attach(InAppWebViewController controller) async {
    _controller = controller;

    // Register the main JS handler
    controller.addJavaScriptHandler(
      handlerName: 'bridge:message',
      callback: (args) async {
        await _handleBridgeMessage(args);
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'asHandler',
      callback: (args) async {
        if (args.isEmpty) {
          throw Exception('Missing method name');
        }

        // Debug logging to understand the argument structure
        ErrorHandler.instance.logInfo(
          "[AppBridge] Received args: $args, types: ${args.map((e) => '${e.runtimeType}').toList()}",
        );

        // Extract method name - handle both [methodName, params] and [params] formats
        String method;
        dynamic params;

        if (args.isNotEmpty && args[0] is String) {
          // 解析方法名和参数
          // Standard format: [methodName, params, ...]
          method = args[0];
          params = args.length > 1 ? args[1] : [];

          // 智能参数解包：如果 params 是单元素数组，自动解包为该元素
          // 这样 H5 调用 method(singleArg) 时，Flutter 端直接收到 singleArg 而不是 [singleArg]
          //
          // 设计说明：
          // - 单参数调用（最常见）：method(arg) → 自动解包为 arg
          // - 多参数调用：method(arg1, arg2) → 保持为 [arg1, arg2]
          // - 无参数调用：method() → 空数组 []
          //
          // 如果某个方法需要区分 "传了一个数组" 和 "传了多个参数"，
          // 可以在该方法的 handler 中检查 params is List 来判断
          if (params is List && params.length == 1) {
            params = params[0];
            ErrorHandler.instance.logInfo(
              "[AppBridge] Auto-unpacked single-element array, new params type: ${params.runtimeType}",
            );
          }

          ErrorHandler.instance.logInfo(
            "[AppBridge] Using standard format - method: $method, params type: ${params.runtimeType}",
          );
        } else if (args.length >= 2) {
          // Possible alternative format where methodName might be in a different position
          // Try to find a string that looks like a method name
          String? foundMethod;
          for (int i = 0; i < args.length; i++) {
            if (args[i] is String) {
              foundMethod = args[i];
              break;
            }
          }

          if (foundMethod != null) {
            method = foundMethod;
            params = args.where((e) => e != foundMethod).toList();

            ErrorHandler.instance.logWarn(
              "[AppBridge] Using fallback format - method: $method found at index, params: $params",
            );
          } else {
            ErrorHandler.instance.logError(
              '[AppBridge] No string method name found in arguments. args: $args',
            );
            throw Exception(
              'No method name found. Received: ${args.map((e) => e.runtimeType).toList()}',
            );
          }
        } else {
          ErrorHandler.instance.logError(
            '[AppBridge] Invalid arguments. Expected at least method name. Received: $args',
          );
          throw Exception(
            'Invalid arguments format. args[0] type: ${args[0].runtimeType}',
          );
        }

        ErrorHandler.instance.logInfo(
          "[AppBridge] JS 调用 Flutter：方法名：$method；\n 参数：${params.toString()}",
        );
        try {
          // 路由到对应的处理程序
          if (_routes.containsKey('as.$method')) {
            return await _routes['as.$method']!(params);
          }

          // 如果没找到路由，抛出异常
          throw Exception("未知方法: $method");
        } catch (e) {
          // 抛出异常可在 JS 捕获
          throw Exception("Flutter 处理出错: ${e.toString()}");
        }
      },
    );
  }

  Future<void> _handleBridgeMessage(List<dynamic> args) async {
    if (args.isEmpty || args.first is! Map) {
      ErrorHandler.instance.logError(
        '[AppBridge] Invalid bridge:message payload: $args',
      );
      return;
    }

    final Map<String, dynamic> msg = Map<String, dynamic>.from(
      args.first as Map,
    );
    final String? type = msg['type'] as String?;

    switch (type) {
      case 'request':
        final String? method = msg['method'] as String?;
        final dynamic params = msg['params'];
        final String? id = msg['id']?.toString();

        if (method == null || id == null) {
          ErrorHandler.instance.logError(
            '[AppBridge] Missing method/id in request message: $msg',
          );
          return;
        }

        final handler = _routes[method];
        if (handler == null) {
          await _sendToJs({
            'v': version,
            'type': 'response',
            'id': id,
            'error': {'code': -32601, 'message': 'Method not found: $method'},
          });
          return;
        }

        try {
          final result = await handler(params);
          await _sendToJs({
            'v': version,
            'type': 'response',
            'id': id,
            'result': result,
          });
        } catch (e) {
          await _sendToJs({
            'v': version,
            'type': 'response',
            'id': id,
            'error': {'code': -32000, 'message': e.toString()},
          });
        }
        break;
      case 'response':
        final String? id = msg['id']?.toString();
        if (id == null) {
          ErrorHandler.instance.logWarn(
            '[AppBridge] Response missing id: $msg',
          );
          return;
        }
        final pending = _pendingJsRequests.remove(id);
        if (pending == null) {
          ErrorHandler.instance.logWarn(
            '[AppBridge] No pending request for response id: $id',
          );
          return;
        }
        pending.timer.cancel();
        if (msg['error'] != null) {
          pending.completer.completeError(msg['error']);
        } else {
          pending.completer.complete(msg['result']);
        }
        break;
      case 'event':
        final String? method = msg['method'] as String?;
        final dynamic params = msg['params'];
        if (method == null) {
          ErrorHandler.instance.logWarn(
            '[AppBridge] Event missing method: $msg',
          );
          return;
        }
        final listener = _eventListeners[method];
        if (listener != null) {
          listener(params);
        } else {
          ErrorHandler.instance.logWarn(
            '[AppBridge] No listener for event: $method',
          );
        }
        break;
      default:
        ErrorHandler.instance.logWarn(
          '[AppBridge] Unknown bridge message type: $msg',
        );
    }
  }

  /// Initialize default handlers that can be called from H5
  /// 初始化as 对象方法
  Future<void> _initDefaultHandlers() async {
    // 获取能力(用于H5获取当前AppBridge的方法列表)
    register(
      BridgeMethodSpec(
        method: 'as.getCapabilities',
        handler: (params) async {
          return _handleGetCapabilities();
        },
        description: "获取当前 AppBridge 的能力和可用方法列表",
        paramsDescription: '无参数',
      ),
    );
    // 获取设备信息
    register(
      BridgeMethodSpec(
        method: 'as.getInfo',
        handler: (params) async {
          return _handleGetInfo();
        },
        description: '获取设备和应用信息',
        paramsDescription: '无参数',
      ),
    );
    // 选择文件
    register(
      BridgeMethodSpec(
        method: 'as.selectFile',
        handler: (params) async {
          return await _handleSelectFile(params);
        },
        description: '打开文件选择器供用户选择文件',
        paramsDescription: '''参数格式：Map（可选）
H5 调用示例：as.selectFile({type: 'image', multiple: false})
Flutter 接收到的 params 将自动解包为：
{
  "type": "image",           // 文件类型: 'image'|'document'|'video'|'audio'|'all'，默认 'all'
  "multiple": false,         // 是否多选，默认 false
  "maxSize": 10485760,       // 最大文件大小（字节），默认 10MB
  "mimeTypes": ["image/*"]   // 允许的 MIME 类型列表，可选
}''',
      ),
    );
    // 下载 Blob 数据
    register(
      BridgeMethodSpec(
        method: 'as.downloadBlob',
        handler: (params) async {
          return await _handleDownloadBlob(params);
        },
        description: '下载 Blob 数据到本地文件系统',
        paramsDescription: '''参数格式：Map（必需）
H5 调用示例：as.downloadBlob({base64: '...', filename: 'doc.xlsx'})
Flutter 接收到的 params 将自动解包为：
{
  "base64": "UEsDBAoAAAAAANuYrV...",  // Base64 编码的文件数据（必需）
  "filename": "document.xlsx"         // 保存的文件名（必需）
}
''',
      ),
    );
    //   saveProtocol
    //     register(BridgeMethodSpec(
    //         method: 'as.saveProtocol',
    //         handler: (params) async {
    //           return await _handleSaveAlphaToolProtocol(params);
    //         },
    //         description: microAppL10n.saveAlphaToolProtocolDesc,
    //         paramsDescription: '''参数格式：String 或 Map（必需）
    // H5 调用示例：as.saveProtocol(protocolString) 或 as.saveProtocol({...})
    // Flutter 接收到的 params 将自动解包为协议数据（String 或 Object）：
    // - 如果是字符串：直接传递协议 JSON 字符串
    // - 如果是对象：{
    //   "protocolData": {          // 协议数据对象
    //     "name": "协议名称",
    //     "steps": [...],
    //     ...
    //   }
    // }'''));

    // 注册滚动同步方法
    register(
      BridgeMethodSpec(
        method: 'richEditor.onScroll',
        handler: (params) async {
          if (parentScrollController == null) return false;
          if (!parentScrollController!.hasClients) return false;

          try {
            double deltaY = 0.0;
            if (params is Map) {
              deltaY = (params['deltaY'] as num?)?.toDouble() ?? 0.0;
            } else if (params is num) {
              deltaY = params.toDouble();
            }

            if (deltaY == 0) return false;

            final position = parentScrollController!.position;
            final currentPixels = position.pixels;
            final newPixels = (currentPixels + deltaY).clamp(
              position.minScrollExtent,
              position.maxScrollExtent,
            );

            if (newPixels != currentPixels) {
              parentScrollController!.jumpTo(newPixels);
              return true;
            }
          } catch (e) {
            ErrorHandler.instance.logError('[AppBridge] Scroll sync error: $e');
          }
          return false;
        },
        description:
            'Sync web scroll event to flutter parent scroll controller',
        paramsDescription: '{ deltaY: number }',
      ),
    );
  }

  /// Optional ScrollController from parent to sync scroll events
  ScrollController? parentScrollController;

  // Future<bool> _handleSaveAlphaToolProtocol(dynamic params) async {
  //   print('_handleSaveAlphaToolProtocol params: $params');
  //
  //   // 由于已在 asHandler 中自动解包，params 现在直接是协议数据
  //   final protocolData = params;
  //
  //   final protocolStr = protocolData.toString();
  //   ErrorHandler.instance.logInfo(
  //       '[AppBridge] Saving protocol: ${protocolStr.length > 100 ? protocolStr.substring(0, 100) + '...' : protocolStr}');
  //
  //   // 打开抽屉，保存
  //   final wrapper = EasyDrawerWrapper();
  //   wrapper.show(
  //     context: microAppContext,
  //     mode: DrawerRenderMode.overlay,
  //     barrierDismissible: false,
  //     child: SaveAlphatoolProtocol(
  //       protocolData: protocolData,
  //     ),
  //   );
  //   return false;
  // }

  Future<Map<String, dynamic>> _handleGetCapabilities() async {
    return {
      'version': version,
      'methods': {
        for (final method in _routes.keys)
          method: {
            'description':
                _methodDescriptions[method] ?? 'No description available',
            if (_methodParamsDescriptions.containsKey(method))
              'params': _methodParamsDescriptions[method],
          },
      },
      'features': {
        'events': true,
        'requestFromFlutter': true,
        'requestFromJs': true,
      },
    };
  }

  Future<Map<String, dynamic>> _handleGetInfo() async {
    return {
      'device':
          Platform.isAndroid
              ? 'android'
              : Platform.isIOS
              ? 'ios'
              : Platform.isMacOS
              ? 'macos'
              : 'unknown',
      'version': version,
    };
  }

  /// Handle file selection request from H5
  ///
  /// Expected params format:
  /// {
  ///   'type': 'image'|'document'|'video'|'audio'|'all',  // 文件类型
  ///   'multiple': false,                                  // 单选/多选
  ///   'maxSize': 10485760,                                // 最大文件大小 (字节)
  ///   'mimeTypes': ['image/*']                            // 可选MIME类型限制
  /// }
  Future<Map<String, dynamic>> _handleSelectFile(dynamic params) async {
    try {
      // 1. 验证和解析参数
      final options = _parseFileSelectOptions(params);

      // 2. 请求权限
      await requestFileAccessPermissions();

      // 3. 打开文件选择器
      final result = await _pickFiles(options);

      if (result == null || result.files.isEmpty) {
        return {'success': false, 'error': "用户取消选择", 'code': 'USER_CANCELLED'};
      }

      // 4. 处理选中的文件
      final files = <Map<String, dynamic>>[];
      for (final file in result.files) {
        try {
          final fileData = await _processFile(file, options);
          if (fileData != null) {
            files.add(fileData);
          }
        } catch (e) {
          ErrorHandler.instance.logError(
            '[AppBridge] "处理文件 ${file.name} 失败": $e',
          );
          // 继续处理其他文件，但记录错误
        }
      }

      if (files.isEmpty) {
        return {
          'success': false,
          'error': "没有有效的文件被选中",
          'code': 'NO_VALID_FILES',
        };
      }

      return {
        'success': true,
        'data': {
          'files': files,
          'count': files.length,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      };
    } catch (e) {
      ErrorHandler.instance.logError('[AppBridge] selectFile error: $e');
      return {'success': false, 'error': e.toString(), 'code': 'ERROR'};
    }
  }

  /// Parse and validate file selection options
  Map<String, dynamic> _parseFileSelectOptions(dynamic params) {
    final Map<String, dynamic> options = {};

    // 由于已在 asHandler 中自动解包，params 现在直接是 Map 或 null
    if (params is Map) {
      final Map<String, dynamic> opts = params as Map<String, dynamic>;
      options['type'] = opts['type'] ?? 'all';
      options['multiple'] = opts['multiple'] ?? false;
      options['maxSize'] = opts['maxSize'] ?? 10485760; // 默认10MB
      options['mimeTypes'] = opts['mimeTypes'];
    } else {
      // 默认参数（无参数或参数格式不正确时）
      options['type'] = 'all';
      options['multiple'] = false;
      options['maxSize'] = 10485760;
      options['mimeTypes'] = null;
    }

    // 验证参数
    if (options['maxSize'] is! int || options['maxSize'] <= 0) {
      options['maxSize'] = 10485760;
    }
    if (options['maxSize'] > 1073741824) {
      // 最大1GB
      options['maxSize'] = 1073741824;
    }

    return options;
  }

  /// Pick files using FilePicker
  Future<FilePickerResult?> _pickFiles(Map<String, dynamic> options) async {
    final String fileType = options['type'] as String;
    final bool allowMultiple = options['multiple'] as bool;
    final List<String>? allowedExtensions = getExtensionsForType(fileType);

    // 如果有指定扩展名，必须使用 FileType.custom
    final FileType pickerFileType =
        (allowedExtensions != null && allowedExtensions.isNotEmpty)
            ? FileType.custom
            : getFilePickerType(fileType);

    return FilePicker.platform.pickFiles(
      type: pickerFileType,
      allowMultiple: allowMultiple,
      allowedExtensions: allowedExtensions,
      withData: true, // 在内存中加载文件数据
      withReadStream: false,
      lockParentWindow: true,
    );
  }

  /// Process a single file and convert to Base64
  /// Returns file data map or null if file is invalid
  Future<Map<String, dynamic>?> _processFile(
    PlatformFile file,
    Map<String, dynamic> options,
  ) async {
    // 1. 检查文件大小
    final maxSize = options['maxSize'] as int;
    if (file.size > maxSize) {
      throw Exception(
        "文件大小超过限制: ${file.size.toString()} > ${maxSize.toString()}",
      );
    }

    // 2. 获取文件数据
    late final Uint8List fileData;
    if (file.bytes != null) {
      fileData = file.bytes!;
    } else if (file.path != null) {
      // 在isolate中读取文件，避免阻塞主线程
      fileData = await readFileInIsolate(file.path!);
    } else {
      throw Exception("无法获取文件数据");
    }

    // 3. 验证MIME类型（可选）
    final allowedMimes = options['mimeTypes'] as List<String>?;
    if (allowedMimes != null && allowedMimes.isNotEmpty) {
      final fileMimeType = getMimeType(file.name);
      if (!isMimeTypeAllowed(fileMimeType, allowedMimes)) {
        throw Exception("文件类型不符合要求: $fileMimeType");
      }
    }

    // 4. 转换为Base64
    final base64String = base64Encode(fileData);
    final mimeType = getMimeType(file.name);

    return {
      'name': file.name,
      'size': file.size,
      'mimeType': mimeType,
      'lastModified':
          file.name.isNotEmpty
              ? (await File(file.path ?? '').lastModified())
                  .millisecondsSinceEpoch
              : DateTime.now().millisecondsSinceEpoch,
      'base64': 'data:$mimeType;base64,$base64String',
    };
  }

  /// Handle blob download request from H5
  /// Expected params format:
  /// {
  ///   'base64': 'UEsDBAoAAAAAANuYrV...',  // 直接的 base64 数据
  ///   'filename': 'layout.xlsx',
  ///   'mimeType': 'mimeType: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  /// }
  Future<Map<String, dynamic>> _handleDownloadBlob(dynamic params) async {
    try {
      // 由于已在 asHandler 中自动解包，params 现在直接是 Map
      String? base64String;
      String? filename;

      if (params is Map) {
        base64String = params['base64'] as String?;
        filename = params['filename'] as String?;
        debugPrint(
          '[AppBridge] Extracted from Map: base64=${base64String?.length ?? 0} bytes, filename=$filename',
        );
      }

      if (base64String == null || base64String.isEmpty) {
        return {
          'success': false,
          'error': "缺少 base64 数据",
          'code': 'MISSING_BASE64',
        };
      }

      if (filename == null || filename.isEmpty) {
        return {'success': false, 'error': "缺少文件名", 'code': 'MISSING_FILENAME'};
      }

      // 移除 data: URL 前缀如果存在
      String cleanBase64 = base64String;
      if (cleanBase64.startsWith('data:')) {
        final parts = cleanBase64.split(',');
        if (parts.length == 2) {
          cleanBase64 = parts[1];
        }
      }

      // 解码 base64
      final Uint8List fileBytes = base64Decode(cleanBase64);

      // 根据平台选择保存策略
      String? outputFilePath;
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        if (Platform.isAndroid) {
          await requestFileAccessPermissions();
        }

        final directoryPath = await FilePicker.platform.getDirectoryPath(
          dialogTitle: '选择保存位置',
        );

        if (directoryPath == null) {
          return {
            'success': false,
            'error': '用户取消保存',
            'code': 'USER_CANCELLED',
          };
        }
        outputFilePath = p.join(directoryPath, filename);
      } else {
        outputFilePath = await FilePicker.platform.saveFile(
          dialogTitle: '选择保存位置',
          fileName: filename,
        );

        if (outputFilePath == null) {
          return {
            'success': false,
            'error': '用户取消保存',
            'code': 'USER_CANCELLED',
          };
        }
      }

      // 在 isolate 中写入文件
      await writeFileInIsolate(outputFilePath, fileBytes);

      return {
        'success': true,
        'data': {
          'path': outputFilePath,
          'filename': filename,
          'size': fileBytes.length,
        },
      };
    } catch (e) {
      ErrorHandler.instance.logError('[AppBridge] downloadBlob error: $e');
      return {'success': false, 'error': e.toString(), 'code': 'ERROR'};
    }
  }

  void detach() {
    _controller = null;
    _pendingJsRequests.clear();
  }

  /// Register a Flutter handler for a method (JS -> Flutter requests).
  void register(BridgeMethodSpec spec) {
    ErrorHandler.instance.logInfo(
      '[AppBridge] Registering method: ${spec.method}',
    );
    _routes[spec.method] = spec.handler;
    if (spec.description != null) {
      _methodDescriptions[spec.method] = spec.description!;
    }
    if (spec.paramsDescription != null) {
      _methodParamsDescriptions[spec.method] = spec.paramsDescription!;
    }
  }

  void unregister(String method) {
    _routes.remove(method);
  }

  /// Listen to events emitted by JS (JS -> Flutter events).
  void onEvent(String event, void Function(dynamic params) listener) {
    _eventListeners[event] = listener;
  }

  void offEvent(String event) {
    _eventListeners.remove(event);
  }

  /// Emit an event to JS (Flutter -> JS events).
  Future<void> emitEventToJs(String event, [dynamic params]) async {
    await _sendToJs({
      'v': version,
      'type': 'event',
      'method': event,
      'params': params,
    });
  }

  /// Invoke a JS-registered method and get the result (Flutter -> JS request/response).
  Future<dynamic> invokeJs(
    String method, [
    dynamic params,
    Duration timeout = const Duration(seconds: 10),
  ]) async {
    final String id = _generateId();
    final completer = Completer<dynamic>();
    final timer = Timer(timeout, () {
      if (!completer.isCompleted) {
        _pendingJsRequests.remove(id);
        completer.completeError(_BridgeTimeoutError());
      }
    });
    _pendingJsRequests[id] = _PendingRequest(
      completer: completer,
      timer: timer,
    );

    await _sendToJs({
      'v': version,
      'type': 'request',
      'id': id,
      'method': method,
      'params': params,
    });

    return completer.future;
  }

  Future<void> _sendToJs(Map<String, dynamic> message) async {
    if (_controller == null) return;
    await _controller!.callAsyncJavaScript(
      functionBody: 'window.__bridge_onNativeMessage(message);',
      arguments: {'message': message},
    );
  }

  String _generateId() =>
      '${DateTime.now().millisecondsSinceEpoch}-${_idCounter++}';

  static int _idCounter = 0;
}

class _PendingRequest {
  _PendingRequest({required this.completer, required this.timer});
  final Completer<dynamic> completer;
  final Timer timer;
}

class _BridgeTimeoutError implements Exception {
  @override
  String toString() => 'BridgeTimeout(-32001): request timed out';
}

// JS SDK injected at document start.
const String _jsSdkSource = r"""
(function () {
  // Inject window.as proxy object for H5 communication
  window.as = new Proxy({}, {
    get: function(target, methodName) {
      return async function(...args) {
        try {
          // Call the registered asHandler with method name and parameters
          // IMPORTANT: Pass args as a single array parameter, not spread
          const result = await window.flutter_inappwebview.callHandler('asHandler', methodName, args);
          return result;
        } catch (e) {
          throw new Error(e.message || String(e));
        }
      };
    }
  });

  // Also inject the AppBridge SDK for backward compatibility
  if (window.AppBridge) return;

  const listeners = new Map();      // event -> Set<fn>
  const serverHandlers = new Map(); // method -> fn(params) => result
  const pending = new Map();        // id -> {resolve,reject,timer}
  let reqId = 0;

  function genId() { return `${Date.now()}-${++reqId}`; }

  function addListener(event, fn) {
    if (!listeners.has(event)) listeners.set(event, new Set());
    listeners.get(event).add(fn);
  }
  function removeListener(event, fn) {
    listeners.get(event)?.delete(fn);
  }
  function emitLocal(event, payload) {
    const set = listeners.get(event);
    if (!set) return;
    for (const fn of set) try { fn(payload); } catch (_) {}
  }

  async function sendMessage(msg) {
    if (window.AppBridge && typeof window.AppBridge.postMessage === 'function') {
      // If native provided a postMessage proxy, prefer it
      window.AppBridge.postMessage(msg);
      return;
    }
    if (window.flutter_inappwebview && typeof window.flutter_inappwebview.callHandler === 'function') {
      await window.flutter_inappwebview.callHandler('bridge:message', msg);
      return;
    }
    throw new Error('No native bridge available');
  }

  // Native -> JS entry point
  window.__bridge_onNativeMessage = function (msg) {
    try {
      if (!msg || typeof msg !== 'object') return;
      const { type } = msg;
      if (type === 'response') {
        const { id, result, error } = msg;
        const entry = id && pending.get(id);
        if (!entry) return;
        pending.delete(id);
        clearTimeout(entry.timer);
        if (error) entry.reject(Object.assign(new Error(error.message || 'BridgeError'), error));
        else entry.resolve(result);
        return;
      }
      if (type === 'event') {
        const { method, params } = msg;
        emitLocal(method, params);
        return;
      }
      if (type === 'request') {
        const { id, method, params } = msg;
        const fn = serverHandlers.get(method);
        if (!id) return;
        if (!fn) {
          sendMessage({ v: '1.0', type: 'response', id, error: { code: -32601, message: `Method not found: ${method}` } });
          return;
        }
        Promise.resolve()
          .then(() => fn(params))
          .then(result => sendMessage({ v: '1.0', type: 'response', id, result }))
          .catch(err => sendMessage({ v: '1.0', type: 'response', id, error: { code: -32000, message: String(err && err.message || err) } }));
        return;
      }
    } catch (_) {}
  };

  const AppBridge = {
    version: '1.0',
    invoke(method, params = {}, options = {}) {
      const id = genId();
      const timeoutMs = options.timeoutMs || 10000;
      const message = { v: '1.0', type: 'request', id, method, params };
      return new Promise((resolve, reject) => {
        const timer = setTimeout(() => {
          pending.delete(id);
          reject(Object.assign(new Error('BridgeTimeout'), { code: -32001 }));
        }, timeoutMs);
        pending.set(id, { resolve, reject, timer });
        sendMessage(message).catch(err => {
          clearTimeout(timer);
          pending.delete(id);
          reject(err);
        });
      });
    },
    on(event, handler) { addListener(event, handler); return () => removeListener(event, handler); },
    off(event, handler) { removeListener(event, handler); },
    emit(event, params) { return sendMessage({ v: '1.0', type: 'event', method: event, params }); },
    register(method, handler) { serverHandlers.set(method, handler); },
    unregister(method) { serverHandlers.delete(method); },
  };

  window.AppBridge = AppBridge;
})();
""";
