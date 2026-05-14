import 'package:flutter/material.dart';
import '../easy_theme.dart';
import 'easy_range_slider_thumb_shape.dart';

class EasyRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final ValueChanged<RangeValues>? onChangeStart;
  final ValueChanged<RangeValues>? onChangeEnd;
  final double min;
  final double max;
  final int? divisions;
  final RangeLabels? labels;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? thumbColor;
  final double? thumbRadius;
  final MouseCursor? mouseCursor;
  final double? trackHeight;
  final Color? overlayColor;
  final RangeSliderValueIndicatorShape? valueIndicatorShape;
  final ShowValueIndicator? showValueIndicator;
  final bool? year2023;

  const EasyRangeSlider({
    super.key,
    required this.values,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.labels,
    this.activeColor,
    this.inactiveColor,
    this.thumbColor,
    this.thumbRadius,
    this.mouseCursor,
    this.trackHeight,
    this.overlayColor,
    this.valueIndicatorShape,
    this.showValueIndicator,
    this.year2023,
  });

  @override
  Widget build(BuildContext context) {
    // Access EasyTheme to get design tokens
    final easyTheme = EasyTheme.of(context);
    final themeData = Theme.of(context);

    // Determine colors based on theme if not provided
    final effectiveActiveColor = activeColor ?? easyTheme.primaryGreen;
    final effectiveInactiveColor = inactiveColor ?? easyTheme.neutralF8;
    // Update default thumb color to be the active color, so the custom shape can use it for the inner circle
    // and derive the outer opacity. Unless user explicitly overrides it.
    final effectiveThumbColor = thumbColor ?? effectiveActiveColor;

    final effectiveTrackHeight = trackHeight ?? 13.0;
    // Default thumb diameter is 1.5 * trackHeight. Radius = 0.75 * trackHeight.
    final double defaultThumbRadius = effectiveTrackHeight * 1.0;

    // Helper to format values
    String formatValue(double v) {
      if (v == v.roundToDouble()) {
        return v.round().toString();
      }
      return v.toStringAsFixed(1);
    }

    // Calculate alignment for liquid value label
    // Map value (min...max) to alignment (-1.0...1.0)
    final double safeMax = max > min ? max : min + 1.0;

    double getAlignmentX(double v) {
      final double percent = (v - min) / (safeMax - min);
      return -1.0 + 2.0 * percent.clamp(0.0, 1.0);
    }

    final startAlignmentX = getAlignmentX(values.start);
    final endAlignmentX = getAlignmentX(values.end);

    final labelStyle = TextStyle(
      color: easyTheme.neutral99,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: themeData.sliderTheme.copyWith(
            // 建议显式 opt-in 新外观（同时也符合弃用提示）
            year2023: year2023 ?? false,
            activeTrackColor: effectiveActiveColor,
            inactiveTrackColor: effectiveInactiveColor,
            thumbColor: effectiveThumbColor,
            overlayColor:
                overlayColor ?? effectiveActiveColor.withOpacity(0.12),
            trackHeight: effectiveTrackHeight,
            // Customize thumb shape if needed, using default for now but ensuring it looks 'Easy' style
            // heavily rounded and clean.
            rangeThumbShape: EasyRangeSliderThumbShape(
              enabledThumbRadius: thumbRadius ?? defaultThumbRadius,
            ),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
            rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
              tickMarkRadius: 0,
            ), // Hide ticks by default or make them small
            rangeValueIndicatorShape:
                valueIndicatorShape ??
                const PaddleRangeSliderValueIndicatorShape(),
            showValueIndicator: showValueIndicator ?? ShowValueIndicator.never,
            valueIndicatorColor: effectiveActiveColor,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
            rangeTrackShape: const _EasyRangeSliderTrackShape(),
          ),
          child: RangeSlider(
            values: values,
            onChanged: onChanged,
            onChangeStart: onChangeStart,
            onChangeEnd: onChangeEnd,
            min: min,
            max: max,
            divisions: divisions,
            labels: labels,
            activeColor: effectiveActiveColor,
            inactiveColor: effectiveInactiveColor,
          ),
        ),
        // Label Row
        SizedBox(
          height: 20,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(formatValue(min), style: labelStyle),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(formatValue(max), style: labelStyle),
              ),
              // Start Value
              Align(
                alignment: Alignment(startAlignmentX, 0.0),
                child: Text(
                  labels?.start ?? formatValue(values.start),
                  style: labelStyle.copyWith(color: effectiveActiveColor),
                ),
              ),
              // End Value
              Align(
                alignment: Alignment(endAlignmentX, 0.0),
                child: Text(
                  labels?.end ?? formatValue(values.end),
                  style: labelStyle.copyWith(color: effectiveActiveColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EasyRangeSliderTrackShape extends RoundedRectRangeSliderTrackShape {
  const _EasyRangeSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
