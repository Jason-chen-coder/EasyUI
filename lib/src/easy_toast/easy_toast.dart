import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'toastification/toastification.dart';
import 'dart:async';

class EasyToastWrapper extends StatelessWidget {
  const EasyToastWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: ToastificationConfig(maxToastLimit: 3, itemWidth: 560),
      child: child,
    );
  }
}

class _HoverableToastWidget extends StatefulWidget {
  final String text;
  final Color? backgroundColor;
  final Widget? icon;
  final ToastificationItem toastItem;
  final Duration? autoCloseDuration;

  const _HoverableToastWidget({
    required this.text,
    required this.backgroundColor,
    required this.icon,
    required this.toastItem,
    this.autoCloseDuration,
  });

  @override
  State<_HoverableToastWidget> createState() => _HoverableToastWidgetState();
}

class _HoverableToastWidgetState extends State<_HoverableToastWidget> {
  bool isHovered = false;
  Timer? autoCloseTimer;

  @override
  void initState() {
    super.initState();
    // Start the auto-close timer
    startAutoCloseTimer();
  }

  @override
  void dispose() {
    autoCloseTimer?.cancel();
    super.dispose();
  }

  void startAutoCloseTimer() {
    // Only start timer if not hovered
    if (!isHovered) {
      autoCloseTimer?.cancel();
      autoCloseTimer = Timer(
        widget.autoCloseDuration ?? const Duration(seconds: 3),
        () {
          if (!isHovered) {
            toastification.dismiss(widget.toastItem);
          }
        },
      );
    }
  }

  void pauseAutoCloseTimer() {
    autoCloseTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
        pauseAutoCloseTimer();
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
        // Restart timer when user stops hovering
        startAutoCloseTimer();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(maxWidth: 560, minHeight: 46),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: StadiumBorder(),
        ),
        foregroundDecoration: ShapeDecoration(
          color: widget.backgroundColor,
          shape: StadiumBorder(),
        ),
        padding: EdgeInsets.only(left: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon != null)
              Padding(
                padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: widget.icon!,
              ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Tooltip(
                  message: widget.text,
                  child: Text(
                    widget.text,
                    style: TextStyle(color: Color(0xFF333333), fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 15, left: 23),
              child: IconButton(
                style: IconButton.styleFrom(
                  minimumSize: Size.square(32),
                  fixedSize: Size.square(32),
                  maximumSize: Size.square(32),
                ),
                onPressed: () {
                  toastification.dismiss(widget.toastItem);
                },
                icon: Icon(Icons.close, color: Color(0xFF666666), size: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showToast({
  required String text,
  required Color? backgroundColor,
  required Widget? icon,
  Alignment? alignment,
  Duration? autoCloseDuration,
}) {
  toastification.showCustom(
    alignment: alignment ?? Alignment.topCenter,
    autoCloseDuration: null, // Disable built-in auto close
    builder: (context, toastItem) {
      return _HoverableToastWidget(
        text: text,
        backgroundColor: backgroundColor,
        icon: icon,
        toastItem: toastItem,
        autoCloseDuration: autoCloseDuration,
      );
    },
  );
}

void showToastError({
  String? text,
  Alignment? alignment,
  Duration? autoCloseDuration,
}) {
  _showToast(
    text: text ?? '',
    backgroundColor: Color(0x1FFF4249),
    icon: SvgPicture.asset(
      'assets/svgs/ic_warning_triangle.svg',
      width: 30,
      height: 30,
      package: 'easy_ui',
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
  );
}

void showToastWarning({
  String? text,
  Alignment? alignment,
  Duration? autoCloseDuration,
}) {
  _showToast(
    text: text ?? '',
    backgroundColor: Color(0x1FF4BE59),
    icon: SvgPicture.asset(
      'assets/svgs/ic_warning.svg',
      width: 30,
      height: 30,
      package: 'easy_ui',
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
  );
}

void showToastInfo({
  String? text,
  Alignment? alignment,
  Duration? autoCloseDuration,
}) {
  _showToast(
    text: text ?? '',
    backgroundColor: Color(0x1F1484FC),
    icon: SvgPicture.asset(
      'assets/svgs/ic_ringtone.svg',
      width: 30,
      height: 30,
      package: 'easy_ui',
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
  );
}

void showToastOk({
  String? text,
  Alignment? alignment,
  Duration? autoCloseDuration,
}) {
  _showToast(
    text: text ?? '',
    backgroundColor: Color(0x1F31DA9F),
    icon: SvgPicture.asset(
      'assets/svgs/ic_success.svg',
      width: 30,
      height: 30,
      package: 'easy_ui',
    ),
    autoCloseDuration: autoCloseDuration,
    alignment: alignment,
  );
}
