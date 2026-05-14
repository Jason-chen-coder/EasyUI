import 'package:flutter/material.dart';

import '../easy_menu/easy_list_pop_menu.dart';
import '../easy_menu/easy_menu_style.dart';
import '../easy_pagination_select/easy_pagination_select.dart';
import '../easy_pagination_select/multiple/easy_pagination_multiple_select_controller.dart';
import '../easy_pagination_select/single/easy_pagination_single_select_controller.dart';
import '../easy_theme.dart';
import 'easy_text_form_field_decoration_layout_delegate.dart';

class EasyPaginationSingleSelectFormField<T> extends FormField<T> {
  EasyPaginationSingleSelectFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    this.placeholder,
    this.width,
    this.height = 38,
    this.style,
    this.menuConstraintsBuilder,
    this.clearable = false,
    this.filterable = false,
    this.onChanged,
    this.decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.showRequiredMark = false,
    AutovalidateMode? autoValidateMode,
    this.decoration,
    required this.controller,
    this.autoDisposeController = true,
    this.searchHintText,
    TextStyle? textStyle,
    EdgeInsets? padding,
  }) : super(
         initialValue: controller.selectedOption?.value,
         builder:
             (field) => _selectChildBuilder(
               field: field,
               decoration: decoration,
               decorationDelegate: decorationDelegate,
               showRequiredMark: showRequiredMark,
               enabled: enabled,
               childBuilder: (easyTheme, showError) {
                 return EasyPaginationSelect<T>.single(
                   placeholder: placeholder,
                   width: width,
                   height: height,
                   style: style,
                   textStyle:
                       textStyle ??
                       TextStyle(
                         fontSize: 14,
                         color:
                             enabled == false
                                 ? easyTheme.neutral99
                                 : easyTheme.neutral66,
                       ),
                   menuConstraintsBuilder: menuConstraintsBuilder,
                   clearable: clearable,
                   filterable: filterable,
                   onChanged: (val) {
                     field.didChange(val);
                     onChanged?.call(val);
                   },
                   borderColor: showError ? easyTheme.warning : null,
                   controller: controller,
                   searchHintText: searchHintText,

                   /// 由于表单验证会意外的销毁 controller，所以这里强制不自动释放
                   /// 改为在`FormField`中处理
                   autoDisposeController: false,
                   padding: padding,
                 );
               },
             ),
       );

  final String? placeholder;
  final double? width;
  final double height;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final ValueChanged<T?>? onChanged;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;
  final InputDecoration? decoration;
  final EasyPaginationSingleSelectController<T> controller;

  /// 是否可清除选中项
  final bool clearable;

  /// 是否可搜索选项
  final bool filterable;

  /// 搜索框提示文字
  final String? searchHintText;

  /// 是否在组件销毁时自动释放 controller
  /// 默认值为`true` 适用于大多数场景
  final bool autoDisposeController;

  @override
  FormFieldState<T> createState() =>
      _EasyPaginationSingleSelectFormFieldState<T>();
}

class _EasyPaginationSingleSelectFormFieldState<T> extends FormFieldState<T> {
  @override
  void dispose() {
    final widget = this.widget as EasyPaginationSingleSelectFormField<T>;
    if (mounted && widget.autoDisposeController) {
      widget.controller.dispose();
    }
    super.dispose();
  }
}

