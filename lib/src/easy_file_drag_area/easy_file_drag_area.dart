import 'dart:io' show Platform;

import 'package:easy_ui/easy_ui.dart' hide BorderType;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// 文件选择结果的统一数据类型
class EasyFileDraggedItem {
  const EasyFileDraggedItem({
    required this.name,
    required this.path,
    required this.size,
  });

  final String name;
  final String path;
  final int size;

  @override
  String toString() =>
      'EasyFileDraggedItem(name: $name, path: $path, size: $size)';
}

/// 控制器：允许父组件主动删除文件项
class EasyFileDragAreaController extends ChangeNotifier {
  bool _pendingClear = false;
  int? _pendingIndexRemove;
  EasyFileDraggedItem? _pendingItemRemove;

  /// 按具体的文件项删除
  void removeItem(EasyFileDraggedItem item) {
    _pendingItemRemove = item;
    notifyListeners();
  }

  /// 按索引删除
  void removeAt(int index) {
    _pendingIndexRemove = index;
    notifyListeners();
  }

  /// 清空所有文件
  void clear() {
    _pendingClear = true;
    notifyListeners();
  }

  bool _takePendingClear() {
    final shouldClear = _pendingClear;
    _pendingClear = false;
    return shouldClear;
  }

  EasyFileDraggedItem? _takePendingItemRemove() {
    final item = _pendingItemRemove;
    _pendingItemRemove = null;
    return item;
  }

  int? _takePendingIndexRemove() {
    final index = _pendingIndexRemove;
    _pendingIndexRemove = null;
    return index;
  }
}

class EasyFileDragArea extends StatefulWidget {
  const EasyFileDragArea({
    super.key,
    this.type = FileType.any,
    this.allowMultiple = false,
    this.allowedExtensions,
    this.onFilesChanged,
    this.showFileList = false,
    this.spacing = 16.0,
    this.fileItemSpacing = 8.0,
    this.controller,
    this.error,
    this.onError,
  });

  /// [type] 默认值为`FileType.any`，同`file_picker`的[FileType]，用于指定文件类型过滤器。
  /// 主要用于移动端打开不同的选择器。 例如：`FileType.image` 打开图片选择器。
  /// 在桌面端和拖动文件到组件时，会退化为使用扩展名过滤器进行过滤。
  final FileType type;

  /// 可选的扩展名过滤器，仅在[type]为`FileType.custom`时有效。
  final List<String>? allowedExtensions;

  /// 是否允许多选文件，默认值为`false`。
  final bool allowMultiple;

  /// 当文件被选中或拖入时的回调函数。
  final ValueChanged<List<EasyFileDraggedItem>>? onFilesChanged;

  /// 是否显示文件列表，默认值为`false`。
  final bool showFileList;

  /// 按钮和文件列表之间的间距，默认值为`16.0`。
  final double spacing;

  /// 文件列表项之间的间距，默认值为`8.0`。
  final double fileItemSpacing;

  /// 控制器，允许外部触发删除操作
  final EasyFileDragAreaController? controller;

  /// 错误提示文本
  final String? error;

  /// 文件选择失败时的回调。用于把异常抛给调用方做额外处理（自定义日志、上报等）。
  /// 组件内部已经会通过 `FlutterError.reportError` 打日志、`showToastError` 弹提示，
  /// 此回调是额外的钩子，不影响默认行为。
  final void Function(Object error)? onError;

  @override
  State<EasyFileDragArea> createState() => _EasyFileDragAreaState();
}

class _EasyFileDragAreaState extends State<EasyFileDragArea> {
  bool isDragging = false;
  bool isPicking = false;

