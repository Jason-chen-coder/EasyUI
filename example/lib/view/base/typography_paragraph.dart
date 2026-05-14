import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class TypographyParagraph extends StatefulWidget {
  const TypographyParagraph({super.key});

  @override
  State<TypographyParagraph> createState() => _TypographyParagraphState();
}

class _TypographyParagraphState extends State<TypographyParagraph> {
  String longText =
      '这是一个演示用的很长的文本内容。Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.这是一个演示用的很长的文本内容。Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
      'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.';

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyTypographyParagraph'),
        p('带省略号和展开功能的段落组件'),
        h2('基础用法'),
        p('无省略的简单文本展示'),
        WidgetHighlight(
          builder: (context) {
            return const EasyTypographyParagraph(text: '这是一个简单的文本内容。', rows: 3);
          },
          codeSnippet: '''
```dart
const EasyTypographyParagraph(
  text: '这是一个简单的文本内容。',
  rows: 3,
)
```
''',
        ),
        h2('带省略号'),
        p('当文本超过指定行数时，自动显示省略号'),
        WidgetHighlight(
          builder: (context) {
            return EasyTypographyParagraph(text: longText, rows: 2);
          },
          codeSnippet: '''
```dart
const EasyTypographyParagraph(
  text: longText,
  rows: 2,
)
```
''',
        ),
        h2('带展开功能'),
        p('启用展开功能，允许用户查看全文'),
        WidgetHighlight(
          builder: (context) {
            return EasyTypographyParagraph(
              text: longText,
              rows: 2,
              expandable: true,
            );
          },
          codeSnippet: '''
```dart
const EasyTypographyParagraph(
  text: longText,
  rows: 2,
  expandable: true,
)
```
''',
        ),
        h2('自定义样式'),
        p('自定义文本和按钮的样式'),
        WidgetHighlight(
          builder: (context) {
            final easyTheme = EasyTheme.of(context);
            return EasyTypographyParagraph(
              text: longText,
              rows: 2,
              expandable: true,
              style: TextStyle(
                fontSize: 14,
                color: easyTheme.neutral66,
                height: 1.6,
              ),
              moreButtonText: '查看全文',
              moreButtonTextStyle: TextStyle(
                fontSize: 14,
                color: easyTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
              collapseButtonText: '收起',
              collapseButtonTextStyle: TextStyle(
                fontSize: 14,
                color: easyTheme.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          codeSnippet: '''
```dart
EasyTypographyParagraph(
  text: longText,
  rows: 2,
  expandable: true,
  style: TextStyle(
    fontSize: 14,
    color: easyTheme.neutral66,
    height: 1.6,
  ),
  moreButtonText: '查看全文',
  moreButtonTextStyle: TextStyle(
    fontSize: 14,
    color: easyTheme.primaryGreen,
    fontWeight: FontWeight.bold,
  ),
  collapseButtonText: '收起',
     collapseButtonTextStyle: TextStyle(
     fontSize: 14,
     color: easyTheme.primaryGreen,
     fontWeight: FontWeight.bold,
  ),
)
```
''',
        ),
        h2('带回调函数'),
        p('点击展开按钮时触发自定义回调函数'),
        WidgetHighlight(
          builder: (context) {
            return EasyTypographyParagraph(
              text: longText,
              rows: 2,
              expandable: true,
              onExpand: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('全文内容'),
                        content: SingleChildScrollView(child: Text(longText)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('关闭'),
                          ),
                        ],
                      ),
                );
              },
              moreButtonText: '查看详情',
            );
          },
          codeSnippet: '''
```dart
EasyTypographyParagraph(
  text: longText,
  rows: 2,
  expandable: true,
  onExpand: () {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('全文内容'),
        content: SingleChildScrollView(
          child: Text(longText),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  },
  moreButtonText: '查看详情',
)
```
''',
        ),
        h2('EasyTypographyParagraph参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        DataCell(Text('text')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('显示的文本内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('rows')),
                        DataCell(Text('int')),
                        DataCell(Text('3')),
                        DataCell(Text('是')),
                        DataCell(Text('文本显示的最大行数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('expandable')),
                        DataCell(Text('bool?')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用展开/收起功能')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('style')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本的样式（字体大小、颜色、高度等）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('moreButtonText')),
                        DataCell(Text('String?')),
                        DataCell(Text('展开')),
                        DataCell(Text('否')),
                        DataCell(Text('展开按钮的文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('moreButtonTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('展开按钮文本的样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('collapseButtonText')),
                        DataCell(Text('String?')),
                        DataCell(Text('收起')),
                        DataCell(Text('否')),
                        DataCell(Text('收起按钮的文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('collapseButtonTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('收起按钮文本的样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onExpand')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('点击展开按钮时的回调函数')),
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
