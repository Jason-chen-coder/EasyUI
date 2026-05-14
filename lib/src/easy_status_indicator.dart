import 'package:flutter/material.dart';

import 'easy_theme.dart';

class EasyStatusIndicator extends StatelessWidget {
  const EasyStatusIndicator({
    super.key,
    required this.text,
    this.width,
    this.padding,
    this.background,
    this.textStyle,
    this.alignment,
    this.border,
    this.maxLines,
  });

  factory EasyStatusIndicator.red({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x1FFF2728),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFFFF2728),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.blue({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x331484FC),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFF1484FC),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.amber({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x33F4BE59),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFFF4BE59),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.green({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x3331DA9F),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFF31DA9F),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.gray({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x338D8C8D),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFF8D8C8D),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.orange({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: const Color(0x33FF943D),
      textStyle: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFFFF943D),
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedRed({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final red = const Color(0xFFFF2728);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: red,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: red),
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedBlue({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final blue = const Color(0xFF1484FC);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: blue,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: blue),
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedAmber({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final amber = const Color(0xFFF4BE59);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: amber,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: amber),
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedGreen({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final green = const Color(0xFF31DA9F);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: green,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: green),
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedGray({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final gray = const Color(0xFF8D8C8D);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: gray,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: gray),
      maxLines: maxLines,
    );
  }

  factory EasyStatusIndicator.outlinedOrange({
    required String text,
    final double fontSize = 12,
    final double? width,
    final EdgeInsets? padding,
    final AlignmentGeometry? alignment,
    final int? maxLines,
  }) {
    final orange = const Color(0xFFFF943D);
    return EasyStatusIndicator(
      text: text,
      width: width,
      padding: padding,
      background: Colors.transparent,
      textStyle: TextStyle(
        fontSize: fontSize,
        color: orange,
        overflow: TextOverflow.ellipsis,
      ),
      alignment: alignment,
      border: Border.all(color: orange),
      maxLines: maxLines,
    );
  }

  /// 文本
  final String text;

  /// 宽度
  final double? width;

  /// 边距
  final EdgeInsets? padding;

  /// 背景色
  final Color? background;

  /// 文本样式
  final TextStyle? textStyle;

  /// 文本在容器中对齐方式
  final AlignmentGeometry? alignment;

  /// 边框
  final BoxBorder? border;

  /// 最大行数
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return Container(
      width: width,
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        color: background ?? easyTheme.primaryGreen.withAlpha(0x33),
        border: border,
      ),
      alignment: alignment,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: maxLines,
        style:
            textStyle ?? TextStyle(fontSize: 12, color: easyTheme.primaryGreen),
      ),
    );
  }
}
