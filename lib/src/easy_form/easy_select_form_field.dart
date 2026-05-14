import 'package:flutter/material.dart';

import '../easy_menu/easy_list_pop_menu.dart';
import '../easy_menu/easy_menu_style.dart';
import '../easy_select/easy_select.dart';
import '../easy_select/easy_select_style.dart';
import '../easy_theme.dart';
import 'easy_text_form_field_decoration_layout_delegate.dart';

/// 单选 Select 的表单封装
class EasySelectFormField<T> extends FormField<T?> {
  EasySelectFormField({
    super.key,
    required this.optionsFetcher,
    super.initialValue,
    this.placeholder,
    TextStyle? placeholderStyle,
    this.width,
    this.height = 38,
    this.style,
    this.menuConstraintsBuilder,
    this.clearable = false,
    this.filterable = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.decoration,
    this.decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.showRequiredMark = false,
    super.enabled,
    AutovalidateMode? autoValidateMode,
    EasySelectController? controller,
    EdgeInsets? padding,
    TextStyle? textStyle,
  }) : super(
         validator: validator,
         autovalidateMode: autoValidateMode,
         onSaved: onSaved,
         builder: (field) {
           final state = field as _EasySelectFormFieldState<T>;
           final easyTheme = EasyTheme.of(field.context);
           final InputDecoration effectiveDecoration = (decoration ??
                   const InputDecoration())
               .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme);

           final showError =
               (field.hasError ||
                   effectiveDecoration.errorText != null ||
                   effectiveDecoration.error != null);
           // 参照 EasyTextFormField 的方式：通过占位 error，让输入控件外观在有错时可呈现错误态（这里仅用于布局/标识，不影响 EasySelect 自身边框）
           final InputDecoration outerDecoration = effectiveDecoration.copyWith(
             // error: showError ? const SizedBox() : null,
             // errorText: null,
             // label: null,
             // labelText 保留给 decorationDelegate 在输入框上方渲染
           );
           fetcher() async {
             try {
               final options = await optionsFetcher.call();
               if (field.mounted) {
                 field.options = options;
               }
               return options;
             } catch (e) {
               rethrow;
             }
           }

           Widget inner = IgnorePointer(
             ignoring: !enabled,
             child: Focus(
               canRequestFocus: false,
               skipTraversal: true,
               child: EasySelect<T>(
                 optionsFetcher: fetcher,
                 multiple: false,
                 initialValue: field.value,
                 placeholder: placeholder,
                 style: style,
                 easySelectStyle: EasySelectStyle(
                   displayTextStyle:
                       textStyle ??
                       TextStyle(
                         fontSize: 14,
                         color:
                             enabled == false
                                 ? easyTheme.neutral99
                                 : easyTheme.neutral66,
                       ),
                   placeholderTextStyle: placeholderStyle,
                   triggerConstraints: BoxConstraints.tightFor(
                     width: width,
                     height: height,
                   ),
                   triggerBorderColor: showError ? easyTheme.warning : null,
                   triggerContentPadding: padding,
                 ),
                 menuConstraintsBuilder: menuConstraintsBuilder,
                 clearable: clearable,
                 filterable: filterable,
                 onChanged: (val) {
                   field.didChange(val);
                   onChanged?.call(val);
                 },
                 controller: controller,
               ),
             ),
           );

           // 交给 decorationDelegate 统一渲染 label/error/helper/counter 布局
           inner = decorationDelegate.buildDecoration(
             field.context,
             decoration: outerDecoration,
             filedHasError: field.hasError,
             fieldErrorText: field.errorText,
             maxLength: null,
             textField: inner,
             controller: state._displayController,
             showRequiredMark: showRequiredMark,
           );

           return inner;
         },
       );

  final EasySelectOptionsFetcher<T> optionsFetcher;
  final String? placeholder;
  final double? width;
  final double height;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final bool clearable;
  final bool filterable;
  final ValueChanged<T?>? onChanged;
  @override
  final FormFieldSetter<T?>? onSaved;
  @override
  final FormFieldValidator<T?>? validator;

  final InputDecoration? decoration;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;

  @override
  FormFieldState<T?> createState() => _EasySelectFormFieldState<T>();
}

