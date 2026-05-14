import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 径向进度指示器的样式配置
class EasyRadialProgressIndicatorStyle {
  const EasyRadialProgressIndicatorStyle({
    this.outerRingWidth = 5,
    this.trackWidth = 50,
    this.tickWidth = 5,
    this.tickHeight = 18,
    this.dotOuterSize = 32,
    this.dotInnerSize = 25,
    this.outerRingGradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFFDA3131), Color(0xFFF06D4C)],
    ),
    this.trackOpacity = 0.2,
    this.tickActiveColor = const Color(0xFFFB3F40),
    this.tickActiveMinOpacity = 0.3,
    this.tickInactiveColor,
    this.dotOuterColor,
    this.dotInnerGradient = const LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFFDA3131), Color(0xFFF06D4C)],
    ),
    this.valueColor = const Color(0xFFF93F40),
    this.totalColor = const Color(0xFFAAAAAA),
  });

  /// 红色主题（默认）
  factory EasyRadialProgressIndicatorStyle.red() {
    return const EasyRadialProgressIndicatorStyle();
  }

  /// 蓝色主题
  factory EasyRadialProgressIndicatorStyle.blue() {
    return const EasyRadialProgressIndicatorStyle(
      outerRingGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF3175DA), Color(0xFF4CCDF0)],
      ),
      tickActiveColor: Color(0xFF3F6FFB),
      dotInnerGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF3155DA), Color(0xFF4C8CF0)],
      ),
      valueColor: Color(0xFF3F6FFB),
    );
  }

  /// 绿色主题
  factory EasyRadialProgressIndicatorStyle.green() {
    return const EasyRadialProgressIndicatorStyle(
      outerRingGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF31DA9F), Color(0xFF4CCDF0)],
      ),
      tickActiveColor: Color(0xFF31DA6F),
      dotInnerGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF28B55A), Color(0xFF4CF08A)],
      ),
      valueColor: Color(0xFF31DA6F),
    );
  }

  /// 橙色主题
  factory EasyRadialProgressIndicatorStyle.orange() {
    return const EasyRadialProgressIndicatorStyle(
      outerRingGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFFDA7731), Color(0xFFF0D04C)],
      ),
      tickActiveColor: Color(0xFFFB8E3F),
      dotInnerGradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFFDA7A31), Color(0xFFF0964C)],
      ),
      valueColor: Color(0xFFFB8E3F),
    );
  }

  // ========== 尺寸 ==========

  /// 最外层实心圆环宽度（基于 326 基准）
  final double outerRingWidth;

  /// 轨道圆环宽度
  final double trackWidth;

  /// 刻度线宽度
  final double tickWidth;

  /// 刻度线高度
  final double tickHeight;

  /// 圆形指示器外圆直径
  final double dotOuterSize;

  /// 圆形指示器内圆直径
  final double dotInnerSize;

  // ========== 最外层实心圆环 ==========

  /// 最外层圆环渐变
  final LinearGradient outerRingGradient;

  // ========== 轨道圆环 ==========

  /// 轨道透明度（基于最外层圆环颜色）
  final double trackOpacity;

  // ========== 刻度线 ==========

  /// 高亮刻度颜色
  final Color tickActiveColor;

  /// 高亮刻度起始透明度（第一个刻度），结束刻度为完全不透明
  final double tickActiveMinOpacity;

  /// 未高亮刻度颜色（null 时亮色模式白色，暗色模式 #08121F）
  final Color? tickInactiveColor;

  // ========== 圆形指示器 ==========

  /// 指示器外圆颜色（null 时亮色模式白色，暗色模式 #08121F）
  final Color? dotOuterColor;

  /// 指示器内圆渐变
  final LinearGradient dotInnerGradient;

  // ========== 文本 ==========

  /// 当前值文本颜色
  final Color valueColor;

  /// 总值文本颜色
  final Color totalColor;

  EasyRadialProgressIndicatorStyle copyWith({
    double? outerRingWidth,
    double? trackWidth,
    double? tickWidth,
    double? tickHeight,
    double? dotOuterSize,
    double? dotInnerSize,
    LinearGradient? outerRingGradient,
    double? trackOpacity,
    Color? tickActiveColor,
    double? tickActiveMinOpacity,
    Color? tickInactiveColor,
    Color? dotOuterColor,
    LinearGradient? dotInnerGradient,
    Color? valueColor,
    Color? totalColor,
  }) {
    return EasyRadialProgressIndicatorStyle(
      outerRingWidth: outerRingWidth ?? this.outerRingWidth,
      trackWidth: trackWidth ?? this.trackWidth,
      tickWidth: tickWidth ?? this.tickWidth,
      tickHeight: tickHeight ?? this.tickHeight,
      dotOuterSize: dotOuterSize ?? this.dotOuterSize,
      dotInnerSize: dotInnerSize ?? this.dotInnerSize,
      outerRingGradient: outerRingGradient ?? this.outerRingGradient,
      trackOpacity: trackOpacity ?? this.trackOpacity,
      tickActiveColor: tickActiveColor ?? this.tickActiveColor,
      tickActiveMinOpacity: tickActiveMinOpacity ?? this.tickActiveMinOpacity,
      tickInactiveColor: tickInactiveColor ?? this.tickInactiveColor,
      dotOuterColor: dotOuterColor ?? this.dotOuterColor,
      dotInnerGradient: dotInnerGradient ?? this.dotInnerGradient,
      valueColor: valueColor ?? this.valueColor,
      totalColor: totalColor ?? this.totalColor,
    );
  }
}

