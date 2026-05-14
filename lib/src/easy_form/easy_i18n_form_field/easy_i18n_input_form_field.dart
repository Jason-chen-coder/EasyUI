import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../easy_button/easy_button.dart';
import '../../easy_button/easy_button_style.dart';
import '../../easy_svg_icon/easy_svg_icon.dart';
import '../../easy_theme.dart';
import '../../l10n/gen/easy_ui_localizations.dart';
import '../easy_text_form_field.dart';
import 'easy_i18n_input_drawer.dart';
import 'easy_i18n_input_model.dart';

class I18nInputFormField extends StatefulWidget {
  const I18nInputFormField({
    super.key,
    required this.labelText,
    this.showRequiredMark = true,
    this.readOnly = false,
    this.onSaved,
    this.initialValue,
    this.maxLength,
    this.hintText,
  });

  /// 是否必填字段
  final bool showRequiredMark;

  /// 标签
  final String labelText;

  /// 是否只读
  final bool readOnly;

  /// 保存回调
  final FormFieldSetter<String>? onSaved;

  /// 初始值，支持JSON字符串和普通字符串格式
  final String? initialValue;

  /// 最大输入长度
  final int? maxLength;

  /// 提示文本
  final String? hintText;

  @override
  State<I18nInputFormField> createState() => _I18nInputFormFieldState();
}

class _I18nInputFormFieldState extends State<I18nInputFormField> {
  final _fieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => EasyI18nInputModel(
            locale: Localizations.localeOf(context),
            l10n: EasyUiLocalizations.of(context),
            readOnly: widget.readOnly,
            labelText: widget.labelText,
            maxLength: widget.maxLength,
          )..setI18nValueFromJson(widget.initialValue ?? ''),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Builder(
      builder: (context) {
        final easyTheme = EasyTheme.of(context);
        final decorationTheme = easyTheme.easyTextFormFieldInputDecorationTheme;

        final model = context.read<EasyI18nInputModel>();
        return !model.readOnly
            ? EasyTextFormField(
              key: _fieldKey,
              controller: model.textEditingController,
              height: 48,
              textAlignVertical: TextAlignVertical.center,
              maxLength: model.maxLength,
              decoration: InputDecoration(
                hintText: widget.hintText,
                contentPadding: EdgeInsets.symmetric(horizontal: 24),
                fillColor: easyTheme.background,
                hoverColor: easyTheme.background,
                label: Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(right: 36),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              if (widget.showRequiredMark)
                                TextSpan(
                                  text: '* ',
                                  style: decorationTheme.labelStyle?.copyWith(
                                    color: easyTheme.warning,
                                  ),
                                ),
                              TextSpan(text: model.labelText),
                            ],
                          ),
                          style: decorationTheme.labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: EasyButton2(
                          type: EasyButtonType.iconDefault,
                          style: EasyButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              easyTheme.primaryGreen,
                            ),
                            overlayColor: WidgetStatePropertyAll(
                              Colors.transparent,
                            ),
                            fixedSize: WidgetStatePropertyAll(Size(36, 36)),
                          ),
                          child: EasySvgIcon.asset(
                            'assets/svgs/ic_translate_btn.svg',
                            package: 'easy_ui',
                          ),
                          onPressed:
                              () => EasyI18nInputDrawer.show(
                                context,
                                onSaved: () {
                                  _fieldKey.currentState?.validate();
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onChanged:
                  (value) =>
                      model.setI18nValue(model.textFieldConfig.code, value),
              validator: (_) => model.validateTextFieldValue(),
              onSaved:
                  (_) => widget.onSaved?.call(jsonEncode(model.i18nValues)),
            )
            : Selector<EasyI18nInputModel, String>(
              selector: (_, model) => model.textFieldConfig.value,
              builder: (_, value, __) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: easyTheme.neutral66,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              },
            );
      },
    );
  }
}
