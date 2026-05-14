import 'dart:math' as math;
import 'dart:ui';

import 'easy_flow_graph.dart';

/// 包含分层计算和路径寻路的具体实现。
/// 这个类封装了流程图布局所需的核心算法。
class EasyFlowAlgorithm {
  /// 路径拐弯的代价（惩罚值）。A*寻路时，路径每拐一个弯，成本会增加此值。
  final int pathTurnPenalty;

  /// 路径重叠的代价（惩罚值）。A*寻路时，如果路径穿过另一条已存在的路径，成本会增加此值。
  final int pathOverlapPenalty;

  /// 创建一个FlowAlgorithm实例。
  const EasyFlowAlgorithm({
    this.pathTurnPenalty = 10,
    this.pathOverlapPenalty = 50,
  });

  /// 计算图中每个节点的层级（rank），用于确定节点的垂直位置（Y轴坐标）。
  ///
  /// 算法结合了 Kahn 算法（一种拓扑排序算法）和 DFS（深度优先搜索）来处理有向无环图（DAG）和检测环路。
  /// 1. 使用 DFS 遍历图，识别出“回边”（back edges），这些边是导致环路的原因。
  /// 2. 在拓扑排序（Kahn算法）中忽略这些回边，从而可以在存在环路的情况下对图的其余部分进行分层。
  /// 3. 没有入度的节点被放置在第0层。
  /// 4. 节点的层级是其所有前驱节点层级最大值加一。
  /// 5. 环路中的节点和无法通过拓扑排序处理的节点会被分配到一个较高的层级。
  ///
  Map<int, int> calculateRanks(EasyFlowGraph graph) {
    final Set<int> ids = graph.nodeIds;
    final Map<int, int> ranks = {};
    // 构建邻接表
    final Map<int, List<int>> adjacency = {for (var id in ids) id: []};

    for (var edge in graph.edges) {
      if (ids.contains(edge.from) && ids.contains(edge.to)) {
        adjacency[edge.from]!.add(edge.to);
      }
    }

    // --- DFS 识别回边 ---
    // visitState: 0=未访问, 1=正在访问, 2=已访问
    final Map<int, int> visitState = {for (var id in ids) id: 0};
    final Set<String> backEdges = {}; // 存储回边，格式为 "fromId-toId"

    void dfs(int u) {
      visitState[u] = 1; // 标记为正在访问
      for (int v in adjacency[u]!) {
        if (visitState[v] == 1) {
          // 如果邻居节点v也处于“正在访问”状态，说明找到了一个环，(u, v)是一条回边
          backEdges.add("$u-$v");
        } else if (visitState[v] == 0) {
          dfs(v);
        }
      }
      visitState[u] = 2; // 标记为已访问
    }

    // 计算原始入度
    final Map<int, int> rawInDegrees = {for (var id in ids) id: 0};
    for (var edge in graph.edges) {
      if (ids.contains(edge.to)) {
        rawInDegrees[edge.to] = (rawInDegrees[edge.to] ?? 0) + 1;
      }
    }

    // 从所有入度为0的节点开始DFS，以确保遍历所有组件
    rawInDegrees.forEach((id, count) {
      if (count == 0 && visitState[id] == 0) {
        dfs(id);
      }
    });
    // 处理图中可能存在的环或多个不连通的组件
    for (var id in ids) {
      if (visitState[id] == 0) {
        dfs(id);
      }
    }

    // --- Kahn 算法 ---
    // 计算有效入度（忽略回边）
    final Map<int, int> effectiveInDegrees = {for (var id in ids) id: 0};
    for (var edge in graph.edges) {
      if (ids.contains(edge.from) && ids.contains(edge.to)) {
        if (!backEdges.contains("${edge.from}-${edge.to}")) {
          effectiveInDegrees[edge.to] = (effectiveInDegrees[edge.to] ?? 0) + 1;
        }
      }
    }

    List<int> queue = [];
    // 将所有有效入度为0的节点加入队列，并设置层级为0
    effectiveInDegrees.forEach((id, degree) {
      if (degree == 0) {
        queue.add(id);
        ranks[id] = 0;
      }
    });

    int processedCount = 0;
    int currentMaxRank = 0;

    while (queue.isNotEmpty) {
      int u = queue.removeAt(0);
      processedCount++;

      int rankU = ranks[u] ?? 0;
      if (rankU > currentMaxRank) currentMaxRank = rankU;

      // 遍历u的所有邻居节点
      for (int v in adjacency[u]!) {
        if (!backEdges.contains("$u-$v")) {
          // 将邻居的有效入度减一
          effectiveInDegrees[v] = (effectiveInDegrees[v] ?? 0) - 1;
          // 更新邻居的层级，取其所有前驱节点层级最大值 + 1
          ranks[v] = math.max(ranks[v] ?? 0, rankU + 1);
          // 如果邻居的有效入度变为0，则加入队列
          if (effectiveInDegrees[v] == 0) {
            queue.add(v);
          }
        }
      }
    }

    // 如果处理的节点数少于总节点数，说明图中存在环
    // 将环中的节点或未处理的节点放置在当前最高层级之后
    if (processedCount < ids.length) {
      for (var id in ids) {
        ranks.putIfAbsent(id, () => currentMaxRank + 1);
      }
    }

    // 确保所有节点都有一个层级值
    for (var id in ids) {
      ranks.putIfAbsent(id, () => 0);
    }

    return ranks;
  }

