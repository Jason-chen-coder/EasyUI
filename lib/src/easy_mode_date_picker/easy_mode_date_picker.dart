import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;

import '../../easy_ui.dart';

class EasyModeDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTimeRange? initialDateRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ModeDatePicker initialMode;
  final Function(DatePickerResult)? onDateSelected;
  final int firstDayOfWeek; // 1=周一, 7=周日

  const EasyModeDatePicker({
    super.key,
    this.initialDate,
    this.initialDateRange,
    this.firstDate,
    this.lastDate,
    this.initialMode = ModeDatePicker.day,
    this.onDateSelected,
    this.firstDayOfWeek = 1,
  });

  @override
  State<EasyModeDatePicker> createState() => _EasyModeDatePickerState();
}

class _EasyModeDatePickerState extends State<EasyModeDatePicker> {
  late DateTime _currentDate;
  late ModeDatePicker _currentMode;
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _selectedDate;
  int? _selectedYear;
  int? _selectedMonth;

  // 视图类型
  ViewType _currentView = ViewType.day;

  // 年份选择相关
  int _decadeStart = 2025;

  // 用于强制刷新 Popover 内容
  final ValueNotifier<int> _overlayTick = ValueNotifier<int>(0);

  // 常量：弹出层尺寸、位置与输入框宽度
  // 日期范围显示区域（输入框）的固定宽度
  static const double _kDateRangeDisplayWidth = 290.0;

  // 弹出层宽度（单月/双月）
  static const double _kPopoverWidthZh = 290.0; // 中文环境：单月视图宽度
  static const double _kPopoverWidthEn = 400.0; // 非中文环境（英文等）：单月视图宽度
  static const double _kPopoverWidthCustom = 540.0; // 自定义模式（双月视图）宽度，语言通用

  // 弹出层水平偏移（确保 Popover 与输入框视觉对齐）
  static const double _kPopoverOffsetXZhCustom = 15.0; // 中文 + 自定义模式
  static const double _kPopoverOffsetXZh = 112.0; // 中文 + 非自定义模式（单月/周/日/年）
  static const double _kPopoverOffsetXEnCustom = 40.0; // 非中文 + 自定义模式
  static const double _kPopoverOffsetXEn = 170.0; // 非中文 + 非自定义模式（单月/周/日/年）

  @override
  void initState() {
    super.initState();
    _currentMode = widget.initialMode;

    // 优先使用 initialDateRange，如果没有则使用 initialDate
    if (widget.initialDateRange != null) {
      // 使用 initialDateRange 初始化
      final range = widget.initialDateRange!;
      DateTime start = range.start;
      DateTime end = range.end;

      // 确保日期在允许的范围内
      if (widget.firstDate != null && start.isBefore(widget.firstDate!)) {
        start = widget.firstDate!;
      }
      if (widget.lastDate != null && end.isAfter(widget.lastDate!)) {
        end = widget.lastDate!;
      }

      // 根据模式设置初始状态
      switch (_currentMode) {
        case ModeDatePicker.day:
          _selectedDate = start;
          _currentDate = start;
          break;
        case ModeDatePicker.week:
          final weekRange = _getWeekRange(start);
          _startDate = weekRange.start;
          _endDate = weekRange.end;
          _currentDate = start;
          break;
        case ModeDatePicker.month:
          _selectedMonth = start.month;
          _currentDate = start;
          break;
        case ModeDatePicker.year:
          _selectedYear = start.year;
          _currentDate = start;
          break;
        case ModeDatePicker.custom:
          _startDate = start;
          _endDate = end;
          _currentDate = start;
          break;
      }
    } else if (widget.initialDate != null) {
      // 使用 initialDate 初始化
      DateTime initial = widget.initialDate!;

      // 确保 initialDate 在允许的范围内
      if (widget.firstDate != null && initial.isBefore(widget.firstDate!)) {
        initial = widget.firstDate!;
      }
      if (widget.lastDate != null && initial.isAfter(widget.lastDate!)) {
        initial = widget.lastDate!;
      }

      _currentDate = initial;

      // 根据模式设置初始状态
      switch (_currentMode) {
        case ModeDatePicker.day:
          _selectedDate = initial;
          break;
        case ModeDatePicker.week:
          final weekRange = _getWeekRange(initial);
          _startDate = weekRange.start;
          _endDate = weekRange.end;
          break;
        case ModeDatePicker.month:
          _selectedMonth = initial.month;
          break;
        case ModeDatePicker.year:
          _selectedYear = initial.year;
          break;
        case ModeDatePicker.custom:
          // 自定义模式需要范围，如果只有单个日期，则设置为同一天
          _startDate = initial;
          _endDate = initial;
          break;
      }
    } else {
      // 没有提供初始日期，使用当前日期
      _currentDate = DateTime.now();
    }

    // 设置年代视图的起始年份
    _decadeStart = (_currentDate.year ~/ 10) * 10;
  }

