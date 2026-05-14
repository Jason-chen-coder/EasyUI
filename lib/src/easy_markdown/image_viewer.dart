import 'dart:typed_data';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';

import '../l10n/gen/easy_ui_localizations.dart';

class ImageViewer extends StatelessWidget {
  final String url;
  final Map<String, String> attributes;
  const ImageViewer(this.url, this.attributes, {super.key});

  @override
  Widget build(BuildContext context) {
    double? width;
    double? height;
    if (attributes['width'] != null) width = double.parse(attributes['width']!);
    if (attributes['height'] != null) {
      height = double.parse(attributes['height']!);
    }

    final imageUrl = attributes['src'] ?? '';
    final alt = attributes['alt'] ?? '';
    final isNetImage = imageUrl.startsWith('http');
    final isBase64Image = imageUrl.startsWith('data:image/');
    Image imgWidget;

    if (isBase64Image) {
      // 处理base64图片
      try {
        // 解析data URL格式: data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA...
        final Uri dataUri = Uri.parse(imageUrl);
        final Uint8List? bytes = dataUri.data?.contentAsBytes();

        if (bytes != null) {
          imgWidget = Image.memory(
            bytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stacktrace) {
              return buildErrorImage(ctx, imageUrl, alt, error);
            },
          );
        } else {
          // base64解码失败，显示错误图片
          return buildErrorImage(context, imageUrl, alt, 'Invalid base64 data');
        }
      } catch (e) {
        // base64解析失败，显示错误图片
        return buildErrorImage(context, imageUrl, alt, e);
      }
    } else if (isNetImage) {
      imgWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return CircularProgressIndicator(
            strokeWidth: 5,
            color: Theme.of(context).primaryColor,
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
          );
        },
        errorBuilder: (ctx, error, stacktrace) {
          return buildErrorImage(ctx, imageUrl, alt, error);
        },
      );
    } else {
      imgWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (ctx, error, stacktrace) {
          return buildErrorImage(ctx, imageUrl, alt, error);
        },
      );
    }

    // 用于追踪图片加载状态
    return _ImageTapWrapper(imageWidget: imgWidget, alt: alt);
  }

  Widget buildErrorImage(
    BuildContext context,
    String url,
    String alt,
    Object? error,
  ) {
    return Tooltip(
      message: EasyUiLocalizations.of(context).loadImageFailed,
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
              child: Icon(Icons.broken_image, color: Colors.redAccent),
              alignment: PlaceholderAlignment.middle,
            ),
            TextSpan(text: alt),
          ],
        ),
      ),
    );
  }
}

/// 只有加载成功时才可点击放大
class _ImageTapWrapper extends StatefulWidget {
  final Image imageWidget;
  final String alt;
  const _ImageTapWrapper({required this.imageWidget, required this.alt});

  @override
  State<_ImageTapWrapper> createState() => _ImageTapWrapperState();
}

class _ImageTapWrapperState extends State<_ImageTapWrapper> {
  bool _isLoaded = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    final ImageStream stream = widget.imageWidget.image.resolve(
      const ImageConfiguration(),
    );
    stream.addListener(
      ImageStreamListener(
        (_, __) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onError: (_, __) {
          if (mounted) setState(() => _isError = true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          (_isLoaded && !_isError)
              ? () {
                showImageViewer(
                  context,
                  widget.imageWidget.image,
                  swipeDismissible: true,
                  doubleTapZoomable: true,
                  closeButtonTooltip: EasyUiLocalizations.of(context).close,
                );
              }
              : null,
      child: widget.imageWidget,
    );
  }
}
