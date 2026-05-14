import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/body_widget.dart';
import '../../../../widgets/paragraph_helper.dart';
import '../../../../widgets/widget_highlight.dart';

class SelectDemo extends StatelessWidget {
  const SelectDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySelect 选择器组件'),

        // 基本介绍
        h2('组件概述'),
        p('EasySelect 是一个功能强大的选择器组件，支持单选、多选、异步加载选项、搜索过滤等功能。'),

        // 基本单选
        h2('基本单选'),
        p('展示基本的单选选择器功能'),
        WidgetHighlight(
          builder: (_) => _SingleSelectDemo(),
          codeSnippet: '''
```dart
EasySelect<String>(
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'option1', title: '选项1'),
            EasyListPopMenuOption.simple(value: 'option2', title: '选项2'),
            EasyListPopMenuOption.simple(value: 'option3', title: '选项3'),
          ],
      placeholder: '请选择',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
```
''',
        ),

        // 基本多选
        h2('基本多选'),
        p('展示基本的多选选择器功能'),
        WidgetHighlight(
          builder: (_) => _MultiSelectDemo(),
          codeSnippet: '''
```dart
EasySelect<String>(
      multiple: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'option1', title: '选项1'),
            EasyListPopMenuOption.simple(value: 'option2', title: '选项2'),
            EasyListPopMenuOption.simple(value: 'option3', title: '选项3'),
          ],
      placeholder: '请选择',
      onChangedMultiple: (values) {
        setState(() {
          _selectedValues.clear();
          _selectedValues.addAll(values);
        });
      },
    );
```
''',
        ),

        // 异步加载选项
        h2('异步加载选项'),
        p('从API异步加载选项数据'),
        WidgetHighlight(
          builder: (_) => _AsyncSelectDemo(),
          codeSnippet: '''
```dart
EasySelect<String>(
      optionsFetcher: () async {
        // 模拟API请求
        await Future.delayed(const Duration(seconds: 1));
        return [
          EasyListPopMenuOption.simple(value: 'async1', title: '异步选项1'),
          EasyListPopMenuOption.simple(value: 'async2', title: '异步选项2'),
          EasyListPopMenuOption.simple(value: 'async3', title: '异步选项3'),
        ];
      },
      placeholder: '请选择(异步加载)',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
```
''',
        ),

        // 可搜索
        h2('可搜索选择器'),
        p('支持搜索过滤选项'),
        WidgetHighlight(
          builder: (_) => _SearchableSelectDemo(),
          codeSnippet: '''
```dart
EasySelect<String>(
      filterable: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
            EasyListPopMenuOption.simple(value: 'banana', title: '香蕉'),
            EasyListPopMenuOption.simple(value: 'orange', title: '橙子'),
            EasyListPopMenuOption.simple(value: 'pear', title: '梨'),
          ],
      placeholder: '搜索水果',
      searchHintText: '输入水果名称',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
```
''',
        ),

        // 可清除
        h2('可清除选择'),
        p('支持清除已选选项'),
        WidgetHighlight(
          builder: (_) => _ClearableSelectDemo(),
          codeSnippet: '''
```dart
EasySelect<String>(
      clearable: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'item1', title: '项目1'),
            EasyListPopMenuOption.simple(value: 'item2', title: '项目2'),
          ],
      placeholder: '请选择(可清除)',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
```
''',
        ),

