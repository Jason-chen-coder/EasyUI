import 'package:flutter/material.dart';

class EasyColorIndicator extends StatelessWidget {
  const EasyColorIndicator({
    super.key,
    required this.height,
    required this.width,
    required this.color,
  });

  final double height;
  final double width;
  final HSVColor color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.0)),
      child: CustomPaint(painter: _IndicatorPainter(color.toColor())),
    );
  }
}

/// Painter for chess type alpha background in color indicator widget.
class _IndicatorPainter extends CustomPainter {
  const _IndicatorPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Size chessSize = Size(size.width / 10, size.height / 10);
    final Paint chessPaintB = Paint()..color = const Color(0xFFCCCCCC);
    final Paint chessPaintW = Paint()..color = Colors.white;
    List.generate((size.height / chessSize.height).round(), (int y) {
      List.generate((size.width / chessSize.width).round(), (int x) {
        canvas.drawRect(
          Offset(chessSize.width * x, chessSize.height * y) & chessSize,
          (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
        );
      });
    });

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
