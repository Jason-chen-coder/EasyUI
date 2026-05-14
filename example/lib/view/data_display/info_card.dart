import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class InfoCardDemo extends StatelessWidget {
  const InfoCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyInfoCard 信息卡片组件示例'),
        h2('基本用法'),
        p('展示最基本的信息片'),
        WidgetHighlight(
          builder: (_) {
            return _EasyInfoCardBaseDemo();
          },
          codeSnippet: '''
```dart
class _EasyInfoCardBaseDemo extends StatelessWidget {
  const _EasyInfoCardBaseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyInfoCard(
      items: [
        EasyInfoItem(label: '项目编码：', valueWidget: Text('PM202500011')),
        EasyInfoItem(label: '项目名称：', valueWidget: Text('测试项目1')),
        EasyInfoItem(label: '项目负责人：', valueWidget: Text('张大丽')),
        EasyInfoItem(label: '项目负责人邮箱：', valueWidget: Text('zhangli@hnsd')),
        EasyInfoItem(label: '项目负责人电话：', valueWidget: Text('13975915937')),
        EasyInfoItem(label: '项目备注：', valueWidget: Text('测试项目')),
      ],
    );
  }
}
```
''',
        ),
        h2('EasyInfoCard参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyInfoCard 参数说明：'),
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
                        DataCell(Text('columnCount')),
                        DataCell(Text('int')),
                        DataCell(Text('3')),
                        DataCell(Text('否')),
                        DataCell(Text('每行列数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('columnSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('32')),
                        DataCell(Text('否')),
                        DataCell(Text('列间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('rowSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('32')),
                        DataCell(Text('否')),
                        DataCell(Text('行间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('labelTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('标签文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('valueTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('值文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('items')),
                        DataCell(Text('List<EasyInfoItem>')),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(Text('子项')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('const EdgeInsets.all(32)')),
                        DataCell(Text('否')),
                        DataCell(Text('卡片间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角')),
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

class _EasyInfoCardBaseDemo extends StatelessWidget {
  const _EasyInfoCardBaseDemo();

  @override
  Widget build(BuildContext context) {
    return EasyInfoCard(
      items: [
        EasyInfoItem(label: '项目编码：', valueWidget: Text('PM202500011')),
        EasyInfoItem(label: '项目名称：', valueWidget: Text('测试项目1')),
        EasyInfoItem(label: '项目负责人：', valueWidget: Text('张大丽')),
        EasyInfoItem(label: '项目负责人邮箱：', valueWidget: Text('zhangli@hnsd')),
        EasyInfoItem(label: '项目负责人电话：', valueWidget: Text('13975915937')),
        EasyInfoItem(label: '项目备注：', valueWidget: Text('测试项目')),
      ],
    );
  }
}