class EasyRadialProgressIndicator extends StatefulWidget {
  const EasyRadialProgressIndicator({
    super.key,
    required this.value,
    required this.total,
    this.size = 326,
    this.tickCount = 80,
    this.style = const EasyRadialProgressIndicatorStyle(),
    this.valueTextStyle,
    this.totalTextStyle,
    this.startAngle = -math.pi / 2,
    this.gapAngle,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeInOut,
    this.child,
  });

  /// 当前值
  final double value;

  /// 总值
  final double total;

  /// 组件尺寸
  final double size;

  /// 刻度数量
  final int tickCount;

  /// 样式配置
  final EasyRadialProgressIndicatorStyle style;

  /// 当前值文本样式（覆盖 style 中的 valueColor）
  final TextStyle? valueTextStyle;

  /// 总值文本样式（覆盖 style 中的 totalColor）
  final TextStyle? totalTextStyle;

  /// 起始角度（弧度），默认 -pi/2（12点方向）
  final double startAngle;

  /// 缺口角度（弧度），null 则闭合，不为 null 则底部开口
  final double? gapAngle;

  /// 动画时长
  final Duration animationDuration;

  /// 动画曲线
  final Curve animationCurve;

  /// 自定义中心内容
  final Widget? child;

  @override
  State<EasyRadialProgressIndicator> createState() =>
      _EasyRadialProgressIndicatorState();
}

