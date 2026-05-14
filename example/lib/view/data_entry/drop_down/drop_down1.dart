import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class DropDownDemo1 extends StatelessWidget {
  const DropDownDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyDropDownTextField 下拉选择框组件示例'),
        h2('1. 基本用法（单选）'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '选项1', value: '1'),
                DropDownValueModel(name: '选项2', value: '2'),
                DropDownValueModel(name: '选项3', value: '3'),
              ],
              onChanged: (value) {
                print('Selected: $value');
              },
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '选项1', value: '1'),
                DropDownValueModel(name: '选项2', value: '2'),
                DropDownValueModel(name: '选项3', value: '3'),
              ],
              onChanged: (value) {
                print('Selected: \$value');
              },
            );
```
''',
        ),

        h2('2. 多选模式'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField.multiSelection(
              dropDownList: const [
                DropDownValueModel(name: '苹果', value: 'apple'),
                DropDownValueModel(name: '香蕉', value: 'banana'),
                DropDownValueModel(name: '橙子', value: 'orange'),
              ],
              onChanged: (value) {
                print('Selected items: $value');
              },
              submitButtonText: '确认',
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField.multiSelection(
              dropDownList: const [
                DropDownValueModel(name: '苹果', value: 'apple'),
                DropDownValueModel(name: '香蕉', value: 'banana'),
                DropDownValueModel(name: '橙子', value: 'orange'),
              ],
              onChanged: (value) {
                print('Selected items: \$value');
              },
              submitButtonText: '确认',
            )
```
''',
        ),

        h2('3. 带搜索功能'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField(
              dropDownList: List.generate(
                20,
                (index) => DropDownValueModel(
                  name: '选项 ${index + 1}',
                  value: 'value_${index + 1}',
                ),
              ),
              enableSearch: true,
              dropDownItemCount: 8,
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField(
              dropDownList: List.generate(
                20,
                (index) => DropDownValueModel(
                  name: '选项 \${index + 1}',
                  value: 'value_\${index + 1}',
                ),
              ),
              enableSearch: true,
              dropDownItemCount: 8,
            );
```
''',
        ),

        h2('4. 自定义样式'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '红色', value: 'red'),
                DropDownValueModel(name: '绿色', value: 'green'),
                DropDownValueModel(name: '蓝色', value: 'blue'),
              ],
              textFieldDecoration: const InputDecoration(
                labelText: '选择颜色',
                border: OutlineInputBorder(),
              ),
              dropdownRadius: 8,
              height: 48,
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '红色', value: 'red'),
                DropDownValueModel(name: '绿色', value: 'green'),
                DropDownValueModel(name: '蓝色', value: 'blue'),
              ],
              textFieldDecoration: const InputDecoration(
                labelText: '选择颜色',
                border: OutlineInputBorder(),
              ),
              dropdownRadius: 8,
              height: 48,
            );
```
''',
        ),

        h2('5. 自定义下拉项样式'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '高优先级', value: 'high'),
                DropDownValueModel(name: '中优先级', value: 'medium'),
                DropDownValueModel(name: '低优先级', value: 'low'),
              ],
              listTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              listPadding: ListPadding(top: 12, bottom: 12),
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '高优先级', value: 'high'),
                DropDownValueModel(name: '中优先级', value: 'medium'),
                DropDownValueModel(name: '低优先级', value: 'low'),
              ],
              listTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              listPadding: ListPadding(top: 12, bottom: 12),
            );
```
''',
        ),

        h2('6. 禁用状态'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '选项A', value: 'a'),
                DropDownValueModel(name: '选项B', value: 'b'),
              ],
              isEnabled: false,
              initialValue: '选项A',
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField(
              dropDownList: const [
                DropDownValueModel(name: '选项A', value: 'a'),
                DropDownValueModel(name: '选项B', value: 'b'),
              ],
              isEnabled: false,
              initialValue: '选项A',
            );
```
''',
        ),

        h2('7. 表单验证'),
        WidgetHighlight(
          builder: (_) {
            return Form(
              child: Column(
                children: [
                  EasyDropDownTextField(
                    dropDownList: const [
                      DropDownValueModel(name: '是', value: true),
                      DropDownValueModel(name: '否', value: false),
                    ],
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return '请选择';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
            );
          },
          codeSnippet: '''
```dart
      Column(
                children: [
                  EasyDropDownTextField(
                    dropDownList: const [
                      DropDownValueModel(name: '是', value: true),
                      DropDownValueModel(name: '否', value: false),
                    ],
                    validator: (value) {
                      if (value == null || value.toString().isEmpty) {
                        return '请选择';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ],
              ),
```
''',
        ),

        h2('8. 自定义复选框样式（多选）'),
        WidgetHighlight(
          builder: (_) {
            return EasyDropDownTextField.multiSelection(
              dropDownList: const [
                DropDownValueModel(name: '周一', value: 'mon'),
                DropDownValueModel(name: '周二', value: 'tue'),
                DropDownValueModel(name: '周三', value: 'wed'),
              ],
              checkBoxProperty: CheckBoxProperty(
                activeColor: Colors.purple,
                checkColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyDropDownTextField.multiSelection(
              dropDownList: const [
                DropDownValueModel(name: '周一', value: 'mon'),
                DropDownValueModel(name: '周二', value: 'tue'),
                DropDownValueModel(name: '周三', value: 'wed'),
              ],
              checkBoxProperty: CheckBoxProperty(
                activeColor: Colors.purple,
                checkColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
```
''',
        ),
        h2('DropDownTextField参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyDropDownTextField 参数说明：'),
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
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<dynamic>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选项变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialValue')),
                        DataCell(Text('dynamic')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始选中的值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('isEnabled')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('enableSearch')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用搜索功能')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('dropDownItemCount')),
                        DataCell(Text('int')),
                        DataCell(Text('5')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉列表显示的最大项目数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textFieldDecoration')),
                        DataCell(Text('InputDecoration?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('输入框装饰样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('dropdownRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉面板圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('组件高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('listTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉列表文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('listPadding')),
                        DataCell(Text('ListPadding?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉列表内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('validator')),
                        DataCell(Text('FormFieldValidator<dynamic>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('表单验证函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('autovalidateMode')),
                        DataCell(Text('AutovalidateMode')),
                        DataCell(Text('AutovalidateMode.disabled')),
                        DataCell(Text('否')),
                        DataCell(Text('自动验证模式')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyDropDownTextField.multiSelection 额外参数说明：'),
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
                        DataCell(Text('submitButtonText')),
                        DataCell(Text('String')),
                        DataCell(Text('"确定"')),
                        DataCell(Text('否')),
                        DataCell(Text('多选模式下的确认按钮文本')),
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
              ],
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}
