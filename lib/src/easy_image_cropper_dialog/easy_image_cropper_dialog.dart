import 'package:easy_ui/easy_ui.dart';
import 'package:easy_ui/src/easy_image_cropper_dialog/crop_editor_helper.dart';
import 'package:easy_ui/src/easy_image_cropper_dialog/crop_layer_painter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'extended_file_image_provider_factory.dart';

typedef CroppedCallBack = Future<void> Function(Uint8List data);

class EasyImageCropperDialog extends StatefulWidget {
  final ImageProvider imageProvider;
  final String title;
  final BoxFit fit;
  final bool enableLoadState;
  final double cropAspectRatio;
  final EditorCropLayerPainter cropLayerPainter;
  final CroppedCallBack? onCropped;

  const EasyImageCropperDialog({
    super.key,
    required this.imageProvider,
    required this.title,
    required this.fit,
    required this.enableLoadState,
    required this.cropAspectRatio,
    required this.cropLayerPainter,
    this.onCropped,
  });

  /// 显示图片裁剪对话框，并在裁剪完成后返回图片的二进制数据（[Uint8List]）。
  ///
  /// 参数说明：
  /// [imageProvider] — 要裁剪的图片资源，支持 AssetImage、NetworkImage、FileImage、MemoryImage 等。
  /// [title] — 对话框顶部标题文本。
  /// [fit] — 图片适配裁剪区域的方式，默认为 [BoxFit.contain]。
  /// [enableLoadState] — 是否显示图片加载状态，默认为 true。
  /// [cropAspectRatio] — 裁剪区域的宽高比，默认为 [CropAspectRatios.ratio1_1]（正方形），可自定义。
  /// [cropLayerPainter] — 裁剪覆盖层的自定义 Painter，默认为 [CircleEditorCropLayerPainter]，可自定义覆盖层样式。
  /// [onCropped] — 裁剪完成后的回调，返回裁剪后的图片数据。
  ///
  /// 注意事项：
  /// - [imageProvider] 需保证可用（如文件存在、网络可访问）。
  /// - 可通过 [cropAspectRatio] 和 [cropLayerPainter] 自定义裁剪行为和样式。
  /// - 返回值为裁剪后的图片二进制数据，若取消则为 null。
  static Future<Uint8List?> show(
    BuildContext context, {
    required ImageProvider imageProvider,
    required String title,
    BoxFit fit = BoxFit.contain,
    bool enableLoadState = true,
    double cropAspectRatio = CropAspectRatios.ratio1_1,
    EditorCropLayerPainter cropLayerPainter =
        const CircleEditorCropLayerPainter(),
    CroppedCallBack? onCropped,
  }) async {
    final easyTheme = EasyTheme.of(context);
    return await showDialog<Uint8List?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(easyTheme.cornerMedium),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700, maxHeight: 600),
            child: EasyImageCropperDialog(
              imageProvider: imageProvider,
              title: title,
              fit: fit,
              enableLoadState: enableLoadState,
              cropAspectRatio: cropAspectRatio,
              cropLayerPainter: cropLayerPainter,
              onCropped: onCropped,
            ),
          ),
        );
      },
    );
  }

  @override
  State<EasyImageCropperDialog> createState() => _CropperDialogContentState();
}

class _CropperDialogContentState extends State<EasyImageCropperDialog> {
  final ImageEditorController _editorController = ImageEditorController();

  bool _processing = false;

  /// 裁剪器
  Widget _buildExtendedImage() {
    /// 注意ExtendedImage使用的ImageProvider是经过拓展的，和原版的不一样
    late final ImageProvider? provider;

    switch (widget.imageProvider) {
      case FileImage image:
        provider = createExtendedFileImageProvider(image);
        break;
      case NetworkImage image:
        provider = ExtendedNetworkImageProvider(image.url, cacheRawData: true);
        break;
      case AssetImage image:
        provider = ExtendedAssetImageProvider(
          image.assetName,
          package: image.package,
          cacheRawData: true,
        );
        break;
      case MemoryImage image:
        provider = ExtendedMemoryImageProvider(image.bytes, cacheRawData: true);
        break;
      case ResizeImage image:
        provider = ExtendedResizeImage(image, cacheRawData: true);
        break;
      default:
        provider = null;
        break;
    }

    if (provider == null) return Container();

    return ExtendedImage(
      image: provider,
      fit: widget.fit,
      mode: ExtendedImageMode.editor,
      enableLoadState: widget.enableLoadState,
      initEditorConfigHandler: (ExtendedImageState? state) {
        return EditorConfig(
          cropAspectRatio: CropAspectRatios.ratio1_1,
          cropLayerPainter: CircleEditorCropLayerPainter(),
          controller: _editorController,
        );
      },
    );
  }

  /// 工具栏
  Widget _buildCropperToolbar(ImageEditorController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.all(EasyTheme.of(context).cornerMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          IconButton(
            icon: Icon(Icons.rotate_left, color: Colors.white),
            onPressed: () => controller.rotate(),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.reset(),
          ),
        ],
      ),
    );
  }

  /// 底部操作按钮
  Widget _buildBottomActions() {
    return Builder(
      builder: (context) {
        final localizations = EasyUiLocalizations.of(context);
        return Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            spacing: 16,
            children: [
              Expanded(
                child: EasyNotifyDialogOutlinedButton(
                  text: localizations.cancel,
                  onPressed:
                      _processing
                          ? null
                          : () => Navigator.of(context).pop(null),
                ),
              ),
              Expanded(
                child: _ProcessingTextButton(
                  processing: _processing,
                  text: localizations.confirm,
                  onPressed: _onConfirm,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 20, color: easyTheme.neutral33),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              _buildExtendedImage(),
              Positioned(
                right: 16,
                bottom: 16,
                child: _buildCropperToolbar(_editorController),
              ),
              if (_processing)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: AbsorbPointer(),
                ),
            ],
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Future<void> _onConfirm() async {
    setState(() => _processing = true);
    try {
      final imageInfo = await cropImageDataWithDartLibrary(_editorController);
      final data = imageInfo.data;
      if (data != null) await widget.onCropped?.call(data);
      if (mounted) Navigator.of(context).pop(data);
    } catch (e) {
      showToastError(text: e.toString());
      if (mounted) Navigator.of(context).pop(null);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }
}

class _ProcessingTextButton extends StatelessWidget {
  const _ProcessingTextButton({
    required this.processing,
    required this.text,
    this.onPressed,
  });

  final bool processing;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final textWidget = Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.white),
    );
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: processing ? Colors.grey : easyTheme.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
        minimumSize: Size(double.infinity, 34),
        fixedSize: Size(double.infinity, 34),
        maximumSize: Size.fromWidth(double.infinity),
        padding: EdgeInsets.zero,
      ),
      onPressed: processing ? null : onPressed,
      child:
          processing
              ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: easyTheme.primaryGreen,
                    ),
                  ),
                  textWidget,
                ],
              )
              : textWidget,
    );
  }
}