class _EasySelectFormFieldState<T> extends FormFieldState<T?> {
  List<EasyListPopMenuOption<T>> options = [];
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplay();
  }

  @override
  void didChange(T? value) {
    super.didChange(value);
    _syncDisplay();
  }

  @override
  void didUpdateWidget(covariant EasySelectFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 选项或值更新时，同步显示文本
    _syncDisplay();
  }

  void _syncDisplay() {
    final widgetTyped = widget as EasySelectFormField<T>;
    final value = this.value;
    if (value == null) {
      _displayController.text = '';
      return;
    }
    final index = options.indexWhere((o) => o.value == value);
    final title = index < 0 ? '' : options[index].title;
    _displayController.text = title;
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}

/// 多选 Select 的表单封装
class EasyMultiSelectFormField<T> extends FormField<Iterable<T>> {
  EasyMultiSelectFormField({
    super.key,
    required this.optionsFetcher,
    Iterable<T>? initialValues,
    this.placeholder,
    this.width,
    this.height = 38,
    this.style,
    this.menuConstraintsBuilder,
    this.filterable = false,
    this.clearable = false,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.decoration,
    this.decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.showRequiredMark = false,
    super.enabled,
    AutovalidateMode? autoValidateMode,
    EdgeInsets? padding,
    TextStyle? textStyle,
  }) : super(
         initialValue: initialValues ?? const [],
         validator: validator,
         autovalidateMode: autoValidateMode,
         onSaved: onSaved,
         builder: (field) {
           final state = field as _EasyMultiSelectFormFieldState<T>;
           final easyTheme = EasyTheme.of(field.context);
           final InputDecoration effectiveDecoration = (decoration ??
                   const InputDecoration())
               .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme);

           final bool showError =
               (field.hasError ||
                   effectiveDecoration.errorText != null ||
                   effectiveDecoration.error != null);
           final InputDecoration outerDecoration = effectiveDecoration.copyWith(
             // error: showError ? const SizedBox() : null,
             // errorText: null,
             // label: null,
           );

           fetcher() async {
             try {
               final options = await optionsFetcher.call();
               if (field.mounted) {
                 field.options = options;
               }
               return options;
             } catch (e) {
               rethrow;
             }
           }

           Widget inner = IgnorePointer(
             ignoring: !enabled,
             child: Focus(
               canRequestFocus: false,
               skipTraversal: true,
               child: EasySelect<T>(
                 optionsFetcher: fetcher,
                 multiple: true,
                 initialValues: field.value,
                 placeholder: placeholder,
                 easySelectStyle: EasySelectStyle(
                   triggerConstraints: BoxConstraints.tightFor(
                     width: width,
                     height: height,
                   ),
                   triggerBorderColor: showError ? easyTheme.warning : null,
                   triggerContentPadding: padding,
                   displayTextStyle: textStyle,
                 ),
                 style: style,
                 menuConstraintsBuilder: menuConstraintsBuilder,
                 clearable: clearable,
                 filterable: filterable,
                 onChangedMultiple: (vals) {
                   field.didChange(vals);
                   onChanged?.call(vals);
                 },
               ),
             ),
           );

           inner = decorationDelegate.buildDecoration(
             field.context,
             decoration: outerDecoration,
             filedHasError: field.hasError,
             fieldErrorText: field.errorText,
             maxLength: null,
             textField: inner,
             controller: state._displayController,
             showRequiredMark: showRequiredMark,
           );

           return inner;
         },
       );

  final EasySelectOptionsFetcher<T> optionsFetcher;
  final String? placeholder;
  final double? width;
  final double height;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final bool filterable;
  final bool clearable;
  final ValueChanged<Iterable<T>?>? onChanged;
  @override
  final FormFieldSetter<Iterable<T>>? onSaved;
  @override
  final FormFieldValidator<Iterable<T>>? validator;

  final InputDecoration? decoration;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;

  @override
  FormFieldState<Iterable<T>> createState() =>
      _EasyMultiSelectFormFieldState<T>();
}

class _EasyMultiSelectFormFieldState<T> extends FormFieldState<Iterable<T>> {
  List<EasyListPopMenuOption<T>> options = [];
  final TextEditingController _displayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncDisplay();
  }

  @override
  void didChange(Iterable<T>? value) {
    super.didChange(value ?? const []);
    _syncDisplay();
  }

  @override
  void didUpdateWidget(covariant EasyMultiSelectFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncDisplay();
  }

  void _syncDisplay() {
    final widgetTyped = widget as EasyMultiSelectFormField<T>;
    final values = value ?? const [];
    if (values.isEmpty) {
      _displayController.text = '';
      return;
    }
    final titles = options
        .where((o) => values.contains(o.value))
        .map((o) => o.title)
        .toList(growable: false);
    _displayController.text = titles.join(', ');
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }
}
