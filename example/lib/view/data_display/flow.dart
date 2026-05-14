import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:flutter/material.dart';

import '../../widgets/widget_highlight.dart';

class EasyFlowDemo extends StatelessWidget {
  const EasyFlowDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyFlowView 流程图组件示例'),
        h2('基本用法'),
        WidgetHighlight(
          builder: (_) {
            return _EasyFlowBaseDemo();
          },

          codeSnippet: '''
```dart
class _EasyFlowBaseDemo extends StatefulWidget {
  const _EasyFlowBaseDemo({super.key});

  @override
  State<_EasyFlowBaseDemo> createState() => _EasyFlowBaseDemoState();
}

class _EasyFlowBaseDemoState extends State<_EasyFlowBaseDemo> {
  final double _maxScale = 3;
  final double _minScale = .3;
  final _initialMatrix = Matrix4.identity();
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController(_initialMatrix);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final graph = EasyFlowGraph(
      nodes: [
        EasyFlowNode(id: 0, previousIds: [], nextIds: [1]),
        EasyFlowNode(id: 1, previousIds: [0, 2, 3], nextIds: [2, 3]),
        EasyFlowNode(id: 2, previousIds: [1], nextIds: [4, 1]),
        EasyFlowNode(id: 3, previousIds: [1], nextIds: [5, 1]),
        EasyFlowNode(id: 4, previousIds: [2], nextIds: []),
        EasyFlowNode(id: 5, previousIds: [3], nextIds: [1]),
      ],
      edges: [
        EasyFlowEdge(from: 0, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 1, to: 2, color: Color(0xFF999999)),
        EasyFlowEdge(from: 1, to: 3, color: Color(0xFF999999)),
        EasyFlowEdge(from: 2, to: 4, color: Color(0xFF999999)),
        EasyFlowEdge(from: 3, to: 5, color: Color(0xFF999999)),
        EasyFlowEdge(from: 3, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 5, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 2, to: 1, color: Color(0xFF999999)),
      ],
    );

    return SizedBox(
      height: 500,
      child: Stack(
        children: [
          // 通过InteractiveViewer获得拖拽和缩放能力
          EasyFlowView(
            maxScale: _maxScale,
            minScale: _minScale,
            transformationController: _controller,
            scaleEnabled: false,
            // 禁止双指缩放和鼠标滚轮缩放
            graph: graph,
            nodeBuilder: (context, index) {
              final node = graph.nodes[index];
              return Material(
                type: MaterialType.card,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {},
                  child: Ink(
                    width: 110,
                    height: 110,
                    child: Center(child: Text('Node \${node.id}')),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Column(
              spacing: 12,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    final matrix = _controller.value;
                    final currentScale = matrix.storage[0];
                    if (currentScale < _maxScale) {
                      final newMatrix = matrix.clone()..scale(1.2);
                      _controller.value = newMatrix;
                    }
                  },
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final matrix = _controller.value;
                    final currentScale = matrix.storage[0];
                    if (currentScale > _minScale) {
                      final newMatrix = matrix.clone()..scale(.8);
                      _controller.value = newMatrix;
                    }
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


```
''',
        ),
        h2('EasyFlowView参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyFlowView 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('默认值')),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('graph')),
                        DataCell(Text('EasyFlowGraph')),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(Text('流程图的数据模型，包含节点和边。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('nodeBuilder')),
                        DataCell(
                          Text(
                            'Widget Function(BuildContext context, int index)',
                          ),
                        ),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(
                          Text('节点构建器，用于根据 [EasyFlowNode] 数据创建对应的 Widget。'),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('horizontalSpacingUnits')),
                        DataCell(Text('int')),
                        DataCell(Text('6')),
                        DataCell(Text('否')),
                        DataCell(Text('节点之间的水平间距（以网格为单位）。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('verticalSpacingUnits')),
                        DataCell(Text('int')),
                        DataCell(Text('6')),
                        DataCell(Text('否')),
                        DataCell(Text('节点之间的垂直间距（以网格为单位）。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('algorithm')),
                        DataCell(Text('EasyFlowAlgorithm')),
                        DataCell(Text('const EasyFlowAlgorithm()')),
                        DataCell(Text('否')),
                        DataCell(Text('用于布局计算和路径寻路的算法实例。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('edgePainter')),
                        DataCell(Text('EasyFlowEdgePainter')),
                        DataCell(Text('const DefaultEasyFlowEdgePainter()')),
                        DataCell(Text('否')),
                        DataCell(Text('用于绘制路径的实例。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('transformationController')),
                        DataCell(Text('TransformationController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('[InteractiveViewer] 的变换控制器。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('maxScale')),
                        DataCell(Text('double')),
                        DataCell(Text('3.0')),
                        DataCell(Text('否')),
                        DataCell(Text('[InteractiveViewer] 允许的最大缩放比例。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('minScale')),
                        DataCell(Text('double')),
                        DataCell(Text('0.3')),
                        DataCell(Text('否')),
                        DataCell(Text('[InteractiveViewer] 允许的最小缩放比例。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('scaleEnabled')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用[InteractiveViewer]自带的缩放功能。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('gridSize')),
                        DataCell(Text('int')),
                        DataCell(Text('12')),
                        DataCell(Text('否')),
                        DataCell(
                          Text('网格单元格的尺寸（像素）。除了节点Widget大小所有布局和间距都基于这个尺寸。'),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('horizontalPaddingUnits')),
                        DataCell(Text('int')),
                        DataCell(Text('6')),
                        DataCell(Text('否')),
                        DataCell(Text('水平方向的内边距（以网格为单位）。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('verticalPaddingUnits')),
                        DataCell(Text('int')),
                        DataCell(Text('6')),
                        DataCell(Text('否')),
                        DataCell(Text('垂直方向的内边距（以网格为单位）。')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('nodeBufferUnits')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('节点矩形在网格中的额外缓冲区域（以网格为单位）。')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}

class _EasyFlowBaseDemo extends StatefulWidget {
  const _EasyFlowBaseDemo();

  @override
  State<_EasyFlowBaseDemo> createState() => _EasyFlowBaseDemoState();
}

class _EasyFlowBaseDemoState extends State<_EasyFlowBaseDemo> {
  final double _maxScale = 3;
  final double _minScale = .3;
  final _initialMatrix = Matrix4.identity();
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController(_initialMatrix);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final graph = EasyFlowGraph(
      nodes: [
        EasyFlowNode(id: 0, previousIds: [], nextIds: [1]),
        EasyFlowNode(id: 1, previousIds: [0, 2, 3], nextIds: [2, 3]),
        EasyFlowNode(id: 2, previousIds: [1], nextIds: [4, 1]),
        EasyFlowNode(id: 3, previousIds: [1], nextIds: [5, 1]),
        EasyFlowNode(id: 4, previousIds: [2], nextIds: []),
        EasyFlowNode(id: 5, previousIds: [3], nextIds: [1]),
      ],
      edges: [
        EasyFlowEdge(from: 0, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 1, to: 2, color: Color(0xFF999999)),
        EasyFlowEdge(from: 1, to: 3, color: Color(0xFF999999)),
        EasyFlowEdge(from: 2, to: 4, color: Color(0xFF999999)),
        EasyFlowEdge(from: 3, to: 5, color: Color(0xFF999999)),
        EasyFlowEdge(from: 3, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 5, to: 1, color: Color(0xFF999999)),
        EasyFlowEdge(from: 2, to: 1, color: Color(0xFF999999)),
      ],
    );

    return SizedBox(
      height: 500,
      child: Stack(
        children: [
          // 通过InteractiveViewer获得拖拽和缩放能力
          EasyFlowView(
            maxScale: _maxScale,
            minScale: _minScale,
            transformationController: _controller,
            scaleEnabled: false,
            // 禁止双指缩放和鼠标滚轮缩放
            graph: graph,
            nodeBuilder: (context, index) {
              final node = graph.nodes[index];
              return Material(
                type: MaterialType.card,
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () {},
                  child: Ink(
                    width: 110,
                    height: 110,
                    child: Center(child: Text('Node ${node.id}')),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Column(
              spacing: 12,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    final matrix = _controller.value;
                    final currentScale = matrix.storage[0];
                    if (currentScale < _maxScale) {
                      final newMatrix = matrix.clone()..scale(1.2);
                      _controller.value = newMatrix;
                    }
                  },
                  child: Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () {
                    final matrix = _controller.value;
                    final currentScale = matrix.storage[0];
                    if (currentScale > _minScale) {
                      final newMatrix = matrix.clone()..scale(.8);
                      _controller.value = newMatrix;
                    }
                  },
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
