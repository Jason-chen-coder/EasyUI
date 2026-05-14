import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class EasyColorPickerDemo extends StatelessWidget {
  const EasyColorPickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return Body.multi(
      children: [
        h1('EasyColorPicker'),
        p('颜色选择器组件，支持HSV颜色模型的选择与输入。'),
        h2('直接使用'),
        p('直接使用时，请务必指定组件宽度'),
        WidgetHighlight(
          builder: (context) {
            Color pickerColor = easyTheme.primaryGreen;
            return StatefulBuilder(
              builder: (context, setter) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [
                    SizedBox(
                      width: 300,
                      child: EasyColorPicker(
                        pickerColor: easyTheme.primaryGreen,
                        onColorChanged: (c) => setter(() => pickerColor = c),
                      ),
                    ),
                    Text(
                      '选中的颜色',
                      style: TextStyle(fontSize: 16, color: pickerColor),
                    ),
                    Container(width: 50, height: 50, color: pickerColor),
                  ],
                );
              },
            );
          },
          codeSnippet: '''
```dart
SizedBox(
  width: 300,
  child: EasyColorPicker(
    pickerColor: easyTheme.primaryGreen, // 初始颜色
    onColorChanged: (c) {}, // 颜色变化回调
  ),
),
```
''',
        ),
        h2('通过下拉框选择颜色'),
        p('愈通过下拉框使用颜色选择器，可以通过使用`EasyColorSelector`组件来实现。'),
        WidgetHighlight(
          builder: (context) {
            return Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 350,
                child: EasyColorSelector(
                  clearable: true,
                  placeholder: '请选择颜色',
                  icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
                  onChanged: (value) {},
                ),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyColorSelector(
  clearable: true,
  placeholder: '请选择颜色',
  icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'), // 图标，用于显示选中颜色，亦可使用 `Icon` 组件
  onChanged: (value) {}, // 颜色变化回调
),
```
''',
        ),
        h2('在表单中使用'),
        p('可以通过使用`EasyColorSelectorFormField`组件在表单中使用颜色选择器。'),
        WidgetHighlight(
          builder: (_) => _FormDemo(),
          codeSnippet: '''
```dart
EasyColorSelectorFormField(
  showRequiredMark: true,
  decoration: InputDecoration(labelText: '选择颜色'),
  decorationDelegate:
      VerticalEasyTextFormFieldDecorationLayoutDelegate(
        outerSuffix: EasyButton2(
          child: Text('验证表单'),
          onPressed: () {
            final res = _formKey.currentState?.validate();
            if (res == true) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('表单验证通过')));
            }
          },
        ),
      ),
  clearable: true,
  placeholder: '请选择颜色',
  icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
  onChanged: (value) {},
  validator: (value) {
    if (value == null) {
      return '请选择颜色';
    }
    return null;
  },
),
```
''',
        ),
        h2('在EasyDialog中使用'),
        WidgetHighlight(
          builder: (context) {
            Color pickerColor = easyTheme.primaryGreen;
            return StatefulBuilder(
              builder: (context, setter) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 24,
                  children: [
                    EasyButton2(
                      child: Text('点击选择颜色'),
                      onPressed: () {
                        showEasyNotifyDialog<Color>(
                          context: context,
                          builder: (context) {
                            Color inner = pickerColor;
                            return EasyNotifyDialog.withTwoActions(
                              icon: const SizedBox.shrink(),
                              title: '选择颜色',
                              body: EasyColorPicker(
                                pickerColor: inner,
                                onColorChanged: (c) => inner = c,
                              ),
                              leftAction: EasyNotifyDialogOutlinedButton(
                                text: '取消',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              rightAction: EasyNotifyDialogElevatedButton(
                                text: '确认',
                                onPressed:
                                    () => Navigator.of(context).pop(inner),
                              ),
                            );
                          },
                        ).then((c) {
                          if (c != null) setter(() => pickerColor = c);
                        });
                      },
                    ),

                    Text(
                      '选中的颜色',
                      style: TextStyle(fontSize: 16, color: pickerColor),
                    ),
                    Container(width: 50, height: 50, color: pickerColor),
                  ],
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyButton2(
  child: Text('点击选择颜色'),
  onPressed: () {
    showEasyNotifyDialog<Color>(
      context: context,
      builder: (context) {
        Color inner = pickerColor;
        return EasyNotifyDialog.withTwoActions(
          icon: const SizedBox.shrink(),
          title: '选择颜色',
          body: EasyColorPicker(
            pickerColor: inner,
            onColorChanged: (c) => inner = c,
          ),
          leftAction: EasyNotifyDialogOutlinedButton(
            text: '取消',
            onPressed: () => Navigator.of(context).pop(),
          ),
          rightAction: EasyNotifyDialogElevatedButton(
            text: '确认',
            onPressed:
                () => Navigator.of(context).pop(inner),
          ),
        );
      },
    ).then((c) {
      // 处理返回的颜色
    });
  },
  ),
```
''',
        ),
      ],
    );
  }
}

class _FormDemo extends StatefulWidget {
  const _FormDemo();

  @override
  State<_FormDemo> createState() => _FormDemoState();
}

class _FormDemoState extends State<_FormDemo> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUnfocus,
      key: _formKey,
      child: Row(
        children: [
          SizedBox(
            width: 430,
            child: EasyColorSelectorFormField(
              showRequiredMark: true,
              decoration: InputDecoration(labelText: '选择颜色'),
              decorationDelegate:
                  VerticalEasyTextFormFieldDecorationLayoutDelegate(
                    outerSuffix: EasyButton2(
                      child: Text('验证表单'),
                      onPressed: () {
                        final res = _formKey.currentState?.validate();
                        if (res == true) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('表单验证通过')));
                        }
                      },
                    ),
                  ),
              clearable: true,
              placeholder: '请选择颜色',
              icon: EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
              onChanged: (value) {},
              validator: (value) {
                if (value == null) {
                  return '请选择颜色';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
