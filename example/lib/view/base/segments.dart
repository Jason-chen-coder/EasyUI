import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class SegmentsDemo extends StatelessWidget {
  const SegmentsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySegments 组件示例'),
        h2('基本用法'),
        WidgetHighlight(
          builder: (context) {
            return _SegmentsBaseView();
          },
          codeSnippet: '''
```dart
  final _segments1 = List.generate(
    3,
    (index) => EasySegmentsItem('segment\$index'),
  );
  final _segments2 = List.generate(
    20,
    (index) => EasySegmentsItem('segment\$index'),
  );

  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        EasySegments(
          segments: _segments1,
          selectedIndex: _selectedIndex1,
          onSegmentChange: (value) {
            setState(() {
              _selectedIndex1 = value;
            });
          },
        ),
        EasySegments(
          segments: _segments2,
          selectedIndex: _selectedIndex2,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex2 = value;
            });
          },
          scrollable: true,
        ),
      ],
    );
  }
```
          ''',
        ),
        h2('显示未读小红点'),
        WidgetHighlight(
          builder: (context) {
            return _SegmentsUnreadView();
          },
          codeSnippet: '''
```dart
  final _data1 = List.generate(3, (index) => index);
  final _data2 = List.generate(20, (index) => index);

  final _isReadIndex1 = <int>{0};
  final _isReadIndex2 = <int>{0};

  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    final segments1 =
        _data1
            .map(
              (e) => EasySegmentsItem(
                'segment\$e',
                unread: !_isReadIndex1.contains(e),
              ),
            )
            .toList();
    final segments2 =
        _data2
            .map(
              (e) => EasySegmentsItem(
                'segment\$e',
                unread: !_isReadIndex2.contains(e),
              ),
            )
            .toList();
    return Column(
      spacing: 8,
      children: [
        EasySegments(
          segments: segments1,
          selectedIndex: _selectedIndex1,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex1 = value;
              _isReadIndex1.add(value);
            });
          },
        ),
        EasySegments(
          segments: segments2,
          selectedIndex: _selectedIndex2,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex2 = value;
              _isReadIndex2.add(value);
            });
          },
          scrollable: true,
        ),
      ],
    );
  }
```
          ''',
        ),
        h2('EasySegments参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasySegments 参数说明：'),
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
                        DataCell(Text('segments')),
                        DataCell(Text('List<EasySegmentsItem>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('每个segment的配置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedIndex')),
                        DataCell(Text('int')),
                        DataCell(Text('0')),
                        DataCell(Text('否')),
                        DataCell(Text('选中的segment的索引')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onSegmentChange')),
                        DataCell(Text('void Function(int segment)?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选中segment回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('const EdgeInsets.all(4.0)')),
                        DataCell(Text('否')),
                        DataCell(Text('整个组件的padding')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double')),
                        DataCell(Text('double.infinity')),
                        DataCell(Text('否')),
                        DataCell(Text('组件宽度，不支持滚动时生效')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double')),
                        DataCell(Text('40')),
                        DataCell(Text('否')),
                        DataCell(Text('组件高度，不支持滚动时生效')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('background')),
                        DataCell(Text('Color')),
                        DataCell(Text('0XFFEEEEEE')),
                        DataCell(Text('否')),
                        DataCell(Text('整个组件的背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius?')),
                        DataCell(
                          Text('BorderRadius.all(Radius.circular(4.0))'),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('整个组件的圆角')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('8')),
                        DataCell(Text('否')),
                        DataCell(Text('每个segment的间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentHeight')),
                        DataCell(Text('double')),
                        DataCell(Text('32')),
                        DataCell(Text('否')),
                        DataCell(Text('每个segment的高度，不支持滚动时生效')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentBorderRadius')),
                        DataCell(Text('BorderRadius?')),
                        DataCell(
                          Text('BorderRadius.all(Radius.circular(4.0))'),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('每个segment的圆角')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedSegmentBackground')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('被选中的segment的背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedSegmentTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(
                          Text(
                            'TextStyle(fontSize: 14, color: easyTheme.primaryGreen)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('被选中的segment的文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(
                          Text(
                            'TextStyle(fontSize: 14, color: easyTheme.neutral66)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('segment的文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('scrollable')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否支持滚动')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentMinWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('136.0')),
                        DataCell(Text('否')),
                        DataCell(Text('仅支持滚动时生效，每个segment的最小宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('segmentPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text(
                            'const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0,)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('仅支持滚动时生效，每个segment的padding')),
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

class _SegmentsBaseView extends StatefulWidget {
  const _SegmentsBaseView();

  @override
  State<_SegmentsBaseView> createState() => _SegmentsBaseViewState();
}

class _SegmentsBaseViewState extends State<_SegmentsBaseView> {
  final _segments1 = List.generate(
    3,
    (index) => EasySegmentsItem('segment$index'),
  );
  final _segments2 = List.generate(
    20,
    (index) => EasySegmentsItem('segment$index'),
  );

  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        EasySegments(
          segments: _segments1,
          selectedIndex: _selectedIndex1,
          onSegmentChange: (value) {
            setState(() {
              _selectedIndex1 = value;
            });
          },
        ),
        EasySegments(
          segments: _segments2,
          selectedIndex: _selectedIndex2,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex2 = value;
            });
          },
          scrollable: true,
        ),
      ],
    );
  }
}

class _SegmentsUnreadView extends StatefulWidget {
  const _SegmentsUnreadView();

  @override
  State<_SegmentsUnreadView> createState() => _SegmentsUnreadViewState();
}

class _SegmentsUnreadViewState extends State<_SegmentsUnreadView> {
  final _data1 = List.generate(3, (index) => index);
  final _data2 = List.generate(20, (index) => index);

  final _isReadIndex1 = <int>{0};
  final _isReadIndex2 = <int>{0};

  int _selectedIndex1 = 0;
  int _selectedIndex2 = 0;

  @override
  Widget build(BuildContext context) {
    final segments1 =
        _data1
            .map(
              (e) => EasySegmentsItem(
                'segment$e',
                unread: !_isReadIndex1.contains(e),
              ),
            )
            .toList();
    final segments2 =
        _data2
            .map(
              (e) => EasySegmentsItem(
                'segment$e',
                unread: !_isReadIndex2.contains(e),
              ),
            )
            .toList();
    return Column(
      spacing: 8,
      children: [
        EasySegments(
          segments: segments1,
          selectedIndex: _selectedIndex1,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex1 = value;
              _isReadIndex1.add(value);
            });
          },
        ),
        EasySegments(
          segments: segments2,
          selectedIndex: _selectedIndex2,
          onSegmentChange: (int value) {
            setState(() {
              _selectedIndex2 = value;
              _isReadIndex2.add(value);
            });
          },
          scrollable: true,
        ),
      ],
    );
  }
}
