import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class EasyInfoItem {
  final String label;
  final Widget valueWidget;
  final double spacing;

  const EasyInfoItem({
    required this.label,
    required this.valueWidget,
    this.spacing = 28.0,
  });
}

class EasyInfoCard extends StatelessWidget {
  const EasyInfoCard({
    super.key,
    this.columnCount = 3,
    this.columnSpacing = 32.0,
    this.rowSpacing = 32.0,
    this.labelTextStyle,
    this.valueTextStyle,
    this.padding = const EdgeInsets.all(32),
    this.backgroundColor,
    this.borderRadius,
    required this.items,
  }) : assert(columnCount > 0, "columnCount must be greater than 0");

  /// 每行列数
  final int columnCount;

  /// 列间距
  final double columnSpacing;

  /// 行间距
  final double rowSpacing;

  /// 标签文本样式
  final TextStyle? labelTextStyle;

  /// 值文本样式
  final TextStyle? valueTextStyle;

  /// 子项
  final List<EasyInfoItem> items;

  /// 卡片间距
  final EdgeInsets padding;

  /// 背景色
  final Color? backgroundColor;

  /// 圆角
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    final labelTextStyle =
        this.labelTextStyle ??
        TextStyle(fontSize: 16, color: easyTheme.neutral99);
    final valueTextStyle =
        this.valueTextStyle ??
        TextStyle(fontSize: 16, color: easyTheme.neutral66);

    double calculateTextWidth(String labelText) {
      final labelPainter = TextPainter(
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
        text: TextSpan(
          text: labelText,
          style: defaultTextStyle.merge(labelTextStyle),
        ),
      )..layout();
      return labelPainter.width;
    }

    double maxLabelTextWidth = 0;
    for (var i = 0; i < items.length; ++i) {
      final item = items[i];
      final labelWidth = calculateTextWidth(item.label);
      if (labelWidth > maxLabelTextWidth) {
        maxLabelTextWidth = labelWidth;
      }
    }

    /// 如果标签文本过长，导致列宽过大，则减少列数
    late final int displayColCount;
    if (maxLabelTextWidth > 200) {
      displayColCount = (columnCount - 1).clamp(1, columnCount);
    } else {
      displayColCount = columnCount;
    }

    final rowCount = (items.length / displayColCount).ceil();
    final children = <Widget>[];
    for (var i = 0; i < rowCount; ++i) {
      final rowChildren = <Widget>[];
      for (var j = 0; j < displayColCount; ++j) {
        final item = items.elementAtOrNull(i * displayColCount + j);
        if (item == null) {
          rowChildren.add(const Spacer());
        } else {
          rowChildren.add(
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: maxLabelTextWidth + item.spacing,
                    child: Text(item.label, style: labelTextStyle),
                  ),
                  Expanded(
                    child: DefaultTextStyle(
                      style: defaultTextStyle.merge(valueTextStyle),
                      child: item.valueWidget,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }
      children.add(
        Row(
          spacing: columnSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rowChildren,
        ),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? easyTheme.neutralF8,
        borderRadius: borderRadius ?? BorderRadius.all(easyTheme.cornerSmall),
      ),
      child: Column(
        spacing: rowSpacing,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
