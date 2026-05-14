import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class DatePickerDemo extends StatelessWidget {
  const DatePickerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyModeDatePicker 多模式日期选择器'),

        // 基本介绍
        h2('组件概述'),
        p('EasyModeDatePicker 是一个功能强大的多模式日期选择器，支持日、周、月、年和自定义范围选择模式。'),

        // 基本用法
        h2('基本用法'),
        p('展示默认的日期选择器功能'),
        WidgetHighlight(
          builder: (_) => _BasicDatePickerDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyModeDatePicker(
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: \${_selectedRange!.start.toLocal()} - \${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
```
''',
        ),

        // 不同模式演示
        h2('选择模式'),
        p('支持日、周、月、年和自定义范围五种选择模式'),
        WidgetHighlight(
          builder: (_) => _ModeSelectionDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyModeDatePicker(
          initialMode: ModeDatePicker.custom,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期范围'
              : '已选择范围: \${_selectedRange!.start.toLocal()} - \${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
```
''',
        ),

        // 自定义范围选择
        h2('自定义范围选择'),
        p('在自定义模式下选择日期范围'),
        WidgetHighlight(
          builder: (_) => _CustomRangeDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyModeDatePicker(
          initialMode: ModeDatePicker.custom,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期范围'
              : '已选择范围: \${_selectedRange!.start.toLocal()} - \${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
```
''',
        ),

        // 初始日期设置
        h2('初始日期设置'),
        p('使用 initialDate 或 initialDateRange 设置日期选择器的初始显示日期。不同模式下的使用方式：'),
        p('• 日模式：使用 initialDate 设置单个初始日期'),
        p('• 周模式：使用 initialDateRange 设置初始周范围，或使用 initialDate 自动计算所在周'),
        p('• 月模式：使用 initialDate 设置初始月份'),
        p('• 年模式：使用 initialDate 设置初始年份'),
        p('• 自定义范围：使用 initialDateRange 设置初始日期范围'),
        WidgetHighlight(
          builder: (_) => _InitialDateDemo(),
          codeSnippet: '''
```dart
// 日模式
EasyModeDatePicker(
  initialMode: ModeDatePicker.day,
  initialDate: DateTime(2024, 6, 15),
  onDateSelected: (result) {
    // 处理选择结果
  },
)

// 周模式 - 使用 initialDateRange
EasyModeDatePicker(
  initialMode: ModeDatePicker.week,
  initialDateRange: DateTimeRange(
    start: DateTime(2024, 6, 3),  // 周一
    end: DateTime(2024, 6, 9),    // 周日
  ),
  onDateSelected: (result) {
    // 处理选择结果
  },
)

// 周模式 - 使用 initialDate（自动计算所在周）
EasyModeDatePicker(
  initialMode: ModeDatePicker.week,
  initialDate: DateTime(2024, 6, 5),  // 会自动计算所在周
  onDateSelected: (result) {
    // 处理选择结果
  },
)

// 月模式
EasyModeDatePicker(
  initialMode: ModeDatePicker.month,
  initialDate: DateTime(2024, 6, 15),  // 会选中6月
  onDateSelected: (result) {
    // 处理选择结果
  },
)

// 年模式
EasyModeDatePicker(
  initialMode: ModeDatePicker.year,
  initialDate: DateTime(2024, 6, 15),  // 会选中2024年
  onDateSelected: (result) {
    // 处理选择结果
  },
)
```
''',
        ),

        // 初始日期范围设置
        h2('初始日期范围设置'),
        p('使用 initialDateRange 设置日期选择器的初始日期范围（适用于需要范围选择的模式，如自定义范围、周模式等）'),
        WidgetHighlight(
          builder: (_) => _InitialDateRangeDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyModeDatePicker(
          initialMode: ModeDatePicker.custom,
          initialDateRange: DateTimeRange(
            start: DateTime(2024, 6, 1),
            end: DateTime(2024, 6, 15),
          ),
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期范围'
              : '已选择范围: \${_selectedRange!.start.toLocal()} - \${_selectedRange!.end.toLocal()}',
        ),
        const SizedBox(height: 8),
        const Text('初始日期范围: 2024-06-01 至 2024-06-15', style: TextStyle(color: Colors.grey)),
      ],
    );
```
''',
        ),

        // 日期限制
        h2('日期限制'),
        p('使用 firstDate 和 lastDate 限制用户可选择的日期范围：'),
        p('• firstDate: 可选的最早日期，早于此日期的日期将被禁用（灰色显示，不可点击）'),
        p('• lastDate: 可选的最晚日期，晚于此日期的日期将被禁用（灰色显示，不可点击）'),
        p('• 如果 initialDate 不在 firstDate/lastDate 范围内，会自动调整到边界值'),
        p('• 在年份、月份选择视图中，超出范围的年份/月份也会被禁用'),
        WidgetHighlight(
          builder: (_) => _DateLimitsDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyModeDatePicker(
          initialDate: DateTime.now().subtract(const Duration(days: 10)),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: \${_selectedRange!.start.toLocal()} - \${_selectedRange!.end.toLocal()}',
        ),
        const SizedBox(height: 8),
        const Text('限制选择范围: 今天前后30天，初始日期: 10天前', style: TextStyle(color: Colors.grey)),
      ],
    );
```
''',
        ),
        h2('DatePicker参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyModeDatePicker 参数说明：'),
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
                        DataCell(Text('onDateSelected')),
                        DataCell(Text('Function(DatePickerResult)')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('日期选择回调，返回开始和结束日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '初始显示的日期（适用于单日期模式），如果不在firstDate/lastDate范围内会自动调整',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialDateRange')),
                        DataCell(Text('DateTimeRange?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '初始日期范围（适用于需要范围选择的模式，如自定义范围、周模式等）。如果提供了initialDateRange，会优先使用它而不是initialDate',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialMode')),
                        DataCell(Text('ModeDatePicker')),
                        DataCell(Text('ModeDatePicker.day')),
                        DataCell(Text('否')),
                        DataCell(Text('初始选择模式：day/week/month/year/custom')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '可选的最早日期。早于此日期的日期会被禁用（灰色显示，不可点击）。如果initialDate早于firstDate，会自动调整为firstDate',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lastDate')),
                        DataCell(Text('DateTime?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '可选的最晚日期。晚于此日期的日期会被禁用（灰色显示，不可点击）。如果initialDate晚于lastDate，会自动调整为lastDate',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('firstDayOfWeek')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('一周的第一天(1=周一,7=周日)')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('DatePickerResult 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('startDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('选择的开始日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('endDate')),
                        DataCell(Text('DateTime')),
                        DataCell(Text('选择的结束日期')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('mode')),
                        DataCell(Text('ModeDatePicker')),
                        DataCell(Text('选择时的模式')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('ModeDatePicker 枚举说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('枚举值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [DataCell(Text('day')), DataCell(Text('日模式'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('week')), DataCell(Text('周模式'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('month')), DataCell(Text('月模式'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('year')), DataCell(Text('年模式'))],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('custom')),
                        DataCell(Text('自定义范围模式')),
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

// 基本用法演示
class _BasicDatePickerDemo extends StatefulWidget {
  @override
  State<_BasicDatePickerDemo> createState() => _BasicDatePickerDemoState();
}

class _BasicDatePickerDemoState extends State<_BasicDatePickerDemo> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyModeDatePicker(
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
  }
}

// 模式选择演示
class _ModeSelectionDemo extends StatefulWidget {
  @override
  State<_ModeSelectionDemo> createState() => _ModeSelectionDemoState();
}

class _ModeSelectionDemoState extends State<_ModeSelectionDemo> {
  ModeDatePicker _currentMode = ModeDatePicker.day;
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('日模式'),
              selected: _currentMode == ModeDatePicker.day,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.day),
            ),
            ChoiceChip(
              label: const Text('周模式'),
              selected: _currentMode == ModeDatePicker.week,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.week),
            ),
            ChoiceChip(
              label: const Text('月模式'),
              selected: _currentMode == ModeDatePicker.month,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.month),
            ),
            ChoiceChip(
              label: const Text('年模式'),
              selected: _currentMode == ModeDatePicker.year,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.year),
            ),
            ChoiceChip(
              label: const Text('自定义范围'),
              selected: _currentMode == ModeDatePicker.custom,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.custom),
            ),
          ],
        ),
        const SizedBox(height: 16),
        EasyModeDatePicker(
          initialMode: _currentMode,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
  }
}

// 自定义范围演示
class _CustomRangeDemo extends StatefulWidget {
  @override
  State<_CustomRangeDemo> createState() => _CustomRangeDemoState();
}

class _CustomRangeDemoState extends State<_CustomRangeDemo> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyModeDatePicker(
          initialMode: ModeDatePicker.custom,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期范围'
              : '已选择范围: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
      ],
    );
  }
}

// 初始日期演示
class _InitialDateDemo extends StatefulWidget {
  @override
  State<_InitialDateDemo> createState() => _InitialDateDemoState();
}

class _InitialDateDemoState extends State<_InitialDateDemo> {
  ModeDatePicker _currentMode = ModeDatePicker.day;
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('日模式'),
              selected: _currentMode == ModeDatePicker.day,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.day),
            ),
            ChoiceChip(
              label: const Text('周模式'),
              selected: _currentMode == ModeDatePicker.week,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.week),
            ),
            ChoiceChip(
              label: const Text('月模式'),
              selected: _currentMode == ModeDatePicker.month,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.month),
            ),
            ChoiceChip(
              label: const Text('年模式'),
              selected: _currentMode == ModeDatePicker.year,
              onSelected:
                  (_) => setState(() => _currentMode = ModeDatePicker.year),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDatePicker(),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
        const SizedBox(height: 8),
        _buildInitialDateInfo(),
      ],
    );
  }

  Widget _buildDatePicker() {
    final initialDate = DateTime(2024, 6, 15);

    switch (_currentMode) {
      case ModeDatePicker.week:
        // 周模式：使用 initialDate，组件会自动计算所在周
        return EasyModeDatePicker(
          initialMode: ModeDatePicker.week,
          initialDate: initialDate,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        );
      case ModeDatePicker.month:
        return EasyModeDatePicker(
          initialMode: ModeDatePicker.month,
          initialDate: initialDate,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        );
      case ModeDatePicker.year:
        return EasyModeDatePicker(
          initialMode: ModeDatePicker.year,
          initialDate: initialDate,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        );
      case ModeDatePicker.day:
      default:
        return EasyModeDatePicker(
          initialMode: ModeDatePicker.day,
          initialDate: initialDate,
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        );
    }
  }

  Widget _buildInitialDateInfo() {
    switch (_currentMode) {
      case ModeDatePicker.week:
        return const Text(
          '初始日期: 2024-06-15 (会自动计算所在周)',
          style: TextStyle(color: Colors.grey),
        );
      case ModeDatePicker.month:
        return const Text(
          '初始日期: 2024-06-15 (会选中6月)',
          style: TextStyle(color: Colors.grey),
        );
      case ModeDatePicker.year:
        return const Text(
          '初始日期: 2024-06-15 (会选中2024年)',
          style: TextStyle(color: Colors.grey),
        );
      case ModeDatePicker.day:
      default:
        return const Text(
          '初始日期: 2024-06-15',
          style: TextStyle(color: Colors.grey),
        );
    }
  }
}

// 初始日期范围演示
class _InitialDateRangeDemo extends StatefulWidget {
  @override
  State<_InitialDateRangeDemo> createState() => _InitialDateRangeDemoState();
}

class _InitialDateRangeDemoState extends State<_InitialDateRangeDemo> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyModeDatePicker(
          initialMode: ModeDatePicker.custom,
          initialDateRange: DateTimeRange(
            start: DateTime(2024, 6, 1),
            end: DateTime(2024, 6, 15),
          ),
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期范围'
              : '已选择范围: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
        const SizedBox(height: 8),
        const Text(
          '初始日期范围: 2024-06-01 至 2024-06-15',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

// 日期限制演示
class _DateLimitsDemo extends StatefulWidget {
  @override
  State<_DateLimitsDemo> createState() => _DateLimitsDemoState();
}

class _DateLimitsDemoState extends State<_DateLimitsDemo> {
  DateTimeRange? _selectedRange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyModeDatePicker(
          initialDate: DateTime.now().subtract(const Duration(days: 10)),
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          onDateSelected: (result) {
            setState(() {
              _selectedRange = DateTimeRange(
                start: result.startDate,
                end: result.endDate,
              );
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          _selectedRange == null
              ? '未选择日期'
              : '已选择: ${_selectedRange!.start.toLocal()} - ${_selectedRange!.end.toLocal()}',
        ),
        const SizedBox(height: 8),
        const Text(
          '限制选择范围: 今天前后30天，初始日期: 10天前',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
