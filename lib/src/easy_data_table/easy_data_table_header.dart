import 'package:flutter/material.dart';

import '../../easy_ui.dart';

class EasyDataTableHeaderData {
  final String columnName;
  final Widget header;

  EasyDataTableHeaderData({required this.columnName, required this.header});
}

class EasyDataTableTextHeader extends StatelessWidget {
  const EasyDataTableTextHeader({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.alignment = AlignmentDirectional.centerStart,
    this.showRequireMark = false,
  });

  final String text;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final bool showRequireMark;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.neutral33.withAlpha(0x0F)),
        ),
      ),
      padding: padding,
      alignment: alignment,
      child: EasyLongPressCopyable(
        longPressCopyable: text.isNotEmpty,
        tooltip: text.isNotEmpty ? text : null,
        child: Text.rich(
          TextSpan(
            children: [
              if (showRequireMark)
                TextSpan(text: '* ', style: TextStyle(color: theme.warning)),
              TextSpan(text: text),
            ],
          ),
        ),
      ),
    );
  }
}

class EasyDataTableCheckboxHeader extends StatelessWidget {
  const EasyDataTableCheckboxHeader({
    super.key,
    required this.allSelected,
    required this.value,
    this.padding = const EdgeInsets.only(left: 16, right: 16),
    this.alignment = AlignmentDirectional.centerStart,
    this.onChanged,
    this.checkboxBorderSide,
  });

  /// 表单所有行是否被选中,true为所有行被选中,false为所有行都未被选中,null为存在行被选中
  final bool? allSelected;

  /// checkbox的值
  final bool? value;
  final ValueSetter<bool?>? onChanged;
  final EdgeInsets padding;
  final AlignmentGeometry alignment;
  final BorderSide? checkboxBorderSide;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return Container(
      alignment: alignment,
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.neutral33.withAlpha(0x0F)),
        ),
      ),
      child: Checkbox(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Color(0xffD9D9D9);
          }
          if (states.contains(WidgetState.selected)) {
            return allSelected == null
                ? theme.primaryGreen.withAlpha(0x33)
                : theme.primaryGreen;
          }
          return Colors.transparent;
        }),
        side: BorderSide(color: theme.neutral99),
        checkColor: allSelected == null ? theme.primaryGreen : Colors.white,
        value: value,
        onChanged: onChanged,
        tristate: true,
      ),
    );
  }
}
