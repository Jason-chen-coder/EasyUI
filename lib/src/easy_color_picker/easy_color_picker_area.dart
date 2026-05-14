import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'easy_color_picker_utils.dart';

class EasyColorPickerArea extends StatelessWidget {
  const EasyColorPickerArea(this.hsvColor, this.onColorChanged, {super.key});

  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;

  void _handleColorRectChange(double horizontal, double vertical) {
    onColorChanged(hsvColor.withSaturation(horizontal).withValue(vertical));
  }

  void _handleGesture(
    Offset position,
    BuildContext context,
    double height,
    double width,
  ) {
    RenderBox? getBox = context.findRenderObject() as RenderBox?;
    if (getBox == null) return;

    Offset localOffset = getBox.globalToLocal(position);
    double horizontal = localOffset.dx.clamp(0.0, width);
    double vertical = localOffset.dy.clamp(0.0, height);

    _handleColorRectChange(horizontal / width, 1 - vertical / height);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        return RawGestureDetector(
          gestures: {
            _AlwaysWinPanGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<
                  _AlwaysWinPanGestureRecognizer
                >(() => _AlwaysWinPanGestureRecognizer(), (
                  _AlwaysWinPanGestureRecognizer instance,
                ) {
                  instance
                    ..onDown =
                        ((details) => _handleGesture(
                          details.globalPosition,
                          context,
                          height,
                          width,
                        ))
                    ..onUpdate =
                        ((details) => _handleGesture(
                          details.globalPosition,
                          context,
                          height,
                          width,
                        ));
                }),
          },
          child: CustomPaint(painter: _HSVWithHueColorPainter(hsvColor)),
        );
      },
    );
  }
}

/// Painter for SV mixture.
class _HSVWithHueColorPainter extends CustomPainter {
  const _HSVWithHueColorPainter(this.hsvColor);

  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const Gradient gradientV = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.black],
    );
    final Gradient gradientH = LinearGradient(
      colors: [
        Colors.white,
        HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor(),
      ],
    );
    canvas.drawRect(rect, Paint()..shader = gradientV.createShader(rect));
    canvas.drawRect(
      rect,
      Paint()
        ..blendMode = BlendMode.multiply
        ..shader = gradientH.createShader(rect),
    );

    canvas.drawCircle(
      Offset(
        size.width * hsvColor.saturation,
        size.height * (1 - hsvColor.value),
      ),
      size.height * 0.025,
      Paint()
        ..color =
            (useWhiteForeground(hsvColor.toColor())
                ? Colors.white
                : Colors.black)
        ..strokeWidth = 4
        ..blendMode = BlendMode.luminosity
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _AlwaysWinPanGestureRecognizer extends PanGestureRecognizer {
  @override
  void addAllowedPointer(event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'alwaysWin';
}
