import 'package:flutter/material.dart';
import '../../easy_ui.dart';
import './enhanced_datetime_picker.dart';
import 'package:intl/intl.dart';

class PopupDateTimePicker extends StatefulWidget {
  final DateTimePickerMode mode;
  final void Function(DateTime startDateTime, DateTime endDateTime)? onConfirm;
  final void Function(DateTime dateTime)? onSingleConfirm;
  final VoidCallback? onClear;
  final String? placeholder;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final DateTime? initialDateTime;
  final DateTime? initialStartDateTime;
  final DateTime? initialEndDateTime;

  /// 是否禁止选择时间，只允许选择日期
  final bool onlyPickDate;

  const PopupDateTimePicker({
    super.key,
    this.mode = DateTimePickerMode.range,
    this.onConfirm,
    this.onSingleConfirm,
    this.onClear,
    this.placeholder,
    this.textStyle,
    this.decoration,
    this.padding,
    this.width,
    this.height = 40,
    this.initialDateTime,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.onlyPickDate = false,
  });

  @override
  State<PopupDateTimePicker> createState() => _PopupDateTimePickerState();
}

class _PopupDateTimePickerState extends State<PopupDateTimePicker>
    with TickerProviderStateMixin {
  DateTime? _selectedSingleDateTime;
  DateTime? _selectedStartDateTime;
  DateTime? _selectedEndDateTime;
  final LayerLink _layerLink = LayerLink();
  bool _isPopupOpen = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;

  final _overlayPortalController = OverlayPortalController();
  final _anchorKey = GlobalKey();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // 设置初始值
    _selectedSingleDateTime = widget.initialDateTime;
    _selectedStartDateTime = widget.initialStartDateTime;
    _selectedEndDateTime = widget.initialEndDateTime;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: -20.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant PopupDateTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _selectedSingleDateTime = widget.initialDateTime;
    }
    if (oldWidget.initialStartDateTime != widget.initialStartDateTime) {
      _selectedStartDateTime = widget.initialStartDateTime;
    }
    if (oldWidget.initialEndDateTime != widget.initialEndDateTime) {
      _selectedEndDateTime = widget.initialEndDateTime;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // String get _displayText {
  //   final localizations = EasyUiLocalizations.of(context);
  //   if (widget.mode == DateTimePickerMode.single) {
  //     if (_selectedSingleDateTime != null) {
  //       return DateFormat(
  //         'yyyy-MM-dd HH:mm:ss',
  //       ).format(_selectedSingleDateTime!);
  //     }
  //     return widget.placeholder ?? localizations.pleasSelectDateTime;
  //   } else {
  //     if (_selectedStartDateTime != null && _selectedEndDateTime != null) {
  //       final startStr = DateFormat(
  //         'yyyy-MM-dd HH:mm',
  //       ).format(_selectedStartDateTime!);
  //       final endStr = DateFormat(
  //         'yyyy-MM-dd HH:mm',
  //       ).format(_selectedEndDateTime!);
  //       return '$startStr - $endStr';
  //     } else if (_selectedStartDateTime != null) {
  //       return '${DateFormat('yyyy-MM-dd HH:mm').format(_selectedStartDateTime!)} - ?';
  //     }
  //     return widget.placeholder ?? localizations.pleaseSelectTimeRange;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayPortalController,
        overlayChildBuilder: _buildOverlay,
        child: InkWell(
          focusNode: _focusNode,
          key: _anchorKey,
          onTap: _togglePopup,
          child: Container(
            width: widget.width,
            height: widget.height,
            padding:
                widget.padding ??
                EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration:
                widget.decoration ??
                BoxDecoration(
                  border: Border.all(color: theme.neutralEE, width: 1),
                  borderRadius: BorderRadius.circular(4),
                  color: theme.background,
                ),
            child: Row(
              children: [
                Expanded(child: _buildDisplayText()),
                _buildTrailingIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisplayText() {
    final theme = EasyTheme.of(context);
    final l10n = EasyUiLocalizations.of(context);
    switch (widget.mode) {
      case DateTimePickerMode.single:
        String str = '';
        if (_selectedSingleDateTime != null) {
          str = DateFormat(
            widget.onlyPickDate ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm:ss',
          ).format(_selectedSingleDateTime!);
        } else {
          str = widget.placeholder ?? l10n.pleasSelectDateTime;
        }
        return Text(
          str,
          style:
              widget.textStyle ??
              TextStyle(
                fontSize: 14,
                color:
                    _selectedSingleDateTime != null
                        ? theme.neutral66
                        : theme.neutral99,
              ),
          overflow: TextOverflow.ellipsis,
        );
      case DateTimePickerMode.range:
        final startDateTimeSelected = _selectedStartDateTime != null;
        final endDateTimeSelected = _selectedEndDateTime != null;

        if (widget.placeholder != null) {
          return Text(
            widget.placeholder!,
            style:
                widget.textStyle ??
                TextStyle(
                  fontSize: 14,
                  color:
                      (startDateTimeSelected && endDateTimeSelected)
                          ? theme.neutral66
                          : theme.neutral99,
                ),
            overflow: TextOverflow.ellipsis,
          );
        }

        final startStr =
            startDateTimeSelected
                ? DateFormat(
                  widget.onlyPickDate ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm',
                ).format(_selectedStartDateTime!)
                : l10n.startDate;
        final endStr =
            endDateTimeSelected
                ? DateFormat(
                  widget.onlyPickDate ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm',
                ).format(_selectedEndDateTime!)
                : l10n.endDate;
        return Center(
          child: Text.rich(
            TextSpan(
              text: startStr,
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    width: 16,
                    height: 2,
                    color: theme.neutral99,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                TextSpan(
                  text: endStr,
                  style:
                      widget.textStyle ??
                      TextStyle(
                        fontSize:
                            !widget.onlyPickDate && startDateTimeSelected
                                ? 12
                                : 16,
                        color:
                            startDateTimeSelected
                                ? theme.neutral66
                                : theme.neutral99,
                        height: 1,
                      ),
                ),
              ],
              style:
                  widget.textStyle ??
                  TextStyle(
                    fontSize:
                        !widget.onlyPickDate && endDateTimeSelected ? 12 : 16,
                    color:
                        endDateTimeSelected ? theme.neutral66 : theme.neutral99,
                    height: 1,
                  ),
            ),
          ),
        );
    }
  }

  Widget _buildTrailingIcon() {
    final bool hasSelection =
        widget.mode == DateTimePickerMode.single
            ? _selectedSingleDateTime != null
            : (_selectedStartDateTime != null || _selectedEndDateTime != null);

    if (hasSelection) {
      return InkWell(
        onTap: _clearSelection,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            Icons.close,
            size: 16,
            color: EasyTheme.of(context).neutral66,
          ),
        ),
      );
    }
    return Icon(
      Icons.calendar_month_outlined,
      size: 16,
      color: EasyTheme.of(context).neutral66,
    );
  }

  void _clearSelection() {
    setState(() {
      _selectedSingleDateTime = null;
      _selectedStartDateTime = null;
      _selectedEndDateTime = null;
    });
    widget.onClear?.call();
  }

  void _togglePopup() {
    if (_isPopupOpen) {
      _closePopup();
    } else {
      _openPopup();
    }
  }

  void _openPopup() {
    _focusNode.requestFocus();
    _overlayPortalController.show();
    setState(() {
      _isPopupOpen = true;
    });
    _animationController.forward();
  }

  void _closePopup() {
    _animationController.reverse().then((_) {
      _focusNode.unfocus();
      _overlayPortalController.hide();
      if (mounted) {
        setState(() {
          _isPopupOpen = false;
        });
      }
    });
  }

  Widget _buildOverlay(BuildContext context) {
    final localizations = EasyUiLocalizations.of(context);
    final anchorContext = _anchorKey.currentContext!;
    final RenderBox renderBox = anchorContext.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenSize = MediaQuery.of(context).size;

    // 计算弹出框的位置
    double popupWidth = widget.mode == DateTimePickerMode.single ? 400 : 600;
    double popupHeight = 500;

    // 默认在下方显示
    double top = offset.dy + size.height + 8;
    double left = offset.dx;

    // 如果右侧空间不够，调整左侧位置
    if (left + popupWidth > screenSize.width) {
      left = screenSize.width - popupWidth - 16;
    }

    // 如果下方空间不够，在上方显示
    if (top + popupHeight > screenSize.height) {
      top = offset.dy - popupHeight - 8;
    }

    // 确保不超出屏幕边界
    if (left < 16) left = 16;
    if (top < 16) top = 16;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _closePopup,
            child: Container(color: Colors.transparent),
          ),
        ),
        // 弹出框
        Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: popupWidth,
                      height: popupHeight,
                      decoration: BoxDecoration(
                        color: EasyTheme.of(context).background,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: EasyTheme.of(
                              context,
                            ).onBackground.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          children: [
                            // 标题栏
                            Container(
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: EasyTheme.of(context).neutralF8,
                                border: Border(
                                  bottom: BorderSide(
                                    color: EasyTheme.of(context).neutralEE,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    widget.mode == DateTimePickerMode.single
                                        ? localizations.selectDateTime
                                        : localizations.selectTimeRange,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: EasyTheme.of(context).neutral33,
                                    ),
                                  ),
                                  Spacer(),
                                  // GestureDetector(
                                  //   onTap: _closePopup,
                                  //   child: Icon(
                                  //     Icons.close,
                                  //     size: 20,
                                  //     color: Color(0xFF666666),
                                  //   ),
                                  // ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      _closePopup();
                                    },
                                    padding: EdgeInsets.all(5),
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            ),
                            // 日期时间选择器
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: EnhancedDateTimePicker(
                                  mode: widget.mode,
                                  onlyPickDate: widget.onlyPickDate,
                                  initialDateTime: widget.initialDateTime,
                                  initialStartDateTime:
                                      widget.initialStartDateTime,
                                  initialEndDateTime: widget.initialEndDateTime,
                                  onSingleConfirm: (dateTime) {
                                    setState(() {
                                      _selectedSingleDateTime = dateTime;
                                    });
                                    widget.onSingleConfirm?.call(dateTime);
                                    _closePopup();
                                  },
                                  onConfirm: (startDateTime, endDateTime) {
                                    setState(() {
                                      _selectedStartDateTime = startDateTime;
                                      _selectedEndDateTime = endDateTime;
                                    });
                                    widget.onConfirm?.call(
                                      startDateTime,
                                      endDateTime,
                                    );
                                    _closePopup();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EasyPopupSingleDateTimePicker extends PopupDateTimePicker {
  const EasyPopupSingleDateTimePicker({
    super.key,
    required void Function(DateTime dateTime) onConfirm,
    super.onClear,
    super.placeholder,
    super.textStyle,
    super.decoration,
    super.padding,
    super.width,
    super.height,
    super.onlyPickDate = false,
    super.initialDateTime,
  }) : super(
         mode: DateTimePickerMode.single,
         onSingleConfirm: onConfirm,
       );
}

class EasyPopupRangeDateTimePicker extends PopupDateTimePicker {
  const EasyPopupRangeDateTimePicker({
    super.key,
    required void Function(DateTime startDateTime, DateTime endDateTime)
    super.onConfirm,
    super.onClear,
    super.placeholder,
    super.textStyle,
    super.decoration,
    super.padding,
    super.width,
    super.height,
    super.onlyPickDate = false,
    super.initialStartDateTime,
    super.initialEndDateTime,
  }) : super(
         mode: DateTimePickerMode.range,
       );
}
