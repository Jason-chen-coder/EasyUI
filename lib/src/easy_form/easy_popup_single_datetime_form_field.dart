import 'package:flutter/material.dart';

import '../easy_theme.dart';
import 'easy_text_form_field_decoration_layout_delegate.dart';
import '../easy_time_picker/easy_popup_datetime_picker.dart';

/// A FormField wrapper for [EasyPopupSingleDateTimePicker] that integrates
/// with the UI Kit's labeled/error layout like [EasyTextFormField].
class EasyPopupSingleDateTimeFormField extends FormField<DateTime> {
  EasyPopupSingleDateTimeFormField({
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
  }) : isEnabled = enabled,
       super(
         validator: validator,
         onSaved: onSaved,
         builder: (field) {
           final state = field as _EasyPopupSingleDateTimeFormFieldState;

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
             child: Focus(
               canRequestFocus: false,
               skipTraversal: true,
               child: EasyPopupSingleDateTimePicker(
                 onConfirm: (picked) {
                   state._handleDatePicked(picked);
                 },
                 onClear: () {
                   state._handleClear();
                 },
                 placeholder: placeholder,
                 textStyle:
                     textStyle ??
                     TextStyle(fontSize: 14, color: easyTheme.neutral33),
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
                 initialDateTime: field.value,
               ),
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
  final ValueChanged<DateTime?>? onChanged;
  @override
  final FormFieldSetter<DateTime>? onSaved;
  @override
  final FormFieldValidator<DateTime>? validator;
  final InputDecoration? decoration;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;
  final bool isEnabled;

  @override
  FormFieldState<DateTime> createState() =>
      _EasyPopupSingleDateTimeFormFieldState();
}

class _EasyPopupSingleDateTimeFormFieldState extends FormFieldState<DateTime> {
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplayText();
  }

  @override
  void didUpdateWidget(covariant EasyPopupSingleDateTimeFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDisplayText();
  }

  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    _syncDisplayText();
  }

  void _handleDatePicked(DateTime picked) {
    setState(() {
      setValue(picked);
    });
    (widget as EasyPopupSingleDateTimeFormField).onChanged?.call(picked);
  }

  void _handleClear() {
    setState(() {
      setValue(null);
    });
    (widget as EasyPopupSingleDateTimeFormField).onChanged?.call(null);
  }

  void _syncDisplayText() {
    final date = value;
    if (date == null) {
      _displayController.text = '';
    } else {
      _displayController.text =
          '${date.year.toString().padLeft(4, '0')}-'
          '${date.month.toString().padLeft(2, '0')}-'
          '${date.day.toString().padLeft(2, '0')} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}:'
          '${date.second.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}
