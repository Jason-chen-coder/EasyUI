import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class I18nFormFiledDemo extends StatelessWidget {
  const I18nFormFiledDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('国际化输入框'),
        p('国际化字段专用的输入框。'),

        h2('内置样式'),
        p('样式与 EasyTextFormField 一致'),
        WidgetHighlight(
          builder:
              (_) => I18nInputFormField(
                initialValue:
                    "{\"zh\":\"这是一个国际化字段\",\"en\":\"This is an i18n field\"}",
                labelText: '国际化字段名',
              ),
          codeSnippet: '''
```dart
I18nInputFormField(
  initialValue:
      "{"zh":"这是一个国际化字段","en":"This is an i18n field"}",
  labelText: '国际化字段名',
)
```
''',
        ),
        h2('自定义样式'),
        p('自定义样式用于样式与 EasyTextFormField 不一致的场景，可以将打开抽屉的按钮和输入框分开。'),
        tip(
          '分开的前提是，在输入框和按钮的共同祖先节点使用`ChangeNotifierProvider`提供`EasyI18nInputModel`。',
        ),
        WidgetHighlight(
          builder: (_) {
            return ChangeNotifierProvider(
              create:
                  (_) => EasyI18nInputModel(
                    locale: Localizations.localeOf(context),
                    l10n: EasyUiLocalizations.of(context),
                    readOnly: false,
                    labelText: '国际化字段名',
                  )..
                  //在这里设置初始值（编辑/查看模式）
                  setI18nValueFromJson(
                    '{"zh":"这是一个国际化字段","en":"This is an i18n field"}',
                  ),
              builder: (context, _) {
                final model = context.read<EasyI18nInputModel>();
                final theme = EasyTheme.of(context);
                return Row(
                  children: [
                    /// 自定义的输入框组件
                    Expanded(
                      child: TextFormField(
                        //! 必须设置为Model中的controller
                        controller: model.textEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryGreen,
                              width: 1.5,
                            ),
                          ),
                        ),
                        maxLength: 100,
                        onChanged: (value) {
                          model.setI18nValue(model.textFieldConfig.code, value);
                          //! 记得在此处同步到你的数据模型
                        },
                      ),
                    ),

                    EasyI18nButton(
                      onSaved: () {
                        // 点击Drawer中保存按钮的回调
                        //! 记得在此处同步到你的数据模型
                      },
                    ),
                  ],
                );
              },
            );
          },
          codeSnippet: '''
```dart
            ChangeNotifierProvider(
              create:
                  (_) => EasyI18nInputModel(
                    locale: Localizations.localeOf(context),
                    l10n: EasyUiLocalizations.of(context),
                    readOnly: false,
                    labelText: '国际化字段名',
                  )..
                  //在这里设置初始值（编辑/查看模式）
                  setI18nValueFromJson(
                    '{"zh":"这是一个国际化字段","en":"This is an i18n field"}',
                  ),
              builder: (context, _) {
                final model = context.read<EasyI18nInputModel>();
                final theme = EasyTheme.of(context);
                return Row(
                  children: [
                    /// 自定义的输入框组件
                    Expanded(
                      child: TextFormField(
                        //! 必须设置为Model中的controller
                        controller: model.textEditingController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: theme.primaryGreen,
                              width: 1.5,
                            ),
                          ),
                        ),
                        maxLength: 100,
                        onChanged: (value) {
                          model.setI18nValue(model.textFieldConfig.code, value);
                          //! 记得在此处同步到你的数据模型
                        },
                      ),
                    ),

                    EasyI18nButton(
                      onSaved: () {
                        // 点击Drawer中保存按钮的回调
                        //! 记得在此处同步到你的数据模型
                      },
                    ),
                  ],
                );
              },
            );
```
''',
        ),
      ],
    );
  }
}
