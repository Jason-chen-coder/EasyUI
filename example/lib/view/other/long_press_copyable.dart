import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class LongPressCopyableDemo extends StatelessWidget {
  const LongPressCopyableDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyLongPressCopyable 示例'),
        h2('基本用法'),
        p('目前只支持复制Text和EasyUserListTile组件的文本'),
        WidgetHighlight(
          builder: (_) {
            return _BaseDemo();
          },
          codeSnippet: '''
```dart
class _BaseDemo extends StatelessWidget {
  const _BaseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        EasyLongPressCopyable(child: Text('Example Text')),
        EasyLongPressCopyable(
          child: Text.rich(
            TextSpan(
              text: 'Rich Text ',
              style: TextStyle(color: ColorScheme.of(context).secondary),
              children: [
                TextSpan(
                  text: 'Example',
                  style: TextTheme.of(context).displaySmall?.copyWith(
                    color: ColorScheme.of(context).primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        EasyLongPressCopyable(
          child: EasyUserListTile(
            userAvatar: '',
            userEmail: '123456789@easy.com',
            userName: 'easy',
          ),
        ),
      ],
    );
  }
}
```
''',
        ),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyLongPressCopyable 额外参数说明：'),
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
                        DataCell(Text('longPressCopyable')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用长按复制')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectable')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否添加[SelectionArea]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tooltip')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('提示文本')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}

class _BaseDemo extends StatelessWidget {
  const _BaseDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        EasyLongPressCopyable(child: Text('Example Text')),
        EasyLongPressCopyable(
          child: Text.rich(
            TextSpan(
              text: 'Rich Text ',
              style: TextStyle(color: ColorScheme.of(context).secondary),
              children: [
                TextSpan(
                  text: 'Example',
                  style: TextTheme.of(context).displaySmall?.copyWith(
                    color: ColorScheme.of(context).primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        EasyLongPressCopyable(
          child: EasyUserListTile(
            userAvatar: '',
            userEmail: '123456789@easy.com',
            userName: 'easy',
          ),
        ),
      ],
    );
  }
}
