import 'dart:math';

import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/paragraph_helper.dart';
import '../widgets/widget_highlight.dart';

class EasySignaturePadExample extends StatefulWidget {
  const EasySignaturePadExample({super.key});

  @override
  State<EasySignaturePadExample> createState() =>
      _EasySignaturePadExampleState();
}

class _EasySignaturePadExampleState extends State<EasySignaturePadExample> {
  late final EasySignaturePadController _signaturePadController;
  bool _themeApplied = false;

  @override
  void initState() {
    _signaturePadController = EasySignaturePadController(
      stokeColor: Colors.black,
      strokeWidth: 6.0,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_themeApplied) {
      return;
    }
    _signaturePadController.strokeColor = EasyTheme.of(context).onBackground;
    _themeApplied = true;
  }

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySignaturePad'),
        p('签名手写板组件Demo'),
        div(),
        h2('组件预览'),
        WidgetHighlight(
          codeSnippet: '''
可以在这里存放组件代码片段或者简短的文档，支持markdown语法，例如：
```dart
  Column(
    children: [
      LayoutBuilder(
        builder: (context, constraints) {
          return EasySignaturePad(
            size: Size(constraints.maxWidth, 400),
            controller: _signaturePadController,
          );
        },
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          ElevatedButton(
            onPressed: () => _signaturePadController.clear(),
            child: Text('Clear Pad'),
          ),
          ElevatedButton(
            onPressed: () {
              final randomIndex = Random().nextInt(100);
              final color =
              Colors.primaries[randomIndex %
                  Colors.primaries.length];
              _signaturePadController.strokeColor = color;
            },
            child: Text('Random Stroke Color'),
          ),
          ElevatedButton(
            onPressed: () {
              double randomWidth = .0;
              do {
                randomWidth =
                    Random().nextInt(100).clamp(6, 20).toDouble();
              } while (randomWidth ==
                  _signaturePadController.strokeWidth);
              _signaturePadController.strokeWidth = randomWidth;
            },
            child: Text('Random Stroke Width'),
          ),
          ElevatedButton(
            onPressed: () {
              _signaturePadController.exportPngImage().then((
                  bytes,
                  ) {
                if (bytes != null) {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                      title: Text('Exported Png Image'),
                      content: Image.memory(bytes),
                      actions: [
                        TextButton(
                          onPressed:
                              () => Navigator.of(context).pop(),
                          child: Text('Close'),
                        ),
                      ],
                    ),
                  );
                }
              });
            },
            child: Text('Export Png Image'),
          ),
        ],
      ),
    ],
  );
```''',
          builder:
              (context) => Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return EasySignaturePad(
                        size: Size(constraints.maxWidth, 400),
                        controller: _signaturePadController,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      ElevatedButton(
                        onPressed: () => _signaturePadController.clear(),
                        child: Text('Clear Pad'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final randomIndex = Random().nextInt(100);
                          final color =
                              Colors.primaries[randomIndex %
                                  Colors.primaries.length];
                          _signaturePadController.strokeColor = color;
                        },
                        child: Text('Random Stroke Color'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double randomWidth = .0;
                          do {
                            randomWidth =
                                Random().nextInt(100).clamp(6, 20).toDouble();
                          } while (randomWidth ==
                              _signaturePadController.strokeWidth);
                          _signaturePadController.strokeWidth = randomWidth;
                        },
                        child: Text('Random Stroke Width'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _signaturePadController.exportPngImage().then((
                            bytes,
                          ) {
                            if (bytes != null) {
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: Text('Exported Png Image'),
                                      content: Image.memory(bytes),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          child: Text('Close'),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          });
                        },
                        child: Text('Export Png Image'),
                      ),
                    ],
                  ),
                ],
              ),
        ),
        h2('SignaturePad参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasySignaturePad 参数说明：'),
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
                        DataCell(Text('size')),
                        DataCell(Text('Size')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('手写板尺寸')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasySignaturePadController')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('控制器，用于操作手写板')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('手写板背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius')),
                        DataCell(Text('BorderRadius.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('border')),
                        DataCell(Text('Border?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('边框样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasySignaturePadController 参数说明：'),
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
                        DataCell(Text('strokeColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.black')),
                        DataCell(Text('否')),
                        DataCell(Text('笔划颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('strokeWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('3.0')),
                        DataCell(Text('否')),
                        DataCell(Text('笔划宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onDrawStart')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('开始绘制回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onDrawEnd')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('结束绘制回调')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasySignaturePadController 方法说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('返回值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('clear')),
                        DataCell(Text('void')),
                        DataCell(Text('清除手写板内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('exportPngImage')),
                        DataCell(Text('Future<Uint8List?>')),
                        DataCell(Text('导出为PNG图片二进制数据')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('exportJpgImage')),
                        DataCell(Text('Future<Uint8List?>')),
                        DataCell(Text('导出为JPG图片二进制数据')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('hasContent')),
                        DataCell(Text('bool')),
                        DataCell(Text('检查是否有绘制内容')),
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
