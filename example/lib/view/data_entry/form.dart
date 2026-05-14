import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class FormDemo extends StatelessWidget {
  const FormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('表单组件综合演示'),

        // EasyTextFormField 组件
        h2('EasyTextFormField 文本输入框'),
        p('提供多种布局和配置选项的文本输入框组件'),
        WidgetHighlight(
          builder: (_) => _TextFormFieldDemo(),
          codeSnippet: '''
```dart
class _TextFormFieldDemo extends StatefulWidget {
  @override
  State<_TextFormFieldDemo> createState() => _TextFormFieldDemoState();
}

class _TextFormFieldDemoState extends State<_TextFormFieldDemo> {
  bool showLabel = false;
  bool showHelperText = false;
  bool showErrorText = false;
  bool showCounter = false;
  bool showRequiredMark = false;
  bool showHintText = false;
  _LayoutType _layoutType = _LayoutType.defaultType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            FilterChip(
              selected: showLabel,
              label: const Text('显示Label'),
              onSelected: (value) => setState(() => showLabel = value),
            ),
            FilterChip(
              selected: showRequiredMark,
              label: const Text('显示必填标记'),
              onSelected: (value) => setState(() => showRequiredMark = value),
            ),
            FilterChip(
              selected: showErrorText,
              label: const Text('显示错误文本'),
              onSelected: (value) => setState(() => showErrorText = value),
            ),
            FilterChip(
              selected: showCounter,
              label: const Text('显示计数器'),
              onSelected: (value) => setState(() => showCounter = value),
            ),
            FilterChip(
              selected: showHintText,
              label: const Text('显示占位文本'),
              onSelected: (value) => setState(() => showHintText = value),
            ),
            FilterChip(
              selected: showHelperText,
              label: const Text('显示提示文本'),
              onSelected: (value) => setState(() => showHelperText = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: [
            ..._LayoutType.values.map(
              (e) => ChoiceChip(
                label: Text(switch (e) {
                  _LayoutType.defaultType => 'Material Design默认布局',
                  _LayoutType.vertical => '垂直布局',
                  _LayoutType.horizontal => '水平布局',
                }),
                selected: _layoutType == e,
                onSelected: (v) {
                  if (v) {
                    setState(() {
                      _layoutType = e;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        switch (_layoutType) {
          _LayoutType.defaultType => EasyTextFormField(
            decorationLayoutDelegate: null,
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
              counter: showCounter ? null : const SizedBox(),
            ),
          ),
          _LayoutType.vertical => EasyTextFormField(
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(
                  showCounter: showCounter,
                ),
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
            ),
          ),
          _LayoutType.horizontal => EasyTextFormField(
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.horizontal(
                  showCounter: showCounter,
                ),
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
            ),
          ),
        },
      ],
    );
  }
}
```
''',
        ),

        // EasyPopupSingleDateTimeFormField 组件
        h2('EasyPopupSingleDateTimeFormField 日期时间选择器'),
        p('提供单个日期时间选择的表单组件'),
        WidgetHighlight(
          builder: (_) => _DateTimeFormFieldDemo(),
          codeSnippet: '''
```dart
Form(
      key: _formKey,
      child: Column(
        children: [
          EasyPopupSingleDateTimeFormField(
            decoration: const InputDecoration(
              labelText: '选择时间',
              helperText: '请选择日期和时间',
            ),
            showRequiredMark: true,
            decorationDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            placeholder: '点击选择时间',
            validator: (v) => v == null ? '请选择时间' : null,
            onChanged: (dt) => setState(() => _selectedDateTime = dt),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('验证通过!')));
                  }
                },
                child: const Text('验证'),
              ),
              const SizedBox(width: 16),
              Text(
                _selectedDateTime == null
                    ? '未选择时间'
                    : '已选择: \${_selectedDateTime!.toLocal()}',
              ),
            ],
          ),
        ],
      ),
    );
```
''',
        ),

        // EasyPopupRangeDateTimeFormField 组件
        h2('EasyPopupRangeDateTimeFormField 日期时间范围选择器'),
        p('提供日期时间范围选择的表单组件'),
        WidgetHighlight(
          builder: (_) => _RangeDateTimeFormFieldDemo(),
          codeSnippet: '''
```dart
Form(
      key: _formKey,
      child: Column(
        children: [
          EasyPopupRangeDateTimeFormField(
            decoration: const InputDecoration(
              labelText: '时间范围',
              helperText: '请选择开始和结束时间',
            ),
            showRequiredMark: true,
            decorationDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            placeholder: '点击选择时间范围',
            validator: (dateRange) {
              if (dateRange == null) return '请选择时间范围';
              if (dateRange.start.isAfter(dateRange.end)) {
                return '开始时间必须在结束时间之前';
              }
              return null;
            },
            onChanged:
                (dateRange) =>
                    setState(() => _selectedDateTimeRange = dateRange),
          ),
          const SizedBox(height: 16),
          EasyTextFormField(
            decoration: const InputDecoration(
              labelText: '事件名称',
              helperText: '请输入事件名称',
            ),
            showRequiredMark: true,
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            validator: (value) => value?.isEmpty == true ? '请输入事件名称' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('表单验证通过!')));
                  }
                },
                child: const Text('验证'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedDateTimeRange == null
                      ? '未选择时间范围'
                      : '已选择: \${_selectedDateTimeRange!.start.toLocal()} - \${_selectedDateTimeRange!.end.toLocal()}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDateTimeRange = DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(const Duration(hours: 2)),
                );
              });
            },
            child: const Text('设置默认范围(当前时间+2小时)'),
          ),
        ],
      ),
    );
```
''',
        ),
        h2('表单组件参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyTextFormField 参数说明：'),
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
                        DataCell(Text('decorationLayoutDelegate')),
                        DataCell(
                          Text('EasyTextFormFieldDecorationLayoutDelegate?'),
                        ),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('布局代理，控制标签、输入框和辅助文本的布局方式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showRequiredMark')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示必填标记')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decoration')),
                        DataCell(Text('InputDecoration')),
                        DataCell(Text('InputDecoration()')),
                        DataCell(Text('否')),
                        DataCell(Text('输入框装饰样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('maxLength')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('最大输入长度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('TextEditingController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本控制器')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('validator')),
                        DataCell(Text('FormFieldValidator<String?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('验证函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<String?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本变化回调')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyPopupSingleDateTimeFormField 参数说明：'),
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
                        DataCell(Text('decoration')),
                        DataCell(Text('InputDecoration')),
                        DataCell(Text('InputDecoration()')),
                        DataCell(Text('否')),
                        DataCell(Text('输入框装饰样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showRequiredMark')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示必填标记')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decorationDelegate')),
                        DataCell(
                          Text('EasyTextFormFieldDecorationLayoutDelegate?'),
                        ),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('布局代理')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('placeholder')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('占位文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('validator')),
                        DataCell(Text('FormFieldValidator<DateTime?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('验证函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<DateTime?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('值变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('DateTime(1900)')),
                        DataCell(Text('否')),
                        DataCell(Text('可选最早日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lastDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('DateTime(2100)')),
                        DataCell(Text('否')),
                        DataCell(Text('可选最晚日期')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyPopupRangeDateTimeFormField 参数说明：'),
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
                        DataCell(Text('decoration')),
                        DataCell(Text('InputDecoration')),
                        DataCell(Text('InputDecoration()')),
                        DataCell(Text('否')),
                        DataCell(Text('输入框装饰样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showRequiredMark')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示必填标记')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decorationDelegate')),
                        DataCell(
                          Text('EasyTextFormFieldDecorationLayoutDelegate?'),
                        ),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('布局代理')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('placeholder')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('占位文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('validator')),
                        DataCell(Text('FormFieldValidator<DateTimeRange?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('验证函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChanged')),
                        DataCell(Text('ValueChanged<DateTimeRange?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('值变化回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialDateRange')),
                        DataCell(Text('DateTimeRange?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始日期范围')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('DateTime(1900)')),
                        DataCell(Text('否')),
                        DataCell(Text('可选最早日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lastDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('DateTime(2100)')),
                        DataCell(Text('否')),
                        DataCell(Text('可选最晚日期')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyTextFormFieldDecorationLayoutDelegate 参数说明：'),
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
                        DataCell(Text('labelPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('标签内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('helperPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助文本内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('errorPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('错误文本内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('labelGap')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('标签与输入框间距')),
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

enum _LayoutType { defaultType, vertical, horizontal }

// 文本输入框演示组件
class _TextFormFieldDemo extends StatefulWidget {
  @override
  State<_TextFormFieldDemo> createState() => _TextFormFieldDemoState();
}

class _TextFormFieldDemoState extends State<_TextFormFieldDemo> {
  bool showLabel = false;
  bool showHelperText = false;
  bool showErrorText = false;
  bool showCounter = false;
  bool showRequiredMark = false;
  bool showHintText = false;
  _LayoutType _layoutType = _LayoutType.defaultType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          runSpacing: 8,
          spacing: 8,
          children: [
            FilterChip(
              selected: showLabel,
              label: const Text('显示Label'),
              onSelected: (value) => setState(() => showLabel = value),
            ),
            FilterChip(
              selected: showRequiredMark,
              label: const Text('显示必填标记'),
              onSelected: (value) => setState(() => showRequiredMark = value),
            ),
            FilterChip(
              selected: showErrorText,
              label: const Text('显示错误文本'),
              onSelected: (value) => setState(() => showErrorText = value),
            ),
            FilterChip(
              selected: showCounter,
              label: const Text('显示计数器'),
              onSelected: (value) => setState(() => showCounter = value),
            ),
            FilterChip(
              selected: showHintText,
              label: const Text('显示占位文本'),
              onSelected: (value) => setState(() => showHintText = value),
            ),
            FilterChip(
              selected: showHelperText,
              label: const Text('显示提示文本'),
              onSelected: (value) => setState(() => showHelperText = value),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: [
            ..._LayoutType.values.map(
              (e) => ChoiceChip(
                label: Text(switch (e) {
                  _LayoutType.defaultType => 'Material Design默认布局',
                  _LayoutType.vertical => '垂直布局',
                  _LayoutType.horizontal => '水平布局',
                }),
                selected: _layoutType == e,
                onSelected: (v) {
                  if (v) {
                    setState(() {
                      _layoutType = e;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        switch (_layoutType) {
          _LayoutType.defaultType => EasyTextFormField(
            decorationLayoutDelegate: null,
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
              counter: showCounter ? null : const SizedBox(),
            ),
          ),
          _LayoutType.vertical => EasyTextFormField(
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(
                  showCounter: showCounter,
                ),
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
            ),
          ),
          _LayoutType.horizontal => EasyTextFormField(
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.horizontal(
                  showCounter: showCounter,
                ),
            showRequiredMark: showRequiredMark,
            maxLength: 100,
            decoration: InputDecoration(
              labelText: showLabel ? '这是Label' : null,
              helperText: showHelperText ? '这是提示文本' : null,
              hintText: showHintText ? '这是占位文本' : null,
              errorText: showErrorText ? '这是一个错误提示' : null,
            ),
          ),
        },
      ],
    );
  }
}

// 日期时间选择器演示组件
class _DateTimeFormFieldDemo extends StatefulWidget {
  @override
  State<_DateTimeFormFieldDemo> createState() => _DateTimeFormFieldDemoState();
}

class _DateTimeFormFieldDemoState extends State<_DateTimeFormFieldDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EasyPopupSingleDateTimeFormField(
            decoration: const InputDecoration(
              labelText: '选择时间',
              helperText: '请选择日期和时间',
            ),
            showRequiredMark: true,
            decorationDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            placeholder: '点击选择时间',
            validator: (v) => v == null ? '请选择时间' : null,
            onChanged: (dt) => setState(() => _selectedDateTime = dt),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('验证通过!')));
                  }
                },
                child: const Text('验证'),
              ),
              const SizedBox(width: 16),
              Text(
                _selectedDateTime == null
                    ? '未选择时间'
                    : '已选择: ${_selectedDateTime!.toLocal()}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 日期时间范围选择器演示组件
class _RangeDateTimeFormFieldDemo extends StatefulWidget {
  @override
  State<_RangeDateTimeFormFieldDemo> createState() =>
      _RangeDateTimeFormFieldDemoState();
}

class _RangeDateTimeFormFieldDemoState
    extends State<_RangeDateTimeFormFieldDemo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTimeRange? _selectedDateTimeRange;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          EasyPopupRangeDateTimeFormField(
            decoration: const InputDecoration(
              labelText: '时间范围',
              helperText: '请选择开始和结束时间',
            ),
            showRequiredMark: true,
            decorationDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            placeholder: '点击选择时间范围',
            validator: (dateRange) {
              if (dateRange == null) return '请选择时间范围';
              if (dateRange.start.isAfter(dateRange.end)) {
                return '开始时间必须在结束时间之前';
              }
              return null;
            },
            onChanged:
                (dateRange) =>
                    setState(() => _selectedDateTimeRange = dateRange),
          ),
          const SizedBox(height: 16),
          EasyTextFormField(
            decoration: const InputDecoration(
              labelText: '事件名称',
              helperText: '请输入事件名称',
            ),
            showRequiredMark: true,
            decorationLayoutDelegate:
                EasyTextFormFieldDecorationLayoutDelegate.vertical(),
            validator: (value) => value?.isEmpty == true ? '请输入事件名称' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('表单验证通过!')));
                  }
                },
                child: const Text('验证'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedDateTimeRange == null
                      ? '未选择时间范围'
                      : '已选择: ${_selectedDateTimeRange!.start.toLocal()} - ${_selectedDateTimeRange!.end.toLocal()}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _selectedDateTimeRange = DateTimeRange(
                  start: DateTime.now(),
                  end: DateTime.now().add(const Duration(hours: 2)),
                );
              });
            },
            child: const Text('设置默认范围(当前时间+2小时)'),
          ),
        ],
      ),
    );
  }
}
