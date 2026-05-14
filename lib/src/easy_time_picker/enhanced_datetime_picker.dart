import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// 选择器模式枚举
enum DateTimePickerMode {
  single, // 单独的日期时间选择（年月日时分秒）
  range, // 时间范围选择（年月日时分）
}

class TimeModel {
  int hour;
  int minute;
  int second;

  TimeModel({required this.hour, required this.minute, required this.second});

  String format(BuildContext context, {bool includeSeconds = true}) {
    if (includeSeconds) {
      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}:'
          '${second.toString().padLeft(2, '0')}';
    } else {
      return '${hour.toString().padLeft(2, '0')}:'
          '${minute.toString().padLeft(2, '0')}';
    }
  }
}

class EnhancedDateTimePicker extends StatefulWidget {
  final DateTimePickerMode mode;
  final void Function(DateTime startDateTime, DateTime endDateTime)? onConfirm;
  final void Function(DateTime dateTime)? onSingleConfirm;
  final DateTime? initialDateTime;
  final DateTime? initialStartDateTime;
  final DateTime? initialEndDateTime;

  /// 是否只选择日期，不选择时间
  final bool onlyPickDate;

  const EnhancedDateTimePicker({
    super.key,
    this.mode = DateTimePickerMode.range,
    this.onConfirm,
    this.onSingleConfirm,
    this.initialDateTime,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.onlyPickDate = false,
  });

  @override
  State<EnhancedDateTimePicker> createState() => _EnhancedDateTimePickerState();
}

class _EnhancedDateTimePickerState extends State<EnhancedDateTimePicker> {
  DateTime _currentMonth = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime? _singleDate; // 单独日期选择
  TimeModel? _startTime;
  TimeModel? _endTime;
  TimeModel? _singleTime; // 单独时间选择

  // 状态控制
  bool _showTimePicker = false;
  bool _isStartTimeSelection = true;

