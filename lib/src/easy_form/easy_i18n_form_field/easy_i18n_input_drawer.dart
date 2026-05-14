import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../easy_button/easy_button.dart';
import '../../easy_button/easy_button_style.dart';
import '../../easy_drawer/easy_drawer.dart';
import '../../easy_locale_model.dart';
import '../../easy_menu/easy_list_pop_menu.dart';
import '../../easy_svg_icon/easy_svg_icon.dart';
import '../../easy_theme.dart';
import '../../l10n/gen/easy_ui_localizations.dart';
import '../easy_select_form_field.dart';
import '../easy_text_form_field.dart';
import '../easy_text_form_field_decoration_layout_delegate.dart';
import 'easy_i18n_input_model.dart';

class EasyI18nInputDrawer extends StatefulWidget {
  static Future<T?> show<T>(BuildContext context, {VoidCallback? onSaved}) {
    final model = context.read<EasyI18nInputModel>();
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: model.readOnly,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return ChangeNotifierProvider.value(
          value: model,
          child: Align(
            alignment: Alignment.centerRight,
            child: EasyI18nInputDrawer(onSaved: onSaved),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
          ),
          child: child,
        );
      },
    );
  }

  const EasyI18nInputDrawer({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  State<EasyI18nInputDrawer> createState() => _EasyI18nInputDrawerState();
}

class _EasyI18nInputDrawerState extends State<EasyI18nInputDrawer> {
  final _formKey = GlobalKey<FormState>();

  late Map<String, String> _i18nValues;

  @override
  void initState() {
    final map = context.read<EasyI18nInputModel>().i18nValues;
    _i18nValues = Map<String, String>.from(map);
    super.initState();
  }

  void addTranslatedValue() {
    final model = context.read<EasyI18nInputModel>();
    if (!_i18nValues.containsKey(model.languageCode)) {
      setState(() {
        _i18nValues[model.languageCode] = '';
      });
    }
  }

  void removeTranslatedValue(String locale) {
    if (_i18nValues.containsKey(locale)) {
      setState(() {
        _i18nValues.remove(locale);
      });
    }
  }

  void setI18nValue(String locale, String value) {
    setState(() {
      _i18nValues[locale] = value.trim();
    });
  }

  String getLanguagesByCode(String languageCode) {
    return switch (languageCode) {
      'zh' => '简体中文',
      'en' => 'English',
      'ru' => 'Русский',
      'zh-Hant' => '繁體中文',
      _ => languageCode,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);
    final theme = EasyTheme.of(context);

    final model = context.watch<EasyI18nInputModel>();
    return EasyDrawer(
      header: EasyDrawerTopBar(title: model.labelText),
      bodyScrollable: true,
      bodyPadding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: model.readOnly ? 24 : 0,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUnfocus,
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 语言选择
            if (!model.readOnly)
              EasySelectFormField<String>(
                decorationDelegate:
                    VerticalEasyTextFormFieldDecorationLayoutDelegate(
                      outerSuffix: EasyButton2(
                        type: EasyButtonType.iconDefault,
                        style: EasyButtonStyle(
                          padding: WidgetStatePropertyAll(EdgeInsets.zero),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          foregroundColor: WidgetStatePropertyAll(
                            theme.primaryGreen,
                          ),
                          overlayColor: WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          fixedSize: WidgetStatePropertyAll(Size(16, 16)),
                        ),
                        child: EasySvgIcon.asset(
                          'assets/svgs/ic_add_solid.svg',
                          package: 'easy_ui',
                        ),
                        onPressed: () => addTranslatedValue(),
                      ),
                    ),
                height: 48,
                decoration: InputDecoration(labelText: l10n.language),
                initialValue: model.languageCode,
                optionsFetcher: () async {
                  return EasyLocaleModel.supportedLocales
                      .map(
                        (e) => EasyListPopMenuOption.simple(
                          title: getLanguagesByCode(e.toLanguageTag()),
                          value: e.toLanguageTag(),
                        ),
                      )
                      .toList();
                },
                onChanged: (newValue) {
                  if (newValue != null) model.languageCode = newValue;
                },
              ),
            // 各语言输入框
            ..._i18nValues.keys.map(
              (e) => EasyTextFormField(
                key: ValueKey("dict_value_$e"),
                decorationLayoutDelegate:
                    VerticalEasyTextFormFieldDecorationLayoutDelegate(
                      outerSuffix:
                          !model.readOnly
                              ? EasyButton2(
                                type: EasyButtonType.iconDefault,
                                style: EasyButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.zero,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                  foregroundColor: WidgetStatePropertyAll(
                                    theme.warning,
                                  ),
                                  overlayColor: WidgetStatePropertyAll(
                                    Colors.transparent,
                                  ),
                                  fixedSize: WidgetStatePropertyAll(
                                    Size(16, 16),
                                  ),
                                ),
                                child: EasySvgIcon.asset(
                                  'assets/svgs/ic_delete_btn_no_padding.svg',
                                  package: 'easy_ui',
                                ),
                                onPressed: () => removeTranslatedValue(e),
                              )
                              : null,
                    ),
                height: 48,
                textAlignVertical: TextAlignVertical.center,
                initialValue: model.i18nValues[e],
                readOnly: model.readOnly,
                decoration: InputDecoration(
                  labelText: getLanguagesByCode(e),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                onSaved: (value) => setI18nValue(e, value ?? ''),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.cannotEmpty('${model.labelText} ($e)');
                  }
                  return null;
                },
                maxLength: model.maxLength,
              ),
            ),
          ],
        ),
      ),
      footer: () {
        if (model.readOnly) return null;
        return EasyDrawerFooterButton(
          text: l10n.save,
          onPressed: () {
            FocusScope.of(context).unfocus();
            if (!_formKey.currentState!.validate()) return;
            _formKey.currentState!.save();
            // 保存到model中
            model.i18nValues = _i18nValues;
            widget.onSaved?.call();
            model.textEditingController.text = model.textFieldConfig.value;
            Navigator.of(context).maybePop();
          },
        );
      }(),
    );
  }
}