  /// 在网格上计算两个点之间的路径，用于绘制节点间的连线。
  ///
  /// 算法：A* 寻路算法。
  /// A* 算法通过估算函数（启发式）来寻找从起点到终点的最优路径。
  /// 成本函数 f = g + h，其中 g 是从起点到当前点的实际代价，h 是从当前点到终点的估算代价（这里使用曼哈顿距离）。
  /// 算法会惩罚路径的拐弯和与其他路径的重叠，以生成更美观、更易读的连线。
  ///
  /// @param start 起始点的网格坐标。
  /// @param end 终点的网格坐标。
  /// @param fromId 起始节点的ID。
  /// @param toId 终点节点的ID。
  /// @param grid 整个布局的网格，存储每个单元格被哪个节点占据。
  /// @param gridWidth 网格宽度。
  /// @param gridHeight 网格高度。
  /// @param nodeGridRects 存储每个节点在网格中占据的矩形区域。
  /// @param occupiedPathPoints 已有路径占据的网格点集合。
  /// @return 一系列网格坐标点，表示从起点到终点的路径。如果找不到路径，则返回空列表。
  List<math.Point<int>> findPath({
    required math.Point<int> start,
    required math.Point<int> end,
    required int fromId,
    required int toId,
    required List<List<Set<int>>> grid,
    required int gridWidth,
    required int gridHeight,
    required Map<int, Rect> nodeGridRects,
    required Set<math.Point<int>> occupiedPathPoints,
  }) {
    List<_AStarNode> openList = []; // 待评估的节点列表
    Set<math.Point<int>> closedSet = {}; // 已评估过的节点集合

    // 将起点加入开放列表
    openList.add(
      _AStarNode(
        point: start,
        g: 0,
        h: _manhattan(start, end),
        parent: null,
        direction: const math.Point(0, 1), // 初始方向，通常是向下
      ),
    );

    while (openList.isNotEmpty) {
      // 找到f值最小的节点
      openList.sort((a, b) => a.f.compareTo(b.f));
      _AStarNode current = openList.removeAt(0);

      // 如果到达终点，回溯路径并返回
      if (current.point == end) {
        List<math.Point<int>> path = [];
        _AStarNode? node = current;
        while (node != null) {
          path.add(node.point);
          node = node.parent;
        }
        return path.reversed.toList();
      }

      // 将当前节点移入关闭列表
      closedSet.add(current.point);

      // 获取当前节点的四个相邻邻居
      final List<math.Point<int>> neighbors = [
        math.Point(current.point.x + 1, current.point.y),
        math.Point(current.point.x - 1, current.point.y),
        math.Point(current.point.x, current.point.y + 1),
        math.Point(current.point.x, current.point.y - 1),
      ];

      for (var neighbor in neighbors) {
        // 越界检查
        if (neighbor.x < 0 ||
            neighbor.x >= gridWidth ||
            neighbor.y < 0 ||
            neighbor.y >= gridHeight) {
          continue;
        }
        // 如果邻居已在关闭列表中，则跳过
        if (closedSet.contains(neighbor)) {
          continue;
        }

        bool isWalkable = true;

        // 检查邻居是否在起点或终点节点的矩形区域内（不包括边框）
        // 目的是让路径可以从节点边缘出发，但不能穿过节点内部
        if (nodeGridRects.containsKey(fromId)) {
          Rect r = nodeGridRects[fromId]!;
          if (neighbor.x > r.left &&
              neighbor.x < r.right &&
              neighbor.y > r.top &&
              neighbor.y < r.bottom) {
            isWalkable = false;
          }
        }
        if (isWalkable && nodeGridRects.containsKey(toId)) {
          Rect r = nodeGridRects[toId]!;
          if (neighbor.x > r.left &&
              neighbor.x < r.right &&
              neighbor.y > r.top &&
              neighbor.y < r.bottom) {
            isWalkable = false;
          }
        }

        // 检查邻居是否被其他节点占据
        if (isWalkable) {
          Set<int> blockers = grid[neighbor.y][neighbor.x];
          if (blockers.isNotEmpty) {
            for (int id in blockers) {
              if (id != fromId && id != toId) {
                isWalkable = false;
                break;
              }
            }
          }
        }

        if (!isWalkable) {
          continue;
        }

        // --- 计算移动成本 ---
        int stepCost = 1; // 基础移动成本
        bool isVerticalStartTrunk = (neighbor.x == start.x); // 是否在起点垂直主干道上
        bool isVerticalEndTrunk = (neighbor.x == end.x); // 是否在终点垂直主干道上

        // 如果路径重叠且不在主干道上，增加重叠惩罚
        if (!isVerticalStartTrunk &&
            !isVerticalEndTrunk &&
            occupiedPathPoints.contains(neighbor)) {
          stepCost = pathOverlapPenalty;
        }

        math.Point<int> newDirection = math.Point(
          neighbor.x - current.point.x,
          neighbor.y - current.point.y,
        );

        // 如果方向改变，增加拐弯惩罚
        int turnCost = 0;
        if (current.direction != newDirection) {
          turnCost = pathTurnPenalty;
        }

        int newG = current.g + stepCost + turnCost;

        int existingIndex = openList.indexWhere((n) => n.point == neighbor);

        if (existingIndex != -1) {
          // 如果在开放列表中找到了该邻居，并且新的g值更小，则更新它
          if (newG < openList[existingIndex].g) {
            openList[existingIndex] = _AStarNode(
              point: neighbor,
              g: newG,
              h: _manhattan(neighbor, end),
              parent: current,
              direction: newDirection,
            );
          }
        } else {
          // 如果邻居不在开放列表中，则添加它
          openList.add(
            _AStarNode(
              point: neighbor,
              g: newG,
              h: _manhattan(neighbor, end),
              parent: current,
              direction: newDirection,
            ),
          );
        }
      }
    }
    return []; // 如果无法找到路径，返回空列表
  }

  /// 计算两点之间的曼哈顿距离。
  /// 曼哈顿距离是两点在网格上沿着轴线的最短距离。
  /// h = |x1 - x2| + |y1 - y2|
  int _manhattan(math.Point<int> a, math.Point<int> b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }
}

/// A* 寻路算法中使用的内部节点类。
class _AStarNode {
  /// 节点在网格中的坐标。
  final math.Point<int> point;

  /// g 值：从起点到当前节点的实际代价。
  final int g;

  /// h 值：从当前节点到终点的估算代价（启发式）。
  final int h;

  /// 父节点，用于回溯生成最终路径。
  final _AStarNode? parent;

  /// 从父节点到当前节点的方向。
  final math.Point<int> direction;

  _AStarNode({
    required this.point,
    required this.g,
    required this.h,
    this.parent,
    required this.direction,
  });

  /// f 值：节点的总评估代价 (f = g + h)。
  int get f => g + h;
}
