import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../easy_ui.dart';

class EasyDataTableCellWrapper extends StatelessWidget {
  const EasyDataTableCellWrapper({
    super.key,
    required this.child,
    this.tooltip,
    this.alignment = AlignmentDirectional.centerStart,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.onTap,
    this.longPressCopyable = true,
  });

  final Widget child;
  final String? tooltip;
  final AlignmentGeometry alignment;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool longPressCopyable;

  @override
  Widget build(BuildContext context) {
    Widget widget = child;

    widget = EasyLongPressCopyable(
      longPressCopyable: longPressCopyable,
      tooltip: tooltip,
      child: widget,
    );

    widget = Container(alignment: alignment, padding: padding, child: widget);

    if (onTap != null) {
      widget = InkWell(onTap: onTap, child: widget);
    }

    return widget;
  }
}

class EasyDataTableTextCell extends StatelessWidget {
  const EasyDataTableTextCell({
    super.key,
    required this.text,
    this.textFormater,
    this.alignment = AlignmentDirectional.centerStart,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.textStyle,
    this.onTapText,
    this.onTap,
    this.maxLines = 1,
  });

  /// 文本
  final String text;

  /// 文本格式化函数,默认为[EasyDataTableTextCell._formatText]
  final String Function(String text)? textFormater;

  final AlignmentGeometry alignment;

  final EdgeInsets padding;

  final TextStyle? textStyle;

  /// 文本点击回调
  final VoidCallback? onTapText;

  /// 单元格点击回调
  final VoidCallback? onTap;

  final int? maxLines;

  static String _formatText(String text) {
    return text.isEmpty ? '---' : text;
  }

  @override
  Widget build(BuildContext context) {
    final formatedText = textFormater?.call(text) ?? _formatText(text);

    Widget child = Text.rich(
      TextSpan(
        text: formatedText,
        recognizer:
            onTapText == null
                ? null
                : (TapGestureRecognizer()..onTap = onTapText),
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );

    child = EasyLongPressCopyable(
      longPressCopyable: text.isNotEmpty,
      selectable: text.isNotEmpty,
      tooltip: text.isEmpty ? null : formatedText,
      child: child,
    );

    child = Container(padding: padding, alignment: alignment, child: child);

    if (onTap != null) {
      child = InkWell(onTap: onTap, child: child);
    }

    return child;
  }
}

class EasyDataTableCheckboxCell extends StatelessWidget {
  const EasyDataTableCheckboxCell({
    super.key,
    required this.value,
    this.onChanged,
    this.alignment = AlignmentDirectional.centerStart,
    this.padding = const EdgeInsets.only(left: 8),
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final AlignmentGeometry alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return Container(
      alignment: alignment,
      padding: padding,
      child: Checkbox(
        tristate: false,
        side: BorderSide(color: theme.neutral99),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Color(0xffD9D9D9);
          }
          if (states.contains(WidgetState.selected)) {
            return theme.primaryGreen;
          }
          return Colors.transparent;
        }),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}

class EasyDataTableOperationsCell extends StatelessWidget {
  const EasyDataTableOperationsCell({
    super.key,
    required this.operations,
    this.padding = const EdgeInsets.only(left: 8, right: 8),
    this.spacing = .0,
  });

  final List<Widget> operations;
  final EdgeInsets padding;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        spacing: spacing,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: operations,
      ),
    );
  }
}

class EasyDataTableUserCell extends StatelessWidget {
  const EasyDataTableUserCell({
    super.key,
    required this.userAvatar,
    required this.userName,
    required this.userEmail,
  });

  final String userAvatar;
  final String userName;
  final String userEmail;

  @override
  Widget build(BuildContext context) {
    return EasyLongPressCopyable(
      tooltip: [userName, userEmail].where((e) => e.isNotEmpty).join('\n'),
      child: EasyUserListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        showTooltip: false,
        userAvatar: userAvatar,
        userName: userName,
        userEmail: userEmail,
      ),
    );
  }
}

class EasyDataTableOperationButton extends StatelessWidget {
  const EasyDataTableOperationButton({
    super.key,
    required this.icon,
    required this.message,
    this.onPressed,
  });

  factory EasyDataTableOperationButton.edit({
    Key? key,
    required String message,
    VoidCallback? onPressed,
  }) {
    return EasyDataTableOperationButton(
      icon: Image.asset(
        'assets/images/ic_table_operation_edit.png',
        package: 'easy_ui',
        width: 40,
        height: 40,
      ),
      message: message,
      onPressed: onPressed,
    );
  }

  factory EasyDataTableOperationButton.delete({
    Key? key,
    required String message,
    VoidCallback? onPressed,
  }) {
    return EasyDataTableOperationButton(
      icon: Image.asset(
        'assets/images/ic_table_operation_delete.png',
        package: 'easy_ui',
        width: 40,
        height: 40,
      ),
      message: message,
      onPressed: onPressed,
    );
  }

  final Widget icon;
  final String message;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
