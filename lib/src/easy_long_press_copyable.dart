import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../easy_ui.dart';

class EasyLongPressCopyable extends StatelessWidget {
  const EasyLongPressCopyable({
    super.key,
    this.tooltip,
    this.longPressCopyable = true,
    this.selectable = true,
    required this.child,
  });

  /// 是否启用长按复制
  final bool longPressCopyable;

  /// 是否添加[SelectionArea]
  final bool selectable;

  /// 提示文本
  final String? tooltip;

  final Widget child;

  static Future<void> copyString(BuildContext context, String text) async {
    final l10n = EasyUiLocalizations.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    showToastOk(text: l10n.hasCopyToClipboard);
  }

  Future<void> _copyText(BuildContext context, Text text) async {
    if (text.data != null) {
      await copyString(context, text.data!);
    } else if (text.textSpan != null) {
      final span = text.textSpan!;
      if (span is TextSpan) {
        final buffer = StringBuffer();
        final queue = Queue<TextSpan>()..add(span);

        while (queue.isNotEmpty) {
          final span = queue.removeLast();

          final spanText = span.text;
          if (spanText != null) {
            buffer.write(spanText);
          }

          final children = span.children;
          if (children != null && children.isNotEmpty) {
            children.whereType<TextSpan>().toList().reversed.forEach(
              queue.addLast,
            );
          }
        }

        await copyString(context, buffer.toString());
      }
    }
  }

  void _copy(BuildContext context) {
    if (child is Text) {
      _copyText(context, child as Text);
    } else if (child is EasyUserListTile) {
      final userListTile = child as EasyUserListTile;
      copyString(
        context,
        '${userListTile.userEmail}\n${userListTile.userName}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    TooltipTriggerMode? triggerMode;
    bool useSelectionArea = selectable;
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        triggerMode = TooltipTriggerMode.tap;
        useSelectionArea = false;
        break;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        break;
    }

    Widget widget = child;
    if (useSelectionArea) {
      widget = SelectionArea(child: child);
    }

    if (longPressCopyable) {
      widget = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onLongPress: () {
            _copy(context);
          },
          child: widget,
        ),
      );
    }

    if (tooltip != null) {
      widget = Tooltip(
        message: tooltip,
        triggerMode: triggerMode,
        child: widget,
      );
    }

    return widget;
  }
}
