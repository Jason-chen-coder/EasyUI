import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';


/// A FormField wrapper for [EasyPopupRangeDateTimePicker] that integrates
/// with the UI Kit's labeled/error layout like [EasyTextFormField].
class EasyPopupRangeDateTimeFormField extends FormField<DateTimeRange> {
  EasyPopupRangeDateTimeFormField({
    super.key,
    super.initialValue,
    this.placeholder,
    this.textStyle,
    this.boxDecoration,
    this.padding,
    this.width,
    this.height = 48,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.decoration,
    this.decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.showRequiredMark = false,
    super.enabled,
    bool onlyPickDate = false,
  }) : isEnabled = enabled,
       super(
         validator: validator,
         onSaved: onSaved,
         builder: (field) {
           final state = field as _EasyPopupRangeDateTimeFormFieldState;

           final easyTheme = EasyTheme.of(field.context);
           final InputDecoration effectiveDecoration = (decoration ??
                   const InputDecoration())
               .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme);

           final hasError =
               field.hasError ||
               effectiveDecoration.error != null ||
               effectiveDecoration.errorText != null;
           // Mirror error state to the visual border via an empty error widget,
           // following the approach used in EasyTextFormField.
           final InputDecoration textFieldDecoration = effectiveDecoration
               .copyWith(
                 error:
                     (field.hasError ||
                             effectiveDecoration.errorText != null ||
                             effectiveDecoration.error != null)
                         ? const SizedBox()
                         : null,
                 errorText: null,
                 label: null,
                 // Keep labelText for the delegate to render above the field.
               );

           Widget fieldBody = IgnorePointer(
             ignoring: !enabled,
             child: EasyPopupRangeDateTimePicker(
               onlyPickDate: onlyPickDate,
               onConfirm: (startDateTime, endDateTime) {
                 state._handleDateRangePicked(startDateTime, endDateTime);
               },
               onClear: () {
                 state._handleClear();
               },
               placeholder: placeholder,
               textStyle: textStyle,
               decoration:
                   boxDecoration ??
                   BoxDecoration(
                     border: Border.all(
                       color:
                           hasError ? easyTheme.warning : easyTheme.neutralEE,
                       width: 1,
                     ),
                     borderRadius: BorderRadius.circular(4),
                     color: easyTheme.background,
                   ),
               padding:
                   padding ??
                   const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
               width: width,
               height: height ?? 40,
               initialStartDateTime: field.value?.start,
               initialEndDateTime: field.value?.end,
             ),
           );

           fieldBody = decorationDelegate.buildDecoration(
             field.context,
             decoration: effectiveDecoration,
             filedHasError: field.hasError,
             fieldErrorText: field.errorText,
             maxLength: null,
             textField: fieldBody,
             // Pass a read-only controller with formatted text; delegate only uses it for counter.
             controller: state._displayController,
             showRequiredMark: showRequiredMark,
           );

           return fieldBody;
         },
       );

  final String? placeholder;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final ValueChanged<DateTimeRange?>? onChanged;
  @override
  final FormFieldSetter<DateTimeRange>? onSaved;
  @override
  final FormFieldValidator<DateTimeRange>? validator;
  final InputDecoration? decoration;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;
  final bool isEnabled;

  @override
  FormFieldState<DateTimeRange> createState() =>
      _EasyPopupRangeDateTimeFormFieldState();
}

class _EasyPopupRangeDateTimeFormFieldState
    extends FormFieldState<DateTimeRange> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplayText();
  }

  @override
  void didUpdateWidget(covariant EasyPopupRangeDateTimeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
    _syncDisplayText();
  }

  @override
  void didChange(DateTimeRange? value) {
    super.didChange(value);
    _syncDisplayText();
  }

  void _handleDateRangePicked(DateTime startDateTime, DateTime endDateTime) {
    final dateRange = DateTimeRange(start: startDateTime, end: endDateTime);
    setState(() {
      setValue(dateRange);
    });
    (widget as EasyPopupRangeDateTimeFormField).onChanged?.call(dateRange);
  }

  void _handleClear() {
    setState(() {
      setValue(null);
    });
    (widget as EasyPopupRangeDateTimeFormField).onChanged?.call(null);
  }

  void _syncDisplayText() {
    final dateRange = value;
    if (dateRange == null) {
      _displayController.text = '';
    } else {
      final startStr =
          '${dateRange.start.year.toString().padLeft(4, '0')}-'
          '${dateRange.start.month.toString().padLeft(2, '0')}-'
          '${dateRange.start.day.toString().padLeft(2, '0')} '
          '${dateRange.start.hour.toString().padLeft(2, '0')}:'
          '${dateRange.start.minute.toString().padLeft(2, '0')}';

      final endStr =
          '${dateRange.end.year.toString().padLeft(4, '0')}-'
          '${dateRange.end.month.toString().padLeft(2, '0')}-'
          '${dateRange.end.day.toString().padLeft(2, '0')} '
          '${dateRange.end.hour.toString().padLeft(2, '0')}:'
          '${dateRange.end.minute.toString().padLeft(2, '0')}';

      final l10n = EasyUiLocalizations.of(context);
      _displayController.text = '$startStr ${l10n.to} $endStr';
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}
