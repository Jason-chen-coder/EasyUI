import 'dart:ui';

/// 表示流程图中的一个节点。
class EasyFlowNode {
  /// 节点的唯一标识符。
  final int id;

  /// 连接到此节点的上一个节点的ID列表。
  final List<int> previousIds;

  /// 此节点连接到的下一个节点的ID列表。
  final List<int> nextIds;

  /// 指向此节点的边的数量（入度）。
  int get inDegreeCount => previousIds.length;

  /// 从此节点出发的边的数量（出度）。
  int get outDegreeCount => nextIds.length;

  EasyFlowNode({
    required this.id,
    required this.previousIds,
    required this.nextIds,
  });
}

/// 表示流程图中连接两个节点的一条边。
class EasyFlowEdge {
  /// 边的起始节点的ID。
  final int from;

  /// 边的结束节点的ID。
  final int to;

  /// 边的颜色。
  final Color color;

  EasyFlowEdge({required this.from, required this.to, required this.color});
}

/// 图数据容器，包含所有的节点和边。
class EasyFlowGraph {
  /// 图中所有节点的列表。
  final List<EasyFlowNode> nodes;

  /// 图中所有边的列表。
  final List<EasyFlowEdge> edges;

  EasyFlowGraph({required this.nodes, required this.edges});

  /// 获取图中所有节点ID的集合。
  Set<int> get nodeIds => nodes.map((n) => n.id).toSet();
}
