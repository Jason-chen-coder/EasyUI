import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

/// 颜色选择器的表单封装
class EasyColorSelectorFormField extends FormField<Color?> {
  EasyColorSelectorFormField({
    super.key,
    super.initialValue,
    String? placeholder,
    double? width,
    double? height = 38.0,
    bool clearable = false,
    ValueChanged<Color?>? onChanged,
    InputDecoration? decoration,
    EasyTextFormFieldDecorationLayoutDelegate decorationDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    bool showRequiredMark = false,
    super.autovalidateMode,
    super.onSaved,
    super.validator,
    super.enabled,

    /// 图标，用于展示选中的颜色
    /// 仅支持可以读取`IconTheme`颜色的图标组件
    /// 例如：`Icon`、`EasySvgIcon`等
    Widget? icon,

    /// 是否启用透明度选择
    bool enableAlpha = true,

    /// 是否在滑块上显示颜色预览
    bool displayThumbColor = true,
  }) : super(
         builder: (field) {
           final easyTheme = EasyTheme.of(field.context);
           final InputDecoration effectiveDecoration = (decoration ??
                   const InputDecoration())
               .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme);

           final showError =
               (field.hasError ||
                   effectiveDecoration.errorText != null ||
                   effectiveDecoration.error != null);
           // 参照 EasyTextFormField 的方式：通过占位 error，让输入控件外观在有错时可呈现错误态（这里仅用于布局/标识，不影响 EasySelect 自身边框）
           final InputDecoration outerDecoration = effectiveDecoration;

           Widget inner = IgnorePointer(
             ignoring: !enabled,
             child: Focus(
               canRequestFocus: false,
               skipTraversal: true,
               child: EasyColorSelector(
                 initialValue: field.value,
                 placeholder: placeholder,
                 width: width,
                 height: height,
                 clearable: clearable,
                 onChanged: (val) {
                   field.didChange(val);
                   onChanged?.call(val);
                 },
                 borderColor: showError ? easyTheme.warning : null,
                 icon: icon,
                 enableAlpha: enableAlpha,
                 displayThumbColor: displayThumbColor,
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
             controller: TextEditingController(),
             showRequiredMark: showRequiredMark,
           );

           return inner;
         },
       );
}
