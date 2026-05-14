import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class GradientBarDemo extends StatelessWidget {
  const GradientBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyMarqueeGradientBar 跑马灯渐变进度条'),

        // 基本介绍
        h2('组件概述'),
        p('EasyMarqueeGradientBar 是一个带有跑马灯动画效果的渐变进度条组件，适用于加载状态、处理中等时长任务等场景。'),

        // 基本用法
        h2('基本用法'),
        p('展示基本的跑马灯渐变进度条'),
        WidgetHighlight(
          builder: (_) => _BasicMarqueeBarDemo(),
          codeSnippet: '''
```dart
EasyMarqueeGradientBar(
      height: 18,
      width: 300,
      backgroundColor: Color(0xFFDDF8F2),
      barColor: Color(0xFF3CDAA2),
      duration: Duration(milliseconds: 1500),
    );
```
''',
        ),

        // 自定义颜色
        h2('自定义颜色'),
        p('自定义进度条和背景颜色'),
        WidgetHighlight(
          builder: (_) => _CustomColorMarqueeBarDemo(),
          codeSnippet: '''
```dart
Column(
      children: const [
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFE6F2FF),
          barColor: Color(0xFF1484FC),
        ),
        SizedBox(height: 16),
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFFFF2E6),
          barColor: Color(0xFFFF7D00),
        ),
        SizedBox(height: 16),
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFF2E6FF),
          barColor: Color(0xFF7D00FF),
        ),
      ],
    );
```
''',
        ),

        // 不同尺寸
        h2('不同尺寸'),
        p('调整进度条的高度'),
        WidgetHighlight(
          builder: (_) => _DifferentSizeMarqueeBarDemo(),
          codeSnippet: '''
```dart
Column(
      children: const [
        Text('小尺寸 (12px)'),
        EasyMarqueeGradientBar(height: 12),
        SizedBox(height: 16),
        Text('中尺寸 (18px)'),
        EasyMarqueeGradientBar(height: 18),
        SizedBox(height: 16),
        Text('大尺寸 (24px)'),
        EasyMarqueeGradientBar(height: 24),
      ],
    );
```
''',
        ),

        // 不同速度
        h2('不同速度'),
        p('调整动画速度'),
        WidgetHighlight(
          builder: (_) => _DifferentSpeedMarqueeBarDemo(),
          codeSnippet: '''
```dart
Column(
      children: const [
        Text('慢速 (2000ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 2000)),
        SizedBox(height: 16),
        Text('中速 (1500ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 1500)),
        SizedBox(height: 16),
        Text('快速 (800ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 800)),
      ],
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在文件上传中使用跑马灯进度条'),
        WidgetHighlight(
          builder: (_) => _FileUploadMarqueeBarDemo(),
          codeSnippet: '''
```dart
// 文件上传演示
class _FileUploadMarqueeBarDemo extends StatefulWidget {
  @override
  State<_FileUploadMarqueeBarDemo> createState() =>
      _FileUploadMarqueeBarDemoState();
}

class _FileUploadMarqueeBarDemoState extends State<_FileUploadMarqueeBarDemo> {
  bool _isProcessing = false;

  void _startProcess() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  void _cancelProcess() {
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('文件处理演示'),
        const SizedBox(height: 16),
        _isProcessing
            ? const EasyMarqueeGradientBar(
              height: 12,
              backgroundColor: Colors.grey,
              barColor: Colors.blue,
            )
            : Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isProcessing ? _cancelProcess : _startProcess,
          child: Text(_isProcessing ? '取消处理' : '开始处理'),
        ),
      ],
    );
  }
}

```
''',
        ),
        h2('MarqueeGradientBar参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyMarqueeGradientBar 参数说明：'),
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
                        DataCell(Text('height')),
                        DataCell(Text('double')),
                        DataCell(Text('12.0')),
                        DataCell(Text('否')),
                        DataCell(Text('进度条高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('进度条宽度，null时自适应')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFEEEEEE)')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('barColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('跑马灯颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('duration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 1500)')),
                        DataCell(Text('否')),
                        DataCell(Text('动画持续时间')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius')),
                        DataCell(Text('BorderRadius.circular(4)')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('gradientWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('80.0')),
                        DataCell(Text('否')),
                        DataCell(Text('渐变宽度')),
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
                    DataRow(
                      cells: [
                        DataCell(Text('margin')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('外边距')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('预设样式方法说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('背景颜色')),
                    DataColumn(label: Text('跑马灯颜色')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('blue')),
                        DataCell(Text('Color(0xFFE6F2FF)')),
                        DataCell(Text('Color(0xFF1484FC)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('amber')),
                        DataCell(Text('Color(0xFFFFF2E6)')),
                        DataCell(Text('Color(0xFFFF7D00)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('red')),
                        DataCell(Text('Color(0xFFFFE6E6)')),
                        DataCell(Text('Color(0xFFFF0000)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('green')),
                        DataCell(Text('Color(0xFFE6FFE6)')),
                        DataCell(Text('Color(0xFF00C853)')),
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

// 基本跑马灯演示
class _BasicMarqueeBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EasyMarqueeGradientBar(
      height: 18,
      width: 300,
      backgroundColor: Color(0xFFDDF8F2),
      barColor: Color(0xFF3CDAA2),
      duration: Duration(milliseconds: 1500),
    );
  }
}

// 自定义颜色演示
class _CustomColorMarqueeBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFE6F2FF),
          barColor: Color(0xFF1484FC),
        ),
        SizedBox(height: 16),
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFFFF2E6),
          barColor: Color(0xFFFF7D00),
        ),
        SizedBox(height: 16),
        EasyMarqueeGradientBar(
          height: 12,
          backgroundColor: Color(0xFFF2E6FF),
          barColor: Color(0xFF7D00FF),
        ),
      ],
    );
  }
}

// 不同尺寸演示
class _DifferentSizeMarqueeBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('小尺寸 (12px)'),
        EasyMarqueeGradientBar(height: 12),
        SizedBox(height: 16),
        Text('中尺寸 (18px)'),
        EasyMarqueeGradientBar(height: 18),
        SizedBox(height: 16),
        Text('大尺寸 (24px)'),
        EasyMarqueeGradientBar(height: 24),
      ],
    );
  }
}

// 不同速度演示
class _DifferentSpeedMarqueeBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('慢速 (2000ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 2000)),
        SizedBox(height: 16),
        Text('中速 (1500ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 1500)),
        SizedBox(height: 16),
        Text('快速 (800ms)'),
        EasyMarqueeGradientBar(duration: Duration(milliseconds: 800)),
      ],
    );
  }
}

// 文件上传演示
class _FileUploadMarqueeBarDemo extends StatefulWidget {
  @override
  State<_FileUploadMarqueeBarDemo> createState() =>
      _FileUploadMarqueeBarDemoState();
}

class _FileUploadMarqueeBarDemoState extends State<_FileUploadMarqueeBarDemo> {
  bool _isProcessing = false;

  void _startProcess() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    });
  }

  void _cancelProcess() {
    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('文件处理演示'),
        const SizedBox(height: 16),
        _isProcessing
            ? const EasyMarqueeGradientBar(
              height: 12,
              backgroundColor: Colors.grey,
              barColor: Colors.blue,
            )
            : Container(
              height: 12,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _isProcessing ? _cancelProcess : _startProcess,
          child: Text(_isProcessing ? '取消处理' : '开始处理'),
        ),
      ],
    );
  }
}
