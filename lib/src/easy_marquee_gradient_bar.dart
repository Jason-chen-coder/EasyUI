
import 'package:flutter/cupertino.dart';

class EasyMarqueeGradientBar extends StatefulWidget {
  const EasyMarqueeGradientBar({
    super.key,
    this.height = 18.0,
    this.width = double.infinity,
    this.backgroundColor = const Color(0xFFDDF8F2),
    this.barColor = const Color(0xFF3CDAA2),
    this.duration = const Duration(milliseconds: 1500),
  });

  final double height;
  final double width;
  final Color backgroundColor;
  final Color barColor;
  final Duration duration;

  @override
  State<EasyMarqueeGradientBar> createState() => EasyMarqueeGradientBarState();
}

class EasyMarqueeGradientBarState extends State<EasyMarqueeGradientBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double actualWidth =
            widget.width == double.infinity
                ? constraints.maxWidth
                : widget.width;
        final double barWidth = actualWidth * 0.7;
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.height / 2),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double x =
                    (actualWidth + barWidth) * _controller.value - barWidth;
                return Stack(
                  children: [
                    Container(color: widget.backgroundColor),
                    Positioned(
                      left: x,
                      top: 0,
                      child: Container(
                        width: barWidth,
                        height: widget.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            widget.height / 2,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              widget.barColor.withOpacity(0.01),
                              widget.barColor,
                            ],
                            stops: const [0.1, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