        // 控制器使用
        h2('使用控制器'),
        p('通过控制器控制选择器行为'),
        WidgetHighlight(
          builder: (_) => _ControlledSelectDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasySelect<String>(
          controller: widget.controller,
          optionsFetcher:
              () async => [
                EasyListPopMenuOption.simple(value: 'ctrl1', title: '控制选项1'),
                EasyListPopMenuOption.simple(value: 'ctrl2', title: '控制选项2'),
              ],
          placeholder: '请选择',
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.controller.refreshOptions();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已刷新选项')));
          },
          child: const Text('刷新选项'),
        ),
      ],
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在表单中使用选择器'),
        WidgetHighlight(
          builder: (_) => _FormSelectDemo(),
          codeSnippet: '''
```dart
Form(
      child: Column(
        children: [
          EasySelect<String>(
            optionsFetcher:
                () async => [
                  EasyListPopMenuOption.simple(value: 'male', title: '男'),
                  EasyListPopMenuOption.simple(value: 'female', title: '女'),
                ],
            placeholder: '请选择性别',
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          EasySelect<String>(
            multiple: true,
            optionsFetcher:
                () async => [
                  EasyListPopMenuOption.simple(value: 'sports', title: '运动'),
                  EasyListPopMenuOption.simple(value: 'music', title: '音乐'),
                  EasyListPopMenuOption.simple(value: 'reading', title: '阅读'),
                ],
            placeholder: '请选择兴趣爱好',
            onChangedMultiple: (values) {
              setState(() {
                _hobbies.clear();
                _hobbies.addAll(values);
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('性别: \$_gender, 兴趣爱好: \${_hobbies.join(', ')}'),
                ),
              );
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
```
''',
        ),
        h2('Select参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasySelect 参数说明：'),
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
                        DataCell(Text('optionsFetcher')),
                        DataCell(
                          Text(
                            'Future<List<EasyListPopMenuOption>> Function()',
                          ),
                        ),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('获取选项列表的异步函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<dynamic>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('单选模式下的值变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChangedMultiple')),
                        DataCell(Text('ValueChanged<Set<dynamic>>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('多选模式下的值变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('multiple')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用多选模式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('placeholder')),
                        DataCell(Text('String')),
                        DataCell(Text('"请选择"')),
                        DataCell(Text('否')),
                        DataCell(Text('未选择时的占位文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('filterable')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用搜索过滤功能')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('searchHintText')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('搜索框提示文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('clearable')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示清除按钮')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasySelectController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选择器控制器')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('disabled')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否禁用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('loadingWidget')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('CircularProgressIndicator()')),
                        DataCell(Text('否')),
                        DataCell(Text('加载中显示的组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('emptyWidget')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('Text("无数据")')),
                        DataCell(Text('否')),
                        DataCell(Text('无数据时显示的组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('errorWidget')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('Text("加载失败")')),
                        DataCell(Text('否')),
                        DataCell(Text('加载失败时显示的组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('menuWidth')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉菜单宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('menuHeight')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉菜单高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('menuPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉菜单内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('menuDecoration')),
                        DataCell(Text('Decoration?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('下拉菜单装饰')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyListPopMenuOption 参数说明：'),
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
                        DataCell(Text('value')),
                        DataCell(Text('dynamic')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('选项的实际值')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('title')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('选项的显示文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('disabled')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否禁用该选项')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('leading')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选项前导组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('trailing')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('选项后置组件')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasySelectController 方法说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('参数')),
                    DataColumn(label: Text('返回值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('refreshOptions')),
                        DataCell(Text('无')),
                        DataCell(Text('void')),
                        DataCell(Text('刷新选项列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('openMenu')),
                        DataCell(Text('无')),
                        DataCell(Text('void')),
                        DataCell(Text('打开下拉菜单')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('closeMenu')),
                        DataCell(Text('无')),
                        DataCell(Text('void')),
                        DataCell(Text('关闭下拉菜单')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('clearSelection')),
                        DataCell(Text('无')),
                        DataCell(Text('void')),
                        DataCell(Text('清除已选内容')),
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

// 基本单选演示
class _SingleSelectDemo extends StatefulWidget {
  @override
  State<_SingleSelectDemo> createState() => _SingleSelectDemoState();
}

class _SingleSelectDemoState extends State<_SingleSelectDemo> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return EasySelect<String>(
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'option1', title: '选项1'),
            EasyListPopMenuOption.simple(value: 'option2', title: '选项2'),
            EasyListPopMenuOption.simple(value: 'option3', title: '选项3'),
          ],
      placeholder: '请选择',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}

// 基本多选演示
class _MultiSelectDemo extends StatefulWidget {
  @override
  State<_MultiSelectDemo> createState() => _MultiSelectDemoState();
}

class _MultiSelectDemoState extends State<_MultiSelectDemo> {
  final Set<String> _selectedValues = {};

  @override
  Widget build(BuildContext context) {
    return EasySelect<String>(
      multiple: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'option1', title: '选项1'),
            EasyListPopMenuOption.simple(value: 'option2', title: '选项2'),
            EasyListPopMenuOption.simple(value: 'option3', title: '选项3'),
          ],
      placeholder: '请选择',
      onChangedMultiple: (values) {
        setState(() {
          _selectedValues.clear();
          _selectedValues.addAll(values);
        });
      },
    );
  }
}

// 异步加载演示
class _AsyncSelectDemo extends StatefulWidget {
  @override
  State<_AsyncSelectDemo> createState() => _AsyncSelectDemoState();
}

class _AsyncSelectDemoState extends State<_AsyncSelectDemo> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return EasySelect<String>(
      optionsFetcher: () async {
        // 模拟API请求
        await Future.delayed(const Duration(seconds: 1));
        return [
          EasyListPopMenuOption.simple(value: 'async1', title: '异步选项1'),
          EasyListPopMenuOption.simple(value: 'async2', title: '异步选项2'),
          EasyListPopMenuOption.simple(value: 'async3', title: '异步选项3'),
        ];
      },
      placeholder: '请选择(异步加载)',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}

// 可搜索演示
class _SearchableSelectDemo extends StatefulWidget {
  @override
  State<_SearchableSelectDemo> createState() => _SearchableSelectDemoState();
}

class _SearchableSelectDemoState extends State<_SearchableSelectDemo> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return EasySelect<String>(
      filterable: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
            EasyListPopMenuOption.simple(value: 'banana', title: '香蕉'),
            EasyListPopMenuOption.simple(value: 'orange', title: '橙子'),
            EasyListPopMenuOption.simple(value: 'pear', title: '梨'),
          ],
      placeholder: '搜索水果',
      searchHintText: '输入水果名称',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}

// 可清除演示
class _ClearableSelectDemo extends StatefulWidget {
  @override
  State<_ClearableSelectDemo> createState() => _ClearableSelectDemoState();
}

class _ClearableSelectDemoState extends State<_ClearableSelectDemo> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return EasySelect<String>(
      clearable: true,
      optionsFetcher:
          () async => [
            EasyListPopMenuOption.simple(value: 'item1', title: '项目1'),
            EasyListPopMenuOption.simple(value: 'item2', title: '项目2'),
          ],
      placeholder: '请选择(可清除)',
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }
}

// 控制器演示
class _ControlledSelectDemo extends StatefulWidget {
  final EasySelectController controller = EasySelectController();

  @override
  State<_ControlledSelectDemo> createState() => _ControlledSelectDemoState();
}

class _ControlledSelectDemoState extends State<_ControlledSelectDemo> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasySelect<String>(
          controller: widget.controller,
          optionsFetcher:
              () async => [
                EasyListPopMenuOption.simple(value: 'ctrl1', title: '控制选项1'),
                EasyListPopMenuOption.simple(value: 'ctrl2', title: '控制选项2'),
              ],
          placeholder: '请选择',
          onChanged: (value) {
            setState(() {
              _selectedValue = value;
            });
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.controller.refreshOptions();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已刷新选项')));
          },
          child: const Text('刷新选项'),
        ),
      ],
    );
  }
}

// 表单中使用演示
class _FormSelectDemo extends StatefulWidget {
  @override
  State<_FormSelectDemo> createState() => _FormSelectDemoState();
}

class _FormSelectDemoState extends State<_FormSelectDemo> {
  String? _gender;
  final Set<String> _hobbies = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          EasySelect<String>(
            optionsFetcher:
                () async => [
                  EasyListPopMenuOption.simple(value: 'male', title: '男'),
                  EasyListPopMenuOption.simple(value: 'female', title: '女'),
                ],
            placeholder: '请选择性别',
            onChanged: (value) {
              setState(() {
                _gender = value;
              });
            },
          ),
          const SizedBox(height: 16),
          EasySelect<String>(
            multiple: true,
            optionsFetcher:
                () async => [
                  EasyListPopMenuOption.simple(value: 'sports', title: '运动'),
                  EasyListPopMenuOption.simple(value: 'music', title: '音乐'),
                  EasyListPopMenuOption.simple(value: 'reading', title: '阅读'),
                ],
            placeholder: '请选择兴趣爱好',
            onChangedMultiple: (values) {
              setState(() {
                _hobbies.clear();
                _hobbies.addAll(values);
              });
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('性别: $_gender, 兴趣爱好: ${_hobbies.join(', ')}'),
                ),
              );
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}
