import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../easy_ui.dart';

/// [EasyFlowView] 是一个用于显示流程图的顶层 Widget。
///
/// 更新说明：
/// 现在的节点大小由 [nodeBuilder] 返回的 Widget 自身决定。
/// 组件会自动计算 Widget 占据了多少个网格单位，并据此进行自动布局。
class EasyFlowView extends StatelessWidget {
  /// 流程图的数据模型，包含节点和边。
  final EasyFlowGraph graph;

  /// 节点构建器，用于根据 [EasyFlowNode] 数据创建对应的 Widget。
  /// 注意：Widget 可以是任意大小，组件会自动将其吸附到网格系统。
  final Widget Function(BuildContext context, int index) nodeBuilder;

  /// 节点之间的水平间距（以网格为单位）。
  final int horizontalSpacingUnits;

  /// 节点之间的垂直间距（以网格为单位）。
  final int verticalSpacingUnits;

  /// 用于布局计算和路径寻路的算法实例。
  final EasyFlowAlgorithm algorithm;

  final EasyFlowEdgePainter edgePainter;

  /// [InteractiveViewer] 的变换控制器。
  final TransformationController? transformationController;

  /// [InteractiveViewer] 允许的最大缩放比例。
  final double maxScale;

  /// [InteractiveViewer] 允许的最小缩放比例。
  final double minScale;

  /// 是否启用[InteractiveViewer]自带的缩放功能。
  final bool scaleEnabled;

  /// [InteractiveViewer]的内容对齐方式
  final Alignment? alignment;

  /// 网格单元格的尺寸（像素）。所有布局和间距都基于这个尺寸。
  final int gridSize;

  /// 水平方向的内边距（以网格为单位）。
  final int horizontalPaddingUnits;

  /// 垂直方向的内边距（以网格为单位）。
  final int verticalPaddingUnits;

  /// 节点矩形在网格中的额外缓冲区域（以网格为单位）。
  final int nodeBufferUnits;

  final ValueChanged<Size>? onLayoutWillCompleted;

  /// 创建一个 [EasyFlowView] 实例。
  const EasyFlowView({
    super.key,
    required this.graph,
    required this.nodeBuilder,
    this.horizontalSpacingUnits = 6,
    this.verticalSpacingUnits = 6,
    this.gridSize = 12,
    this.horizontalPaddingUnits = 6,
    this.verticalPaddingUnits = 6,
    this.nodeBufferUnits = 1,
    this.algorithm = const EasyFlowAlgorithm(),
    this.edgePainter = const DefaultEasyFlowEdgePainter(),
    this.transformationController,
    this.maxScale = 3.0,
    this.minScale = .3,
    this.scaleEnabled = true,
    this.alignment = Alignment.center,
    this.onLayoutWillCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // 根据图数据，使用 nodeBuilder 创建每个节点的 Widget
    final children =
        graph.nodes.indexed.map((e) {
          final (index, node) = e;
          return _EasyFlowViewChildWrapper(
            key: ValueKey(node.id),
            id: node.id,
            // 移除了 widthUnit 和 heightUnit 的传递，由 Widget 自身决定大小
            child: nodeBuilder(context, index),
          );
        }).toList();

    return InteractiveViewer(
      maxScale: maxScale,
      minScale: minScale,
      constrained: false,
      boundaryMargin: EdgeInsets.all(double.infinity),
      alignment: alignment,
      scaleEnabled: scaleEnabled,
      transformationController: transformationController,
      child: _EasyFlowViewLayout(
        graph: graph,
        horizontalSpacingUnits: horizontalSpacingUnits,
        verticalSpacingUnits: verticalSpacingUnits,
        gridSize: gridSize,
        horizontalPaddingUnits: horizontalPaddingUnits,
        verticalPaddingUnits: verticalPaddingUnits,
        nodeBufferUnits: nodeBufferUnits,
        algorithm: algorithm,
        edgePainter: edgePainter,
        onLayoutWillCompleted: onLayoutWillCompleted,
        children: children,
      ),
    );
  }
}

/// 自定义的 [ParentData]。
class _EasyFlowParentData extends ContainerBoxParentData<RenderBox> {
  /// 节点的唯一标识符。
  int id;

