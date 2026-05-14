import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../easy_theme.dart';
import '../l10n/gen/easy_ui_localizations.dart';

class EasyTypographyParagraph extends StatefulWidget {
  const EasyTypographyParagraph({
    super.key,
    required this.text,
    this.rows = 3,
    this.expandable = false,
    this.onExpand,
    this.style,
    this.textAlign = TextAlign.start,
    this.moreButtonText,
    this.moreButtonTextStyle,
    this.ellipsis = '...',
    this.collapseButtonText,
    this.collapseButtonTextStyle,
  });

  /// 文本内容
  final String text;

  /// 最大显示行数
  final int rows;

  /// 是否可展开
  final bool expandable;

  /// 点击"更多"按钮的回调函数
  /// 如果为空，则直接展开所有内容
  /// 如果不为空，则执行此回调
  final VoidCallback? onExpand;

  /// 文本样式
  final TextStyle? style;

  /// 文本对齐方式
  final TextAlign textAlign;

  /// "更多"按钮文案
  /// 如果为空，则使用国际化默认文本
  final String? moreButtonText;

  /// "更多"按钮文本样式
  final TextStyle? moreButtonTextStyle;

  /// 省略号
  final String ellipsis;

  /// "收起"按钮文案
  /// 如果为空，则使用国际化默认文本
  final String? collapseButtonText;

  /// "收起"按钮文本样式
  final TextStyle? collapseButtonTextStyle;

  @override
  State<EasyTypographyParagraph> createState() =>
      _EasyTypographyParagraphState();
}

class _EasyTypographyParagraphState extends State<EasyTypographyParagraph> {
  bool _isExpanded = false;

  @override
  void didUpdateWidget(EasyTypographyParagraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _isExpanded = false;
    }
  }

  /// 检查文本是否超过行数限制
  bool _isTextOverflow(double maxWidth, TextStyle defaultStyle) {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: defaultStyle),
      textDirection: TextDirection.ltr,
      maxLines: widget.rows,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  /// 获取在指定行数内能显示的最大字符数
  int _getMaxCharIndex(
    double maxWidth,
    TextStyle defaultStyle,
    String moreText,
  ) {
    // 二分查找
    int left = 0;
    int right = widget.text.length;
    int result = 0;

    while (left <= right) {
      int mid = (left + right) ~/ 2;
      final testText = '${widget.text.substring(0, mid)}$moreText';

      final testPainter = TextPainter(
        text: TextSpan(text: testText, style: defaultStyle),
        textDirection: TextDirection.ltr,
        maxLines: widget.rows,
      );
      testPainter.layout(maxWidth: maxWidth);

      if (!testPainter.didExceedMaxLines) {
        result = mid;
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final localizations = EasyUiLocalizations.of(context);

    // 获取国际化文本
    final moreButtonText =
        widget.moreButtonText ?? localizations.typographyParagraphMore;
    final collapseButtonText =
        widget.collapseButtonText ?? localizations.typographyParagraphCollapse;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 默认文本样式
        final defaultStyle =
            widget.style ?? TextStyle(color: easyTheme.neutral33);

        final isOverflow = _isTextOverflow(constraints.maxWidth, defaultStyle);
        final shouldShowMoreButton =
            widget.expandable && isOverflow && !_isExpanded;

        // 如果已展开，显示全部文本
        if (_isExpanded) {
          final collapseRecognizer =
              TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _isExpanded = false;
                  });
                };

          return RichText(
            text: TextSpan(
              text: widget.text,
              style: defaultStyle,
              children: [
                TextSpan(
                  text: collapseButtonText,
                  style:
                      widget.collapseButtonTextStyle ??
                      TextStyle(
                        fontSize: 14,
                        color: easyTheme.secondaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                  recognizer: collapseRecognizer,
                ),
              ],
            ),
            textAlign: widget.textAlign,
          );
        }

        // 如果不需要显示"更多"按钮，正常显示文本
        if (!shouldShowMoreButton) {
          return Text(
            widget.text,
            style: defaultStyle,
            textAlign: widget.textAlign,
            maxLines: widget.rows,
            overflow: TextOverflow.ellipsis,
          );
        }

        // 需要显示"更多"按钮：使用 RichText
        final recognizer =
            TapGestureRecognizer()
              ..onTap = () {
                if (widget.onExpand != null) {
                  widget.onExpand!();
                } else {
                  setState(() {
                    _isExpanded = true;
                  });
                }
              };

        // 获取最大字符数
        final moreDisplayText = '${widget.ellipsis}$moreButtonText';
        final maxCharIndex = _getMaxCharIndex(
          constraints.maxWidth,
          defaultStyle,
          moreDisplayText,
        );
        final displayText = widget.text.substring(0, maxCharIndex);

        return RichText(
          text: TextSpan(
            text: displayText,
            style: defaultStyle,
            children: [
              TextSpan(text: widget.ellipsis, style: defaultStyle),
              TextSpan(
                text: moreButtonText,
                style:
                    widget.moreButtonTextStyle ??
                    TextStyle(
                      fontSize: 14,
                      color: easyTheme.secondaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                recognizer: recognizer,
              ),
            ],
          ),
          textAlign: widget.textAlign,
          maxLines: widget.rows,
          overflow: TextOverflow.clip,
        );
      },
    );
  }
}
