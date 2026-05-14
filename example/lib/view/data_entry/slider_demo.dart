import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class SliderDemo extends StatefulWidget {
  const SliderDemo({super.key});

  @override
  State<SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<SliderDemo> {
  // State variables for examples
  double _basicValue = 20.0;
  double _discreteValue = 50.0;
  RangeValues _basicRangeValues = const RangeValues(20, 80);
  RangeValues _discreteRangeValues = const RangeValues(10, 40);

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Slider / RangeSlider'),
        p('Easy 风格的滑块组件，支持单值选择和范围选择。'),

        h2('EasySlider 基础用法'),
        p('最简单的滑块，用于选择 0-100 之间的值。'),
        WidgetHighlight(
          builder: (context) {
            return EasySlider(
              value: _basicValue,
              min: 0,
              max: 100,
              onChanged: (value) {
                setState(() {
                  _basicValue = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
double _value = 20.0;

EasySlider(
  value: _value,
  min: 0,
  max: 100,
  onChanged: (value) {
    setState(() {
      _value = value;
    });
  },
)
```
''',
        ),

        h2('EasySlider 离散值'),
        p('设置 `divisions` 属性，使滑块只在指定的分隔点停留。'),
        WidgetHighlight(
          builder: (context) {
            return EasySlider(
              value: _discreteValue,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _discreteValue = value;
                });
              },
            );
          },
          codeSnippet: '''
```dart
double _value = 50.0;

EasySlider(
  value: _value,
  min: 0,
  max: 100,
  divisions: 10,
  onChanged: (value) {
    setState(() {
      _value = value;
    });
  },
)
```
''',
        ),

        const Divider(height: 48),

        h2('EasyRangeSlider 基础用法'),
        p('范围滑块，用于选择一个数值区间。'),
        WidgetHighlight(
          builder: (context) {
            return EasyRangeSlider(
              values: _basicRangeValues,
              min: 0,
              max: 100,
              onChanged: (values) {
                setState(() {
                  _basicRangeValues = values;
                });
              },
            );
          },
          codeSnippet: '''
```dart
RangeValues _rangeValues = const RangeValues(20, 80);

EasyRangeSlider(
  values: _rangeValues,
  min: 0,
  max: 100,
  onChanged: (values) {
    setState(() {
      _rangeValues = values;
    });
  },
)
```
''',
        ),

        h2('EasyRangeSlider 离散值'),
        p('同样支持 `divisions` 属性。'),
        WidgetHighlight(
          builder: (context) {
            return EasyRangeSlider(
              values: _discreteRangeValues,
              min: 0,
              max: 50,
              divisions: 5,
              onChanged: (values) {
                setState(() {
                  _discreteRangeValues = values;
                });
              },
            );
          },
          codeSnippet: '''
```dart
RangeValues _rangeValues = const RangeValues(10, 40);

EasyRangeSlider(
  values: _rangeValues,
  min: 0,
  max: 50,
  divisions: 5,
  onChanged: (values) {
    setState(() {
      _rangeValues = values;
    });
  },
)
```
''',
        ),

        h2('参数说明'),
        h3('EasySlider 参数'),
        WidgetHighlight(
          builder:
              (_) => _buildParamTable([
                _Param('value', 'double', '-', '当前值 (必填)'),
                _Param('onChanged', 'ValueChanged<double>?', 'null', '值改变时的回调'),
                _Param('min', 'double', '0.0', '最小值'),
                _Param('max', 'double', '1.0', '最大值'),
                _Param('divisions', 'int?', 'null', '离散分段数'),
                _Param('label', 'String?', 'null', '标签文本'),
                _Param('activeColor', 'Color?', 'null', '激活轨道/滑块颜色'),
                _Param('inactiveColor', 'Color?', 'null', '非激活轨道颜色'),
                _Param(
                  'thumbColor',
                  'Color?',
                  'null',
                  '滑块颜色 (默认使用activeColor)',
                ),
                _Param('trackHeight', 'double?', 'null', '轨道高度 (默认根据Theme调整)'),
              ]),
          codeSnippet: '',
          initiallyOpen: true,
        ),

        h3('EasyRangeSlider 参数'),
        WidgetHighlight(
          builder:
              (_) => _buildParamTable([
                _Param('values', 'RangeValues', '-', '当前范围值 (必填)'),
                _Param(
                  'onChanged',
                  'ValueChanged<RangeValues>?',
                  'null',
                  '值改变时的回调',
                ),
                _Param('min', 'double', '0.0', '最小值'),
                _Param('max', 'double', '1.0', '最大值'),
                _Param('divisions', 'int?', 'null', '离散分段数'),
                _Param('labels', 'RangeLabels?', 'null', '标签文本'),
                _Param('activeColor', 'Color?', 'null', '激活轨道/滑块颜色'),
                _Param('inactiveColor', 'Color?', 'null', '非激活轨道颜色'),
                _Param(
                  'thumbColor',
                  'Color?',
                  'null',
                  '滑块颜色 (默认使用activeColor)',
                ),
                _Param('trackHeight', 'double?', 'null', '轨道高度 (默认根据Theme调整)'),
              ]),
          codeSnippet: '',
          initiallyOpen: true,
        ),
      ],
    );
  }

  Widget _buildParamTable(List<_Param> params) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('参数名', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('类型', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('默认值', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text('说明', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
        rows:
            params.map((p) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      p.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  DataCell(
                    Text(
                      p.type,
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                  DataCell(Text(p.defaultValue)),
                  DataCell(Text(p.desc)),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class _Param {
  final String name;
  final String type;
  final String defaultValue;
  final String desc;

  _Param(this.name, this.type, this.defaultValue, this.desc);
}
