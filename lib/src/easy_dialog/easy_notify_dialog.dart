import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../easy_theme.dart';
import 'easy_dialog_size.dart';

Future<T?> showEasyNotifyDialog<T>({
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
    barrierLabel: "Dialog",
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

class EasyNotifyDialog extends StatelessWidget {
  const EasyNotifyDialog({
    super.key,
    this.size = EasyDialogSize.small,
    required this.icon,
    required this.title,
    required this.body,
    this.actions,
    this.showActionsDividerLine = false,
  });

  final EasyDialogSize size;
  final Widget icon;
  final String title;
  final Widget body;
  final Widget? actions;
  final bool showActionsDividerLine;

  factory EasyNotifyDialog.withTwoActions({
    EasyDialogSize size = EasyDialogSize.small,
    required Widget icon,
    required String title,
    required Widget body,
    required Widget leftAction,
    required Widget rightAction,
    bool showActionsDividerLine = false,
  }) {
    return EasyNotifyDialog(
      size: size,
      icon: icon,
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
    );
  }

  factory EasyNotifyDialog.alert({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required String confirmButtonText,
    required String cancelButtonText,
    VoidCallback? onConfirmButtonPressed,
    VoidCallback? onCancelButtonPressed,
  }) {
    return EasyNotifyDialog(
      size: size,
      icon: SvgPicture.asset(
        'assets/svgs/ic_warning.svg',
        package: 'easy_ui',
        width: 50,
        height: 50,
      ),
      title: title,
      body: body,
      actions: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, bottom: 24),
        child: Row(
          spacing: 16,
          children: [
            Expanded(
              child: EasyNotifyDialogOutlinedButton(
                text: cancelButtonText,
                onPressed: onCancelButtonPressed,
              ),
            ),
            Expanded(
              child: EasyNotifyDialogElevatedButton(
                text: confirmButtonText,
                onPressed: onConfirmButtonPressed,
              ),
            ),
          ],
        ),
      ),
      showActionsDividerLine: false,
    );
  }

  factory EasyNotifyDialog.alertWithSingleButton({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return EasyNotifyDialog(
      size: size,
      icon: SvgPicture.asset(
        'assets/svgs/ic_warning.svg',
        package: 'easy_ui',
        width: 50,
        height: 50,
      ),
      title: title,
      body: body,
      actions: EasyNotifyDialogTextButton(
        text: buttonText,
        onPressed: onButtonPressed,
      ),
      showActionsDividerLine: false,
    );
  }

  factory EasyNotifyDialog.warnWithSingleButton({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return EasyNotifyDialog(
      size: size,
      icon: SvgPicture.asset(
        'assets/svgs/ic_warning_triangle.svg',
        package: 'easy_ui',
        width: 50,
        height: 50,
      ),
      title: title,
      body: body,
      actions: EasyNotifyDialogTextButton(
        text: buttonText,
        onPressed: onButtonPressed,
      ),
      showActionsDividerLine: false,
    );
  }

  factory EasyNotifyDialog.successWithSingleButton({
    EasyDialogSize size = EasyDialogSize.small,
    required String title,
    required Widget body,
    required String buttonText,
    VoidCallback? onButtonPressed,
  }) {
    return EasyNotifyDialog(
      size: size,
      icon: SvgPicture.asset(
        'assets/svgs/ic_success.svg',
        package: 'easy_ui',
        width: 50,
        height: 50,
      ),
      title: title,
      body: body,
      actions: EasyNotifyDialogTextButton(
        text: buttonText,
        onPressed: onButtonPressed,
      ),
      showActionsDividerLine: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final width = size.width;

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
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon,
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, color: easyTheme.neutral33),
                  ),
                  const SizedBox(height: 24),
                  Flexible(
                    child: DefaultTextStyle(
                      style: Theme.of(context).primaryTextTheme.bodyMedium!
                          .copyWith(fontSize: 14, color: easyTheme.neutral99),
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

class EasyNotifyDialogTextButton extends StatelessWidget {
  const EasyNotifyDialogTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.textStyle,
    this.height,
  });

  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size(double.infinity, height ?? 58),
        fixedSize: Size(double.infinity, height ?? 58),
        maximumSize: Size.fromWidth(double.infinity),
        shape: RoundedRectangleBorder(),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: easyTheme.secondaryBlue,
        ).merge(textStyle),
      ),
    );
  }
}

class EasyNotifyDialogOutlinedButton extends StatelessWidget {
  const EasyNotifyDialogOutlinedButton({
    super.key,
    this.onPressed,
    required this.text,
    this.textStyle,
    this.height,
  });

  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: EasyTheme.of(context).background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
          side: BorderSide(color: easyTheme.neutralEE),
        ),
        minimumSize: Size(double.infinity, height ?? 34),
        fixedSize: Size(double.infinity, height ?? 34),
        maximumSize: Size.fromWidth(double.infinity),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: easyTheme.neutral66,
        ).merge(textStyle),
      ),
    );
  }
}

class EasyNotifyDialogElevatedButton extends StatelessWidget {
  const EasyNotifyDialogElevatedButton({
    super.key,
    this.onPressed,
    this.textWidget,
    required this.text,
    this.textStyle,
    this.height,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget? textWidget;
  final TextStyle? textStyle;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: easyTheme.primaryGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(easyTheme.cornerSmall),
        ),
        minimumSize: Size(double.infinity, height ?? 34),
        fixedSize: Size(double.infinity, height ?? 34),
        maximumSize: Size.fromWidth(double.infinity),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child:
          textWidget ??
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ).merge(textStyle),
          ),
    );
  }
}
