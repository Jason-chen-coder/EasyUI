import 'package:flutter/material.dart';

import '../easy_theme.dart';

/// hook掉[TextField]默认的label,counter,helper,error
abstract class EasyTextFormFieldDecorationLayoutDelegate {
  const EasyTextFormFieldDecorationLayoutDelegate();

  const factory EasyTextFormFieldDecorationLayoutDelegate.vertical({
    Widget? outerSuffix,
    bool showCounter,
    bool showBottomWidget,
  }) = VerticalEasyTextFormFieldDecorationLayoutDelegate;

  const factory EasyTextFormFieldDecorationLayoutDelegate.horizontal({
    double? labelWidth,
    double spacing,
    Widget? fieldLeftWidget,
    Widget? fieldRightWidget,
    bool showCounter,
  }) = HorizontalEasyTextFormFieldDecorationLayoutDelegate;

  Widget buildDecoration(
    BuildContext context, {
    required InputDecoration decoration,
    required bool filedHasError,
    required String? fieldErrorText,
    required int? maxLength,
    required Widget textField,
    required TextEditingController controller,
    required bool showRequiredMark,
  });
}

/// label在输入框上方，error/helper在输入框下方左侧，counter在输入框下方右侧的布局
class VerticalEasyTextFormFieldDecorationLayoutDelegate
    extends EasyTextFormFieldDecorationLayoutDelegate {
  const VerticalEasyTextFormFieldDecorationLayoutDelegate({
    this.outerSuffix,
    this.showCounter = false,
    this.showBottomWidget = true,
  });

  /// 该widget会放在输入框外的右侧，与输入框同一水平线
  final Widget? outerSuffix;

  /// 是否展示右下角的字数统计
  /// 默认值为`false`
  final bool showCounter;

  /// 是否展示输入框下方的组件（`error`/`helper`/`counter`）
  /// 该选项会覆盖`showCounter`
  /// 默认值为`true`
  final bool showBottomWidget;

  @override
  Widget buildDecoration(
    BuildContext context, {
    required InputDecoration decoration,
    required bool filedHasError,
    required String? fieldErrorText,
    required int? maxLength,
    required Widget textField,
    required TextEditingController controller,
    required bool showRequiredMark,
  }) {
    final easyTheme = EasyTheme.of(context);

    Widget? bottomLeftWidget;
    if (filedHasError && fieldErrorText != null && fieldErrorText.isNotEmpty) {
      bottomLeftWidget = Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          fieldErrorText ?? '',
          style: decoration.errorStyle,
          maxLines: decoration.errorMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else if (decoration.error != null) {
      bottomLeftWidget = decoration.error!;
    } else if (decoration.errorText != null &&
        decoration.errorText!.isNotEmpty) {
      bottomLeftWidget = Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          decoration.errorText!,
          style: decoration.errorStyle,
          maxLines: decoration.errorMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else if (decoration.helper != null) {
      bottomLeftWidget = decoration.helper!;
    } else if (decoration.helperText != null &&
        decoration.helperText!.isNotEmpty) {
      bottomLeftWidget = Padding(
        padding: EdgeInsets.only(top: 4),
        child: Text(
          decoration.helperText!,
          style: decoration.helperStyle,
          maxLines: decoration.helperMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    Widget? bottomRightWidget;
    if (showCounter) {
      if (decoration.counter != null) {
        bottomRightWidget = decoration.counter;
      } else if (maxLength != null) {
        bottomRightWidget = ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                decoration.counterText ?? '${value.text.length}/$maxLength',
                style: decoration.counterStyle,
              ),
            );
          },
        );
      }
    }

    Widget? topLeftWidget;
    if (decoration.label != null) {
      topLeftWidget = decoration.label;
    } else if (decoration.labelText != null) {
      topLeftWidget = Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text.rich(
          TextSpan(
            children: [
              if (showRequiredMark)
                TextSpan(
                  text: '* ',
                  style: decoration.labelStyle?.copyWith(
                    color: easyTheme.warning,
                  ),
                ),
              if (decoration.labelText!.isNotEmpty)
                TextSpan(text: decoration.labelText!),
            ],
          ),
          style: decoration.labelStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    if (topLeftWidget != null ||
        bottomLeftWidget != null ||
        bottomRightWidget != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          topLeftWidget ?? const SizedBox(),
          Table(
            columnWidths: {
              0: const FlexColumnWidth(),
              if (outerSuffix != null) 1: const IntrinsicColumnWidth(),
            },
            children: [
              TableRow(
                children: [
                  TableCell(child: textField),
                  if (outerSuffix != null)
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: outerSuffix!,
                      ),
                    ),
                ],
              ),
              if (showBottomWidget &&
                  (bottomLeftWidget != null || bottomRightWidget != null))
                TableRow(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16.0,
                      children: [
                        bottomLeftWidget != null
                            ? Expanded(child: bottomLeftWidget)
                            : const Spacer(),
                        bottomRightWidget ?? const SizedBox(),
                      ],
                    ),
                    if (outerSuffix != null) const SizedBox(),
                  ],
                ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        spacing: 16,
        children: [
          Flexible(child: textField),
          if (outerSuffix != null) outerSuffix!,
        ],
      );
    }
  }
}

/// label在输入框左侧，error/helper/counter在输入框右下方的布局
class HorizontalEasyTextFormFieldDecorationLayoutDelegate
    extends EasyTextFormFieldDecorationLayoutDelegate {
  const HorizontalEasyTextFormFieldDecorationLayoutDelegate({
    this.labelWidth,
    this.spacing = 8.0,
    this.fieldLeftWidget,
    this.fieldRightWidget,
    this.showCounter = false,
  });

  /// Label宽度，null表示不限制
  /// 如果没有Label,设置了也不会生效
  final double? labelWidth;

  /// Label到输入框之间的间距
  /// 如果没有Label,设置了也不会生效
  final double spacing;

  /// 输入框左侧Widget
  final Widget? fieldLeftWidget;

  /// 输入框右侧Widget
  final Widget? fieldRightWidget;

  /// 是否展示字数统计
  /// 默认值为false
  final bool showCounter;

  @override
  Widget buildDecoration(
    BuildContext context, {
    required InputDecoration decoration,
    required bool filedHasError,
    required String? fieldErrorText,
    required int? maxLength,
    required Widget textField,
    required TextEditingController controller,
    required bool showRequiredMark,
  }) {
    final easyTheme = EasyTheme.of(context);

    Widget? bottomRightWidget;
    if (filedHasError && fieldErrorText != null && fieldErrorText.isNotEmpty) {
      bottomRightWidget = Text(
        fieldErrorText ?? '',
        style: decoration.errorStyle,
        maxLines: decoration.errorMaxLines,
        overflow: TextOverflow.ellipsis,
      );
    } else if (decoration.error != null) {
      bottomRightWidget = decoration.error!;
    } else if (decoration.errorText != null &&
        decoration.errorText!.isNotEmpty) {
      bottomRightWidget = Text(
        decoration.errorText!,
        style: decoration.errorStyle,
        maxLines: decoration.errorMaxLines,
        overflow: TextOverflow.ellipsis,
      );
    } else if (decoration.helper != null) {
      bottomRightWidget = decoration.helper!;
    } else if (decoration.helperText != null &&
        decoration.helperText!.isNotEmpty) {
      bottomRightWidget = Text(
        decoration.helperText!,
        style: decoration.helperStyle,
        maxLines: decoration.helperMaxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    Widget? counter;
    if (showCounter) {
      if (decoration.counter != null) {
        counter = decoration.counter;
      } else if (maxLength != null) {
        counter = ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            return Text(
              decoration.counterText ?? '${value.text.length}/$maxLength',
              style: decoration.counterStyle,
            );
          },
        );
      }
    }

    Widget? label;
    if (decoration.label != null) {
      label = decoration.label;
    } else if (decoration.labelText != null) {
      label = Text.rich(
        TextSpan(
          children: [
            if (showRequiredMark)
              TextSpan(
                text: '* ',
                style: decoration.labelStyle?.copyWith(
                  color: easyTheme.warning,
                ),
              ),
            if (decoration.labelText!.isNotEmpty)
              TextSpan(text: decoration.labelText!),
          ],
        ),
        style: decoration.labelStyle,
      );
    }
    if (labelWidth != null && label != null) {
      label = SizedBox(width: labelWidth, child: label);
    }
    if (label != null) {
      label = Padding(padding: EdgeInsets.only(right: spacing), child: label);
    }

    if (label != null || bottomRightWidget != null || counter != null) {
      return Column(
        spacing: 4,
        children: [
          Row(
            children: [
              label ?? const SizedBox(),
              if (fieldLeftWidget != null) fieldLeftWidget!,
              Expanded(child: textField),
              if (fieldRightWidget != null) fieldRightWidget!,
            ],
          ),
          if (bottomRightWidget != null || counter != null)
            Row(
              spacing: 16.0,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (bottomRightWidget != null)
                  Flexible(child: bottomRightWidget),
                if (counter != null) counter,
              ],
            ),
        ],
      );
    } else {
      return textField;
    }
  }
}
