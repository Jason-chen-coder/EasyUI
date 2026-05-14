import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class PopoverDemo extends StatelessWidget {
  const PopoverDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyPopover 弹出框组件'),

        // 基本介绍
        h2('组件概述'),
        p('EasyPopover 是一个灵活的弹出框组件，支持多种显示方向和丰富的自定义选项，适用于工具提示、菜单、上下文操作等场景。'),

        // 基本用法
        h2('基本用法'),
        p('展示基本的弹出框功能'),
        WidgetHighlight(
          builder: (_) => _BasicPopoverDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text('这是一个基本弹出框'),
              ),
        );
      },
      child: const Text('显示基本弹出框'),
    );
```
''',
        ),

        // 不同方向
        h2('不同显示方向'),
        p('支持上下左右四个方向的弹出'),
        p('如果弹出层位置异常，请使用`Builder`组件包裹需要触发弹出框的组件'),
        WidgetHighlight(
          builder: (_) => _DirectionPopoverDemo(),
          codeSnippet: '''
```dart
  Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            showEasyPopover(
              context: context,
              direction: EasyPopoverDirection.top,
              contentBuilder:
                  (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('上方弹出框'),
                  ),
            );
          },
          child: const Text('上方弹出'),
        );
      },
    ),
    Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            showEasyPopover(
              context: context,
              direction: EasyPopoverDirection.bottom,
              contentBuilder:
                  (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('下方弹出框'),
                  ),
            );
          },
          child: const Text('下方弹出'),
        );
      },
    ),
    Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            showEasyPopover(
              context: context,
              direction: EasyPopoverDirection.left,
              contentBuilder:
                  (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('左侧弹出框'),
                  ),
            );
          },
          child: const Text('左侧弹出'),
        );
      },
    ),
    Builder(
      builder: (context) {
        return ElevatedButton(
          onPressed: () {
            showEasyPopover(
              context: context,
              direction: EasyPopoverDirection.right,
              contentBuilder:
                  (context) => Container(
                    padding: const EdgeInsets.all(16),
                    child: const Text('右侧弹出框'),
                  ),
            );
          },
          child: const Text('右侧弹出'),
        );
      },
    ),
  ],
  );
```
''',
        ),

        // 自定义样式
        h2('自定义样式'),
        p('自定义弹出框的外观'),
        WidgetHighlight(
          builder: (_) => _StyledPopoverDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  '自定义样式弹出框',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          width: 300,
          height: 150,
          backgroundColor: Colors.blue,
          radius: 20,
          arrowWidth: 20,
          arrowHeight: 10,
          shadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        );
      },
      child: const Text('显示自定义样式弹出框'),
    );
```
''',
        ),
        // 偏移调整
        h2('偏移调整'),
        p('调整弹出框和箭头的位置'),
        WidgetHighlight(
          builder: (_) => _OffsetPopoverDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text('带偏移的弹出框'),
              ),
          arrowDxOffset: 20,
          arrowDyOffset: -10,
          contentDxOffset: 10,
          contentDyOffset: 5,
        );
      },
      child: const Text('显示带偏移的弹出框'),
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在表格操作列中使用'),
        WidgetHighlight(
          builder: (_) => _TableActionPopoverDemo(),
          codeSnippet: '''
