import 'package:easy_ui/src/easy_dialog/easy_notify_dialog.dart';
import 'package:flutter/material.dart';

import '../easy_theme.dart';
import 'easy_dialog_size.dart';

Future<T?> showEasyContentDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
}) {
  // 根据主题亮度选择遮罩颜色，暗色模式下使用更深的遮罩
  final brightness = Theme.of(context).brightness;
  final barrierColor = switch (brightness) {
    Brightness.dark => Colors.black.withAlpha(204),
    Brightness.light => Colors.black54,
  };

  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: "ContentDialog",
    barrierColor: barrierColor,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) => builder(context),
    transitionBuilder: (transitionContext, animation1, animation2, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation1,
        curve: Curves.easeOut,
      );
      final navigator = Navigator.of(transitionContext);
      final themes = InheritedTheme.capture(
        from: transitionContext,
        to: navigator.context,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.1),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
          child: themes.wrap(child),
        ),
      );
    },
  );
}

class EasyContentDialog extends StatelessWidget {
  const EasyContentDialog({
    super.key,
    this.size = EasyDialogSize.small,
    required this.title,
    required this.body,
    this.actions,
    this.showActionsDividerLine = false,
    this.titleTextStyle,
    this.bodyTextStyle,
  });

  final EasyDialogSize size;
  final String title;
  final Widget body;
  final Widget? actions;
  final bool showActionsDividerLine;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;

  factory EasyContentDialog.withTwoActions({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required Widget leftAction,
    required Widget rightAction,
    bool showActionsDividerLine = false,
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
  }) {
    return EasyContentDialog(
      size: size,
      title: title,
      body: body,
      actions: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Row(
          spacing: 16,
          children: [Expanded(child: leftAction), Expanded(child: rightAction)],
        ),
      ),
      showActionsDividerLine: showActionsDividerLine,
      titleTextStyle: titleTextStyle,
      bodyTextStyle: bodyTextStyle,
    );
  }

  factory EasyContentDialog.withSingleButton({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required String buttonText,
    VoidCallback? onButtonPressed,
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
    TextStyle? buttonTextStyle,
    double? buttonHeight,
  }) {
    return EasyContentDialog(
      size: size,
      title: title,
      body: body,
      actions: EasyNotifyDialogTextButton(
        text: buttonText,
        onPressed: onButtonPressed,
        textStyle: buttonTextStyle,
        height: buttonHeight,
      ),
      showActionsDividerLine: true,
      titleTextStyle: titleTextStyle,
      bodyTextStyle: bodyTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final width = size.width;
    final resolvedTitleTextStyle = TextStyle(
      fontSize: 20,
      color: easyTheme.neutral33,
    ).merge(titleTextStyle);
    final resolvedBodyTextStyle = Theme.of(context).primaryTextTheme.bodyMedium!
        .copyWith(fontSize: 14, color: easyTheme.neutral99)
        .merge(bodyTextStyle);

    Widget? actions = this.actions;
    if (actions != null && showActionsDividerLine) {
      actions = Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: easyTheme.neutralEE)),
        ),
        child: actions,
      );
    }

    var bodyBottomPadding = 24.0;
    if (actions == null) {
      bodyBottomPadding = 40.0;
    }

    return Dialog(
      backgroundColor: EasyTheme.of(context).background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(easyTheme.cornerMedium),
      ),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: () {
            final child = Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: bodyBottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: resolvedTitleTextStyle),
                  const SizedBox(height: 24),
                  Flexible(
                    child: DefaultTextStyle(
                      style: resolvedBodyTextStyle,
                      child: body,
                    ),
                  ),
                ],
              ),
            );
            if (actions == null) return [child];
            return [Flexible(child: child), actions];
          }(),
        ),
      ),
    );
  }
}
