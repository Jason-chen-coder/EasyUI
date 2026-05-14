import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'easy_theme.dart';

class EasyLinearProgressIndicator extends StatelessWidget {
  const EasyLinearProgressIndicator({
    super.key,
    required this.progress,
    this.height = 18.0,
    this.width = double.infinity,
    this.progressTextInActiveStyle,
    this.progressTextInPassiveStyle,
    this.activeBackgroundColor,
    this.passiveBackgroundColor,
    this.showProgressText = true,
    this.marqueeDuration = const Duration(milliseconds: 1500),
  });

  factory EasyLinearProgressIndicator.blue({
    required double progress,
    double height = 12.0,
    double width = double.infinity,
    bool showProgressText = true,
  }) {
    return EasyLinearProgressIndicator(
      progress: progress,
      height: height,
      width: width,
      showProgressText: showProgressText,
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF8D8C8D),
      ),
      activeBackgroundColor: const Color(0xFF1484FC),
    );
  }

  factory EasyLinearProgressIndicator.amber({
    required double progress,
    double height = 12.0,
    double width = double.infinity,
    bool showProgressText = true,
  }) {
    return EasyLinearProgressIndicator(
      progress: progress,
      height: height,
      width: width,
      showProgressText: showProgressText,
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF8D8C8D),
      ),
      activeBackgroundColor: const Color(0xFFF4BE59),
    );
  }

  factory EasyLinearProgressIndicator.red({
    required double progress,
    double height = 12.0,
    double width = double.infinity,
    bool showProgressText = true,
  }) {
    return EasyLinearProgressIndicator(
      progress: progress,
      height: height,
      width: width,
      showProgressText: showProgressText,
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF8D8C8D),
      ),
      activeBackgroundColor: const Color(0xFFFF2728),
    );
  }

  factory EasyLinearProgressIndicator.green({
    required double progress,
    double height = 12.0,
    double width = double.infinity,
    bool showProgressText = true,
  }) {
    return EasyLinearProgressIndicator(
      progress: progress,
      height: height,
      width: width,
      showProgressText: showProgressText,
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 12,
        color: Color(0xFF8D8C8D),
      ),
      activeBackgroundColor: const Color(0xFF31DA9F),
    );
  }

  /// 进度
  final double progress;

  /// 高度
  final double height;

  /// 宽度
  final double width;

  /// 百分比文本在已完成背景样式
  final TextStyle? progressTextInActiveStyle;

  /// 百分比文本在未完成背景样式
  final TextStyle? progressTextInPassiveStyle;

  /// 已完成背景色
  final Color? activeBackgroundColor;

  /// 未完成背景色
  final Color? passiveBackgroundColor;

  /// 跑马灯动画时长
  final Duration marqueeDuration;

  /// 是否显示进度文本
  final bool showProgressText;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    final activeBackgroundColor =
        this.activeBackgroundColor ?? easyTheme.primaryGreen;
    final passiveBackgroundColor =
        this.passiveBackgroundColor ?? EasyTheme.of(context).background;
    final progressTextInActiveStyle =
        this.progressTextInActiveStyle ??
        TextStyle(fontSize: 12, color: EasyTheme.of(context).background);
    final progressTextInPassiveStyle =
        this.progressTextInPassiveStyle ??
        TextStyle(fontSize: 12, color: easyTheme.termination);

    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: passiveBackgroundColor,
      ),
      child: CustomPaint(
        painter: EasyLinearProgressIndicatorPainter(
          showProgressText: showProgressText,
          progress: progress,
          progressTextStyleInActive: progressTextInActiveStyle,
          progressTextStyleInPassive: progressTextInPassiveStyle,
          activeColor: activeBackgroundColor,
        ),
      ),
    );
  }
}

class EasyLinearProgressIndicatorPainter extends CustomPainter {
  const EasyLinearProgressIndicatorPainter({
    required this.showProgressText,
    required this.progress,
    required this.progressTextStyleInActive,
    required this.progressTextStyleInPassive,
    required this.activeColor,
  });

  final bool showProgressText;
  final double progress;
  final TextStyle progressTextStyleInActive;
  final TextStyle progressTextStyleInPassive;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    final paint =
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill;

    final activeWidth = clampedProgress * size.width;
    final radius = size.height / 2;
    if (activeWidth < radius) {
      final rectHeight =
          math.sqrt(math.pow(radius, 2) - math.pow(radius - activeWidth, 2)) *
          2;
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, activeWidth, rectHeight),
          topLeft: Radius.circular(rectHeight / 2),
          bottomLeft: Radius.circular(rectHeight / 2),
        ),
        paint,
      );
    } else {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, activeWidth, size.height),
          Radius.circular(radius),
        ),
        paint,
      );
    }
    if (showProgressText) {
      const textPadding = 16.0;
      var textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
          text: '${(clampedProgress * 100).toStringAsFixed(0)}%',
          style: progressTextStyleInActive,
        ),
      )..layout();

      if (activeWidth < textPadding + textPainter.width) {
        textPainter = TextPainter(
          textDirection: TextDirection.ltr,
          text: TextSpan(
            text: '${(clampedProgress * 100).toStringAsFixed(0)}%',
            style: progressTextStyleInPassive,
          ),
        )..layout();
      }

      textPainter.paint(
        canvas,
        Offset(
          (size.width * clampedProgress - textPainter.width - textPadding)
              .clamp(textPadding, size.width - textPadding),
          (size.height - textPainter.height) / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(EasyLinearProgressIndicatorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressTextStyleInActive != progressTextStyleInActive ||
        oldDelegate.progressTextStyleInPassive != progressTextStyleInPassive ||
        oldDelegate.activeColor != activeColor;
  }
}