```dart
SizedBox(
      width: 400,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('姓名')),
          DataColumn(label: Text('年龄')),
          DataColumn(label: Text('操作')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('张三')),
              const DataCell(Text('25')),
              DataCell(
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showEasyPopover(
                          context: context,
                          direction: EasyPopoverDirection.bottom,
                          contentBuilder:
                              (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text('编辑'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(content: Text('编辑操作')),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      '删除',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(content: Text('删除操作')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
```
''',
        ),
        h2('Popover参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyPopover 参数说明：'),
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
                        DataCell(Text('contentBuilder')),
                        DataCell(Text('Widget Function(BuildContext)')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('构建弹出框内容的回调函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('direction')),
                        DataCell(Text('EasyPopoverDirection')),
                        DataCell(Text('EasyPopoverDirection.bottom')),
                        DataCell(Text('否')),
                        DataCell(Text('弹出方向：top/bottom/left/right')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('弹出框宽度，null时自适应')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('弹出框高度，null时自适应')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('radius')),
                        DataCell(Text('double')),
                        DataCell(Text('8.0')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('arrowWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('16.0')),
                        DataCell(Text('否')),
                        DataCell(Text('箭头宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('arrowHeight')),
                        DataCell(Text('double')),
                        DataCell(Text('8.0')),
                        DataCell(Text('否')),
                        DataCell(Text('箭头高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('arrowDxOffset')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('箭头水平偏移')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('arrowDyOffset')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('箭头垂直偏移')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('contentDxOffset')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('内容水平偏移')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('contentDyOffset')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('内容垂直偏移')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('shadow')),
                        DataCell(Text('List<BoxShadow>')),
                        DataCell(
                          Text(
                            '[BoxShadow(color: Colors.black12, blurRadius: 4)]',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('阴影效果')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(16)')),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('margin')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('外边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('constraints')),
                        DataCell(Text('BoxConstraints?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('约束条件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('barrierColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('否')),
                        DataCell(Text('遮罩层颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('barrierDismissible')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('点击遮罩层是否关闭')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('transitionDuration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 200)')),
                        DataCell(Text('否')),
                        DataCell(Text('动画持续时间')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyPopoverDirection 枚举说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('枚举值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [DataCell(Text('top')), DataCell(Text('上方弹出'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('bottom')), DataCell(Text('下方弹出'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('left')), DataCell(Text('左侧弹出'))],
                    ),
                    DataRow(
                      cells: [DataCell(Text('right')), DataCell(Text('右侧弹出'))],
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

// 基本弹出框演示
class _BasicPopoverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text('这是一个基本弹出框'),
              ),
        );
      },
      child: const Text('显示基本弹出框'),
    );
  }
}

// 不同方向弹出框演示
class _DirectionPopoverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showEasyPopover(
                  context: context,
                  direction: EasyPopoverDirection.top,
                  contentBuilder:
                      (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('上方弹出框'),
                      ),
                );
              },
              child: const Text('上方弹出'),
            );
          },
        ),
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showEasyPopover(
                  context: context,
                  direction: EasyPopoverDirection.bottom,
                  contentBuilder:
                      (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('下方弹出框'),
                      ),
                );
              },
              child: const Text('下方弹出'),
            );
          },
        ),
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showEasyPopover(
                  context: context,
                  direction: EasyPopoverDirection.left,
                  contentBuilder:
                      (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('左侧弹出框'),
                      ),
                );
              },
              child: const Text('左侧弹出'),
            );
          },
        ),
        Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showEasyPopover(
                  context: context,
                  direction: EasyPopoverDirection.right,
                  contentBuilder:
                      (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text('右侧弹出框'),
                      ),
                );
              },
              child: const Text('右侧弹出'),
            );
          },
        ),
      ],
    );
  }
}

// 自定义样式弹出框演示
class _StyledPopoverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text(
                  '自定义样式弹出框',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          width: 300,
          height: 150,
          backgroundColor: Colors.blue,
          radius: 20,
          arrowWidth: 20,
          arrowHeight: 10,
          shadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        );
      },
      child: const Text('显示自定义样式弹出框'),
    );
  }
}

// 偏移调整弹出框演示
class _OffsetPopoverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyPopover(
          context: context,
          contentBuilder:
              (context) => Container(
                padding: const EdgeInsets.all(16),
                child: const Text('带偏移的弹出框'),
              ),
          arrowDxOffset: 20,
          arrowDyOffset: -10,
          contentDxOffset: 10,
          contentDyOffset: 5,
        );
      },
      child: const Text('显示带偏移的弹出框'),
    );
  }
}

// 表格操作列弹出框演示
class _TableActionPopoverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('姓名')),
          DataColumn(label: Text('年龄')),
          DataColumn(label: Text('操作')),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('张三')),
              const DataCell(Text('25')),
              DataCell(
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showEasyPopover(
                          context: context,
                          direction: EasyPopoverDirection.bottom,
                          contentBuilder:
                              (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text('编辑'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(content: Text('编辑操作')),
                                      );
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: const Text(
                                      '删除',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(content: Text('删除操作')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