  @override
  void initState() {
    super.initState();

    // 初始化传入的日期值
    if (widget.mode == DateTimePickerMode.single) {
      if (widget.initialDateTime != null) {
        _singleDate = DateTime(
          widget.initialDateTime!.year,
          widget.initialDateTime!.month,
          widget.initialDateTime!.day,
        );
        _singleTime = TimeModel(
          hour: widget.initialDateTime!.hour,
          minute: widget.initialDateTime!.minute,
          second: widget.initialDateTime!.second,
        );
        _currentMonth = DateTime(
          widget.initialDateTime!.year,
          widget.initialDateTime!.month,
        );
      }
    } else {
      if (widget.initialStartDateTime != null) {
        _startDate = DateTime(
          widget.initialStartDateTime!.year,
          widget.initialStartDateTime!.month,
          widget.initialStartDateTime!.day,
        );
        _startTime = TimeModel(
          hour: widget.initialStartDateTime!.hour,
          minute: widget.initialStartDateTime!.minute,
          second: 0,
        );
        _currentMonth = DateTime(
          widget.initialStartDateTime!.year,
          widget.initialStartDateTime!.month,
        );
      }
      if (widget.initialEndDateTime != null) {
        _endDate = DateTime(
          widget.initialEndDateTime!.year,
          widget.initialEndDateTime!.month,
          widget.initialEndDateTime!.day,
        );
        _endTime = TimeModel(
          hour: widget.initialEndDateTime!.hour,
          minute: widget.initialEndDateTime!.minute,
          second: 0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = EasyUiLocalizations.of(context);
    return SizedBox(
      width: widget.mode == DateTimePickerMode.single ? 400 : 600,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateTimeDisplay(localizations),
          SizedBox(height: 10),
          _showTimePicker
              ? _buildTimeSelectionView(localizations)
              : Column(
                children: [
                  _buildMonthYearHeader(),
                  SizedBox(height: 10),
                  _buildCalendarView(localizations),
                ],
              ),
          _buildBottomButtons(localizations),
        ],
      ),
    );
  }

  Widget _buildTimeSelectionView(EasyUiLocalizations localizations) {
    if (widget.mode == DateTimePickerMode.single) {
      return Column(
        children: [
          Text(
            localizations.selectTime,
            style: TextStyle(fontSize: 14, color: Color(0xFF4F5159)),
          ),
          SizedBox(height: 10),
          _buildTimePicker(
            _singleTime,
            true,
            localizations,
            includeSeconds: true,
          ),
        ],
      );
    } else {
      return Row(
        children: [
          // 左侧开始时间
          Expanded(
            child: Column(
              children: [
                Text(
                  localizations.startTime,
                  style: TextStyle(fontSize: 14, color: Color(0xFF4F5159)),
                ),
                SizedBox(height: 10),
                _buildTimePicker(
                  _startTime,
                  true,
                  localizations,
                  includeSeconds: false,
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          // 右侧结束时间
          Expanded(
            child: Column(
              children: [
                Text(
                  localizations.endTime,
                  style: TextStyle(fontSize: 14, color: Color(0xFF4F5159)),
                ),
                SizedBox(height: 16),
                _buildTimePicker(
                  _endTime,
                  false,
                  localizations,
                  includeSeconds: false,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildTimePicker(
    TimeModel? time,
    bool isStart,
    EasyUiLocalizations localizations, {
    bool includeSeconds = false,
  }) {
    List<Widget> timeColumns = [
      Expanded(
        child: _buildTimePickerColumn(
          localizations.hour,
          List.generate(24, (index) => index.toString().padLeft(2, '0')),
          time?.hour ?? 0,
          (value) => _updateTime(isStart: isStart, hour: value),
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Text(':', style: TextStyle(fontSize: 20)),
      ),
      Expanded(
        child: _buildTimePickerColumn(
          localizations.minute,
          List.generate(60, (index) => index.toString().padLeft(2, '0')),
          time?.minute ?? 0,
          (value) => _updateTime(isStart: isStart, minute: value),
        ),
      ),
    ];

    if (includeSeconds) {
      timeColumns.addAll([
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(':', style: TextStyle(fontSize: 20)),
        ),
        Expanded(
          child: _buildTimePickerColumn(
            localizations.second,
            List.generate(60, (index) => index.toString().padLeft(2, '0')),
            time?.second ?? 0,
            (value) => _updateTime(isStart: isStart, second: value),
          ),
        ),
      ]);
    }

    return SizedBox(height: 200, child: Row(children: timeColumns));
  }

  void _updateTime({
    required bool isStart,
    int? hour,
    int? minute,
    int? second,
  }) {
    setState(() {
      if (widget.mode == DateTimePickerMode.single) {
        // 单独时间选择模式
        if (_singleTime == null) {
          _singleTime = TimeModel(
            hour: hour ?? 0,
            minute: minute ?? 0,
            second: second ?? 0,
          );
        } else {
          if (hour != null) _singleTime!.hour = hour;
          if (minute != null) _singleTime!.minute = minute;
          if (second != null) _singleTime!.second = second;
        }
      } else {
        // 范围选择模式
        if (isStart) {
          // 更新开始时间
          if (_startTime == null) {
            _startTime = TimeModel(
              hour: hour ?? 0,
              minute: minute ?? 0,
              second: second ?? 0,
            );
          } else {
            if (hour != null) _startTime!.hour = hour;
            if (minute != null) _startTime!.minute = minute;
            if (second != null) _startTime!.second = second;
          }

          // 如果结束时间存在，检查是否需要调整结束时间
          if (_endDate != null &&
              _startDate != null &&
              _startDate!.isAtSameMomentAs(_endDate!) &&
              _endTime != null) {
            // 如果在同一天，确保结束时间晚于开始时间
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

            if (endMinutes <= startMinutes) {
              // 自动调整结束时间为开始时间后一小时
              _endTime = TimeModel(
                hour: (_startTime!.hour + 1) % 24,
                minute: _startTime!.minute,
                second: 0,
              );
            }
          }
        } else {
          // 更新结束时间
          if (_endTime == null) {
            _endTime = TimeModel(
              hour: hour ?? 0,
              minute: minute ?? 0,
              second: second ?? 0,
            );
          } else {
            if (hour != null) _endTime!.hour = hour;
            if (minute != null) _endTime!.minute = minute;
            if (second != null) _endTime!.second = second;
          }

          // 如果开始时间存在，检查是否需要调整开始时间
          if (_startDate != null &&
              _endDate != null &&
              _startDate!.isAtSameMomentAs(_endDate!) &&
              _startTime != null) {
            // 如果在同一天，确保开始时间早于结束时间
            final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
            final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

            if (startMinutes >= endMinutes) {
              // 自动调整开始时间为结束时间前一小时
              _startTime = TimeModel(
                hour: (_endTime!.hour - 1 + 24) % 24,
                minute: _endTime!.minute,
                second: 0,
              );
            }
          }
        }
      }
    });
  }

  Widget _buildTimePickerColumn(
    String label,
    List<String> items,
    int selectedValue,
    ValueChanged<int> onChanged,
  ) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 30,
      physics: FixedExtentScrollPhysics(),
      onSelectedItemChanged: onChanged,
      controller: FixedExtentScrollController(initialItem: selectedValue),
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          if (index < 0 || index >= items.length) return null;
          return Container(
            height: 30,
            alignment: Alignment.center,
            child: Text(
              items[index],
              style: TextStyle(
                fontSize: 16,
                color:
                    index == selectedValue
                        ? Color(0xFF0052D9)
                        : EasyTheme.of(context).onBackground,
                fontWeight:
                    index == selectedValue
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }

  Widget _buildTimeBox(
    String label,
    String value, {
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: widget.mode == DateTimePickerMode.single ? 180 : 140,
        height: 34,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? Color(0xFF0052D9)
                    : EasyTheme.of(context).neutralF8,
          ),
          borderRadius: BorderRadius.circular(4),
          color: EasyTheme.of(context).neutralF8,
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: Color(0xFF8D8C8D)),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeDisplay(EasyUiLocalizations localizations) {
    if (widget.mode == DateTimePickerMode.single) {
      return Row(
        children: [
          Expanded(
            child: _buildTimeBox(
              localizations.selectDate,
              _singleDate != null
                  ? DateFormat('yyyy-MM-dd').format(_singleDate!)
                  : localizations.pleaseSelect,
              onTap: () {
                setState(() {
                  _showTimePicker = false;
                });
              },
              isSelected: _showTimePicker == false,
            ),
          ),
          if (!widget.onlyPickDate) ...[
            SizedBox(width: 8),
            Expanded(
              child: _buildTimeBox(
                localizations.selectTime,
                _singleTime != null
                    ? _singleTime!.format(context)
                    : localizations.pleaseSelect,
                onTap: () {
                  setState(() {
                    _showTimePicker = true;
                    _isStartTimeSelection = true;
                  });
                },
                isSelected: _showTimePicker,
              ),
            ),
          ],
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildTimeBox(
              localizations.startDate,
              _startDate != null
                  ? DateFormat('yyyy-MM-dd').format(_startDate!)
                  : localizations.pleaseSelect,
              onTap: () {
                setState(() {
                  _showTimePicker = false;
                });
              },
            ),
          ),
          if (!widget.onlyPickDate) ...[
            SizedBox(width: 8),
            Expanded(
              child: _buildTimeBox(
                localizations.startTime,
                _startTime != null
                    ? _startTime!.format(context, includeSeconds: false)
                    : localizations.pleaseSelect,
                onTap: () {
                  setState(() {
                    _showTimePicker = true;
                    _isStartTimeSelection = true;
                  });
                },
                isSelected: _showTimePicker && _isStartTimeSelection,
              ),
            ),
          ],
          SizedBox(width: 8),
          Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
            color: Color(0xFFC6C6CD),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildTimeBox(
              localizations.endDate,
              _endDate != null
                  ? DateFormat('yyyy-MM-dd').format(_endDate!)
                  : localizations.pleaseSelect,
              onTap: () {
                setState(() {
                  _showTimePicker = false;
                });
              },
            ),
          ),
          if (!widget.onlyPickDate) ...[
            SizedBox(width: 8),
            Expanded(
              child: _buildTimeBox(
                localizations.endTime,
                _endTime != null
                    ? _endTime!.format(context, includeSeconds: false)
                    : localizations.pleaseSelect,
                onTap: () {
                  setState(() {
                    _showTimePicker = true;
                    _isStartTimeSelection = false;
                  });
                },
                isSelected: _showTimePicker && !_isStartTimeSelection,
              ),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildCalendarGrid(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 2,
        crossAxisSpacing: 0,
        mainAxisExtent: 40,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) return Container();

        final dayNumber = index - firstWeekday + 2;
        if (dayNumber > daysInMonth) return Container();

        final date = DateTime(month.year, month.month, dayNumber);
        final isStartDate = _isStartDate(date);
        final isEndDate = _isEndDate(date);
        final isSingleDate = _isSingleDate(date);
        final isInRange = _isDateInRange(date);
        final isToday = _isToday(date);

        return Stack(
          children: [
            // 范围背景（仅在范围模式下显示）
            if (widget.mode == DateTimePickerMode.range && isInRange)
              Positioned.fill(
                child: Container(color: Color(0xFF0052D9).withOpacity(0.1)),
              ),
            // 选中日期的圆形背景
            if (isStartDate || isEndDate || isSingleDate)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0052D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            // 范围模式的连接背景
            if (widget.mode == DateTimePickerMode.range &&
                isStartDate &&
                _endDate != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0052D9).withOpacity(0.1),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            if (widget.mode == DateTimePickerMode.range && isEndDate)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF0052D9).withOpacity(0.1),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            // 日期内容
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayNumber.toString(),
                    style: TextStyle(
                      color:
                          isStartDate || isEndDate || isSingleDate
                              ? EasyTheme.of(context).background
                              : isInRange
                              ? Color(0xFF0052D9)
                              : isToday
                              ? Color(0xFF0052D9)
                              : EasyTheme.of(context).onBackground,
                    ),
                  ),
                  if (isToday && !isStartDate && !isEndDate && !isSingleDate)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Color(0xFF0052D9),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
            // 点击区域
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectDate(date),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isStartDate(DateTime date) {
    return widget.mode == DateTimePickerMode.range &&
        _startDate != null &&
        date.year == _startDate!.year &&
        date.month == _startDate!.month &&
        date.day == _startDate!.day;
  }

  bool _isEndDate(DateTime date) {
    return widget.mode == DateTimePickerMode.range &&
        _endDate != null &&
        date.year == _endDate!.year &&
        date.month == _endDate!.month &&
        date.day == _endDate!.day;
  }

  bool _isSingleDate(DateTime date) {
    return widget.mode == DateTimePickerMode.single &&
        _singleDate != null &&
        date.year == _singleDate!.year &&
        date.month == _singleDate!.month &&
        date.day == _singleDate!.day;
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool _isDateSelected(DateTime date) {
    if (widget.mode == DateTimePickerMode.single) {
      return _isSingleDate(date);
    } else {
      return _isStartDate(date) || _isEndDate(date);
    }
  }

  bool _isDateInRange(DateTime date) {
    if (widget.mode != DateTimePickerMode.range ||
        _startDate == null ||
        _endDate == null) {
      return false;
    }
    return date.isAfter(_startDate!) &&
        date.isBefore(_endDate!) &&
        !_isDateSelected(date);
  }

  Widget _buildMonthYearHeader() {
    final l10n = EasyUiLocalizations.of(context);
    if (widget.mode == DateTimePickerMode.single) {
      // 单独模式只显示一个月
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              // 年份切换按钮
              GestureDetector(
                onTap: () => _changeYear(-1),
                child: Icon(
                  Icons.keyboard_double_arrow_left_rounded,
                  size: 20,
                  color: Color(0xFF8D8C8D),
                ),
              ),
              // 月份切换按钮
              GestureDetector(
                onTap: () => _changeMonth(-1),
                child: Icon(
                  Icons.keyboard_arrow_left,
                  size: 20,
                  color: Color(0xFF8D8C8D),
                ),
              ),
            ],
          ),
          SizedBox(width: 20),
          // 当前年月显示
          Row(
            children: [
              Text(
                l10n.years(_currentMonth.year),
                style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
              ),
              SizedBox(width: 10),
              Text(
                l10n.months(_currentMonth.month),
                style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
              ),
            ],
          ),
          SizedBox(width: 20),
          Row(
            children: [
              // 月份切换按钮
              GestureDetector(
                onTap: () => _changeMonth(1),
                child: Icon(
                  Icons.keyboard_arrow_right,
                  size: 20,
                  color: Color(0xFF8D8C8D),
                ),
              ),
              // 年份切换按钮
              GestureDetector(
                onTap: () => _changeYear(1),
                child: Icon(
                  Icons.keyboard_double_arrow_right_rounded,
                  size: 20,
                  color: Color(0xFF8D8C8D),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // 范围模式显示两个月
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 左侧年月切换
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 年份切换按钮
                    GestureDetector(
                      onTap: () => _changeYear(-1),
                      child: Icon(
                        Icons.keyboard_double_arrow_left_rounded,
                        size: 20,
                        color: Color(0xFF8D8C8D),
                      ),
                    ),
                    // 月份切换按钮
                    GestureDetector(
                      onTap: () => _changeMonth(-1),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: 20,
                        color: Color(0xFF8D8C8D),
                      ),
                    ),
                  ],
                ),
                // 当前年月显示
                Row(
                  children: [
                    Text(
                      l10n.years(_currentMonth.year),
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      l10n.months(_currentMonth.month),
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
                    ),
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          // 右侧年月切换
          SizedBox(
            width: 280,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                // 当前年月显示
                Row(
                  children: [
                    Text(
                      l10n.years(
                        DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        ).year,
                      ),
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
                    ),
                    SizedBox(width: 10),
                    Text(
                      l10n.months(
                        DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        ).month,
                      ),
                      style: TextStyle(fontSize: 16, color: Color(0xFF4F5159)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    // 月份切换按钮
                    GestureDetector(
                      onTap: () => _changeMonth(1),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                        color: Color(0xFF8D8C8D),
                      ),
                    ),
                    // 年份切换按钮
                    GestureDetector(
                      onTap: () => _changeYear(1),
                      child: Icon(
                        Icons.keyboard_double_arrow_right_rounded,
                        size: 20,
                        color: Color(0xFF8D8C8D),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
  }

  Widget _buildCalendarView(EasyUiLocalizations localizations) {
    if (widget.mode == DateTimePickerMode.single) {
      // 单独模式只显示一个日历
      return Column(
        children: [
          _buildWeekHeader(localizations),
          SizedBox(height: 8),
          _buildCalendarGrid(_currentMonth),
        ],
      );
    } else {
      // 范围模式显示两个日历
      return Column(
        children: [
          // 星期头部
          Row(
            children: [
              Expanded(child: _buildWeekHeader(localizations)),
              SizedBox(width: 20),
              Expanded(child: _buildWeekHeader(localizations)),
            ],
          ),
          SizedBox(height: 8),
          // 日历网格
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildCalendarGrid(_currentMonth)),
              SizedBox(width: 20),
              Expanded(
                child: _buildCalendarGrid(
                  DateTime(_currentMonth.year, _currentMonth.month + 1),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildWeekHeader(EasyUiLocalizations localizations) {
    final weekDays = [
      localizations.weekMon,
      localizations.weekTue,
      localizations.weekWed,
      localizations.weekThu,
      localizations.weekFri,
      localizations.weekSat,
      localizations.weekSun,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF979797),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  void _changeYear(int years) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year + years, _currentMonth.month);
    });
  }

  void _changeMonth(int months) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + months,
      );
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      if (widget.mode == DateTimePickerMode.single) {
        _singleDate = date;
        if (!widget.onlyPickDate) {
          // 选完日期后，自动切换到时间
          _showTimePicker = true;
          _isStartTimeSelection = true;
        }
      } else {
        if (_startDate == null || (_startDate != null && _endDate != null)) {
          // 开始一个新的区间：先选择开始日期，保持在日期面板以便选择结束日期
          _startDate = date;
          _endDate = null;
          if (!widget.onlyPickDate) {
            _showTimePicker = false;
            _isStartTimeSelection = true;
          }
        } else {
          if (date.isBefore(_startDate!)) {
            // 如果选择比开始日期更早，则重置开始日期，并保持在日期面板
            _startDate = date;
            if (!widget.onlyPickDate) {
              _showTimePicker = false;
              _isStartTimeSelection = true;
            }
          } else {
            // 选择结束日期后，自动切换到时间（默认先选开始时间）
            _endDate = date;
            if (!widget.onlyPickDate) {
              _showTimePicker = true;
              _isStartTimeSelection = true;
            }
          }
        }
      }
    });
  }

  Widget _buildBottomButtons(EasyUiLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 94,
          height: 40,
          decoration: BoxDecoration(
            color: EasyTheme.of(context).neutralF8,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            onPressed: _clearSelection,
            child: Text(
              localizations.clear,
              style: TextStyle(fontSize: 14, color: Color(0xFFE94459)),
            ),
          ),
        ),
        SizedBox(width: 16),
        Container(
          width: 94,
          height: 40,
          decoration: BoxDecoration(
            color: EasyTheme.of(context).neutralF8,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextButton(
            onPressed: () => _confirmSelection(localizations),
            child: Text(
              localizations.confirm,
              style: TextStyle(fontSize: 14, color: Color(0xFF1484FC)),
            ),
          ),
        ),
      ],
    );
  }

  void _clearSelection() {
    setState(() {
      if (widget.mode == DateTimePickerMode.single) {
        _singleDate = null;
        _singleTime = null;
      } else {
        _startDate = null;
        _endDate = null;
        _startTime = null;
        _endTime = null;
      }
    });
  }

  void _confirmSelection(EasyUiLocalizations localizations) {
    if (widget.mode == DateTimePickerMode.single) {
      // 单独模式
      if (_singleDate == null) {
        final l10n = EasyUiLocalizations.of(context);
        showToastWarning(text: l10n.pleaseSelectDate);
        return;
      }
      _singleTime ??= TimeModel(hour: 0, minute: 0, second: 0);

      final dateTime = DateTime(
        _singleDate!.year,
        _singleDate!.month,
        _singleDate!.day,
        _singleTime!.hour,
        _singleTime!.minute,
        _singleTime!.second,
      );
      widget.onSingleConfirm?.call(dateTime);
    } else {
      // 范围模式
      if (_startDate == null && _endDate == null) {
        final l10n = EasyUiLocalizations.of(context);
        showToastWarning(text: l10n.pleaseSelectStartOrEndDate);
        return;
      }
      if (_startTime == null && _endTime == null) {
        _startTime = TimeModel(hour: 0, minute: 0, second: 0);
        if (widget.onlyPickDate) {
          _endTime = TimeModel(hour: 23, minute: 59, second: 59);
        } else {
          _endTime = TimeModel(hour: 0, minute: 0, second: 0);
        }
      }
      if (_startDate != null &&
          _endDate != null &&
          _startTime != null &&
          _endTime != null) {
        final startDateTime = DateTime(
          _startDate!.year,
          _startDate!.month,
          _startDate!.day,
          _startTime!.hour,
          _startTime!.minute,
        );
        final endDateTime = DateTime(
          _endDate!.year,
          _endDate!.month,
          _endDate!.day,
          _endTime!.hour,
          _endTime!.minute,
        );
        widget.onConfirm?.call(startDateTime, endDateTime);
      }
    }
  }
}
