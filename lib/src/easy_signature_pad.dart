import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'easy_theme.dart';

class EasySignaturePad extends StatefulWidget {
  const EasySignaturePad({
    super.key,
    required this.size,
    required this.controller,
  });

  final Size size;
  final EasySignaturePadController controller;

  @override
  State<EasySignaturePad> createState() => _EasySignaturePadState();
}

class _EasySignaturePadState extends State<EasySignaturePad> {
  List<List<Offset>> _strokes = [];
  late Color _strokeColor;
  late double _strokeWidth;

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
    _strokeWidth = widget.controller.strokeWidth;
    _strokeColor = widget.controller.strokeColor;
  }

  @override
  void didUpdateWidget(covariant EasySignaturePad oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._detach(this);
      widget.controller._attach(this);
      _strokeWidth = widget.controller.strokeWidth;
      _strokeColor = widget.controller.strokeColor;
    }
  }

  @override
  void dispose() {
    widget.controller._detach(this);
    super.dispose();
  }

  /// 设置笔划粗细
  void _setStrokeWidth(double strokeWidth) {
    _strokeWidth = strokeWidth;
    if (context.mounted) {
      setState(() {});
    }
  }

  /// 设置笔划颜色
  void _setStrokeColor(Color strokeColor) {
    _strokeColor = strokeColor;
    if (context.mounted) {
      setState(() {});
    }
  }

  /// 清除笔划
  void _clear() {
    _strokes.clear();
    if (context.mounted) {
      setState(() {});
    }
  }

  /// 导出为png图片
  Future<Uint8List?> _exportPngImage() async {
    if (_strokes.isEmpty) {
      return null;
    }

    final size = widget.size;
    // 1. 创建 PictureRecorder
    final ui.PictureRecorder recorder = ui.PictureRecorder();

    // 2. 创建 Canvas
    final Canvas canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, size.width, size.height),
    );

    // 3. 执行绘制逻辑 (类似 CustomPainter 的 paint 方法)
    final paint =
        Paint()
          ..color = _strokeColor
          ..strokeWidth = _strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

    for (var stroke in _strokes) {
      canvas.drawPoints(ui.PointMode.polygon, stroke, paint);
    }

    // 4. 结束记录，得到 Picture
    final ui.Picture picture = recorder.endRecording();

    // 5. 将 Picture 转换为 Image
    ui.Image image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );

    // 6. 将 Image 转换为 Uint8List
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }

  void _onPanDown(DragDownDetails details, Size size) {
    if (size.contains(details.localPosition)) {
      setState(() {
        final newStrokes = List.of(_strokes);
        _strokes =
            newStrokes..add([
              Offset(details.localPosition.dx, details.localPosition.dy),
            ]);
      });
    }
  }

  void _onPanStart(DragStartDetails details, Size size) {
    if (size.contains(details.localPosition)) {
      setState(() {
        final newStrokes = List.of(_strokes);
        newStrokes.last.add(
          Offset(details.localPosition.dx, details.localPosition.dy),
        );
        _strokes = newStrokes;
      });
    }
  }

  void _onPanUpdate(DragUpdateDetails details, Size size) {
    if (size.contains(details.localPosition)) {
      setState(() {
        final newStrokes = List.of(_strokes);
        newStrokes.last.add(
          Offset(details.localPosition.dx, details.localPosition.dy),
        );
        _strokes = newStrokes;
      });
    } else if (_strokes.last.isNotEmpty) {
      setState(() {
        final newStrokes = List.of(_strokes);
        newStrokes.add([]);
        _strokes = newStrokes;
      });
    }
  }

  void _onPanEnd(DragEndDetails details, Size size) {
    if (size.contains(details.localPosition)) {
      setState(() {
        final newStrokes = List.of(_strokes);
        newStrokes.last.add(
          Offset(details.localPosition.dx, details.localPosition.dy),
        );
        _strokes = newStrokes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return GestureDetector(
      onPanDown: (details) => _onPanDown(details, size),
      onPanStart: (details) => _onPanStart(details, size),
      onPanUpdate: (details) => _onPanUpdate(details, size),
      onPanEnd: (details) => _onPanEnd(details, size),
      child: Container(
        color: EasyTheme.of(context).background,
        child: CustomPaint(
          size: size,
          painter: EasySignaturePainter(
            strokes: _strokes,
            strokeWidth: _strokeWidth,
            strokeColor: _strokeColor,
          ),
        ),
      ),
    );
  }
}

class EasySignaturePadController {
  EasySignaturePadController({
    required Color stokeColor,
    required double strokeWidth,
  }) : _stokeColor = stokeColor,
       _strokeWidth = strokeWidth;

  Color get strokeColor => _stokeColor;
  Color _stokeColor;

  set strokeColor(Color value) {
    _stokeColor = value;
    if (isAttached) {
      _state!._setStrokeColor(value);
    }
  }

  double get strokeWidth => _strokeWidth;
  double _strokeWidth;

  set strokeWidth(double value) {
    _strokeWidth = value;
    if (isAttached) {
      _state!._setStrokeWidth(value);
    }
  }

  _EasySignaturePadState? _state;

  bool get isAttached => _state != null;

  void _attach(_EasySignaturePadState state) {
    assert(_state == null);
    _state = state;
  }

  void _detach(_EasySignaturePadState state) {
    assert(_state == state);
    _state = null;
  }

  void clear() {
    assert(isAttached);
    _state!._clear();
  }

  Future<Uint8List?> exportPngImage() {
    assert(isAttached);
    return _state!._exportPngImage();
  }
}

class EasySignaturePainter extends CustomPainter {
  EasySignaturePainter({
    required this.strokes,
    required this.strokeWidth,
    required this.strokeColor,
  });

  final List<List<Offset>> strokes;
  final double strokeWidth;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = strokeColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
    for (var stroke in strokes) {
      canvas.drawPoints(ui.PointMode.polygon, stroke, strokePaint);
    }
  }

  @override
  bool shouldRepaint(EasySignaturePainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeColor != strokeColor;
  }
}
