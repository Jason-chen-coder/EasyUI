import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class StatusIndicatorDemo extends StatelessWidget {
  const StatusIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('StatusIndicator 状态指示器组件示例'),
        h2('基本用法'),
        p('展示默认状态指示器'),
        WidgetHighlight(
          builder: (_) {
            return const EasyStatusIndicator(text: '默认状态');
          },
          codeSnippet: '''
```dart
EasyStatusIndicator(text: '默认状态')
```
''',
        ),

        h2('预设颜色样式'),
        p('内置六种标准颜色样式'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                EasyStatusIndicator.red(text: '红色警告'),
                EasyStatusIndicator.blue(text: '蓝色信息'),
                EasyStatusIndicator.amber(text: '琥珀色提醒'),
                EasyStatusIndicator.green(text: '绿色成功'),
                EasyStatusIndicator.gray(text: '灰色中性'),
                EasyStatusIndicator.orange(text: '橙色警告'),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                EasyStatusIndicator.red(text: '红色警告'),
                EasyStatusIndicator.blue(text: '蓝色信息'),
                EasyStatusIndicator.amber(text: '琥珀色提醒'),
                EasyStatusIndicator.green(text: '绿色成功'),
                EasyStatusIndicator.gray(text: '灰色中性'),
                EasyStatusIndicator.orange(text: '橙色警告'),
              ],
            );
```
''',
        ),

        h2('描边样式'),
        p('展示带边框的描边样式'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                EasyStatusIndicator.outlinedRed(text: '红色描边'),
                EasyStatusIndicator.outlinedBlue(text: '蓝色描边'),
                EasyStatusIndicator.outlinedAmber(text: '琥珀描边'),
                EasyStatusIndicator.outlinedGreen(text: '绿色描边'),
                EasyStatusIndicator.outlinedGray(text: '灰色描边'),
                EasyStatusIndicator.outlinedOrange(text: '橙色描边'),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                EasyStatusIndicator.outlinedRed(text: '红色描边'),
                EasyStatusIndicator.outlinedBlue(text: '蓝色描边'),
                EasyStatusIndicator.outlinedAmber(text: '琥珀描边'),
                EasyStatusIndicator.outlinedGreen(text: '绿色描边'),
                EasyStatusIndicator.outlinedGray(text: '灰色描边'),
                EasyStatusIndicator.outlinedOrange(text: '橙色描边'),
              ],
            );
```
''',
        ),

        h2('自定义尺寸'),
        p('调整宽度和内边距'),
        WidgetHighlight(
          builder: (_) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyStatusIndicator(text: '宽度限制', width: 200),
                SizedBox(height: 8),
                EasyStatusIndicator(
                  text: '大内边距',
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyStatusIndicator(text: '宽度限制', width: 200),
                SizedBox(height: 8),
                EasyStatusIndicator(
                  text: '大内边距',
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                ),
              ],
            );
```
''',
        ),

        h2('文本控制'),
        p('控制文本显示样式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EasyStatusIndicator(text: '超长文本会被自动截断显示省略号', width: 150),
                const SizedBox(height: 8),
                EasyStatusIndicator(
                  text: '自定义文本样式',
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                const EasyStatusIndicator(text: '多行文本控制\n第二行内容', maxLines: 2),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const EasyStatusIndicator(text: '超长文本会被自动截断显示省略号', width: 150),
                const SizedBox(height: 8),
                EasyStatusIndicator(
                  text: '自定义文本样式',
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 8),
                const EasyStatusIndicator(text: '多行文本控制\n第二行内容', maxLines: 2),
              ],
            );
```
''',
        ),

        h2('完全自定义'),
        p('组合所有自定义参数'),
        WidgetHighlight(
          builder: (_) {
            return const EasyStatusIndicator(
              text: '完全自定义',
              width: 180,
              padding: EdgeInsets.all(12),
              background: Colors.purpleAccent,
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              alignment: Alignment.center,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.deepPurple, width: 2),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyStatusIndicator(
              text: '完全自定义',
              width: 180,
              padding: EdgeInsets.all(12),
              background: Colors.purpleAccent,
              textStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              alignment: Alignment.center,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.deepPurple, width: 2),
              ),
            );
```
''',
        ),

        h2('实际应用场景'),
        p('在表格和列表中的使用示例'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '表格状态列:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('订单号')),
                    DataColumn(label: Text('状态')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1001')),
                        DataCell(EasyStatusIndicator.green(text: '已完成')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1002')),
                        DataCell(EasyStatusIndicator.blue(text: '处理中')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1003')),
                        DataCell(EasyStatusIndicator.red(text: '已取消')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '列表状态标记:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('项目A'),
                  trailing: EasyStatusIndicator.orange(text: '待审核'),
                ),
                ListTile(
                  title: const Text('项目B'),
                  trailing: EasyStatusIndicator.green(text: '已通过'),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                const Text(
                  '表格状态列:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('订单号')),
                    DataColumn(label: Text('状态')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1001')),
                        DataCell(EasyStatusIndicator.green(text: '已完成')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1002')),
                        DataCell(EasyStatusIndicator.blue(text: '处理中')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('ORD-1003')),
                        DataCell(EasyStatusIndicator.red(text: '已取消')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '列表状态标记:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: const Text('项目A'),
                  trailing: EasyStatusIndicator.orange(text: '待审核'),
                ),
                ListTile(
                  title: const Text('项目B'),
                  trailing: EasyStatusIndicator.green(text: '已通过'),
                ),
              ],
            );
```
''',
        ),
        h2('StatusIndicator参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyStatusIndicator 参数说明：'),
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
                        DataCell(Text('状态文本内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('指示器宽度，不设置则自适应')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text(
                            'EdgeInsets.symmetric(horizontal: 8, vertical: 4)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('background')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey[200]!')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('AlignmentGeometry')),
                        DataCell(Text('Alignment.center')),
                        DataCell(Text('否')),
                        DataCell(Text('内容对齐方式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('border')),
                        DataCell(Text('Border?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('边框样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius')),
                        DataCell(Text('BorderRadius.circular(4)')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('maxLines')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('最大行数')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('预设样式方法说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('背景颜色')),
                    DataColumn(label: Text('文本颜色')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('red')),
                        DataCell(Text('Colors.red[100]')),
                        DataCell(Text('Colors.red[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('blue')),
                        DataCell(Text('Colors.blue[100]')),
                        DataCell(Text('Colors.blue[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('amber')),
                        DataCell(Text('Colors.amber[100]')),
                        DataCell(Text('Colors.amber[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('green')),
                        DataCell(Text('Colors.green[100]')),
                        DataCell(Text('Colors.green[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('gray')),
                        DataCell(Text('Colors.grey[200]')),
                        DataCell(Text('Colors.grey[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('orange')),
                        DataCell(Text('Colors.orange[100]')),
                        DataCell(Text('Colors.orange[800]')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedRed')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.red')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedBlue')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.blue')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedAmber')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.amber')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedGreen')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.green')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedGray')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.grey')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('outlinedOrange')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('Colors.orange')),
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