class EasyPaginationMultipleSelectFormField<T> extends FormField<Iterable<T>> {
  EasyPaginationMultipleSelectFormField({
    super.key,
    super.onSaved,
    super.validator,
    super.autovalidateMode,
    super.enabled,
    this.placeholder,
    this.width,
    this.height = 38,
    this.style,
    this.menuConstraintsBuilder,
    this.clearable = false,
    this.filterable = false,
    this.onChanged,
    this.decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.showRequiredMark = false,
    AutovalidateMode? autoValidateMode,
    this.decoration,
    required this.controller,
    this.autoDisposeController = true,
    this.searchHintText,
    this.showSelectAllItem = true,
    this.selectAllItemTitle,
  }) : super(
         initialValue: controller.selectedValues.toList(),
         builder:
             (field) => _selectChildBuilder(
               field: field,
               decoration: decoration,
               decorationDelegate: decorationDelegate,
               showRequiredMark: showRequiredMark,
               enabled: enabled,
               childBuilder: (easyTheme, showError) {
                 return EasyPaginationSelect<T>.multiple(
                   placeholder: placeholder,
                   width: width,
                   height: height,
                   style: style,
                   menuConstraintsBuilder: menuConstraintsBuilder,
                   clearable: clearable,
                   filterable: filterable,
                   onChanged: (vals) {
                     field.didChange(vals);
                     onChanged?.call(vals);
                   },
                   borderColor: showError ? easyTheme.warning : null,
                   controller: controller,
                   searchHintText: searchHintText,

                   /// 由于表单验证会意外的销毁 controller，所以这里强制不自动释放
                   /// 改为在`FormField`中处理
                   autoDisposeController: false,
                   showSelectAllItem: showSelectAllItem,
                   selectAllItemTitle: selectAllItemTitle,
                   textStyle: TextStyle(
                     fontSize: 14,
                     color:
                         enabled == false
                             ? easyTheme.neutral99
                             : easyTheme.neutral66,
                   ),
                 );
               },
             ),
       );

  final String? placeholder;
  final double? width;
  final double height;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final ValueChanged<List<T>>? onChanged;
  final EasyTextFormFieldDecorationLayoutDelegate decorationDelegate;
  final bool showRequiredMark;
  final InputDecoration? decoration;
  final EasyPaginationMultipleSelectController<T> controller;

  /// 是否在组件销毁时自动释放 controller
  /// 默认值为`true` 适用于大多数场景
  final bool autoDisposeController;

  /// 是否可清除选中项
  final bool clearable;

  /// 是否可搜索选项
  final bool filterable;

  /// 搜索框提示文字
  final String? searchHintText;

  /// 显示选择全部选项
  final bool showSelectAllItem;

  /// 选择全部选项的标题
  final String? selectAllItemTitle;

  @override
  FormFieldState<Iterable<T>> createState() =>
      _EasyPaginationMultipleSelectFormFieldState<T>();
}

class _EasyPaginationMultipleSelectFormFieldState<T>
    extends FormFieldState<Iterable<T>> {
  @override
  void dispose() {
    final widget = this.widget as EasyPaginationMultipleSelectFormField<T>;
    if (mounted && widget.autoDisposeController) {
      widget.controller.dispose();
    }
    super.dispose();
  }
}

Widget _selectChildBuilder<T>({
  required FormFieldState<T> field,
  required Widget Function(EasyThemeData, bool showError) childBuilder,
  required InputDecoration? decoration,
  required bool enabled,
  required EasyTextFormFieldDecorationLayoutDelegate decorationDelegate,
  required bool showRequiredMark,
}) {
  final easyTheme = EasyTheme.of(field.context);
  final InputDecoration effectiveDecoration = (decoration ??
          const InputDecoration())
      .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme);

  final bool showError =
      (field.hasError ||
          effectiveDecoration.errorText != null ||
          effectiveDecoration.error != null);

  Widget inner = IgnorePointer(
    ignoring: !enabled,
    child: Focus(
      canRequestFocus: false,
      skipTraversal: true,
      child: childBuilder(easyTheme, showError),
    ),
  );

  inner = decorationDelegate.buildDecoration(
    field.context,
    decoration: effectiveDecoration,
    filedHasError: field.hasError,
    fieldErrorText: field.errorText,
    maxLength: null,
    textField: inner,
    controller: TextEditingController(),
    showRequiredMark: showRequiredMark,
  );

  return inner;
}