class _EasyRadialProgressIndicatorState
    extends State<EasyRadialProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _valueAnimation;

  /// 颜色过渡：old style → new style
  EasyRadialProgressIndicatorStyle? _oldStyle;
  bool _isStyleAnimating = false;

  static const double _kBaseSize = 326;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    final targetProgress =
        widget.total > 0 ? (widget.value / widget.total).clamp(0.0, 1.0) : 0.0;

    _progressAnimation = Tween<double>(begin: 0.0, end: targetProgress).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    _valueAnimation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(EasyRadialProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    final valueChanged =
        oldWidget.value != widget.value || oldWidget.total != widget.total;
    final styleChanged = oldWidget.style != widget.style;

    if (!valueChanged && !styleChanged) return;

    final oldProgress = _progressAnimation.value;
    final oldValue = _valueAnimation.value;
    final newProgress =
        widget.total > 0 ? (widget.value / widget.total).clamp(0.0, 1.0) : 0.0;

    _controller.duration = widget.animationDuration;

    _progressAnimation = Tween<double>(
      begin: valueChanged ? oldProgress : newProgress,
      end: newProgress,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    _valueAnimation = Tween<double>(
      begin: valueChanged ? oldValue : widget.value,
      end: widget.value,
    ).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    if (styleChanged) {
      _oldStyle = oldWidget.style;
      _isStyleAnimating = true;
    }

    _controller
      ..reset()
      ..forward().then((_) {
        if (_isStyleAnimating && mounted) {
          setState(() {
            _isStyleAnimating = false;
            _oldStyle = null;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// null 时根据亮暗模式返回白色或 #08121F
  Color _resolveColor(BuildContext context, Color? color) {
    if (color != null) return color;
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF08121F)
        : Colors.white;
  }

  /// 在两个 LinearGradient 之间插值
  LinearGradient _lerpGradient(LinearGradient a, LinearGradient b, double t) {
    return LinearGradient(
      begin: Alignment.lerp(a.begin as Alignment, b.begin as Alignment, t)!,
      end: Alignment.lerp(a.end as Alignment, b.end as Alignment, t)!,
      colors: [
        for (int i = 0; i < a.colors.length && i < b.colors.length; i++)
          Color.lerp(a.colors[i], b.colors[i], t)!,
      ],
    );
  }

  /// 在两个 style 之间插值
  EasyRadialProgressIndicatorStyle _lerpStyle(
    EasyRadialProgressIndicatorStyle a,
    EasyRadialProgressIndicatorStyle b,
    double t,
  ) {
    return EasyRadialProgressIndicatorStyle(
      outerRingGradient: _lerpGradient(
        a.outerRingGradient,
        b.outerRingGradient,
        t,
      ),
      trackOpacity: a.trackOpacity + (b.trackOpacity - a.trackOpacity) * t,
      tickActiveColor: Color.lerp(a.tickActiveColor, b.tickActiveColor, t)!,
      tickActiveMinOpacity:
          a.tickActiveMinOpacity +
          (b.tickActiveMinOpacity - a.tickActiveMinOpacity) * t,
      dotInnerGradient: _lerpGradient(
        a.dotInnerGradient,
        b.dotInnerGradient,
        t,
      ),
      valueColor: Color.lerp(a.valueColor, b.valueColor, t)!,
      totalColor: Color.lerp(a.totalColor, b.totalColor, t)!,
      // 尺寸保持目标值
      outerRingWidth: b.outerRingWidth,
      trackWidth: b.trackWidth,
      tickWidth: b.tickWidth,
      tickHeight: b.tickHeight,
      dotOuterSize: b.dotOuterSize,
      dotInnerSize: b.dotInnerSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sweepAngle = 2 * math.pi - (widget.gapAngle ?? 0);
    final effectiveStartAngle =
        widget.gapAngle != null
            ? math.pi / 2 + widget.gapAngle! / 2
            : widget.startAngle;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final currentStyle =
            (_isStyleAnimating && _oldStyle != null)
                ? _lerpStyle(_oldStyle!, widget.style, _controller.value)
                : widget.style;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RadialProgressPainter(
              progress: _progressAnimation.value,
              tickCount: widget.tickCount,
              style: currentStyle,
              tickInactiveColor: _resolveColor(
                context,
                widget.style.tickInactiveColor,
              ),
              dotOuterColor: _resolveColor(context, widget.style.dotOuterColor),
              startAngle: effectiveStartAngle,
              sweepAngle: sweepAngle,
              scale: widget.size / _kBaseSize,
            ),
            child: Center(
              child:
                  widget.child ??
                  _buildDefaultCenter(
                    context,
                    _valueAnimation.value,
                    currentStyle,
                  ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDefaultCenter(
    BuildContext context,
    double displayValue,
    EasyRadialProgressIndicatorStyle currentStyle,
  ) {
    final scale = widget.size / _kBaseSize;
    final effectiveValueStyle =
        widget.valueTextStyle ??
        TextStyle(
          fontSize: 60 * scale,
          fontWeight: FontWeight.bold,
          color: currentStyle.valueColor,
          height: 1.2,
        );
    final effectiveTotalStyle =
        widget.totalTextStyle ??
        TextStyle(
          fontSize: 30 * scale,
          color: currentStyle.totalColor,
          height: 1.2,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(displayValue.toInt().toString(), style: effectiveValueStyle),
        Text('/ ${widget.total.toInt()}', style: effectiveTotalStyle),
      ],
    );
  }
}

class _RadialProgressPainter extends CustomPainter {
  _RadialProgressPainter({
    required this.progress,
    required this.tickCount,
    required this.style,
    required this.tickInactiveColor,
    required this.dotOuterColor,
    required this.startAngle,
    required this.sweepAngle,
    required this.scale,
  });

  final double progress;
  final int tickCount;
  final EasyRadialProgressIndicatorStyle style;
  final Color tickInactiveColor;
  final Color dotOuterColor;
  final double startAngle;
  final double sweepAngle;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;

    final outerRingWidth = style.outerRingWidth * scale;
    final trackWidth = style.trackWidth * scale;
    final tickWidth = style.tickWidth * scale;
    final tickHeight = style.tickHeight * scale;
    final dotOuterSize = style.dotOuterSize * scale;
    final dotInnerSize = style.dotInnerSize * scale;

    // ========== 最外层实心圆环 ==========
    final outerRingRadius = outerRadius - outerRingWidth / 2;
    final outerRingPaint =
        Paint()
          ..shader = style.outerRingGradient.createShader(
            Rect.fromCircle(center: center, radius: outerRingRadius),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerRingWidth
          ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRingRadius),
      startAngle,
      sweepAngle,
      false,
      outerRingPaint,
    );

    // ========== 轨道圆环 ==========
    final trackOuterRadius = outerRadius - outerRingWidth;
    final trackInnerRadius = trackOuterRadius - trackWidth;
    final trackCenterRadius = (trackOuterRadius + trackInnerRadius) / 2;

    // 轨道颜色：取最外层圆环渐变的中间色，带 trackOpacity 透明度
    final trackColors = style.outerRingGradient.colors;
    final trackColor = Color.lerp(
      trackColors.first,
      trackColors.last,
      0.5,
    )!.withValues(alpha: style.trackOpacity);
    final trackBgPaint =
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth;

    canvas.drawCircle(center, trackCenterRadius, trackBgPaint);

    // ========== 刻度线 ==========
    final tickGapAngle = sweepAngle / tickCount;
    final activeTickCount = (progress * tickCount).ceil();
    final tickOuterRadius2 = trackCenterRadius + tickHeight / 2;
    final tickInnerRadius2 = trackCenterRadius - tickHeight / 2;

    for (int i = 0; i < tickCount; i++) {
      final angle = startAngle + tickGapAngle * i + tickGapAngle / 2;
      final isActive = i < activeTickCount;

      final Color tickColor;
      if (isActive && activeTickCount > 0) {
        // 透明度从 tickActiveMinOpacity 渐变到 1.0
        final t = activeTickCount > 1 ? i / (activeTickCount - 1) : 1.0;
        final opacity =
            style.tickActiveMinOpacity + (1.0 - style.tickActiveMinOpacity) * t;
        tickColor = style.tickActiveColor.withValues(alpha: opacity);
      } else {
        tickColor = tickInactiveColor;
      }

      final paint =
          Paint()
            ..color = tickColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = tickWidth
            ..strokeCap = StrokeCap.butt;

      final outerPoint = Offset(
        center.dx + tickOuterRadius2 * math.cos(angle),
        center.dy + tickOuterRadius2 * math.sin(angle),
      );
      final innerPoint = Offset(
        center.dx + tickInnerRadius2 * math.cos(angle),
        center.dy + tickInnerRadius2 * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, paint);
    }

    // ========== 圆形指示器 ==========
    if (progress > 0 && progress <= 1.0) {
      final dotAngle = startAngle + sweepAngle * progress;
      final dotCenter = Offset(
        center.dx + trackCenterRadius * math.cos(dotAngle),
        center.dy + trackCenterRadius * math.sin(dotAngle),
      );

      // 外圆
      final dotOuterPaint =
          Paint()
            ..color = dotOuterColor
            ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, dotOuterSize / 2, dotOuterPaint);

      // 内圆
      final dotInnerRadius = dotInnerSize / 2;
      final dotInnerPaint =
          Paint()
            ..shader = style.dotInnerGradient.createShader(
              Rect.fromCircle(center: dotCenter, radius: dotInnerRadius),
            )
            ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, dotInnerRadius, dotInnerPaint);
    }
  }

  @override
  bool shouldRepaint(_RadialProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.tickCount != tickCount ||
        oldDelegate.style != style ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.scale != scale;
  }
}
