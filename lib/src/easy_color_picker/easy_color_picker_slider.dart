import 'package:flutter/material.dart';

/// Track types for slider picker.
enum TrackType { hue, alpha }

class EasyColorPickerSlider extends StatelessWidget {
  const EasyColorPickerSlider(
    this.trackType,
    this.hsvColor,
    this.onColorChanged, {
    super.key,
    this.displayThumbColor = false,
    this.fullThumbColor = false,
  });

  final TrackType trackType;
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onColorChanged;
  final bool displayThumbColor;
  final bool fullThumbColor;

  void slideEvent(RenderBox getBox, BoxConstraints box, Offset globalPosition) {
    double localDx = getBox.globalToLocal(globalPosition).dx - 8.0;
    double progress =
        localDx.clamp(0.0, box.maxWidth - 16.0) / (box.maxWidth - 16.0);
    switch (trackType) {
      case TrackType.hue:
        // 360 is the same as zero
        // if set to 360, sliding to end goes to zero
        onColorChanged(hsvColor.withHue(progress * 359));
        break;
      case TrackType.alpha:
        onColorChanged(hsvColor.withAlpha(progress));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        double thumbOffset = 8.0;
        Color thumbColor;
        switch (trackType) {
          case TrackType.hue:
            thumbOffset += (box.maxWidth - 16.0) * hsvColor.hue / 359;
            thumbColor =
                HSVColor.fromAHSV(1.0, hsvColor.hue, 1.0, 1.0).toColor();
            break;
          case TrackType.alpha:
            thumbOffset += (box.maxWidth - 16.0) * hsvColor.alpha;
            thumbColor = hsvColor.toColor();
            break;
        }

        return CustomMultiChildLayout(
          delegate: _SliderLayout(),
          children: <Widget>[
            LayoutId(
              id: _SliderLayout.track,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(999)),
                child: CustomPaint(painter: _TrackPainter(trackType, hsvColor)),
              ),
            ),
            LayoutId(
              id: _SliderLayout.thumb,
              child: Transform.translate(
                offset: Offset(thumbOffset, 0.0),
                child: CustomPaint(
                  painter: _ThumbPainter(
                    thumbColor: displayThumbColor ? thumbColor : null,
                    fullThumbColor: fullThumbColor,
                  ),
                ),
              ),
            ),
            LayoutId(
              id: _SliderLayout.gestureContainer,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints box) {
                  RenderBox? getBox = context.findRenderObject() as RenderBox?;
                  return GestureDetector(
                    onPanDown:
                        (DragDownDetails details) =>
                            getBox != null
                                ? slideEvent(
                                  getBox,
                                  box,
                                  details.globalPosition,
                                )
                                : null,
                    onPanUpdate:
                        (DragUpdateDetails details) =>
                            getBox != null
                                ? slideEvent(
                                  getBox,
                                  box,
                                  details.globalPosition,
                                )
                                : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SliderLayout extends MultiChildLayoutDelegate {
  static const String track = 'track';
  static const String thumb = 'thumb';
  static const String gestureContainer = 'gesturecontainer';

  @override
  void performLayout(Size size) {
    layoutChild(
      track,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    positionChild(track, Offset.zero);
    layoutChild(thumb, BoxConstraints.tightFor(width: 5, height: size.height));
    positionChild(thumb, Offset.zero);
    layoutChild(
      gestureContainer,
      BoxConstraints.tightFor(width: size.width, height: size.height),
    );
    positionChild(gestureContainer, Offset.zero);
  }

  @override
  bool shouldRelayout(_SliderLayout oldDelegate) => false;
}

/// Painter for all kinds of track types.
class _TrackPainter extends CustomPainter {
  const _TrackPainter(this.trackType, this.hsvColor);

  final TrackType trackType;
  final HSVColor hsvColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    if (trackType == TrackType.alpha) {
      final Size chessSize = Size(size.height / 2, size.height / 2);
      Paint chessPaintB = Paint()..color = const Color(0xffcccccc);
      Paint chessPaintW = Paint()..color = Colors.white;
      List.generate((size.height / chessSize.height).round(), (int y) {
        List.generate((size.width / chessSize.width).round(), (int x) {
          canvas.drawRect(
            Offset(chessSize.width * x, chessSize.width * y) & chessSize,
            (x + y) % 2 != 0 ? chessPaintW : chessPaintB,
          );
        });
      });
    }

    switch (trackType) {
      case TrackType.hue:
        final List<Color> colors = [
          const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
          const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
      case TrackType.alpha:
        final Color baseColor = hsvColor.toColor();
        final List<Color> colors = [
          baseColor.withAlpha(0),
          baseColor.withAlpha(255),
        ];
        Gradient gradient = LinearGradient(colors: colors);
        canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Painter for thumb of slider.
class _ThumbPainter extends CustomPainter {
  const _ThumbPainter({this.thumbColor, this.fullThumbColor = false});

  final Color? thumbColor;
  final bool fullThumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawShadow(
      Path()..addOval(
        Rect.fromCircle(
          center: Offset(0.0, size.height / 2),
          radius: size.height / 2,
        ),
      ),
      Colors.black,
      3.0,
      true,
    );
    canvas.drawCircle(
      Offset(0.0, size.height / 2),
      size.height / 2,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
    if (thumbColor != null) {
      canvas.drawCircle(
        Offset(0.0, size.height / 2),
        (size.height * (fullThumbColor ? 1.0 : 0.55)) / 2,
        Paint()
          ..color = thumbColor!
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