  _EasyFlowParentData({required this.id});
}

/// 包装器现在只负责传递 ID。
class _EasyFlowViewChildWrapper extends ParentDataWidget<_EasyFlowParentData> {
  const _EasyFlowViewChildWrapper({
    super.key,
    required this.id,
    required super.child,
  });

  final int id;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(renderObject.parentData is _EasyFlowParentData);
    final _EasyFlowParentData parentData =
        renderObject.parentData! as _EasyFlowParentData;

    if (parentData.id != id) {
      parentData.id = id;
      renderObject.parent?.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => _EasyFlowViewLayout;
}

class _EasyFlowViewLayout extends MultiChildRenderObjectWidget {
  final EasyFlowGraph graph;
  final int horizontalSpacingUnits;
  final int verticalSpacingUnits;
  final int gridSize;
  final int horizontalPaddingUnits;
  final int verticalPaddingUnits;
  final int nodeBufferUnits;
  final EasyFlowAlgorithm algorithm;
  final EasyFlowEdgePainter edgePainter;
  final ValueChanged<Size>? onLayoutWillCompleted;

  const _EasyFlowViewLayout({
    required List<_EasyFlowViewChildWrapper> children,
    required this.graph,
    required this.horizontalSpacingUnits,
    required this.verticalSpacingUnits,
    required this.gridSize,
    required this.horizontalPaddingUnits,
    required this.verticalPaddingUnits,
    required this.nodeBufferUnits,
    required this.algorithm,
    required this.edgePainter,
    this.onLayoutWillCompleted,
  }) : super(children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return EasyRenderFlowView(
      graph: graph,
      horizontalSpacingUnits: horizontalSpacingUnits,
      verticalSpacingUnits: verticalSpacingUnits,
      gridSize: gridSize,
      horizontalPaddingUnits: horizontalPaddingUnits,
      verticalPaddingUnits: verticalPaddingUnits,
      nodeBufferUnits: nodeBufferUnits,
      algorithm: algorithm,
      edgePainter: edgePainter,
      onLayoutWillCompleted: onLayoutWillCompleted,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    EasyRenderFlowView renderObject,
  ) {
    renderObject
      ..graph = graph
      ..horizontalSpacingUnits = horizontalSpacingUnits
      ..verticalSpacingUnits = verticalSpacingUnits
      ..gridSize = gridSize
      ..horizontalPaddingUnits = horizontalPaddingUnits
      ..verticalPaddingUnits = verticalPaddingUnits
      ..nodeBufferUnits = nodeBufferUnits
      ..algorithm = algorithm
      ..edgePainter = edgePainter
      ..onLayoutWillCompleted = onLayoutWillCompleted;
  }
}

// ---------------------------------------------------------------------------
// 核心渲染层 (RenderObject Layer)
// ---------------------------------------------------------------------------

class EasyRenderFlowView extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _EasyFlowParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _EasyFlowParentData> {
  EasyFlowGraph _graph;
  int _horizontalSpacingUnits;
  int _verticalSpacingUnits;
  int _gridSize;
  int _horizontalPaddingUnits;
  int _verticalPaddingUnits;
  int _nodeBufferUnits;
  EasyFlowAlgorithm _algorithm;
  EasyFlowEdgePainter _edgePainter;
  ValueChanged<Size>? _onLayoutWillCompleted;

  EasyRenderFlowView({
    required EasyFlowGraph graph,
    required int horizontalSpacingUnits,
    required int verticalSpacingUnits,
    required int gridSize,
    required int horizontalPaddingUnits,
    required int verticalPaddingUnits,
    required int nodeBufferUnits,
    required EasyFlowAlgorithm algorithm,
    required EasyFlowEdgePainter edgePainter,
    ValueChanged<Size>? onLayoutWillCompleted,
  }) : _graph = graph,
       _horizontalSpacingUnits = horizontalSpacingUnits,
       _verticalSpacingUnits = verticalSpacingUnits,
       _gridSize = gridSize,
       _horizontalPaddingUnits = horizontalPaddingUnits,
       _verticalPaddingUnits = verticalPaddingUnits,
       _nodeBufferUnits = nodeBufferUnits,
       _algorithm = algorithm,
       _edgePainter = edgePainter,
       _onLayoutWillCompleted = onLayoutWillCompleted;