  List<EasyFileDraggedItem> pickedItems = [];

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleControllerRequest);
  }

  @override
  void didUpdateWidget(covariant EasyFileDragArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerRequest);
      widget.controller?.addListener(_handleControllerRequest);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerRequest);
    super.dispose();
  }

  /// 选择文件
  void _pickFile() async {
    if (isPicking || isDragging) return;
    setState(() => isPicking = true);
    try {
      await Future.delayed(Durations.short4);
      final pickResult = await FilePicker.platform.pickFiles(
        type: widget.type,
        allowMultiple: widget.allowMultiple,
        allowedExtensions: widget.allowedExtensions,
        lockParentWindow: true,
      );

      if (pickResult != null && pickResult.files.isNotEmpty) {
        final newItems =
            pickResult.files
                .where((file) => file.path != null)
                .map(
                  (file) => EasyFileDraggedItem(
                    name: file.name,
                    path: file.path!,
                    size: file.size,
                  ),
                )
                .toList();

        _addItems(newItems);
      }
    } catch (e, st) {
      _handlePickError(e, st);
    } finally {
      if (mounted) setState(() => isPicking = false);
    }
  }

  /// 选择文件失败的统一收口：
  /// 1. `FlutterError.reportError` 把异常 + 堆栈 + 现场上下文打到控制台/DevTools
  /// 2. UI 层 `showToastError` 提示用户（Linux 缺少 zenity 时给可执行的安装命令）
  /// 3. 触发可选的 `onError` 回调供业务方做额外处理
  void _handlePickError(Object e, StackTrace st) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: e,
        stack: st,
        library: 'easy_file_drag_area',
        context: ErrorDescription(
          'EasyFileDragArea._pickFile failed '
          '(platform=${Platform.operatingSystem}, '
          'type=${widget.type}, '
          'allowMultiple=${widget.allowMultiple}, '
          'allowedExtensions=${widget.allowedExtensions})',
        ),
      ),
    );

    showToastError(text: _buildUserFacingMessage(e));

    widget.onError?.call(e);
  }

  String _buildUserFacingMessage(Object e) {
    if (_isMissingLinuxDialogHelper(e)) {
      return '文件选择器不可用：请安装 zenity 后重试'
          '（sudo apt-get update && sudo apt install zenity）';
    }
    return '文件选择失败：$e';
  }

  bool _isMissingLinuxDialogHelper(Object e) {
    if (!Platform.isLinux) return false;
    final msg = e.toString().toLowerCase();
    return msg.contains("couldn't find the executable") ||
        msg.contains('zenity') ||
        msg.contains('qarma') ||
        msg.contains('kdialog');
  }

  /// 拖动文件
  void _onDragDone(DropDoneDetails details) async {
    if (details.files.isEmpty) return;

    final allowedExtensions = fileTypeToFileFilter(
      widget.type,
      widget.allowedExtensions,
    );

    List<EasyFileDraggedItem> validItems = [];

    for (final xFile in details.files) {
      // 检查文件扩展名
      if (_isFileExtensionAllowed(xFile.path, allowedExtensions)) {
        final item = EasyFileDraggedItem(
          name: xFile.name,
          path: xFile.path,
          size: await xFile.length(),
        );
        validItems.add(item);

        // 如果不允许多选，只取第一个文件
        if (!widget.allowMultiple) {
          break;
        }
      }
    }

    if (validItems.isNotEmpty) _addItems(validItems);
  }

  /// 添加文件项
  void _addItems(List<EasyFileDraggedItem> newItems) {
    List<EasyFileDraggedItem> finalItems;

    if (widget.allowMultiple) {
      // 多选模式：去重后追加到现有列表
      final updatedItems = List<EasyFileDraggedItem>.from(pickedItems);

      for (final newItem in newItems) {
        // 检查是否已存在相同路径的文件，避免重复添加
        if (!updatedItems.any((item) => item.path == newItem.path)) {
          updatedItems.add(newItem);
        }
      }

      finalItems = updatedItems;
    } else {
      // 单选模式：直接替换
      finalItems = newItems;
    }

    setState(() => pickedItems = finalItems);
    widget.onFilesChanged?.call(finalItems);
  }

  /// 移除文件项
  void _onItemRemove(int index) {
    final updatedItems = List<EasyFileDraggedItem>.from(pickedItems);
    updatedItems.removeAt(index);
    setState(() => pickedItems = updatedItems);
    widget.onFilesChanged?.call(updatedItems);
  }

  void _handleControllerRequest() {
    if (widget.controller?._takePendingClear() ?? false) {
      if (pickedItems.isEmpty) return;
      setState(() => pickedItems = []);
      widget.onFilesChanged?.call(const []);
      return;
    }

    final indexToRemove = widget.controller?._takePendingIndexRemove();
    if (indexToRemove != null) {
      if (indexToRemove < 0 || indexToRemove >= pickedItems.length) return;
      final updatedItems = List<EasyFileDraggedItem>.from(pickedItems)
        ..removeAt(indexToRemove);
      setState(() => pickedItems = updatedItems);
      widget.onFilesChanged?.call(updatedItems);
      return;
    }

    final itemToRemove = widget.controller?._takePendingItemRemove();
    if (itemToRemove != null) {
      // 先定位是否存在，再执行删除，避免无效刷新
      final targetIndex = pickedItems.indexWhere(
        (item) => item.path == itemToRemove.path,
      );
      if (targetIndex == -1) return;

      final updatedItems = List<EasyFileDraggedItem>.from(pickedItems)
        ..removeAt(targetIndex);

      setState(() => pickedItems = updatedItems);
      widget.onFilesChanged?.call(updatedItems);
      return;
    }

    // final request = widget.controller?._takePending();
    // if (request == null) return;

    // final updatedItems = pickedItems
    //     .where((item) => !request.shouldRemove(item))
    //     .toList(growable: false);

    // if (updatedItems.length == pickedItems.length) return;

    // setState(() => pickedItems = updatedItems);
    // widget.onFilesChanged?.call(updatedItems);
  }

  /// 检查文件扩展名是否允许
  bool _isFileExtensionAllowed(
    String filePath,
    List<String> allowedExtensions,
  ) {
    if (allowedExtensions.isEmpty) return true;

    final extension = _getFileExtension(filePath);
    return allowedExtensions.any((ext) => ext.toLowerCase() == extension);
  }

  /// 获取文件扩展名（不包含点号）
  String _getFileExtension(String filePath) {
    final lastDot = filePath.lastIndexOf('.');
    if (lastDot == -1 || lastDot == filePath.length - 1) {
      return '';
    }
    return filePath.substring(lastDot + 1).toLowerCase();
  }

  List<String> fileTypeToFileFilter(
    FileType type,
    List<String>? allowedExtensions,
  ) {
    if (type != FileType.custom && (allowedExtensions?.isNotEmpty ?? false)) {
      throw ArgumentError.value(
        allowedExtensions,
        'allowedExtensions',
        '仅当 FileType 为 FileType.custom 时才允许使用 allowedExtensions'
            '请移除 allowedExtensions 或将 FileType 更改为 FileType.custom。',
      );
    }
    switch (type) {
      case FileType.any:
        return [];
      case FileType.audio:
        return ["aac", "midi", "mp3", "ogg", "wav"];
      case FileType.custom:
        return [...?allowedExtensions];
      case FileType.image:
        return ["bmp", "gif", "jpeg", "jpg", "png"];
      case FileType.media:
        return [
          "avi",
          "flv",
          "m4v",
          "mkv",
          "mov",
          "mp4",
          "mpeg",
          "webm",
          "wmv",
          "bmp",
          "gif",
          "jpeg",
          "jpg",
          "png",
        ];
      case FileType.video:
        return [
          "avi",
          "flv",
          "mkv",
          "mov",
          "mp4",
          "m4v",
          "mpeg",
          "webm",
          "wmv",
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: widget.spacing,
      children: [_buildButton(context), if (widget.showFileList) _buildList()],
    );
  }

  Widget _buildButton(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final l10n = EasyUiLocalizations.of(context);
    final hoverColor = Theme.of(context).hoverColor.withValues(alpha: 0.01);
    final hasError = widget.error != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DottedBorder(
          color: hasError ? easyTheme.warning : easyTheme.neutralEE,
          padding: EdgeInsets.zero,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          radius: easyTheme.cornerMedium,
          dashPattern: [6, 4],
          child: Material(
            borderRadius: BorderRadius.all(easyTheme.cornerMedium),
            clipBehavior: Clip.hardEdge,
            type: MaterialType.transparency,
            child: AnimatedContainer(
              duration: Durations.short3,
              color: isDragging ? hoverColor : Colors.transparent,
              child: DropTarget(
                onDragEntered: (_) => setState(() => isDragging = true),
                onDragExited: (_) => setState(() => isDragging = false),
                onDragDone: _onDragDone,
                enable: !isPicking,
                child: InkWell(
                  onTap: isDragging ? null : _pickFile,
                  hoverColor: hoverColor,
                  child: Container(
                    height: 181,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        // 上传图标 (占位符)
                        SvgPicture.asset(
                          'assets/svgs/ic_cloud_upload.svg',
                          package: 'easy_ui',
                          width: 45,
                          height: 31,
                        ),
                        // 上传提示文字
                        Text(
                          l10n.uploadButtonText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: easyTheme.neutral66,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.error?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              widget.error!,
              style: TextStyle(color: easyTheme.warning, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildList() {
    return Column(
      spacing: widget.fileItemSpacing,
      children: [
        for (int i = 0; i < pickedItems.length; i++)
          EasyFileDragAreaFileListItem(
            item: pickedItems[i],
            onRemove: () => _onItemRemove(i),
          ),
      ],
    );
  }
}

class EasyFileDragAreaFileListItem extends StatelessWidget {
  const EasyFileDragAreaFileListItem({
    super.key,
    required this.item,
    required this.onRemove,
  });

  final EasyFileDraggedItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: easyTheme.neutralF8,
        borderRadius: BorderRadius.all(easyTheme.cornerSmall),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        spacing: 12,
        children: [
          SvgPicture.asset(
            'assets/svgs/ic_document.svg',
            package: 'easy_ui',
            height: 32,
            width: 32,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14,
                    color: easyTheme.neutral66,
                    height: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  item.size.toReadableString,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    color: easyTheme.neutral99,
                    height: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          EasyButton2(
            type: EasyButtonType.iconDefault,
            size: EasyButtonSize.small,
            clipBehavior: Clip.hardEdge,
            onPressed: onRemove,
            style: EasyButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                Colors.transparent,
              ),
            ),
            child: Icon(Icons.clear, size: 12),
          ),
        ],
      ),
    );
  }
}

extension on int {
  String get toReadableString {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
