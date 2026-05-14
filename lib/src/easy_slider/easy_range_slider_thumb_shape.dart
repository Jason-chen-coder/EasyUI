import 'package:flutter/material.dart';

class EasyRangeSliderThumbShape extends RangeSliderThumbShape {
  final double enabledThumbRadius;
  final double? innerThumbRadius;

  const EasyRangeSliderThumbShape({
    this.enabledThumbRadius = 10.0,
    this.innerThumbRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    // Use thumbColor from theme for the base color.
    // We expect the parent EasyRangeSlider to pass the primary color (or configured thumbColor) here.
    final Color color = sliderTheme.thumbColor ?? Colors.blue;

    // Outer circle: 20% opacity
    final Paint outerPaint =
        Paint()
          ..color = color.withOpacity(0.20)
          ..style = PaintingStyle.fill;

    // Inner circle: 100% opacity
    final Paint innerPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // Draw Outer Circle Background (White)
    final Paint whitePaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, whitePaint);

    // Draw Outer Circle
    canvas.drawCircle(center, enabledThumbRadius, outerPaint);

    // Draw Inner Circle
    // Default inner radius to half of the outer radius if not specified
    final double innerRadius = innerThumbRadius ?? (enabledThumbRadius / 2.0);
    canvas.drawCircle(center, innerRadius, innerPaint);
  }
}