  @override
  void didUpdateWidget(EasyModeDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 检查 initialMode 是否改变
    if (oldWidget.initialMode != widget.initialMode) {
      _currentMode = widget.initialMode;

      // 根据模式调整视图
      if (_currentMode == ModeDatePicker.year) {
        _currentView = ViewType.decade;
      } else if (_currentMode == ModeDatePicker.month) {
        _currentView = ViewType.month;
      } else {
        _currentView = ViewType.day;
      }

      // 根据当前的 initialDate 或 initialDateRange 重新初始化状态
      if (widget.initialDateRange != null) {
        final range = widget.initialDateRange!;
        DateTime start = range.start;
        DateTime end = range.end;

        // 确保日期在允许的范围内
        if (widget.firstDate != null && start.isBefore(widget.firstDate!)) {
          start = widget.firstDate!;
        }
        if (widget.lastDate != null && end.isAfter(widget.lastDate!)) {
          end = widget.lastDate!;
        }

        // 根据新模式设置状态
        switch (_currentMode) {
          case ModeDatePicker.day:
            _selectedDate = start;
            _currentDate = start;
            _startDate = null;
            _endDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.week:
            final weekRange = _getWeekRange(start);
            _startDate = weekRange.start;
            _endDate = weekRange.end;
            _currentDate = start;
            _selectedDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.month:
            _selectedMonth = start.month;
            _currentDate = start;
            _startDate = null;
            _endDate = null;
            _selectedDate = null;
            _selectedYear = null;
            break;
          case ModeDatePicker.year:
            _selectedYear = start.year;
            _currentDate = start;
            _startDate = null;
            _endDate = null;
            _selectedDate = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.custom:
            _startDate = start;
            _endDate = end;
            _currentDate = start;
            _selectedDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
        }
      } else if (widget.initialDate != null) {
        // 使用 initialDate 重新初始化
        DateTime initial = widget.initialDate!;

        if (widget.firstDate != null && initial.isBefore(widget.firstDate!)) {
          initial = widget.firstDate!;
        }
        if (widget.lastDate != null && initial.isAfter(widget.lastDate!)) {
          initial = widget.lastDate!;
        }

        _currentDate = initial;

        // 根据新模式设置状态
        switch (_currentMode) {
          case ModeDatePicker.day:
            _selectedDate = initial;
            _startDate = null;
            _endDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.week:
            final weekRange = _getWeekRange(initial);
            _startDate = weekRange.start;
            _endDate = weekRange.end;
            _selectedDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.month:
            _selectedMonth = initial.month;
            _startDate = null;
            _endDate = null;
            _selectedDate = null;
            _selectedYear = null;
            break;
          case ModeDatePicker.year:
            _selectedYear = initial.year;
            _startDate = null;
            _endDate = null;
            _selectedDate = null;
            _selectedMonth = null;
            break;
          case ModeDatePicker.custom:
            _startDate = initial;
            _endDate = initial;
            _selectedDate = null;
            _selectedYear = null;
            _selectedMonth = null;
            break;
        }
      } else {
        // 没有初始日期，重置所有状态
        _startDate = null;
        _endDate = null;
        _selectedDate = null;
        _selectedYear = null;
        _selectedMonth = null;
      }
    }

    // 检查 initialDateRange 是否改变
    if (oldWidget.initialDateRange != widget.initialDateRange) {
      if (widget.initialDateRange != null) {
        final range = widget.initialDateRange!;
        DateTime start = range.start;
        DateTime end = range.end;

        // 确保日期在允许的范围内
        if (widget.firstDate != null && start.isBefore(widget.firstDate!)) {
          start = widget.firstDate!;
        }
        if (widget.lastDate != null && end.isAfter(widget.lastDate!)) {
          end = widget.lastDate!;
        }

        // 根据模式设置状态
        switch (_currentMode) {
          case ModeDatePicker.day:
            _selectedDate = start;
            _currentDate = start;
            break;
          case ModeDatePicker.week:
            final weekRange = _getWeekRange(start);
            _startDate = weekRange.start;
            _endDate = weekRange.end;
            _currentDate = start;
            break;
          case ModeDatePicker.month:
            _selectedMonth = start.month;
            _currentDate = start;
            break;
          case ModeDatePicker.year:
            _selectedYear = start.year;
            _currentDate = start;
            break;
          case ModeDatePicker.custom:
            _startDate = start;
            _endDate = end;
            _currentDate = start;
            break;
        }
      } else if (widget.initialDate != null) {
        // 如果 initialDateRange 变为 null，但 initialDate 存在，使用 initialDate
        DateTime initial = widget.initialDate!;

        if (widget.firstDate != null && initial.isBefore(widget.firstDate!)) {
          initial = widget.firstDate!;
        }
        if (widget.lastDate != null && initial.isAfter(widget.lastDate!)) {
          initial = widget.lastDate!;
        }

        _currentDate = initial;

        switch (_currentMode) {
          case ModeDatePicker.day:
            _selectedDate = initial;
            break;
          case ModeDatePicker.week:
            final weekRange = _getWeekRange(initial);
            _startDate = weekRange.start;
            _endDate = weekRange.end;
            break;
          case ModeDatePicker.month:
            _selectedMonth = initial.month;
            break;
          case ModeDatePicker.year:
            _selectedYear = initial.year;
            break;
          case ModeDatePicker.custom:
            _startDate = initial;
            _endDate = initial;
            break;
        }
      }
    }
    // 检查 initialDate 是否改变（仅在 initialDateRange 为 null 时）
    else if (oldWidget.initialDate != widget.initialDate &&
        widget.initialDateRange == null) {
      if (widget.initialDate != null) {
        DateTime initial = widget.initialDate!;

        if (widget.firstDate != null && initial.isBefore(widget.firstDate!)) {
          initial = widget.firstDate!;
        }
        if (widget.lastDate != null && initial.isAfter(widget.lastDate!)) {
          initial = widget.lastDate!;
        }

        _currentDate = initial;

        switch (_currentMode) {
          case ModeDatePicker.day:
            _selectedDate = initial;
            break;
          case ModeDatePicker.week:
            final weekRange = _getWeekRange(initial);
            _startDate = weekRange.start;
            _endDate = weekRange.end;
            break;
          case ModeDatePicker.month:
            _selectedMonth = initial.month;
            break;
          case ModeDatePicker.year:
            _selectedYear = initial.year;
            break;
          case ModeDatePicker.custom:
            _startDate = initial;
            _endDate = initial;
            break;
        }
      }
    }

    // 更新年代视图的起始年份
    _decadeStart = (_currentDate.year ~/ 10) * 10;
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
    _overlayTick.value = _overlayTick.value + 1;
  }

