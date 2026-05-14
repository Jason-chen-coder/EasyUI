import 'dart:math' as math;

import 'package:flutter/rendering.dart';

import 'easy_flow_graph.dart';

/// [EasyFlowEdgePainter] 定义了绘制流程图边缘（连线）的接口。
///
/// 实现此类以自定义节点之间的连线方式（例如：直角折线、直线、贝塞尔曲线等）。
/// 此绘制器只负责绘制，不负责路径计算。
abstract class EasyFlowEdgePainter {
  /// 创建一个 [EasyFlowEdgePainter] 实例。
  const EasyFlowEdgePainter();

  /// 绘制边缘的核心方法。
  ///
  /// * [context]: 绘制上下文，提供了用于绘制的 [Canvas]。
  /// * [edge]: 当前需要绘制的边缘对象，包含了颜色等属性。
  /// * [points]: 描述边缘路径的点坐标列表。
  void paint(PaintingContext context, EasyFlowEdge edge, List<Offset> points);
}

/// [DefaultEasyFlowEdgePainter] 是默认的边缘绘制器。
///
/// 它负责将计算好的路径绘制为线条，并在末端添加箭头。
class DefaultEasyFlowEdgePainter extends EasyFlowEdgePainter {
  /// 创建一个 [DefaultEasyFlowEdgePainter] 实例。
  const DefaultEasyFlowEdgePainter();

  // 定义箭头的高度，以便在路径和箭头绘制中复用
  static const double _arrowHeight = 8.0;

  @override
  void paint(PaintingContext context, EasyFlowEdge edge, List<Offset> points) {
    if (points.length < 2) {
      // 点的数量不足以构成一条线，直接返回
      return;
    }

    final Canvas canvas = context.canvas;
    final Paint linePaint =
        Paint()
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
          ..color = edge.color;

    final Offset pLast = points.last;
    final Offset pPrev = points[points.length - 2];
    final double angle = math.atan2(pLast.dy - pPrev.dy, pLast.dx - pPrev.dx);

    // 计算路径的新终点，使其不与箭头重叠
    final Offset newLastPoint = pLast.translate(
      -_arrowHeight * math.cos(angle),
      -_arrowHeight * math.sin(angle),
    );

    // 创建新的点列表用于绘制路径
    final List<Offset> pathPoints = List.from(points);
    pathPoints[pathPoints.length - 1] = newLastPoint;

    final path = Path()..addPolygon(pathPoints, false);

    canvas.drawPath(path, linePaint);

    // 在原路径的末端绘制箭头
    _drawArrow(canvas, pLast, angle, edge.color);
  }

  /// 在指定位置绘制一个箭头。
  ///
  /// * [canvas]: 用于绘制的画布。
  /// * [tip]: 箭头的尖端坐标。
  /// * [angle]: 箭头的旋转角度。
  /// * [color]: 箭头的颜色。
  void _drawArrow(Canvas canvas, Offset tip, double angle, Color color) {
    const double arrowBase = 4.0; // 箭头底边的一半
    final Paint arrowPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    // 使用 Path 绘制箭头形状
    final Path arrowPath = Path();
    arrowPath.moveTo(0, 0); // 箭头尖端
    arrowPath.lineTo(-_arrowHeight, -arrowBase);
    arrowPath.lineTo(-_arrowHeight, arrowBase);
    arrowPath.close();

    canvas.save();
    // 将画布变换到箭头的尖端位置和方向
    canvas.translate(tip.dx, tip.dy);
    canvas.rotate(angle);
    // 绘制箭头路径
    canvas.drawPath(arrowPath, arrowPaint);
    canvas.restore();
  }
}
