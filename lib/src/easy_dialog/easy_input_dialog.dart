import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

class EasyInputDialog extends StatelessWidget {
  /// 输入框得焦的border
  static InputBorder? getTextFieldFocusedBorder(EasyThemeData easyTheme) {
    return easyTheme.easyTextFormFieldInputDecorationTheme.focusedBorder
        ?.copyWith(borderSide: BorderSide(color: easyTheme.primaryGreen));
  }

  /// 带单位的文本输入框文本样式
  static TextStyle getUnitTextFieldStyle(EasyThemeData easyTheme) {
    return TextStyle(fontSize: 14, color: easyTheme.neutral99);
  }

  /// 带单位的文本输入框的[InputDecoration]
  static InputDecoration getUnitTextFieldDecoration(
    EasyThemeData easyTheme,
    String unit, {
    String? hintText,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.only(left: 12, top: 8, bottom: 8),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      focusedBorder: getTextFieldFocusedBorder(easyTheme),
      suffix: Padding(
        padding: EdgeInsets.only(left: 4, right: 12),
        child: Text(unit, style: TextStyle(color: easyTheme.neutral99)),
      ),
      constraints: BoxConstraints.tightFor(height: 38),
      hintText: hintText,
    );
  }

  const EasyInputDialog({
    super.key,
    this.size = EasyDialogSize.small,
    required this.title,
    this.subtitle,
    required this.input,
    this.cancelButtonText,
    this.confirmButtonText,
    this.confirmButtonTextWidget,
    required this.onCancelPressed,
    required this.onConfirmPressed,
  });

  /// 大小
  final EasyDialogSize size;

  /// 标题
  final String title;

  /// 副标题
  final String? subtitle;

  /// 输入组件
  final Widget input;

  /// 取消按钮文本
  final String? cancelButtonText;

  /// 确认按钮文本
  final String? confirmButtonText;

  /// 确认按钮文本Widget, 不为null时[confirmButtonText]将不生效
  final Widget? confirmButtonTextWidget;

  /// 取消按钮点击回调
  final VoidCallback? onCancelPressed;

  /// 确认按钮点击回调
  final VoidCallback? onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);
    final easyTheme = EasyTheme.of(context);

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(easyTheme.cornerMedium),
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 32, top: 32, right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, color: easyTheme.neutral33),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 14,
                        color: easyTheme.neutral99,
                      ),
                    ),
                  input,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24),
              child: Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: EasyNotifyDialogOutlinedButton(
                      text: cancelButtonText ?? l10n.cancel,
                      onPressed: onCancelPressed,
                    ),
                  ),
                  Expanded(
                    child: EasyNotifyDialogElevatedButton(
                      textWidget: confirmButtonTextWidget,
                      text: confirmButtonText ?? l10n.confirm,
                      onPressed: onConfirmPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