  set graph(EasyFlowGraph value) {
    if (_graph != value) {
      _graph = value;
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  set horizontalSpacingUnits(int value) {
    if (_horizontalSpacingUnits != value) {
      _horizontalSpacingUnits = value;
      markNeedsLayout();
    }
  }

  set verticalSpacingUnits(int value) {
    if (_verticalSpacingUnits != value) {
      _verticalSpacingUnits = value;
      markNeedsLayout();
    }
  }

  set gridSize(int value) {
    if (_gridSize != value) {
      _gridSize = value;
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  set horizontalPaddingUnits(int value) {
    if (_horizontalPaddingUnits != value) {
      _horizontalPaddingUnits = value;
      markNeedsLayout();
    }
  }

  set verticalPaddingUnits(int value) {
    if (_verticalPaddingUnits != value) {
      _verticalPaddingUnits = value;
      markNeedsLayout();
    }
  }

  set nodeBufferUnits(int value) {
    if (_nodeBufferUnits != value) {
      _nodeBufferUnits = value;
      markNeedsLayout();
    }
  }

  set algorithm(EasyFlowAlgorithm value) {
    if (_algorithm != value) {
      _algorithm = value;
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  set edgePainter(EasyFlowEdgePainter value) {
    if (_edgePainter != value) {
      _edgePainter = value;
      markNeedsPaint();
    }
  }

  set onLayoutWillCompleted(ValueChanged<Size>? value) {
    if (_onLayoutWillCompleted != value) {
      _onLayoutWillCompleted = value;
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EasyFlowParentData) {
      child.parentData = _EasyFlowParentData(id: -1);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }

  final Map<int, Rect> _nodeGridRects = {};

  @override
  void performLayout() {
    _nodeGridRects.clear();
    if (firstChild == null) {
      size = Size.zero;
      return;
    }

    final double horizontalPadding =
        _horizontalPaddingUnits * _gridSize.toDouble();
    final double verticalPadding = _verticalPaddingUnits * _gridSize.toDouble();

    final Map<int, RenderBox> nodeMap = {};
    RenderBox? child = firstChild;

    // 1. 布局所有子节点，让子节点决定自己的大小
    while (child != null) {
      final _EasyFlowParentData childParentData =
          child.parentData! as _EasyFlowParentData;
      nodeMap[childParentData.id] = child;

      // 使用 loose constraints，允许子节点自由决定大小（不超过父容器限制，这里父容器大小未定，所以基本自由）
      child.layout(BoxConstraints(), parentUsesSize: true);

      // 注意：这里不再将计算出的网格单位存储在 ParentData 中
      // 后续步骤将根据 child.size 实时计算

      child = childParentData.nextSibling;
    }

    // 2. 调用算法计算每个节点的层级。
    final Map<int, int> ranks = _algorithm.calculateRanks(_graph);

    // 3. 按层级组织节点，并计算每层的总宽度（基于网格对齐的宽度）
    final Map<int, List<int>> nodesByRank = {};
    ranks.forEach((id, rank) {
      nodesByRank.putIfAbsent(rank, () => []).add(id);
    });

    final Map<int, double> rankWidths = {};
    final Map<int, double> rankMaxHeights = {};
    double maxContentWidth = 0;

    for (var rank in nodesByRank.keys) {
      double w = 0;
      double maxH = 0;
      final List<int> ids = nodesByRank[rank]!;
      for (int i = 0; i < ids.length; i++) {
        final RenderBox node = nodeMap[ids[i]]!;

        final double effectiveWidth = node.size.width;
        final double effectiveHeight = node.size.height;

        w += effectiveWidth;
        if (effectiveHeight > maxH) {
          maxH = effectiveHeight;
        }

        if (i < ids.length - 1) {
          w += (_horizontalSpacingUnits * _gridSize);
        }
      }
      rankWidths[rank] = w;
      rankMaxHeights[rank] = maxH;
      if (w > maxContentWidth) {
        maxContentWidth = w;
      }
    }

    // 4. 计算每个节点的最终位置。
    double maxY = 0;
    double currentY = verticalPadding;
    final List<int> sortedRanks = nodesByRank.keys.toList()..sort();

    for (int r in sortedRanks) {
      final List<int> idsInRank = nodesByRank[r] ?? [];
      final double currentLayerWidth = rankWidths[r] ?? 0;
      final double centeringOffset = (maxContentWidth - currentLayerWidth) / 2;
      double currentX = horizontalPadding + centeringOffset;

      final double maxRankHeight = rankMaxHeights[r] ?? 0;

      for (int id in idsInRank) {
        final RenderBox node = nodeMap[id]!;
        final _EasyFlowParentData pd = node.parentData! as _EasyFlowParentData;

        final double offsetX = currentX;
        final double offsetY = currentY;
        pd.offset = Offset(offsetX, offsetY);

        // 推进 currentX
        currentX += node.size.width + (_horizontalSpacingUnits * _gridSize);

        // 计算最大Y值用于画布尺寸
        maxY = math.max(maxY, offsetY + node.size.height);

        final int startX =
            pd.offset.dx.toInt() % _gridSize == 0
                ? (pd.offset.dx / _gridSize).toInt() - _nodeBufferUnits
                : (pd.offset.dx / _gridSize).floor() - _nodeBufferUnits;
        final int startY =
            pd.offset.dy.toInt() % _gridSize == 0
                ? (pd.offset.dy / _gridSize).toInt() - _nodeBufferUnits
                : (pd.offset.dy / _gridSize).floor() - _nodeBufferUnits;
        final int endX =
            (pd.offset.dx + node.size.width).toInt() % _gridSize == 0
                ? ((pd.offset.dx + node.size.width) / _gridSize).toInt() +
                    _nodeBufferUnits
                : ((pd.offset.dx + node.size.width) / _gridSize).ceil() +
                    _nodeBufferUnits;
        final int endY =
            (pd.offset.dy + node.size.height).toInt() % _gridSize == 0
                ? ((pd.offset.dy + node.size.height) / _gridSize).toInt() +
                    _nodeBufferUnits
                : ((pd.offset.dy + node.size.height) / _gridSize).ceil() +
                    _nodeBufferUnits;

        _nodeGridRects[pd.id] = Rect.fromPoints(
          Offset(startX.toDouble(), startY.toDouble()),
          Offset(endX.toDouble(), endY.toDouble()),
        );
      }

      currentY += maxRankHeight + (_verticalSpacingUnits * _gridSize);
    }

    final double totalWidth = maxContentWidth + horizontalPadding * 2;
    final double totalHeight = maxY + verticalPadding * 2;
    size = Size(totalWidth, totalHeight);
    _onLayoutWillCompleted?.call(size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    // _paintGrid(canvas, offset);

    final int gridWidth = (size.width / _gridSize).ceil() + 1;
    final int gridHeight = (size.height / _gridSize).ceil() + 1;

    final List<List<Set<int>>> grid = List.generate(
      gridHeight,
      (_) => List.generate(gridWidth, (_) => <int>{}),
    );

    final Map<int, RenderBox> nodeMap = {};

    RenderBox? child = firstChild;
    while (child != null) {
      final _EasyFlowParentData pd = child.parentData! as _EasyFlowParentData;
      nodeMap[pd.id] = child;

      // 实时计算网格单位
      final rect = _nodeGridRects[pd.id];
      if (rect != null) {
        final int startX = rect.topLeft.dx.round();
        final int startY = rect.topLeft.dy.round();
        final int endX = rect.bottomRight.dx.round();
        final int endY = rect.bottomRight.dy.round();
        for (int gy = startY; gy <= endY; gy++) {
          for (int gx = startX; gx <= endX; gx++) {
            if (gy >= 0 && gy < gridHeight && gx >= 0 && gx < gridWidth) {
              grid[gy][gx].add(pd.id);
            }
          }
        }
      }

      child = pd.nextSibling;
    }

    final Paint linePaint =
        Paint()
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    final Set<math.Point<int>> occupiedPathPoints = {};

    for (var edge in _graph.edges) {
      final RenderBox? fromNode = nodeMap[edge.from];
      final RenderBox? toNode = nodeMap[edge.to];
      final fromRect = _nodeGridRects[edge.from];
      final toRect = _nodeGridRects[edge.to];

      if (fromNode != null &&
          toNode != null &&
          fromRect != null &&
          toRect != null) {
        final _EasyFlowParentData fromData =
            fromNode.parentData! as _EasyFlowParentData;
        final _EasyFlowParentData toData =
            toNode.parentData! as _EasyFlowParentData;

        final int startX =
            (fromData.offset.dx + fromNode.size.width / 2).round();
        final int startY = (fromData.offset.dy + fromNode.size.height).round();
        final int endX = (toData.offset.dx + toNode.size.width / 2).round();
        final int endY = (toData.offset.dy).round();
        final int startGridX = (startX / _gridSize).round();
        final int startGridY = fromRect.bottom.round();
        final int endGridX = (endX / _gridSize).round();
        final int endGridY = toRect.top.round();

        final int safeStartGuideY = math.min(startGridY, gridHeight - 1);
        final int safeEndGuideY = math.max(endGridY, 0);

        final math.Point<int> startGuide = math.Point(
          startGridX,
          safeStartGuideY,
        );
        final math.Point<int> endGuide = math.Point(endGridX, safeEndGuideY);

        final List<math.Point<int>> midPath = _algorithm.findPath(
          start: startGuide,
          end: endGuide,
          grid: grid,
          gridWidth: gridWidth,
          gridHeight: gridHeight,
          fromId: fromData.id,
          toId: toData.id,
          nodeGridRects: _nodeGridRects,
          occupiedPathPoints: occupiedPathPoints,
        );

        if (midPath.isNotEmpty) {
          for (int i = 0; i < midPath.length; i++) {
            if (i == 0 || i == midPath.length - 1) continue;
            occupiedPathPoints.add(midPath[i]);
          }
        }

        final List<math.Point<int>> path = [];
        if (midPath.isNotEmpty || startGuide == endGuide) {
          path.add(startGuide);
          if (midPath.isNotEmpty) {
            if (midPath.first == startGuide) {
              path.addAll(midPath.sublist(1));
            } else {
              path.addAll(midPath);
            }
          }
          if (path.last != endGuide) path.add(endGuide);
        }
        final fullPath =
            path
                .map(
                  (p) =>
                      Offset(
                        p.x.toDouble() * _gridSize,
                        p.y.toDouble() * _gridSize,
                      ) +
                      offset,
                )
                .toList();
        fullPath.insert(
          0,
          Offset(startGridX.toDouble() * _gridSize, startY.toDouble()) + offset,
        );
        fullPath.insert(
          fullPath.length,
          Offset(endGridX.toDouble() * _gridSize, endY.toDouble()) + offset,
        );

        if (fullPath.isNotEmpty) {
          linePaint.color = edge.color;
          _edgePainter.paint(context, edge, fullPath);
        }
      }
    }
    defaultPaint(context, offset);
  }

  /// 绘制网格，仅调试时使用
  void _paintGrid(Canvas canvas, Offset offset) {
    final maxGridX = (size.width / _gridSize).ceil();
    final maxGridY = (size.height / _gridSize).ceil();
    final Paint linePaint =
        Paint()
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke
          ..color = Colors.red.withAlpha(0x33);
    for (var i = 0; i <= maxGridX; ++i) {
      canvas.drawLine(
        Offset(i.toDouble() * _gridSize, 0) + offset,
        Offset(i.toDouble() * _gridSize, size.height) + offset,
        linePaint,
      );
    }
    for (var i = 0; i <= maxGridY; ++i) {
      canvas.drawLine(
        Offset(0, i.toDouble() * _gridSize) + offset,
        Offset(size.width, i.toDouble() * _gridSize) + offset,
        linePaint,
      );
    }
  }
}
