import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class DropDownDemo2 extends StatelessWidget {
  const DropDownDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('MultiSelection 多选组件示例'),
        h2('基本用法'),
        p('展示基本的多选列表功能'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '选项1', value: '1'),
                  DropDownValueModel(name: '选项2', value: '2'),
                  DropDownValueModel(name: '选项3', value: '3'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(top: 8, bottom: 8),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '选项1', value: '1'),
                  DropDownValueModel(name: '选项2', value: '2'),
                  DropDownValueModel(name: '选项3', value: '3'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(top: 8, bottom: 8),
              ),
```
''',
        ),

        h2('初始选中状态'),
        p('设置初始选中的项目'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '苹果', value: 'apple'),
                  DropDownValueModel(name: '香蕉', value: 'banana'),
                  DropDownValueModel(name: '橙子', value: 'orange'),
                ],
                list: [true, false, true],
                // 默认选中第一和第三项
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '苹果', value: 'apple'),
                  DropDownValueModel(name: '香蕉', value: 'banana'),
                  DropDownValueModel(name: '橙子', value: 'orange'),
                ],
                list: [true, false, true],
                // 默认选中第一和第三项
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(),
              ),
```
''',
        ),

        h2('自定义确认按钮'),
        p('自定义确认按钮的样式和文本'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '红色', value: 'red'),
                  DropDownValueModel(name: '绿色', value: 'green'),
                  DropDownValueModel(name: '蓝色', value: 'blue'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                buttonText: '确认选择',
                buttonColor: Colors.blue,
                buttonTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                listPadding: ListPadding(),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '红色', value: 'red'),
                  DropDownValueModel(name: '绿色', value: 'green'),
                  DropDownValueModel(name: '蓝色', value: 'blue'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                buttonText: '确认选择',
                buttonColor: Colors.blue,
                buttonTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                listPadding: ListPadding(),
              ),
```
''',
        ),

        h2('自定义复选框样式'),
        p('自定义复选框的颜色和形状'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '周一', value: 'mon'),
                  DropDownValueModel(name: '周二', value: 'tue'),
                  DropDownValueModel(name: '周三', value: 'wed'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                checkBoxProperty: CheckBoxProperty(
                  activeColor: Colors.purple,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                listPadding: ListPadding(),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '周一', value: 'mon'),
                  DropDownValueModel(name: '周二', value: 'tue'),
                  DropDownValueModel(name: '周三', value: 'wed'),
                ],
                list: [false, false, false],
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                checkBoxProperty: CheckBoxProperty(
                  activeColor: Colors.purple,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                listPadding: ListPadding(),
              ),
```
''',
        ),

        h2('带提示信息的选项'),
        p('为选项添加提示信息'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(
                    name: '标准版',
                    value: 'standard',
                    toolTipMsg: '包含基本功能',
                  ),
                  DropDownValueModel(
                    name: '专业版',
                    value: 'pro',
                    toolTipMsg: '包含高级功能',
                  ),
                ],
                list: [false, false],
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(
                    name: '标准版',
                    value: 'standard',
                    toolTipMsg: '包含基本功能',
                  ),
                  DropDownValueModel(
                    name: '专业版',
                    value: 'pro',
                    toolTipMsg: '包含高级功能',
                  ),
                ],
                list: [false, false],
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                listPadding: ListPadding(),
              ),
```
''',
        ),

        h2('自定义文本样式'),
        p('自定义选项文本样式'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '选项A', value: 'a'),
                  DropDownValueModel(name: '选项B', value: 'b'),
                ],
                list: [false, false],
                onChanged: (selected) {
                  print('选中项: $selected');
                },
                height: 200,
                listTileHeight: 48,
                listTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
                listPadding: ListPadding(),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                dropDownList: const [
                  DropDownValueModel(name: '选项A', value: 'a'),
                  DropDownValueModel(name: '选项B', value: 'b'),
                ],
                list: [false, false],
                onChanged: (selected) {
                  print('选中项: \$selected');
                },
                height: 200,
                listTileHeight: 48,
                listTextStyle: const TextStyle(
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
                listPadding: ListPadding(),
              ),
```
''',
        ),

        h2('实际应用场景'),
        p('在表单中使用多选组件'),
        WidgetHighlight(
          builder: (_) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '选择您感兴趣的主题:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 300,
                    child: EasyMultiSelection(
                      dropDownList: const [
                        DropDownValueModel(name: '科技', value: 'tech'),
                        DropDownValueModel(name: '体育', value: 'sports'),
                        DropDownValueModel(name: '音乐', value: 'music'),
                      ],
                      list: [false, false, false],
                      onChanged: (selected) {
                        print('选中项: $selected');
                      },
                      height: 200,
                      listTileHeight: 48,
                      buttonText: '保存选择',
                      listPadding: ListPadding(),
                    ),
                  ),
                ],
              ),
            );
          },
          codeSnippet: '''
```dart
EasyMultiSelection(
                      dropDownList: const [
                        DropDownValueModel(name: '科技', value: 'tech'),
                        DropDownValueModel(name: '体育', value: 'sports'),
                        DropDownValueModel(name: '音乐', value: 'music'),
                      ],
                      list: [false, false, false],
                      onChanged: (selected) {
                        print('选中项: \$selected');
                      },
                      height: 200,
                      listTileHeight: 48,
                      buttonText: '保存选择',
                      listPadding: ListPadding(),
                    ),
```
''',
        ),
        h2('MultiSelection参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyMultiSelection 参数说明：'),
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
                        DataCell(Text('dropDownList')),
                        DataCell(Text('List<DropDownValueModel>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('下拉选项列表，每个选项包含name和value')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('list')),
                        DataCell(Text('List<bool>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('初始选中状态列表，与dropDownList一一对应')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<List<bool>>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('选中状态变化回调，返回新的选中状态列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double')),
                        DataCell(Text('300.0')),
                        DataCell(Text('否')),
                        DataCell(Text('组件总高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('listTileHeight')),
                        DataCell(Text('double')),
                        DataCell(Text('48.0')),
                        DataCell(Text('否')),
                        DataCell(Text('每个选项的高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('buttonText')),
                        DataCell(Text('String')),
                        DataCell(Text('"确定"')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('buttonColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('buttonTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('listTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选项文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('checkBoxProperty')),
                        DataCell(Text('CheckBoxProperty?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('复选框样式配置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('listPadding')),
                        DataCell(Text('ListPadding')),
                        DataCell(Text('ListPadding(top: 0, bottom: 0)')),
                        DataCell(Text('否')),
                        DataCell(Text('列表内边距')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('DropDownValueModel 参数说明：'),
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
                        DataCell(Text('name')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('选项显示名称')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('value')),
                        DataCell(Text('dynamic')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('选项实际值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('toolTipMsg')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选项提示信息')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('CheckBoxProperty 参数说明：'),
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
                        DataCell(Text('activeColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('选中状态颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('checkColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('勾选标记颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('shape')),
                        DataCell(Text('ShapeBorder')),
                        DataCell(Text('CircleBorder()')),
                        DataCell(Text('否')),
                        DataCell(Text('复选框形状')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('ListPadding 参数说明：'),
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
                        DataCell(Text('top')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('顶部内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('bottom')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('底部内边距')),
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
