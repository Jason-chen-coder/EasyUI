import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../easy_ui.dart';
import 'easy_image_preview_wrapper.dart';
import 'easy_image_tool.dart';

/// 自定义网络图片组件，基于 Image / CachedNetworkImage，带加载中与错误占位
class EasyImage extends StatelessWidget {
  final String src;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? loadingPlaceholder;
  final Widget? errorPlaceholder;
  final BorderRadius? borderRadius;

  /// 图片缓存的宽度（图片将被解析为指定宽度）
  /// 单位为像素
  final int? cacheWidth;

  /// 图片缓存的高度（图片将被解析为指定高度）
  /// 单位为像素
  final int? cacheHeight;
  final String? semanticLabel;
  final bool excludeFromSemantics;
  final Color? color;
  final BlendMode? colorBlendMode;
  final AlignmentGeometry alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool isAntiAlias;
  final FilterQuality filterQuality;
  final String? packageName;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;

  /// 仅网络图片
  /// [imageUrl] 淡入动画的持续时间。
  final Duration fadeInDuration;

  /// 是否启用预览功能，点击图片时会打开全屏预览
  /// 默认值为 `false`
  final bool preview;

  /// 预览时的图片列表(可左右切换)
  /// 如果为 `null`，则默认只预览当前图片
  final List<String>? previewImages;

  /// 预览时的索引(用于指定从哪一张图片开始预览)
  /// 如果为 `null`，则默认从第一张图片开始预览
  final int? previewIndex;

  /// 是否显示缩略图
  /// 默认值为 `false`
  /// 如果为 `true`，则图片会被解析为容器约束对应的尺寸
  final bool displayThumbnail;

  const EasyImage({
    super.key,
    required this.src,
    this.width,
    this.height,
    this.fit,
    this.loadingPlaceholder,
    this.errorPlaceholder,
    this.borderRadius,
    this.cacheWidth,
    this.cacheHeight,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.isAntiAlias = false,
    this.filterQuality = FilterQuality.low,
    this.packageName,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.all(0),
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.preview = false,
    this.previewImages,
    this.previewIndex,
    this.displayThumbnail = false,
  });

  /// 打开图片预览
  void _openPreview(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder:
            (_, __, ___) => EasyImagePreviewWrapper(
              galleryItems: previewImages ?? [src],
              initialIndex: previewIndex ?? 0,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildImageWidget(int? cacheWidth, int? cacheHeight) {
      if (src.isAsset) {
        return Image.asset(
          src,
          package: packageName,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          color: color,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          errorBuilder:
              (context, error, stackTrace) => _buildPlaceholder(
                context,
                errorPlaceholder ?? _buildDefaultErrorPlaceholder(),
              ),
        );
      } else if (src.isNetwork) {
        // return Image.network(src);
        return CachedNetworkImage(
          imageUrl: src,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          fadeInDuration: fadeInDuration,
          memCacheWidth: cacheWidth,
          memCacheHeight: cacheHeight,
          placeholder:
              (context, url) => _buildPlaceholder(
                context,
                loadingPlaceholder ?? _buildDefaultLoadingPlaceholder(context),
              ),
          errorWidget:
              (context, url, error) => _buildPlaceholder(
                context,
                errorPlaceholder ?? _buildDefaultErrorPlaceholder(),
              ),
        );
      } else {
        // 处理本地文件路径，包括 file:// URI
        final filePath = src.normalizeFilePath;
        return Image.file(
          File(filePath),
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          cacheHeight: cacheHeight,
          cacheWidth: cacheWidth,
          errorBuilder:
              (context, error, stackTrace) => _buildPlaceholder(
                context,
                errorPlaceholder ?? _buildDefaultErrorPlaceholder(),
              ),
        );
      }
    }

    late final Widget imageWidget;

    if (displayThumbnail && cacheHeight == null && cacheWidth == null) {
      /// 设备像素比
      final dpr = MediaQuery.of(context).devicePixelRatio;

      /// 优先根据宽高计算缓存尺寸
      if (width != null || height != null) {
        imageWidget = buildImageWidget(
          width != null ? (width! * dpr).toInt() : null,
          height != null ? (height! * dpr).toInt() : null,
        );
      }
      /// 如果宽高都未指定，则使用 LayoutBuilder 根据约束计算缓存尺寸
      else {
        /// 应用阶梯算法，避免桌面端调节窗口尺寸时的频繁解码
        int applyStep(double targetPixels) {
          const cacheStepSize = 200;
          if (cacheStepSize <= 0) return targetPixels.toInt();
          // 向上取整到最近的阶梯倍数
          // 例如 step=150: 100px -> 150px, 151px -> 300px
          return (targetPixels / cacheStepSize).ceil() * cacheStepSize;
        }

        imageWidget = LayoutBuilder(
          builder: (context, constraints) {
            int? cacheWidth;
            int? cacheHeight;

            // 策略优先级逻辑：
            if (constraints.hasBoundedWidth) {
              // 优先使用宽度
              final double targetWidth = constraints.maxWidth * dpr;
              cacheWidth = applyStep(targetWidth);
            } else if (constraints.hasBoundedHeight) {
              // 如果宽度无界，则回退使用高度
              final double targetHeight = constraints.maxHeight * dpr;
              cacheHeight = applyStep(targetHeight);
            }

            return buildImageWidget(cacheWidth, cacheHeight);
          },
        );
      }
    } else {
      imageWidget = buildImageWidget(cacheWidth, cacheHeight);
    }

    Widget result = Container(
      width: width,
      height: height,
      color: backgroundColor,
      padding: padding,
      child: imageWidget,
    );

    if (preview) {
      result = GestureDetector(
        onTap: () => _openPreview(context),
        child: Hero(
          tag: 'easy_image_hero_${previewIndex ?? 0}_$src',
          child: result,
        ),
      );
    }

    if (borderRadius != null) {
      result = ClipRRect(borderRadius: borderRadius!, child: result);
    }

    return result;
  }

  Widget _buildPlaceholder(BuildContext context, Widget placeholder) {
    return SizedBox(width: width, height: height, child: placeholder);
  }

  Widget _buildDefaultLoadingPlaceholder(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final resolvedBorderRadius =
        borderRadius ?? BorderRadius.all(easyTheme.cornerSmall);

    return Shimmer.fromColors(
      baseColor: easyTheme.neutralEE,
      highlightColor: Colors.white,
      period: const Duration(milliseconds: 1800),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: easyTheme.neutralEE,
          borderRadius: resolvedBorderRadius,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildDefaultErrorPlaceholder() {
    return Image.asset(
      'assets/images/error_img.png',
      package: 'easy_ui',
      fit: BoxFit.contain,
    );
  }
}
