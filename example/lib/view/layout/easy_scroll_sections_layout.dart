import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class EasyScrollSectionsLayoutDemo extends StatelessWidget {
  const EasyScrollSectionsLayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyScrollSectionsLayout 多章节滚动布局组件示例'),
        h2('基本用法'),
        WidgetHighlight(
          builder: (_) {
            return _EasyScrollSectionsLayoutBaseDemo();
          },
          codeSnippet: '''
```dart
class _EasyScrollSectionsLayoutBaseDemo extends StatelessWidget {
  const _EasyScrollSectionsLayoutBaseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionTitles = [
      'Section1',
      'Section2',
      'Section3',
      'Section4',
      'Section5',
    ];
    return SizedBox(
      height: 500,
      child: EasyScrollSectionsLayout(
        itemCount: sectionTitles.length,
        itemBuilder: (context, index) {
          return EasySectionContent(
            title: sectionTitles[index],
            titleBuilder:
                index == 1
                    ? (context, title) => Row(
                      children: [
                        Expanded(child: title),
                        ElevatedButton(onPressed: () {}, child: Text('Button')),
                      ],
                    )
                    : null,
            content: Container(
              color: Colors.primaries[index % Colors.primaries.length],
              height: 300,
              alignment: Alignment.center,
              child: Text(sectionTitles[index]),
            ),
          );
        },
      ),
    );
  }
}
```
''',
        ),
        h2('创建跟滚动位置联动的指示器'),
        WidgetHighlight(
          builder: (_) {
            return _EasyScrollSectionsLayoutWithIndicatorDemo();
          },
          codeSnippet: '''
```dart
class _EasyScrollSectionsLayoutWithIndicatorDemo extends StatelessWidget {
  const _EasyScrollSectionsLayoutWithIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionTitles = [
      'Section1',
      'Section2',
      'Section3',
      'Section4',
      'Section5',
    ];
    return SizedBox(
      height: 600,
      child: EasyScrollSectionsLayout(
        positionIndicatorBuilder: (context, index, scrollTo) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: EasySegments(
              selectedIndex: index,
              segments: sectionTitles.map((e) => EasySegmentsItem(e)).toList(),
              scrollable: true,
              onSegmentChange: (index) {
                scrollTo(index);
              },
            ),
          );
        },
        itemCount: sectionTitles.length,
        itemBuilder: (context, index) {
          return EasySectionContent(
            key: ValueKey(index),
            title: sectionTitles[index],
            titleBuilder:
                index == 1
                    ? (context, title) => Row(
                      children: [
                        Expanded(child: title),
                        ElevatedButton(onPressed: () {}, child: Text('Button')),
                      ],
                    )
                    : null,
            content: Container(
              color: Colors.primaries[index % Colors.primaries.length],
              height: 200,
              alignment: Alignment.center,
              child: Text(sectionTitles[index]),
            ),
          );
        },
      ),
    );
  }
}
```
''',
        ),
        h2('EasyScrollSectionsLayout参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyScrollSectionsLayout 参数说明：'),
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
                        DataCell(Text('itemCount')),
                        DataCell(Text('int')),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(Text('子项数量')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('itemBuilder')),
                        DataCell(Text('IndexedWidgetBuilder')),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(Text('子项构造函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('itemSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('24')),
                        DataCell(Text('否')),
                        DataCell(Text('子项间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('positionIndicatorBuilder')),
                        DataCell(
                          Text('EasyScrollSectionsPositionIndicatorBuilder?'),
                        ),
                        DataCell(Text('')),
                        DataCell(Text('否')),
                        DataCell(Text('子项位置指示器构建函数')),
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

class _EasyScrollSectionsLayoutBaseDemo extends StatelessWidget {
  const _EasyScrollSectionsLayoutBaseDemo();

  @override
  Widget build(BuildContext context) {
    final sectionTitles = [
      'Section1',
      'Section2',
      'Section3',
      'Section4',
      'Section5',
    ];
    return SizedBox(
      height: 500,
      child: EasyScrollSectionsLayout(
        itemCount: sectionTitles.length,
        itemBuilder: (context, index) {
          return EasySectionContent(
            title: sectionTitles[index],
            titleBuilder:
                index == 1
                    ? (context, title) => Row(
                      children: [
                        Expanded(child: title),
                        ElevatedButton(onPressed: () {}, child: Text('Button')),
                      ],
                    )
                    : null,
            content: Container(
              color: Colors.primaries[index % Colors.primaries.length],
              height: 300,
              alignment: Alignment.center,
              child: Text(sectionTitles[index]),
            ),
          );
        },
      ),
    );
  }
}

class _EasyScrollSectionsLayoutWithIndicatorDemo extends StatelessWidget {
  const _EasyScrollSectionsLayoutWithIndicatorDemo();

  @override
  Widget build(BuildContext context) {
    final sectionTitles = [
      'Section1',
      'Section2',
      'Section3',
      'Section4',
      'Section5',
    ];
    return SizedBox(
      height: 600,
      child: EasyScrollSectionsLayout(
        positionIndicatorBuilder: (context, index, scrollTo) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: EasySegments(
              selectedIndex: index,
              segments: sectionTitles.map((e) => EasySegmentsItem(e)).toList(),
              scrollable: true,
              onSegmentChange: (index) {
                scrollTo(index);
              },
            ),
          );
        },
        itemCount: sectionTitles.length,
        itemBuilder: (context, index) {
          return EasySectionContent(
            key: ValueKey(index),
            title: sectionTitles[index],
            titleBuilder:
                index == 1
                    ? (context, title) => Row(
                      children: [
                        Expanded(child: title),
                        ElevatedButton(onPressed: () {}, child: Text('Button')),
                      ],
                    )
                    : null,
            content: Container(
              color: Colors.primaries[index % Colors.primaries.length],
              height: 200,
              alignment: Alignment.center,
              child: Text(sectionTitles[index]),
            ),
          );
        },
      ),
    );
  }
}
