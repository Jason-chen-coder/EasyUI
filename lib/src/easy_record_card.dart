import 'package:flutter/material.dart';

import 'easy_long_press_copyable.dart';
import 'easy_theme.dart';

class EasyRecordCard extends StatelessWidget {
  const EasyRecordCard({
    super.key,
    required this.title,
    this.titleStyle,
    this.leading,
    this.endSideButtons = const [],
    this.propertyRows = const [],
    this.propertyStyle,
    this.extra,
  });

  /// 左侧widget
  final Widget? leading;

  /// 标题
  final String title;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 右侧按钮
  final List<Widget> endSideButtons;

  /// 属性列表
  final List<Widget> propertyRows;

  /// 属性样式
  final TextStyle? propertyStyle;

  /// 额外Widget
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    final effectiveTitleStyle =
        titleStyle ??
        TextStyle(
          fontSize: 14,
          color: easyTheme.neutral33,
          fontWeight: FontWeight.bold,
        );

    final properties =
        propertyRows.isEmpty
            ? null
            : DefaultTextStyle.merge(
              style:
                  propertyStyle ??
                  TextStyle(fontSize: 12, color: easyTheme.neutral99),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: propertyRows,
              ),
            );

    return Container(
      decoration: BoxDecoration(
        color: easyTheme.neutralF8,
        borderRadius: BorderRadius.all(easyTheme.cornerMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (leading != null) leading!,
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EasyLongPressCopyable(
                    child: Text(title, style: effectiveTitleStyle),
                  ),
                  if (properties != null)
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: properties,
                    ),
                  if (extra != null) extra!,
                ],
              ),
            ),
          ),
          if (endSideButtons.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 24, right: 24, bottom: 24),
              child: IntrinsicWidth(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: endSideButtons,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EasyCardButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? disableColor;

  const EasyCardButton({
    super.key,
    required this.text,
    required this.icon,
    this.backgroundColor,
    this.onPressed,
    this.textColor,
    this.disableColor,
  });

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return FilledButton(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: backgroundColor ?? easyTheme.primaryGreen,
        disabledBackgroundColor: disableColor ?? easyTheme.neutralBB,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 8,
        children: [
          icon,
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
