import 'dart:async';

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class LinearProgressDemo extends StatelessWidget {
  const LinearProgressDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyLinearProgressIndicator 线性进度条'),

        // 基本介绍
        h2('组件概述'),
        p(
          'EasyLinearProgressIndicator 是一个美观的线性进度指示器，支持百分比显示、多种预设样式和自定义配置，适用于任务进度、加载状态等场景。',
        ),

        // 基本用法
        h2('基本用法'),
        p('展示基本的线性进度条'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _BasicProgressDemo(),
          codeSnippet: '''
```dart
EasyLinearProgressIndicator(
      progress: 0.65,
      height: 12,
      width: 300,
      showProgressText:false
    );
```
''',
        ),

        // 预设样式
        h2('预设样式'),
        p('使用内置的四种颜色样式'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _PresetStyleProgressDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyLinearProgressIndicator.blue(progress: 0.4, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.amber(progress: 0.6, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.red(progress: 0.8, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.green(progress: 0.3, height: 12),
      ],
    );
```
''',
        ),

        // 自定义样式
        h2('自定义样式'),
        p('完全自定义进度条的外观'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _CustomStyleProgressDemo(),
          codeSnippet: '''
```dart
 EasyLinearProgressIndicator(
      progress: 0.75,
      height: 18,
      width: 400,
      progressTextInActiveStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      activeBackgroundColor: Colors.purple,
      passiveBackgroundColor: Colors.grey[200],
    );
```
''',
        ),

        // 不同尺寸
        h2('不同尺寸'),
        p('调整进度条的高度'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _DifferentSizeProgressDemo(),
          codeSnippet: '''
```dart
Column(
      children: const [
        Text('小尺寸 (8px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 8),
        SizedBox(height: 16),
        Text('中尺寸 (12px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 12),
        SizedBox(height: 16),
        Text('大尺寸 (18px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 18),
        SizedBox(height: 16),
        Text('超大尺寸 (24px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 24),
      ],
    );
```
''',
        ),

        // 动画效果
        h2('动画效果'),
        p('展示进度变化的动画效果'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _AnimatedProgressDemo(),
          codeSnippet: '''
```dart
// 动画效果演示
class _AnimatedProgressDemo extends StatefulWidget {
  @override
  State<_AnimatedProgressDemo> createState() => _AnimatedProgressDemoState();
}

class _AnimatedProgressDemoState extends State<_AnimatedProgressDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            EasyLinearProgressIndicator(progress: _animation.value, height: 12),
            const SizedBox(height: 8),
            Text(
              '当前进度: \${(_animation.value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在文件上传中使用进度条'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => _FileUploadProgressDemo(),
          codeSnippet: '''
```dart
// 文件上传演示
class _FileUploadProgressDemo extends StatefulWidget {
  @override
  State<_FileUploadProgressDemo> createState() =>
      _FileUploadProgressDemoState();
}

class _FileUploadProgressDemoState extends State<_FileUploadProgressDemo> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startUpload() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
        }
      });
    });
  }

  void _cancelUpload() {
    _timer?.cancel();
    setState(() => _progress = 0.0);
  }

  void _complete() {
    setState(() => _progress = 0.0);
    _startUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('上传进度: \${(_progress * 100).toStringAsFixed(1)}%'),
        const SizedBox(height: 8),
        EasyLinearProgressIndicator(
          progress: _progress,
          height: 12,
          activeBackgroundColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        if (_progress < 1.0)
          ElevatedButton(onPressed: _cancelUpload, child: const Text('取消上传'))
        else
          ElevatedButton(onPressed: _complete, child: const Text('完成')),
      ],
    );
  }
}

```
''',
        ),
        h2('LinearProgress参数说明'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyLinearProgressIndicator 参数说明：'),
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
                        DataCell(Text('progress')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('是')),
                        DataCell(Text('进度值(0.0-1.0)')),
                      ],
                    ),
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
                        DataCell(Text('activeBackgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('已完成部分背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('passiveBackgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey[200]!')),
                        DataCell(Text('否')),
                        DataCell(Text('未完成部分背景色')),
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
                        DataCell(Text('showProgressText')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('是')),
                        DataCell(Text('是否显示进度文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('progressTextInActiveStyle')),
                        DataCell(Text('TextStyle')),
                        DataCell(
                          Text('TextStyle(color: Colors.white, fontSize: 12)'),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('已完成部分文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('progressTextInPassiveStyle')),
                        DataCell(Text('TextStyle')),
                        DataCell(
                          Text('TextStyle(color: Colors.grey, fontSize: 12)'),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('未完成部分文本样式')),
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
                    DataColumn(label: Text('文本颜色')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('blue')),
                        DataCell(Text('Colors.blue')),
                        DataCell(Text('Colors.white')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('amber')),
                        DataCell(Text('Colors.amber')),
                        DataCell(Text('Colors.black87')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('red')),
                        DataCell(Text('Colors.red')),
                        DataCell(Text('Colors.white')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('green')),
                        DataCell(Text('Colors.green')),
                        DataCell(Text('Colors.white')),
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

// 基本进度条演示
class _BasicProgressDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EasyLinearProgressIndicator(
      progress: 0.65,
      height: 12,
      width: 300,
      showProgressText: false,
    );
  }
}

// 预设样式演示
class _PresetStyleProgressDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyLinearProgressIndicator.blue(progress: 0.4, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.amber(progress: 0.6, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.red(progress: 0.8, height: 12),
        SizedBox(height: 16),
        EasyLinearProgressIndicator.green(progress: 0.3, height: 12),
      ],
    );
  }
}

// 自定义样式演示
class _CustomStyleProgressDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyLinearProgressIndicator(
      progress: 0.75,
      height: 18,
      width: 400,
      progressTextInActiveStyle: const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      progressTextInPassiveStyle: const TextStyle(
        fontSize: 14,
        color: Colors.grey,
      ),
      activeBackgroundColor: Colors.purple,
      passiveBackgroundColor: Colors.grey[200],
    );
  }
}

// 不同尺寸演示
class _DifferentSizeProgressDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('小尺寸 (8px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 8),
        SizedBox(height: 16),
        Text('中尺寸 (12px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 12),
        SizedBox(height: 16),
        Text('大尺寸 (18px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 18),
        SizedBox(height: 16),
        Text('超大尺寸 (24px)'),
        EasyLinearProgressIndicator(progress: 0.5, height: 24),
      ],
    );
  }
}

// 动画效果演示
class _AnimatedProgressDemo extends StatefulWidget {
  @override
  State<_AnimatedProgressDemo> createState() => _AnimatedProgressDemoState();
}

class _AnimatedProgressDemoState extends State<_AnimatedProgressDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            EasyLinearProgressIndicator(progress: _animation.value, height: 12),
            const SizedBox(height: 8),
            Text(
              '当前进度: ${(_animation.value * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        );
      },
    );
  }
}

// 文件上传演示
class _FileUploadProgressDemo extends StatefulWidget {
  @override
  State<_FileUploadProgressDemo> createState() =>
      _FileUploadProgressDemoState();
}

class _FileUploadProgressDemoState extends State<_FileUploadProgressDemo> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startUpload() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        _progress += 0.05;
        if (_progress >= 1.0) {
          _progress = 1.0;
          timer.cancel();
        }
      });
    });
  }

  void _cancelUpload() {
    _timer?.cancel();
    setState(() => _progress = 0.0);
  }

  void _complete() {
    setState(() => _progress = 0.0);
    _startUpload();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('上传进度: ${(_progress * 100).toStringAsFixed(1)}%'),
        const SizedBox(height: 8),
        EasyLinearProgressIndicator(
          progress: _progress,
          height: 12,
          activeBackgroundColor: Colors.blue,
        ),
        const SizedBox(height: 16),
        if (_progress < 1.0)
          ElevatedButton(onPressed: _cancelUpload, child: const Text('取消上传'))
        else
          ElevatedButton(onPressed: _complete, child: const Text('完成')),
      ],
    );
  }
}
