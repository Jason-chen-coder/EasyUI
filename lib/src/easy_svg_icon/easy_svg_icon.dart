import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:vector_graphics/vector_graphics_compat.dart'
    show RenderingStrategy;

import 'easy_svg_file_loader.dart';

class EasySvgIcon extends StatelessWidget {
  /// 对`SvgPicture`的一个封装，支持通过`IconTheme`来控制图标的大小和颜色
  const EasySvgIcon(
    this.bytesLoader, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    this.renderingStrategy = RenderingStrategy.picture,
  });

  EasySvgIcon.asset(
    String assetName, {
    super.key,
    this.matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    SvgTheme? theme,
    ColorMapper? colorMapper,
    this.colorFilter,
    this.renderingStrategy = RenderingStrategy.picture,
  }) : bytesLoader = SvgAssetLoader(
         assetName,
         packageName: package,
         assetBundle: bundle,
         theme: theme,
         colorMapper: colorMapper,
       );

  EasySvgIcon.network(
    String url, {
    super.key,
    Map<String, String>? headers,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    SvgTheme? theme,
    ColorMapper? colorMapper,
    http.Client? httpClient,
    this.renderingStrategy = RenderingStrategy.picture,
  }) : bytesLoader = SvgNetworkLoader(
         url,
         headers: headers,
         theme: theme,
         colorMapper: colorMapper,
         httpClient: httpClient,
       );

  EasySvgIcon.file(
    File file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    SvgTheme? theme,
    ColorMapper? colorMapper,
    this.renderingStrategy = RenderingStrategy.picture,
  }) : bytesLoader = createEasySvgFileLoader(
         file,
         theme: theme,
         colorMapper: colorMapper,
       );

  EasySvgIcon.memory(
    Uint8List bytes, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    SvgTheme? theme,
    ColorMapper? colorMapper,
    this.renderingStrategy = RenderingStrategy.picture,
  }) : bytesLoader = SvgBytesLoader(
         bytes,
         theme: theme,
         colorMapper: colorMapper,
       );

  EasySvgIcon.string(
    String string, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.colorFilter,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.errorBuilder,
    SvgTheme? theme,
    ColorMapper? colorMapper,
    this.renderingStrategy = RenderingStrategy.picture,
  }) : bytesLoader = SvgStringLoader(
         string,
         theme: theme,
         colorMapper: colorMapper,
       );

  /// The default placeholder for a SVG that may take time to parse or
  /// retrieve, e.g. from a network location.
  static WidgetBuilder defaultPlaceholderBuilder =
      (BuildContext ctx) => const LimitedBox();

  /// If specified, the width to use for the SVG.  If unspecified, the SVG
  /// will take the width of its parent.
  final double? width;

  /// If specified, the height to use for the SVG.  If unspecified, the SVG
  /// will take the height of its parent.
  final double? height;

  /// How to inscribe the picture into the space allocated during layout.
  /// The default is [BoxFit.contain].
  final BoxFit fit;

  /// How to align the picture within its parent widget.
  ///
  /// The alignment aligns the given position in the picture to the given position
  /// in the layout bounds. For example, an [Alignment] alignment of (-1.0,
  /// -1.0) aligns the image to the top-left corner of its layout bounds, while a
  /// [Alignment] alignment of (1.0, 1.0) aligns the bottom right of the
  /// picture with the bottom right corner of its layout bounds. Similarly, an
  /// alignment of (0.0, 1.0) aligns the bottom middle of the image with the
  /// middle of the bottom edge of its layout bounds.
  ///
  /// If the [alignment] is [TextDirection]-dependent (i.e. if it is a
  /// [AlignmentDirectional]), then a [TextDirection] must be available
  /// when the picture is painted.
  ///
  /// Defaults to [Alignment.center].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  /// The [BytesLoader] used to resolve the SVG.
  final BytesLoader bytesLoader;

  /// The placeholder to use while fetching, decoding, and parsing the SVG data.
  final WidgetBuilder? placeholderBuilder;

  /// If true, will horizontally flip the picture in [TextDirection.rtl] contexts.
  final bool matchTextDirection;

  /// If true, will allow the SVG to be drawn outside of the clip boundary of its
  /// viewBox.
  final bool allowDrawingOutsideViewBox;

  /// The [Semantics.label] for this picture.
  ///
  /// The value indicates the purpose of the picture, and will be
  /// read out by screen readers.
  final String? semanticsLabel;

  /// Whether to exclude this picture from semantics.
  ///
  /// Useful for pictures which do not contribute meaningful information to an
  /// application.
  final bool excludeFromSemantics;

  /// The content will be clipped (or not) according to this option.
  ///
  /// See the enum [Clip] for details of all possible options and their common
  /// use cases.
  ///
  /// Defaults to [Clip.hardEdge], and must not be null.
  final Clip clipBehavior;

  /// Widget displayed while the target image failed loading.
  final SvgErrorWidgetBuilder? errorBuilder;

  /// The color filter, if any, to apply to this widget.
  final ColorFilter? colorFilter;

  /// Widget rendering strategy used to balance flexibility and performance.
  ///
  /// See the enum [RenderingStrategy] for details of all possible options and their common
  /// use cases.
  ///
  /// Defaults to [RenderingStrategy.picture].
  final RenderingStrategy renderingStrategy;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    ColorFilter? effectiveColorFilter = colorFilter;

    if (effectiveColorFilter == null && iconTheme.color != null) {
      final color = iconTheme.color!;
      final opacity = iconTheme.opacity ?? 1.0;
      final effectiveColor =
          opacity == 1.0 ? color : color.withValues(alpha: opacity);
      effectiveColorFilter = ColorFilter.mode(effectiveColor, BlendMode.srcIn);
    }

    return SvgPicture(
      bytesLoader,
      width: width ?? iconTheme.size,
      height: height ?? iconTheme.size,
      fit: fit,
      alignment: alignment,
      placeholderBuilder: placeholderBuilder ?? defaultPlaceholderBuilder,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      semanticsLabel: excludeFromSemantics ? null : semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      colorFilter: effectiveColorFilter,
      errorBuilder: errorBuilder,
      renderingStrategy: renderingStrategy,
    );
  }
}
