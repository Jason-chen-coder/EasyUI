import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class TimePickerDemo extends StatelessWidget {
  const TimePickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyPopupDateTimePicker 弹出式日期时间选择器'),

        // 基本介绍
        h2('组件概述'),
        p(
          'EasyPopupDateTimePicker 是一个弹出式的日期时间选择器，支持单选和范围选择模式，提供简洁的触发按钮和完整的日期时间选择功能。',
        ),

        // 基本单选
        h2('基本单选模式'),
        p('弹出式单选日期时间选择器'),
        WidgetHighlight(
          builder: (_) => _SinglePopupDateTimePickerDemo(),
          codeSnippet: '''
```dart
EasyPopupSingleDateTimePicker(
      initialDateTime: _selectedDateTime,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDateTime = dateTime;
        });
      },
      placeholder: '请选择时间',
    );
```
''',
        ),

        // 基本范围选择
        h2('基本范围选择模式'),
        p('弹出式日期时间范围选择器'),
        WidgetHighlight(
          builder: (_) => _RangePopupDateTimePickerDemo(),
          codeSnippet: '''
```dart
EasyPopupRangeDateTimePicker(
      initialStartDateTime: _startDateTime,
      initialEndDateTime: _endDateTime,
      onConfirm: (start, end) {
        setState(() {
          _startDateTime = start;
          _endDateTime = end;
        });
      },
      placeholder: '请选择时间范围',
    );
```
''',
        ),

        // 仅选择日期
        h2('仅选择日期'),
        p('不显示时间选择部分'),
        WidgetHighlight(
          builder: (_) => _DateOnlyPopupPickerDemo(),
          codeSnippet: '''
```dart
EasyPopupSingleDateTimePicker(
      onlyPickDate: true,
      initialDateTime: _selectedDate,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDate = dateTime;
        });
      },
      placeholder: '请选择日期',
    );
```
''',
        ),

        // 自定义样式
        h2('自定义样式'),
        p('自定义触发按钮的样式'),
        WidgetHighlight(
          builder: (_) => _StyledPopupPickerDemo(),
          codeSnippet: '''
```dart
EasyPopupSingleDateTimePicker(
      initialDateTime: _selectedDateTime,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDateTime = dateTime;
        });
      },
      placeholder: '请选择时间',
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.blue),
      height: 48,
    );
```
''',
        ),

        // 初始值设置
        h2('初始值设置'),
        p('设置初始选择的日期时间'),
        WidgetHighlight(
          builder: (_) => _InitialValuePopupDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyPopupSingleDateTimePicker(
          initialDateTime: _selectedDateTime,
          onConfirm: (dateTime) {
            setState(() {
              _selectedDateTime = dateTime;
            });
          },
          placeholder: '请选择时间',
        ),
        const SizedBox(height: 16),
        EasyPopupRangeDateTimePicker(
          initialStartDateTime: _startDateTime,
          initialEndDateTime: _endDateTime,
          onConfirm: (start, end) {
            setState(() {
              _startDateTime = start;
              _endDateTime = end;
            });
          },
          placeholder: '请选择时间范围',
        ),
      ],
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在表单中使用弹出式日期时间选择器'),
        WidgetHighlight(
          builder: (_) => _FormPopupPickerDemo(),
          codeSnippet: '''
```dart
Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('预约时间:', style: TextStyle(fontSize: 16)),
          EasyPopupSingleDateTimePicker(
            initialDateTime: _appointmentTime,
            onConfirm: (dateTime) {
              setState(() {
                _appointmentTime = dateTime;
              });
            },
            placeholder: '请选择预约时间',
          ),
          const SizedBox(height: 16),
          const Text('会议时间范围:', style: TextStyle(fontSize: 16)),
          EasyPopupRangeDateTimePicker(
            initialStartDateTime: _meetingStartTime,
            initialEndDateTime: _meetingEndTime,
            onConfirm: (start, end) {
              setState(() {
                _meetingStartTime = start;
                _meetingEndTime = end;
              });
            },
            placeholder: '请选择会议时间',
          ),
          const SizedBox(height: 16),
          if (_appointmentTime != null)
            Text('预约时间: \${_appointmentTime!.toLocal()}'),
          if (_meetingStartTime != null && _meetingEndTime != null)
            Text(
              '会议时间: \${_meetingStartTime!.toLocal()} 到 \${_meetingEndTime!.toLocal()}',
            ),
        ],
      ),
    );
```
''',
        ),
        h2('TimePicker参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyPopupSingleDateTimePicker 参数说明：'),
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
                        DataCell(Text('initialDateTime')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始选择的日期时间')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onConfirm')),
                        DataCell(Text('ValueChanged<DateTime>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('确认选择回调')),
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
                        DataCell(Text('onlyPickDate')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否仅选择日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decoration')),
                        DataCell(Text('Decoration?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('触发按钮的装饰样式')),
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
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('触发按钮高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('可选的最早日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lastDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('可选的最晚日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('datePickerTitle')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('日期选择器标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('timePickerTitle')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('时间选择器标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('confirmText')),
                        DataCell(Text('String')),
                        DataCell(Text('"确定"')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cancelText')),
                        DataCell(Text('String')),
                        DataCell(Text('"取消"')),
                        DataCell(Text('否')),
                        DataCell(Text('取消按钮文本')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyPopupRangeDateTimePicker 参数说明：'),
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
                        DataCell(Text('initialStartDateTime')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始选择的开始日期时间')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialEndDateTime')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('初始选择的结束日期时间')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onConfirm')),
                        DataCell(Text('ValueChanged<DateTime, DateTime>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('确认选择回调')),
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
                        DataCell(Text('onlyPickDate')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否仅选择日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('decoration')),
                        DataCell(Text('Decoration?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('触发按钮的装饰样式')),
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
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('触发按钮高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('可选的最早日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lastDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('可选的最晚日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('datePickerTitle')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('日期选择器标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('timePickerTitle')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('时间选择器标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('confirmText')),
                        DataCell(Text('String')),
                        DataCell(Text('"确定"')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cancelText')),
                        DataCell(Text('String')),
                        DataCell(Text('"取消"')),
                        DataCell(Text('否')),
                        DataCell(Text('取消按钮文本')),
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

// 单选弹出式日期时间选择器演示
class _SinglePopupDateTimePickerDemo extends StatefulWidget {
  @override
  State<_SinglePopupDateTimePickerDemo> createState() =>
      _SinglePopupDateTimePickerDemoState();
}

class _SinglePopupDateTimePickerDemoState
    extends State<_SinglePopupDateTimePickerDemo> {
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return EasyPopupSingleDateTimePicker(
      initialDateTime: _selectedDateTime,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDateTime = dateTime;
        });
      },
      placeholder: '请选择时间',
    );
  }
}

// 范围弹出式日期时间选择器演示
class _RangePopupDateTimePickerDemo extends StatefulWidget {
  @override
  State<_RangePopupDateTimePickerDemo> createState() =>
      _RangePopupDateTimePickerDemoState();
}

class _RangePopupDateTimePickerDemoState
    extends State<_RangePopupDateTimePickerDemo> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  Widget build(BuildContext context) {
    return EasyPopupRangeDateTimePicker(
      initialStartDateTime: _startDateTime,
      initialEndDateTime: _endDateTime,
      onConfirm: (start, end) {
        setState(() {
          _startDateTime = start;
          _endDateTime = end;
        });
      },
      placeholder: '请选择时间范围',
    );
  }
}

// 仅选择日期的弹出式选择器演示
class _DateOnlyPopupPickerDemo extends StatefulWidget {
  @override
  State<_DateOnlyPopupPickerDemo> createState() =>
      _DateOnlyPopupPickerDemoState();
}

class _DateOnlyPopupPickerDemoState extends State<_DateOnlyPopupPickerDemo> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return EasyPopupSingleDateTimePicker(
      onlyPickDate: true,
      initialDateTime: _selectedDate,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDate = dateTime;
        });
      },
      placeholder: '请选择日期',
    );
  }
}

// 自定义样式的弹出式选择器演示
class _StyledPopupPickerDemo extends StatefulWidget {
  @override
  State<_StyledPopupPickerDemo> createState() => _StyledPopupPickerDemoState();
}

class _StyledPopupPickerDemoState extends State<_StyledPopupPickerDemo> {
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return EasyPopupSingleDateTimePicker(
      initialDateTime: _selectedDateTime,
      onConfirm: (dateTime) {
        setState(() {
          _selectedDateTime = dateTime;
        });
      },
      placeholder: '请选择时间',
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(color: Colors.blue),
      height: 48,
    );
  }
}

// 初始值设置的弹出式选择器演示
class _InitialValuePopupDemo extends StatefulWidget {
  @override
  State<_InitialValuePopupDemo> createState() => _InitialValuePopupDemoState();
}

class _InitialValuePopupDemoState extends State<_InitialValuePopupDemo> {
  DateTime? _selectedDateTime;
  DateTime? _startDateTime;
  DateTime? _endDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyPopupSingleDateTimePicker(
          initialDateTime: _selectedDateTime,
          onConfirm: (dateTime) {
            setState(() {
              _selectedDateTime = dateTime;
            });
          },
          placeholder: '请选择时间',
        ),
        const SizedBox(height: 16),
        EasyPopupRangeDateTimePicker(
          initialStartDateTime: _startDateTime,
          initialEndDateTime: _endDateTime,
          onConfirm: (start, end) {
            setState(() {
              _startDateTime = start;
              _endDateTime = end;
            });
          },
          placeholder: '请选择时间范围',
        ),
      ],
    );
  }
}

// 表单中使用弹出式选择器演示
class _FormPopupPickerDemo extends StatefulWidget {
  @override
  State<_FormPopupPickerDemo> createState() => _FormPopupPickerDemoState();
}

class _FormPopupPickerDemoState extends State<_FormPopupPickerDemo> {
  DateTime? _appointmentTime;
  DateTime? _meetingStartTime;
  DateTime? _meetingEndTime;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('预约时间:', style: TextStyle(fontSize: 16)),
          EasyPopupSingleDateTimePicker(
            initialDateTime: _appointmentTime,
            onConfirm: (dateTime) {
              setState(() {
                _appointmentTime = dateTime;
              });
            },
            placeholder: '请选择预约时间',
          ),
          const SizedBox(height: 16),
          const Text('会议时间范围:', style: TextStyle(fontSize: 16)),
          EasyPopupRangeDateTimePicker(
            initialStartDateTime: _meetingStartTime,
            initialEndDateTime: _meetingEndTime,
            onConfirm: (start, end) {
              setState(() {
                _meetingStartTime = start;
                _meetingEndTime = end;
              });
            },
            placeholder: '请选择会议时间',
          ),
          const SizedBox(height: 16),
          if (_appointmentTime != null)
            Text('预约时间: ${_appointmentTime!.toLocal()}'),
          if (_meetingStartTime != null && _meetingEndTime != null)
            Text(
              '会议时间: ${_meetingStartTime!.toLocal()} 到 ${_meetingEndTime!.toLocal()}',
            ),
        ],
      ),
    );
  }
}