  @override
  void dispose() {
    _overlayTick.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 模式选择标签
        _buildModeTabs(),
        // 日期范围显示
        SizedBox(
          width: _kDateRangeDisplayWidth,
          height: 40,
          child: _buildDateRangeDisplay(),
        ),
      ],
    );
  }

  // 获取月份的天数
  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  // 获取月份第一天是星期几
  int _getFirstWeekdayOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    int weekday = firstDay.weekday;

    // 调整为配置的起始星期
    if (widget.firstDayOfWeek == 7) {
      return weekday == 7 ? 0 : weekday;
    } else {
      return weekday - 1;
    }
  }

  // 检查日期是否在允许的范围内（只比较日期部分，忽略时间）
  bool _isDateInRange(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (widget.firstDate != null) {
      final firstDateOnly = DateTime(
        widget.firstDate!.year,
        widget.firstDate!.month,
        widget.firstDate!.day,
      );
      if (dateOnly.isBefore(firstDateOnly)) {
        return false;
      }
    }
    if (widget.lastDate != null) {
      final lastDateOnly = DateTime(
        widget.lastDate!.year,
        widget.lastDate!.month,
        widget.lastDate!.day,
      );
      if (dateOnly.isAfter(lastDateOnly)) {
        return false;
      }
    }
    return true;
  }

  bool _canConfirm() {
    switch (_currentMode) {
      case ModeDatePicker.custom:
        return _startDate != null && _endDate != null;
      case ModeDatePicker.week:
        return _startDate != null; // week selection uses _startDate as anchor
      case ModeDatePicker.day:
        return _selectedDate != null;
      case ModeDatePicker.year:
        return _selectedYear != null;
      case ModeDatePicker.month:
        return _selectedMonth != null;
    }
  }

  // 获取某日期所在周的起止日期
  DateTimeRange _getWeekRange(DateTime date) {
    // 根据配置的起始日期计算周范围
    final int weekday = date.weekday; // 1=周一, 7=周日

    // 计算距离一周开始还有几天
    final int daysFromWeekStart;
    if (widget.firstDayOfWeek == 7) {
      // 周日为一周的开始
      daysFromWeekStart = weekday == 7 ? 0 : weekday;
    } else {
      // 周一为一周的开始（firstDayOfWeek == 1）
      daysFromWeekStart = weekday == 1 ? 0 : (weekday - 1);
    }

    final DateTime start = DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromWeekStart));
    final DateTime end = start.add(const Duration(days: 6));
    return DateTimeRange(start: start, end: end);
  }

  // 处理日期选择
  void _handleDateSelection(DateTime date) {
    // 检查日期是否在允许的范围内
    if (!_isDateInRange(date)) {
      return;
    }

    switch (_currentMode) {
      case ModeDatePicker.day:
        if (_isDateInRange(date)) {
          _selectedDate = date;
          _confirmSelection(context);
        }
        break;
      case ModeDatePicker.week:
        final range = _getWeekRange(date);
        // 检查周范围是否在允许的范围内
        if (_isDateInRange(range.start) && _isDateInRange(range.end)) {
          _startDate = range.start;
          _endDate = range.end;
        }
        break;
      case ModeDatePicker.month:
        // 月份模式在月份视图中选择
        break;
      case ModeDatePicker.year:
        // 年份模式在年份视图中选择
        break;
      case ModeDatePicker.custom:
        if (_startDate == null || (_startDate != null && _endDate != null)) {
          if (_isDateInRange(date)) {
            _startDate = date;
            _endDate = null;
          }
        } else {
          if (date.isBefore(_startDate!)) {
            if (_isDateInRange(date)) {
              _endDate = _startDate;
              _startDate = date;
            }
          } else {
            if (_isDateInRange(date)) {
              _endDate = date;
            }
          }
        }
        break;
    }
    setState(() {});
  }

  // 确认选择
  void _confirmSelection(BuildContext context) {
    DatePickerResult? result;
    shadcn.closeOverlay(context);
    switch (_currentMode) {
      case ModeDatePicker.day:
        if (_selectedDate != null) {
          result = DatePickerResult(
            startDate: _selectedDate!,
            endDate: _selectedDate!,
            mode: _currentMode,
          );
        }
        break;
      case ModeDatePicker.week:
        if (_startDate != null && _endDate != null) {
          result = DatePickerResult(
            startDate: _startDate!,
            endDate: _endDate!,
            mode: _currentMode,
          );
        }
        break;
      case ModeDatePicker.month:
        if (_selectedMonth != null) {
          final start = DateTime(_currentDate.year, _selectedMonth!, 1);
          final end = DateTime(_currentDate.year, _selectedMonth! + 1, 0);
          result = DatePickerResult(
            startDate: start,
            endDate: end,
            mode: _currentMode,
          );
        }
        break;
      case ModeDatePicker.year:
        if (_selectedYear != null) {
          final start = DateTime(_selectedYear!, 1, 1);
          final end = DateTime(_selectedYear!, 12, 31);
          result = DatePickerResult(
            startDate: start,
            endDate: end,
            mode: _currentMode,
          );
        }
        break;
      case ModeDatePicker.custom:
        if (_startDate != null && _endDate != null) {
          result = DatePickerResult(
            startDate: _startDate!,
            endDate: _endDate!,
            mode: _currentMode,
          );
        }
        break;
    }
    if (result != null) {
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(result);
      }
    }
  }

  // 构建年代选择视图
  Widget _buildDecadeView() {
    final l10n = EasyUiLocalizations.of(context);
    return Column(
      children: [
        // 年代范围标题 + 切换按钮
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _decadeStart -= 10;
                  });
                },
              ),
              Text(
                '${l10n.years(_decadeStart)}-${l10n.years(_decadeStart + 9)}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _decadeStart += 10;
                  });
                },
              ),
            ],
          ),
        ),
        // 年份网格（首尾为上一/下一年的占位用于跳转）
        GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            if (index == 0) {
              // 上一个十年的过渡年（灰）
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _decadeStart -= 10;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_decadeStart - 1}',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              );
            } else if (index == 11) {
              // 下一个十年的过渡年（灰）
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _decadeStart += 10;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${_decadeStart + 10}',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              );
            } else {
              final year = _decadeStart + index - 1;
              // 检查年份是否在允许范围内
              final bool isYearValid =
                  (widget.firstDate == null ||
                      year >= widget.firstDate!.year) &&
                  (widget.lastDate == null || year <= widget.lastDate!.year);
              final bool isSelected =
                  _currentMode == ModeDatePicker.year
                      ? (_selectedYear != null && _selectedYear == year)
                      : (_currentDate.year == year);
              final theme = Theme.of(context);
              return GestureDetector(
                onTap:
                    isYearValid
                        ? () {
                          setState(() {
                            if (_currentMode == ModeDatePicker.year) {
                              _selectedYear = year;
                              _currentDate = DateTime(year, 1, 1);
                            } else {
                              _currentDate = DateTime(
                                year,
                                _currentDate.month,
                                _currentDate.day,
                              );
                              _currentView = ViewType.month;
                            }
                          });
                        }
                        : null,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primaryColor : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '$year',
                    style: TextStyle(
                      color:
                          isYearValid
                              ? (isSelected
                                  ? EasyTheme.of(context).background
                                  : EasyTheme.of(
                                    context,
                                  ).onBackground.withValues(alpha: 0.87))
                              : Colors.grey.shade300,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  // 构建月份选择视图
  Widget _buildMonthView() {
    final l10n = EasyUiLocalizations.of(context);
    final months = List.generate(12, (index) {
      final month = index + 1;
      return l10n.months(month);
    });

    return Column(
      children: [
        // 年份标题
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _currentDate = DateTime(
                      _currentDate.year - 1,
                      _currentDate.month,
                      1,
                    );
                  });
                },
              ),
              Text(
                l10n.years(_currentDate.year),
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _currentDate = DateTime(
                      _currentDate.year + 1,
                      _currentDate.month,
                      1,
                    );
                  });
                },
              ),
            ],
          ),
        ),
        // 月份网格
        GridView.builder(
          padding: const EdgeInsets.all(16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            final month = index + 1;
            final monthDate = DateTime(_currentDate.year, month, 1);
            final monthEnd = DateTime(_currentDate.year, month + 1, 0);
            // 检查月份是否在允许范围内
            final bool isMonthValid =
                (widget.firstDate == null ||
                    !monthEnd.isBefore(widget.firstDate!)) &&
                (widget.lastDate == null ||
                    !monthDate.isAfter(widget.lastDate!));
            final isSelected =
                _currentMode == ModeDatePicker.month
                    ? (_selectedMonth != null && _selectedMonth == month)
                    : (_currentDate.month == month);
            final theme = Theme.of(context);

            return GestureDetector(
              onTap:
                  isMonthValid
                      ? () {
                        setState(() {
                          if (_currentMode == ModeDatePicker.month) {
                            _selectedMonth = month;
                          } else {
                            _currentDate = DateTime(
                              _currentDate.year,
                              month,
                              1,
                            );
                            _currentView = ViewType.day;
                          }
                        });
                      }
                      : null,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? theme.primaryColor : null,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  months[index],
                  style: TextStyle(
                    color:
                        isMonthValid
                            ? (isSelected
                                ? EasyTheme.of(context).background
                                : EasyTheme.of(
                                  context,
                                ).onBackground.withValues(alpha: 0.87))
                            : Colors.grey.shade300,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 构建日历视图
  Widget _buildCalendarView() {
    final daysInMonth = _getDaysInMonth(_currentDate);
    final firstWeekday = _getFirstWeekdayOfMonth(_currentDate);
    final l10n = EasyUiLocalizations.of(context);
    final weekDays =
        widget.firstDayOfWeek == 7
            ? [
              l10n.weekSun,
              l10n.weekMon,
              l10n.weekTue,
              l10n.weekWed,
              l10n.weekThu,
              l10n.weekFri,
              l10n.weekSat,
            ]
            : [
              l10n.weekMon,
              l10n.weekTue,
              l10n.weekWed,
              l10n.weekThu,
              l10n.weekFri,
              l10n.weekSat,
              l10n.weekSun,
            ];
    final bool showTodayText = _isChineseLocale(context);

    return Column(
      children: [
        // 月份年份导航
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_currentMode == ModeDatePicker.week)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    icon: const Icon(Icons.keyboard_double_arrow_left),
                    iconSize: 18,
                    onPressed: () {
                      final prevYear = DateTime(
                        _currentDate.year - 1,
                        _currentDate.month,
                        1,
                      );
                      if (widget.firstDate == null ||
                          !prevYear.isBefore(
                            DateTime(
                              widget.firstDate!.year,
                              widget.firstDate!.month,
                              1,
                            ),
                          )) {
                        setState(() {
                          _currentDate = prevYear;
                        });
                      }
                    },
                  ),
                ),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left),
                  iconSize: 18,
                  onPressed: () {
                    final prevMonth = DateTime(
                      _currentDate.year,
                      _currentDate.month - 1,
                      1,
                    );
                    if (widget.firstDate == null ||
                        !prevMonth.isBefore(
                          DateTime(
                            widget.firstDate!.year,
                            widget.firstDate!.month,
                            1,
                          ),
                        )) {
                      setState(() {
                        _currentDate = prevMonth;
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentView = ViewType.month;
                        });
                      },
                      child: Text(
                        '${l10n.years(_currentDate.year)} ${l10n.months(_currentDate.month)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final now = DateTime.now();
                        final nowDateOnly = DateTime(
                          now.year,
                          now.month,
                          now.day,
                        );
                        // 检查今天是否在允许的范围内
                        if (!_isDateInRange(nowDateOnly)) {
                          return;
                        }
                        setState(() {
                          _currentDate = DateTime(now.year, now.month, 1);
                          switch (_currentMode) {
                            case ModeDatePicker.day:
                              _selectedDate = DateTime(
                                now.year,
                                now.month,
                                now.day,
                              );
                              break;
                            case ModeDatePicker.week:
                              final range = _getWeekRange(now);
                              // 检查周范围是否在允许的范围内
                              if (_isDateInRange(range.start) &&
                                  _isDateInRange(range.end)) {
                                _startDate = range.start;
                                _endDate = range.end;
                              }
                              break;
                            case ModeDatePicker.month:
                              _selectedMonth = now.month;
                              break;
                            case ModeDatePicker.year:
                              _selectedYear = now.year;
                              break;
                            case ModeDatePicker.custom:
                              _startDate = DateTime(
                                now.year,
                                now.month,
                                now.day,
                              );
                              _endDate = DateTime(now.year, now.month, now.day);
                              break;
                          }
                        });
                        _confirmSelection(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF1484FC)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10n.todayShort,
                          style: const TextStyle(color: Color(0xFF1484FC)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 32,
                height: 32,
                child: IconButton(
                  iconSize: 18,
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    final nextMonth = DateTime(
                      _currentDate.year,
                      _currentDate.month + 1,
                      1,
                    );
                    if (widget.lastDate == null ||
                        !nextMonth.isAfter(
                          DateTime(
                            widget.lastDate!.year,
                            widget.lastDate!.month,
                            1,
                          ),
                        )) {
                      setState(() {
                        _currentDate = nextMonth;
                      });
                    }
                  },
                ),
              ),
              if (_currentMode == ModeDatePicker.week)
                SizedBox(
                  width: 32,
                  height: 32,
                  child: IconButton(
                    iconSize: 18,
                    icon: const Icon(Icons.keyboard_double_arrow_right),
                    onPressed: () {
                      final nextYear = DateTime(
                        _currentDate.year + 1,
                        _currentDate.month,
                        1,
                      );
                      if (widget.lastDate == null ||
                          !nextYear.isAfter(
                            DateTime(
                              widget.lastDate!.year,
                              widget.lastDate!.month,
                              1,
                            ),
                          )) {
                        setState(() {
                          _currentDate = nextYear;
                        });
                      }
                    },
                  ),
                ),
            ],
          ),
        ),
        // 星期标题
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                weekDays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 8),
        // 日期网格
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            // 计算实际日期
            final dayOffset = index - firstWeekday + 1;

            if (dayOffset < 1 || dayOffset > daysInMonth) {
              // 上个月或下个月的日期
              DateTime otherMonthDate;
              String displayDay;

              if (dayOffset < 1) {
                // 上个月
                final prevMonth = DateTime(
                  _currentDate.year,
                  _currentDate.month - 1,
                  1,
                );
                final prevMonthDays = _getDaysInMonth(prevMonth);
                displayDay = '${prevMonthDays + dayOffset}';
                otherMonthDate = DateTime(
                  prevMonth.year,
                  prevMonth.month,
                  prevMonthDays + dayOffset,
                );
              } else {
                // 下个月
                displayDay = '${dayOffset - daysInMonth}';
                otherMonthDate = DateTime(
                  _currentDate.year,
                  _currentDate.month + 1,
                  dayOffset - daysInMonth,
                );
              }

              // 也对跨月日期应用相同的选中/范围高亮逻辑
              final bool isToday =
                  otherMonthDate.year == DateTime.now().year &&
                  otherMonthDate.month == DateTime.now().month &&
                  otherMonthDate.day == DateTime.now().day;
              bool isSelected = false;
              bool isInRange = false;
              bool isRangeStart = false;
              bool isRangeEnd = false;

              if (_currentMode == ModeDatePicker.day && _selectedDate != null) {
                isSelected =
                    _selectedDate!.year == otherMonthDate.year &&
                    _selectedDate!.month == otherMonthDate.month &&
                    _selectedDate!.day == otherMonthDate.day;
              } else if (_currentMode == ModeDatePicker.week &&
                  _startDate != null &&
                  _endDate != null) {
                isInRange =
                    !otherMonthDate.isBefore(_startDate!) &&
                    !otherMonthDate.isAfter(_endDate!);
                isRangeStart =
                    otherMonthDate.year == _startDate!.year &&
                    otherMonthDate.month == _startDate!.month &&
                    otherMonthDate.day == _startDate!.day;
                isRangeEnd =
                    otherMonthDate.year == _endDate!.year &&
                    otherMonthDate.month == _endDate!.month &&
                    otherMonthDate.day == _endDate!.day;
              } else if (_currentMode == ModeDatePicker.custom) {
                if (_startDate != null && _endDate != null) {
                  isInRange =
                      !otherMonthDate.isBefore(_startDate!) &&
                      !otherMonthDate.isAfter(_endDate!);
                  isRangeStart =
                      otherMonthDate.year == _startDate!.year &&
                      otherMonthDate.month == _startDate!.month &&
                      otherMonthDate.day == _startDate!.day;
                  isRangeEnd =
                      otherMonthDate.year == _endDate!.year &&
                      otherMonthDate.month == _endDate!.month &&
                      otherMonthDate.day == _endDate!.day;
                } else if (_startDate != null) {
                  isSelected =
                      _startDate!.year == otherMonthDate.year &&
                      _startDate!.month == otherMonthDate.month &&
                      _startDate!.day == otherMonthDate.day;
                }
              }
              final bool isDisabled = !_isDateInRange(otherMonthDate);
              final theme = Theme.of(context);
              final bool shouldMerge =
                  (_currentMode == ModeDatePicker.week ||
                      _currentMode == ModeDatePicker.custom) &&
                  (isInRange || isRangeStart || isRangeEnd) &&
                  !isDisabled;
              final BorderRadius cellRadius =
                  shouldMerge
                      ? (isRangeStart && isRangeEnd
                          ? BorderRadius.circular(4)
                          : (isRangeStart
                              ? const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              )
                              : (isRangeEnd
                                  ? const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  )
                                  : BorderRadius.zero)))
                      : BorderRadius.circular(4);

              return GestureDetector(
                onTap:
                    isDisabled
                        ? null
                        : () => _handleDateSelection(otherMonthDate),
                child: Container(
                  margin:
                      shouldMerge ? EdgeInsets.zero : const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:
                        isDisabled
                            ? null
                            : (isSelected || isRangeStart || isRangeEnd
                                ? theme.primaryColor
                                : isInRange
                                ? theme.primaryColor.withOpacity(0.3)
                                : null),
                    borderRadius: cellRadius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isToday && showTodayText ? l10n.todayShort : displayDay,
                    style: TextStyle(
                      color:
                          isDisabled
                              ? Colors.grey.shade300
                              : (isSelected || isRangeStart || isRangeEnd)
                              ? EasyTheme.of(context).background
                              : (isToday
                                  ? const Color(0xFF1484FC)
                                  : (isInRange
                                      ? EasyTheme.of(
                                        context,
                                      ).onBackground.withValues(alpha: 0.87)
                                      : Colors.grey.shade400)),
                    ),
                  ),
                ),
              );
            }

            final date = DateTime(
              _currentDate.year,
              _currentDate.month,
              dayOffset,
            );
            final bool isToday =
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;
            bool isSelected = false;
            bool isInRange = false;
            bool isRangeStart = false;
            bool isRangeEnd = false;

            // 根据模式判断选中状态
            if (_currentMode == ModeDatePicker.day && _selectedDate != null) {
              isSelected =
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;
            } else if (_currentMode == ModeDatePicker.week &&
                _startDate != null &&
                _endDate != null) {
              isInRange =
                  !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
              isRangeStart =
                  date.year == _startDate!.year &&
                  date.month == _startDate!.month &&
                  date.day == _startDate!.day;
              isRangeEnd =
                  date.year == _endDate!.year &&
                  date.month == _endDate!.month &&
                  date.day == _endDate!.day;
            } else if (_currentMode == ModeDatePicker.custom) {
              if (_startDate != null && _endDate != null) {
                isInRange =
                    !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
                isRangeStart =
                    date.year == _startDate!.year &&
                    date.month == _startDate!.month &&
                    date.day == _startDate!.day;
                isRangeEnd =
                    date.year == _endDate!.year &&
                    date.month == _endDate!.month &&
                    date.day == _endDate!.day;
              } else if (_startDate != null) {
                isSelected =
                    _startDate!.year == date.year &&
                    _startDate!.month == date.month &&
                    _startDate!.day == date.day;
              }
            }
            final bool isDisabled = !_isDateInRange(date);
            final theme = Theme.of(context);
            final bool shouldMerge =
                (_currentMode == ModeDatePicker.week ||
                    _currentMode == ModeDatePicker.custom) &&
                (isInRange || isRangeStart || isRangeEnd) &&
                !isDisabled;
            final BorderRadius cellRadius =
                shouldMerge
                    ? (isRangeStart && isRangeEnd
                        ? BorderRadius.circular(4)
                        : (isRangeStart
                            ? const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            )
                            : (isRangeEnd
                                ? const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                )
                                : BorderRadius.zero)))
                    : BorderRadius.circular(4);

            return GestureDetector(
              onTap: isDisabled ? null : () => _handleDateSelection(date),
              child: Container(
                margin: shouldMerge ? EdgeInsets.zero : const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      isDisabled
                          ? null
                          : (isSelected || isRangeStart || isRangeEnd
                              ? theme.primaryColor
                              : isInRange
                              ? theme.primaryColor.withOpacity(0.3)
                              : null),
                  borderRadius: cellRadius,
                ),
                alignment: Alignment.center,
                child: Text(
                  isToday && showTodayText ? l10n.todayShort : '$dayOffset',
                  style: TextStyle(
                    color:
                        isDisabled
                            ? Colors.grey.shade300
                            : (isSelected || isRangeStart || isRangeEnd)
                            ? EasyTheme.of(context).background
                            : (isToday
                                ? const Color(0xFF1484FC)
                                : EasyTheme.of(
                                  context,
                                ).onBackground.withValues(alpha: 0.87)),
                    fontWeight:
                        isDisabled
                            ? FontWeight.normal
                            : (isSelected || isRangeStart || isRangeEnd
                                ? FontWeight.bold
                                : FontWeight.normal),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // 用于在双月视图中渲染单个月的星期标题与日期网格
  Widget _buildMonthGridFor(DateTime month) {
    final daysInMonth = _getDaysInMonth(month);
    final firstWeekday = _getFirstWeekdayOfMonth(month);
    final l10n = EasyUiLocalizations.of(context);
    final weekDays =
        widget.firstDayOfWeek == 7
            ? [
              l10n.weekSun,
              l10n.weekMon,
              l10n.weekTue,
              l10n.weekWed,
              l10n.weekThu,
              l10n.weekFri,
              l10n.weekSat,
            ]
            : [
              l10n.weekMon,
              l10n.weekTue,
              l10n.weekWed,
              l10n.weekThu,
              l10n.weekFri,
              l10n.weekSat,
              l10n.weekSun,
            ];
    final theme = Theme.of(context);
    final bool showTodayText = _isChineseLocale(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                weekDays
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayOffset = index - firstWeekday + 1;

            if (dayOffset < 1 || dayOffset > daysInMonth) {
              DateTime otherMonthDate;
              String displayDay;

              if (dayOffset < 1) {
                final prevMonth = DateTime(month.year, month.month - 1, 1);
                final prevMonthDays = _getDaysInMonth(prevMonth);
                displayDay = '${prevMonthDays + dayOffset}';
                otherMonthDate = DateTime(
                  prevMonth.year,
                  prevMonth.month,
                  prevMonthDays + dayOffset,
                );
              } else {
                displayDay = '${dayOffset - daysInMonth}';
                otherMonthDate = DateTime(
                  month.year,
                  month.month + 1,
                  dayOffset - daysInMonth,
                );
              }

              final bool isToday =
                  otherMonthDate.year == DateTime.now().year &&
                  otherMonthDate.month == DateTime.now().month &&
                  otherMonthDate.day == DateTime.now().day;
              bool isSelected = false;
              bool isInRange = false;
              bool isRangeStart = false;
              bool isRangeEnd = false;

              if (_currentMode == ModeDatePicker.day && _selectedDate != null) {
                isSelected =
                    _selectedDate!.year == otherMonthDate.year &&
                    _selectedDate!.month == otherMonthDate.month &&
                    _selectedDate!.day == otherMonthDate.day;
              } else if (_currentMode == ModeDatePicker.week &&
                  _startDate != null &&
                  _endDate != null) {
                isInRange =
                    !otherMonthDate.isBefore(_startDate!) &&
                    !otherMonthDate.isAfter(_endDate!);
                isRangeStart =
                    otherMonthDate.year == _startDate!.year &&
                    otherMonthDate.month == _startDate!.month &&
                    otherMonthDate.day == _startDate!.day;
                isRangeEnd =
                    otherMonthDate.year == _endDate!.year &&
                    otherMonthDate.month == _endDate!.month &&
                    otherMonthDate.day == _endDate!.day;
              } else if (_currentMode == ModeDatePicker.custom) {
                if (_startDate != null && _endDate != null) {
                  isInRange =
                      !otherMonthDate.isBefore(_startDate!) &&
                      !otherMonthDate.isAfter(_endDate!);
                  isRangeStart =
                      otherMonthDate.year == _startDate!.year &&
                      otherMonthDate.month == _startDate!.month &&
                      otherMonthDate.day == _startDate!.day;
                  isRangeEnd =
                      otherMonthDate.year == _endDate!.year &&
                      otherMonthDate.month == _endDate!.month &&
                      otherMonthDate.day == _endDate!.day;
                } else if (_startDate != null) {
                  isSelected =
                      _startDate!.year == otherMonthDate.year &&
                      _startDate!.month == otherMonthDate.month &&
                      _startDate!.day == otherMonthDate.day;
                }
              }

              final bool isDisabled = !_isDateInRange(otherMonthDate);
              final bool shouldMerge =
                  (_currentMode == ModeDatePicker.week ||
                      _currentMode == ModeDatePicker.custom) &&
                  (isInRange || isRangeStart || isRangeEnd) &&
                  !isDisabled;
              final BorderRadius cellRadius =
                  shouldMerge
                      ? (isRangeStart && isRangeEnd
                          ? BorderRadius.circular(4)
                          : (isRangeStart
                              ? const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                bottomLeft: Radius.circular(4),
                              )
                              : (isRangeEnd
                                  ? const BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  )
                                  : BorderRadius.zero)))
                      : BorderRadius.circular(4);

              return GestureDetector(
                onTap:
                    isDisabled
                        ? null
                        : () => _handleDateSelection(otherMonthDate),
                child: Container(
                  margin:
                      shouldMerge ? EdgeInsets.zero : const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color:
                        isDisabled
                            ? null
                            : (isSelected || isRangeStart || isRangeEnd
                                ? theme.primaryColor
                                : (isInRange
                                    ? theme.primaryColor.withOpacity(0.3)
                                    : null)),
                    borderRadius: cellRadius,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    isToday && showTodayText ? l10n.todayShort : displayDay,
                    style: TextStyle(
                      color:
                          isDisabled
                              ? Colors.grey.shade300
                              : (isSelected || isRangeStart || isRangeEnd)
                              ? EasyTheme.of(context).background
                              : (isToday
                                  ? const Color(0xFF1484FC)
                                  : (isInRange
                                      ? EasyTheme.of(
                                        context,
                                      ).onBackground.withValues(alpha: 0.87)
                                      : Colors.grey.shade400)),
                    ),
                  ),
                ),
              );
            }

            final date = DateTime(month.year, month.month, dayOffset);
            final bool isToday =
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;
            bool isSelected = false;
            bool isInRange = false;
            bool isRangeStart = false;
            bool isRangeEnd = false;

            if (_currentMode == ModeDatePicker.day && _selectedDate != null) {
              isSelected =
                  _selectedDate!.year == date.year &&
                  _selectedDate!.month == date.month &&
                  _selectedDate!.day == date.day;
            } else if (_currentMode == ModeDatePicker.week &&
                _startDate != null &&
                _endDate != null) {
              isInRange =
                  !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
              isRangeStart =
                  date.year == _startDate!.year &&
                  date.month == _startDate!.month &&
                  date.day == _startDate!.day;
              isRangeEnd =
                  date.year == _endDate!.year &&
                  date.month == _endDate!.month &&
                  date.day == _endDate!.day;
            } else if (_currentMode == ModeDatePicker.custom) {
              if (_startDate != null && _endDate != null) {
                isInRange =
                    !date.isBefore(_startDate!) && !date.isAfter(_endDate!);
                isRangeStart =
                    date.year == _startDate!.year &&
                    date.month == _startDate!.month &&
                    date.day == _startDate!.day;
                isRangeEnd =
                    date.year == _endDate!.year &&
                    date.month == _endDate!.month &&
                    date.day == _endDate!.day;
              } else if (_startDate != null) {
                isSelected =
                    _startDate!.year == date.year &&
                    _startDate!.month == date.month &&
                    _startDate!.day == date.day;
              }
            }

            final bool isDisabled = !_isDateInRange(date);
            final bool shouldMerge =
                (_currentMode == ModeDatePicker.week ||
                    _currentMode == ModeDatePicker.custom) &&
                (isInRange || isRangeStart || isRangeEnd) &&
                !isDisabled;
            final BorderRadius cellRadius =
                shouldMerge
                    ? (isRangeStart && isRangeEnd
                        ? BorderRadius.circular(4)
                        : (isRangeStart
                            ? const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            )
                            : (isRangeEnd
                                ? const BorderRadius.only(
                                  topRight: Radius.circular(4),
                                  bottomRight: Radius.circular(4),
                                )
                                : BorderRadius.zero)))
                    : BorderRadius.circular(4);

            return GestureDetector(
              onTap: isDisabled ? null : () => _handleDateSelection(date),
              child: Container(
                margin: shouldMerge ? EdgeInsets.zero : const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color:
                      isDisabled
                          ? null
                          : (isSelected || isRangeStart || isRangeEnd
                              ? theme.primaryColor
                              : (isInRange
                                  ? theme.primaryColor.withOpacity(0.3)
                                  : null)),
                  borderRadius: cellRadius,
                ),
                alignment: Alignment.center,
                child: Text(
                  isToday && showTodayText ? l10n.todayShort : '$dayOffset',
                  style: TextStyle(
                    color:
                        isDisabled
                            ? Colors.grey.shade300
                            : (isSelected || isRangeStart || isRangeEnd)
                            ? EasyTheme.of(context).background
                            : (isToday
                                ? const Color(0xFF1484FC)
                                : EasyTheme.of(
                                  context,
                                ).onBackground.withValues(alpha: 0.87)),
                    fontWeight:
                        isDisabled
                            ? FontWeight.normal
                            : (isSelected || isRangeStart || isRangeEnd
                                ? FontWeight.bold
                                : FontWeight.normal),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  //自定义模式下的双月视图（左右两个月份）
  Widget _buildDualCalendarView() {
    final leftMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final rightMonth = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    final l10n = EasyUiLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              // 顶部导航（左右翻月 + 居中的月份标题与“今”）
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.keyboard_double_arrow_left),
                        onPressed: () {
                          final prevYear = DateTime(
                            _currentDate.year - 1,
                            _currentDate.month,
                            1,
                          );
                          if (widget.firstDate == null ||
                              !prevYear.isBefore(
                                DateTime(
                                  widget.firstDate!.year,
                                  widget.firstDate!.month,
                                  1,
                                ),
                              )) {
                            setState(() {
                              _currentDate = prevYear;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          final prevMonth = DateTime(
                            _currentDate.year,
                            _currentDate.month - 1,
                            1,
                          );
                          if (widget.firstDate == null ||
                              !prevMonth.isBefore(
                                DateTime(
                                  widget.firstDate!.year,
                                  widget.firstDate!.month,
                                  1,
                                ),
                              )) {
                            setState(() {
                              _currentDate = prevMonth;
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        '${l10n.years(leftMonth.year)} ${l10n.months(leftMonth.month)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              _buildMonthGridFor(leftMonth),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // 顶部导航（左右翻月 + 居中的月份标题与“今”）
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        '${l10n.years(rightMonth.year)} ${l10n.months(rightMonth.month)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.chevron_right),
                        onPressed: () {
                          final nextMonth = DateTime(
                            _currentDate.year,
                            _currentDate.month + 1,
                            1,
                          );
                          if (widget.lastDate == null ||
                              !nextMonth.isAfter(
                                DateTime(
                                  widget.lastDate!.year,
                                  widget.lastDate!.month,
                                  1,
                                ),
                              )) {
                            setState(() {
                              _currentDate = nextMonth;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.keyboard_double_arrow_right),
                        onPressed: () {
                          final nextYear = DateTime(
                            _currentDate.year + 1,
                            _currentDate.month,
                            1,
                          );
                          if (widget.lastDate == null ||
                              !nextYear.isAfter(
                                DateTime(
                                  widget.lastDate!.year,
                                  widget.lastDate!.month,
                                  1,
                                ),
                              )) {
                            setState(() {
                              _currentDate = nextYear;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              _buildMonthGridFor(rightMonth),
            ],
          ),
        ),
      ],
    );
  }

  // 构建模式选择标签
  Widget _buildModeTabs() {
    final l10n = EasyUiLocalizations.of(context);
    final modes = [
      (l10n.modeDay, ModeDatePicker.day),
      (l10n.modeWeek, ModeDatePicker.week),
      (l10n.modeMonth, ModeDatePicker.month),
      (l10n.modeYear, ModeDatePicker.year),
      (l10n.modeCustom, ModeDatePicker.custom),
    ];
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: EasyTheme.of(context).neutralEE, width: 1),
        ),
        child: Row(
          children:
              modes.asMap().entries.map((entry) {
                final index = entry.key;
                final mode = entry.value;
                final isSelected = _currentMode == mode.$2;
                final bool isFirst = index == 0;
                final bool isLast = index == modes.length - 1;
                final BorderRadius segmentRadius = BorderRadius.only(
                  topLeft: Radius.circular(isSelected && isFirst ? 4 : 0),
                  bottomLeft: Radius.circular(isSelected && isFirst ? 4 : 0),
                  topRight: Radius.circular(isSelected && isLast ? 4 : 0),
                  bottomRight: Radius.circular(isSelected && isLast ? 4 : 0),
                );
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right:
                          isLast
                              ? const BorderSide(
                                color: Colors.transparent,
                                width: 0,
                              )
                              : BorderSide(
                                color: EasyTheme.of(context).neutralEE,
                                width: 1,
                              ),
                    ),
                  ),
                  child: Material(
                    color:
                        isSelected
                            ? theme.primaryColor
                            : EasyTheme.of(context).background,
                    borderRadius: segmentRadius,
                    child: InkWell(
                      borderRadius: segmentRadius,
                      onTap: () {
                        setState(() {
                          _currentMode = mode.$2;

                          // 以当前日期作为默认选中基准
                          final now = DateTime.now();
                          final baseDate =
                              _isDateInRange(now) ? now : _currentDate;

                          switch (_currentMode) {
                            case ModeDatePicker.day:
                              _currentView = ViewType.day;
                              // 保留已有选中，否则默认选中当天
                              _selectedDate ??= DateTime(
                                baseDate.year,
                                baseDate.month,
                                baseDate.day,
                              );
                              _currentDate = _selectedDate!;
                              break;
                            case ModeDatePicker.week:
                              _currentView = ViewType.day;
                              if (_startDate == null || _endDate == null) {
                                final range = _getWeekRange(baseDate);
                                _startDate = range.start;
                                _endDate = range.end;
                                _currentDate = baseDate;
                              } else {
                                _currentDate = _startDate!;
                              }
                              break;
                            case ModeDatePicker.month:
                              _currentView = ViewType.month;
                              _selectedMonth ??= baseDate.month;
                              _currentDate = DateTime(
                                baseDate.year,
                                _selectedMonth!,
                                1,
                              );
                              break;
                            case ModeDatePicker.year:
                              _currentView = ViewType.decade;
                              _selectedYear ??= baseDate.year;
                              _currentDate = DateTime(_selectedYear!, 1, 1);
                              _decadeStart = (_currentDate.year ~/ 10) * 10;
                              break;
                            case ModeDatePicker.custom:
                              _currentView = ViewType.day;
                              if (_startDate == null && _endDate == null) {
                                final today = DateTime(
                                  baseDate.year,
                                  baseDate.month,
                                  baseDate.day,
                                );
                                _startDate = today;
                                _endDate = today;
                              }
                              _currentDate = _startDate ?? baseDate;
                              break;
                          }
                        });
                        // 切换模式后立即触发变更回调
                        _confirmSelection(context);
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.all(11),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            mode.$1,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? EasyTheme.of(context).background
                                      : EasyTheme.of(
                                        context,
                                      ).onBackground.withValues(alpha: 0.87),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // 构建日期范围显示
  Widget _buildDateRangeDisplay() {
    String displayText = '';
    bool showPlaceHolder = false;
    final l10n = EasyUiLocalizations.of(context);
    if (_currentMode == ModeDatePicker.custom && _startDate != null) {
      if (_endDate != null) {
        displayText =
            '${DateFormat('yyyy-MM-dd').format(_startDate!)} ${l10n.to} ${DateFormat('yyyy-MM-dd').format(_endDate!)}';
      } else {
        displayText = DateFormat('yyyy-MM-dd').format(_startDate!);
      }
    } else if (_currentMode == ModeDatePicker.week &&
        _startDate != null &&
        _endDate != null) {
      displayText =
          '${DateFormat('yyyy-MM-dd').format(_startDate!)} ${l10n.to} ${DateFormat('yyyy-MM-dd').format(_endDate!)}';
    } else if (_currentMode == ModeDatePicker.day && _selectedDate != null) {
      displayText = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    } else if (_currentMode == ModeDatePicker.month && _selectedMonth != null) {
      displayText = DateFormat(
        'yyyy-MM',
      ).format(DateTime(_currentDate.year, _selectedMonth!, 1));
    } else if (_currentMode == ModeDatePicker.year && _selectedYear != null) {
      displayText = '$_selectedYear';
    }

    if (displayText.isEmpty) {
      displayText = l10n.selectDate;
      showPlaceHolder = true;
    }

    return GestureDetector(
      onTap: () => _openDatePickerPopover(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: EasyTheme.of(context).neutralEE, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              displayText,
              style: TextStyle(
                fontSize: 14,
                color:
                    showPlaceHolder
                        ? EasyTheme.of(context).neutral99
                        : EasyTheme.of(context).neutral66,
              ),
            ),
            if (showPlaceHolder)
              SvgPicture.asset(
                'assets/svgs/ic_calendar.svg',
                package: 'easy_ui',
                width: 16,
                height: 16,
                color: EasyTheme.of(context).neutral99,
              ),
            if (!showPlaceHolder)
              EasyButton2(
                type: EasyButtonType.iconDefault,
                size: EasyButtonSize.small,
                style: EasyButtonStyle.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _startDate = null;
                    _endDate = null;
                    _selectedDate = null;
                    _selectedYear = null;
                    _selectedMonth = null;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  // 是否为中文环境
  bool _isChineseLocale(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode.toLowerCase().startsWith('zh');
  }

  // 根据当前语言环境自动计算 Popover 的水平偏移量
  double _computePopoverOffsetX(BuildContext context) {
    final isChinese = _isChineseLocale(context);
    final bool isCustom = _currentMode == ModeDatePicker.custom;
    return isChinese
        ? (isCustom ? _kPopoverOffsetXZhCustom : _kPopoverOffsetXZh)
        : (isCustom ? _kPopoverOffsetXEnCustom : _kPopoverOffsetXEn);
  }

  double _computePopoverWidth(BuildContext context) {
    final isChinese = _isChineseLocale(context);
    final bool isCustom = _currentMode == ModeDatePicker.custom;
    return isChinese
        ? (isCustom ? _kPopoverWidthCustom : _kPopoverWidthZh)
        : (isCustom ? _kPopoverWidthCustom : _kPopoverWidthEn);
  }

  void _openDatePickerPopover(BuildContext context) {
    final l10n = EasyUiLocalizations.of(context);
    // 根据语言环境自动设置 offsetX（中英适配）
    final double offsetX = _computePopoverOffsetX(context);
    shadcn.showPopover(
      handler: shadcn.PopoverOverlayHandler(),
      context: context,
      alignment: Alignment.topCenter,
      offset: Offset(offsetX, 5),
      overlayBarrier: shadcn.OverlayBarrier(
        borderRadius: BorderRadius.circular(8),
      ),
      builder: (BuildContext context) {
        return ValueListenableBuilder<int>(
          valueListenable: _overlayTick,
          builder: (context, _, __) {
            final theme = Theme.of(context);
            return Container(
              width: _computePopoverWidth(context),
              decoration: BoxDecoration(
                color: EasyTheme.of(context).background,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 主要内容区域
                  _currentView == ViewType.decade
                      ? _buildDecadeView()
                      : _currentView == ViewType.month
                      ? _buildMonthView()
                      : (_currentMode == ModeDatePicker.custom
                          ? _buildDualCalendarView()
                          : _buildCalendarView()),
                  // 操作按钮
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            // borderRadius
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size.fromHeight(38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: EasyTheme.of(context).neutralEE,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                                _selectedDate = null;
                                _selectedYear = null;
                                _selectedMonth = null;
                              });
                            },
                            child: Text(
                              l10n.clear,
                              style: TextStyle(
                                color: EasyTheme.of(context).neutral66,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                _canConfirm()
                                    ? () => _confirmSelection(context)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              minimumSize: Size.fromHeight(38),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              l10n.confirm,
                              style: TextStyle(
                                color: EasyTheme.of(context).background,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
