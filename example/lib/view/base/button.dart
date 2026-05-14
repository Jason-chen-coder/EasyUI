import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Button 示例'),
        h2('基本按钮类型'),
        p('展示所有不同类型的按钮'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  onPressed: () {},
                  child: const Text('默认按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: () {},
                  child: Text('主要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.secondary,
                  onPressed: () {},
                  child: Text('次要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.info,
                  onPressed: () {},
                  child: Text('信息按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  onPressed: () {},
                  child: Text('文字按钮'),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  onPressed: () {},
                  child: const Text('默认按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: () {},
                  child: Text('主要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.secondary,
                  onPressed: () {},
                  child: Text('次要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.info,
                  onPressed: () {},
                  child: Text('信息按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  onPressed: () {},
                  child: Text('文字按钮'),
                ),
              ],
            );
```
''',
        ),
        h2('不同尺寸'),
        p('展示大尺寸和小尺寸的按钮'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  size: EasyButtonSize.big,
                  child: Text('大号默认按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.defalut,
                  size: EasyButtonSize.small,
                  child: Text('小号默认按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  size: EasyButtonSize.big,
                  child: Text('大号主色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  size: EasyButtonSize.small,
                  child: Text('小号主色按钮'),
                  onPressed: () {},
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  size: EasyButtonSize.big,
                  child: Text('大号默认按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.defalut,
                  size: EasyButtonSize.small,
                  child: Text('小号默认按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  size: EasyButtonSize.big,
                  child: Text('大号主色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  size: EasyButtonSize.small,
                  child: Text('小号主色按钮'),
                  onPressed: () {},
                ),
              ],
            );
```
''',
        ),
        h2('禁用状态'),
        p('展示禁用状态的按钮'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  onPressed: null,
                  child: Text('禁用默认按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: null,
                  child: Text('禁用主色按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.secondary,
                  onPressed: null,
                  child: Text('禁用次要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  onPressed: null,
                  child: Text('禁用文字按钮'),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  onPressed: null,
                  child: Text('禁用默认按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: null,
                  child: Text('禁用主色按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.secondary,
                  onPressed: null,
                  child: Text('禁用次要按钮'),
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  onPressed: null,
                  child: Text('禁用文字按钮'),
                ),
              ],
            );
```
''',
        ),
        h2('带图标的按钮'),
        p('展示带图标的按钮，图标可以在文字前面或后面'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2.icon(
                  icon: const Icon(Icons.add),
                  child: const Text('添加'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.primary,
                  icon: const Icon(Icons.save),
                  child: const Text('保存'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.secondary,
                  icon: const Icon(Icons.refresh),
                  child: const Text('刷新'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.text,
                  icon: const Icon(Icons.download),
                  child: const Text('下载'),
                  onPressed: () {},
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
       Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2.icon(
                  icon: const Icon(Icons.add),
                  child: const Text('添加'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.primary,
                  icon: const Icon(Icons.save),
                  child: const Text('保存'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.secondary,
                  icon: const Icon(Icons.refresh),
                  child: const Text('刷新'),
                  onPressed: () {},
                ),
                EasyButton2.icon(
                  type: EasyButtonType.text,
                  icon: const Icon(Icons.download),
                  child: const Text('下载'),
                  onPressed: () {},
                ),
              ],
            );
```
''',
        ),
        h2('图标按钮'),
        p('展示不同类型的图标按钮'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.iconDefault,
                  child: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.iconPrimary,
                  child: Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.iconDefault,
                  child: Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.iconPrimary,
                  child: Icon(Icons.favorite),
                  onPressed: () {},
                ),
              ],
            );
```
''',
        ),
        h2('自定义样式'),
        p('通过 style 参数自定义按钮样式'),
        WidgetHighlight(
          builder: (_) {
            final easyTheme = EasyTheme.of(context);
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  style: EasyButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.purple),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text('圆角紫色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  style: EasyButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text('加宽橙色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  style: EasyButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      easyTheme.primaryGreen,
                    ),
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: const Text('粗体文字按钮'),
                  onPressed: () {},
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyButton2(
                  type: EasyButtonType.defalut,
                  style: EasyButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.purple),
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text('圆角紫色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.primary,
                  style: EasyButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.orange),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                  child: const Text('加宽橙色按钮'),
                  onPressed: () {},
                ),
                EasyButton2(
                  type: EasyButtonType.text,
                  style: EasyButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      easyTheme.primaryGreen,
                    ),
                    textStyle: WidgetStateProperty.all(
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  child: const Text('粗体文字按钮'),
                  onPressed: () {},
                ),
              ],
            );
```
''',
        ),
        h2('防抖功能'),
        p('展示防抖功能，防止重复点击'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: const Text('点击后禁用2秒'),
                ),
                const SizedBox(height: 16),
                EasyButton2(
                  type: EasyButtonType.primary,
                  withDebounce: false,
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: const Text('无防抖功能'),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                EasyButton2(
                  type: EasyButtonType.primary,
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: const Text('点击后禁用2秒'),
                ),
                const SizedBox(height: 16),
                EasyButton2(
                  type: EasyButtonType.primary,
                  withDebounce: false,
                  onPressed: () async {
                    await Future.delayed(const Duration(seconds: 2));
                  },
                  child: const Text('无防抖功能'),
                ),
              ],
            );
```
''',
        ),
        h2('Button参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyButton2 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('默认值')),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('type')),
                        DataCell(Text('EasyButtonType')),
                        DataCell(Text('EasyButtonType.defalut')),
                        DataCell(Text('否')),
                        DataCell(
                          Text('按钮类型：default、primary、secondary、info、text等'),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('size')),
                        DataCell(Text('EasyButtonSize')),
                        DataCell(Text('EasyButtonSize.normal')),
                        DataCell(Text('否')),
                        DataCell(Text('按钮尺寸：big、normal、small')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onPressed')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('按钮点击回调函数，为null时按钮禁用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('child')),
                        DataCell(Text('Widget')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('按钮内容子组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('style')),
                        DataCell(Text('EasyButtonStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义按钮样式，可覆盖默认样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('withDebounce')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用防抖功能，防止重复点击')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('icon')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('按钮图标，用于带图标的按钮')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('iconPosition')),
                        DataCell(Text('IconPosition')),
                        DataCell(Text('IconPosition.left')),
                        DataCell(Text('否')),
                        DataCell(Text('图标位置：left或right')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}
