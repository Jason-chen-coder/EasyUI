import 'dart:math' as math;

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class EasyRadialProgressIndicatorDemo extends StatelessWidget {
  const EasyRadialProgressIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyRadialProgressIndicator 径向进度指示器'),

        // 基本介绍
        h2('组件概述'),
        p(
          'EasyRadialProgressIndicator 是一个带刻度的环形进度指示器，支持多种预设主题、缺口模式、自定义样式配置，适用于仪表盘、数据统计等场景。',
        ),

        // 基本用法
        h2('基本用法'),
        p('展示基本的径向进度指示器（闭合圆环）'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _BasicDemo(),
          codeSnippet: '''
```dart
EasyRadialProgressIndicator(
  value: 2052,
  total: 9364,
  size: 200,
)
```
''',
        ),

        // 带缺口模式
        h2('带缺口模式'),
        p('通过 gapAngle 参数设置底部缺口，呈现仪表盘效果'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _GapDemo(),
          codeSnippet: '''
```dart
EasyRadialProgressIndicator(
  value: 2052,
  total: 9364,
  size: 200,
  gapAngle: math.pi / 3, // 60度缺口
)
```
''',
        ),

        // 预设主题
        h2('预设主题'),
        p('内置四种颜色主题：红色（默认）、蓝色、绿色、橙色'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _PresetStyleDemo(),
          codeSnippet: '''
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    EasyRadialProgressIndicator(
      value: 2052, total: 9364, size: 150,
      style: EasyRadialProgressIndicatorStyle.red(),
    ),
    EasyRadialProgressIndicator(
      value: 6000, total: 9364, size: 150,
      style: EasyRadialProgressIndicatorStyle.blue(),
    ),
    EasyRadialProgressIndicator(
      value: 4000, total: 9364, size: 150,
      style: EasyRadialProgressIndicatorStyle.green(),
    ),
    EasyRadialProgressIndicator(
      value: 3000, total: 9364, size: 150,
      style: EasyRadialProgressIndicatorStyle.orange(),
    ),
  ],
)
```
''',
        ),

        // 自定义样式
        h2('自定义样式'),
        p('通过 EasyRadialProgressIndicatorStyle 完全自定义外观'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _CustomStyleDemo(),
          codeSnippet: '''
```dart
EasyRadialProgressIndicator(
  value: 750,
  total: 1000,
  size: 200,
  tickCount: 40,
  style: EasyRadialProgressIndicatorStyle(
    outerRingGradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFF8855ED), Color(0xFFAA88F3)],
    ),
    trackOpacity: 0.15,
    tickActiveColor: Color(0xFF7C3AED),
    tickActiveMinOpacity: 0.2,
    dotInnerGradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
    ),
    valueColor: Color(0xFF7C3AED),
  ),
)
```
''',
        ),

        // 不同尺寸
        h2('不同尺寸'),
        p('调整 size 参数改变组件大小，所有内部尺寸按比例缩放'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _DifferentSizeDemo(),
          codeSnippet: '''
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    EasyRadialProgressIndicator(value: 65, total: 100, size: 100),
    EasyRadialProgressIndicator(value: 65, total: 100, size: 150),
    EasyRadialProgressIndicator(value: 65, total: 100, size: 200),
    EasyRadialProgressIndicator(value: 65, total: 100, size: 260),
  ],
)
```
''',
        ),

        // 自定义中心内容
        h2('自定义中心内容'),
        p('通过 child 参数替换默认的数字文本显示'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _CustomChildDemo(),
          codeSnippet: '''
```dart
EasyRadialProgressIndicator(
  value: 75,
  total: 100,
  size: 200,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.check_circle, color: Color(0xFFFB3F40), size: 40),
      Text('75%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    ],
  ),
)
```
''',
        ),

        // 主题切换动画
        h2('主题切换动画'),
        p('切换不同主题时颜色平滑过渡'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _StyleSwitchDemo(),
          codeSnippet: '''
```dart
// 切换 style 时组件自动做颜色过渡动画
EasyRadialProgressIndicator(
  value: 5000,
  total: 9364,
  size: 200,
  style: _currentStyle, // 切换不同主题
)
```
''',
        ),

        // 进度变化动画
        h2('进度变化动画'),
        p('点击按钮触发进度变化，观察平滑过渡动画效果'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _ProgressChangeDemo(),
          codeSnippet: '''
```dart
// 每次点击按钮更新 value，组件自动动画过渡
ElevatedButton(
  onPressed: () => setState(() => _value = 随机值),
  child: Text('随机进度'),
),
EasyRadialProgressIndicator(
  value: _value,
  total: 9364,
  size: 200,
  animationDuration: Duration(milliseconds: 800),
)
```
''',
        ),

        // 参数说明
        h2('EasyRadialProgressIndicator 参数说明'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _ParameterTable(),
          codeSnippet: "",
        ),

        // Style 参数说明
        h2('EasyRadialProgressIndicatorStyle 参数说明'),
        WidgetHighlight(
          backgroundColor: EasyTheme.of(context).neutralF8,
          builder: (_) => const _StyleParameterTable(),
          codeSnippet: "",
        ),
      ],
    );
  }
}

// ========== 基本用法 ==========
class _BasicDemo extends StatelessWidget {
  const _BasicDemo();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: EasyRadialProgressIndicator(value: 2052, total: 9364, size: 200),
    );
  }
}

// ========== 带缺口模式 ==========
class _GapDemo extends StatelessWidget {
  const _GapDemo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const EasyRadialProgressIndicator(
                value: 2052,
                total: 9364,
                size: 180,
                gapAngle: math.pi / 4,
              ),
              const SizedBox(height: 8),
              Text('45°缺口', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          Column(
            children: [
              const EasyRadialProgressIndicator(
                value: 2052,
                total: 9364,
                size: 180,
                gapAngle: math.pi / 3,
              ),
              const SizedBox(height: 8),
              Text('60°缺口', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          Column(
            children: [
              const EasyRadialProgressIndicator(
                value: 2052,
                total: 9364,
                size: 180,
                gapAngle: math.pi / 2,
              ),
              const SizedBox(height: 8),
              Text('90°缺口', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }
}

// ========== 预设主题 ==========
class _PresetStyleDemo extends StatelessWidget {
  const _PresetStyleDemo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            EasyRadialProgressIndicator(
              value: 2052,
              total: 9364,
              size: 150,
              style: EasyRadialProgressIndicatorStyle.red(),
            ),
            const SizedBox(height: 8),
            Text('红色（默认）', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            EasyRadialProgressIndicator(
              value: 6000,
              total: 9364,
              size: 150,
              style: EasyRadialProgressIndicatorStyle.blue(),
            ),
            const SizedBox(height: 8),
            Text('蓝色', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            EasyRadialProgressIndicator(
              value: 4000,
              total: 9364,
              size: 150,
              style: EasyRadialProgressIndicatorStyle.green(),
            ),
            const SizedBox(height: 8),
            Text('绿色', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            EasyRadialProgressIndicator(
              value: 3000,
              total: 9364,
              size: 150,
              style: EasyRadialProgressIndicatorStyle.orange(),
            ),
            const SizedBox(height: 8),
            Text('橙色', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}

// ========== 自定义样式 ==========
class _CustomStyleDemo extends StatelessWidget {
  const _CustomStyleDemo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EasyRadialProgressIndicator(
        value: 750,
        total: 1000,
        size: 200,
        tickCount: 40,
        style: const EasyRadialProgressIndicatorStyle(
          outerRingGradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF8855ED), Color(0xFFAA88F3)],
          ),
          trackOpacity: 0.15,
          tickActiveColor: Color(0xFF7C3AED),
          tickActiveMinOpacity: 0.2,
          dotInnerGradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
          ),
          valueColor: Color(0xFF7C3AED),
        ),
      ),
    );
  }
}

// ========== 不同尺寸 ==========
class _DifferentSizeDemo extends StatelessWidget {
  const _DifferentSizeDemo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          children: [
            const EasyRadialProgressIndicator(value: 65, total: 100, size: 100),
            const SizedBox(height: 8),
            Text('100', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            const EasyRadialProgressIndicator(value: 65, total: 100, size: 150),
            const SizedBox(height: 8),
            Text('150', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            const EasyRadialProgressIndicator(value: 65, total: 100, size: 200),
            const SizedBox(height: 8),
            Text('200', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        Column(
          children: [
            const EasyRadialProgressIndicator(value: 65, total: 100, size: 260),
            const SizedBox(height: 8),
            Text('260', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}

// ========== 自定义中心内容 ==========
class _CustomChildDemo extends StatelessWidget {
  const _CustomChildDemo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EasyRadialProgressIndicator(
        value: 75,
        total: 100,
        size: 200,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Color(0xFFFB3F40), size: 40),
            SizedBox(height: 4),
            Text(
              '75%',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFB3F40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========== 动画效果 ==========
class _AnimatedDemo extends StatefulWidget {
  const _AnimatedDemo();

  @override
  State<_AnimatedDemo> createState() => _AnimatedDemoState();
}

class _AnimatedDemoState extends State<_AnimatedDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return EasyRadialProgressIndicator(
            value: _animation.value * 9364,
            total: 9364,
            size: 200,
            gapAngle: math.pi / 3,
          );
        },
      ),
    );
  }
}

// ========== 进度变化动画 ==========
class _ProgressChangeDemo extends StatefulWidget {
  const _ProgressChangeDemo();

  @override
  State<_ProgressChangeDemo> createState() => _ProgressChangeDemoState();
}

class _ProgressChangeDemoState extends State<_ProgressChangeDemo> {
  double _value = 2052;
  final double _total = 9364;
  final _random = math.Random();

  void _randomProgress() {
    setState(() => _value = _random.nextDouble() * _total);
  }

  void _increaseProgress() {
    setState(() => _value = (_value + _total * 0.1).clamp(0, _total));
  }

  void _resetProgress() {
    setState(() => _value = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyRadialProgressIndicator(
            value: _value,
            total: _total,
            size: 200,
            gapAngle: math.pi / 3,
            animationDuration: const Duration(milliseconds: 800),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _resetProgress,
                child: const Text('重置'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _increaseProgress,
                child: const Text('+10%'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _randomProgress,
                child: const Text('随机进度'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ========== 主题切换动画 ==========
class _StyleSwitchDemo extends StatefulWidget {
  const _StyleSwitchDemo();

  @override
  State<_StyleSwitchDemo> createState() => _StyleSwitchDemoState();
}

class _StyleSwitchDemoState extends State<_StyleSwitchDemo> {
  static final _styles = [
    EasyRadialProgressIndicatorStyle.red(),
    EasyRadialProgressIndicatorStyle.blue(),
    EasyRadialProgressIndicatorStyle.green(),
    EasyRadialProgressIndicatorStyle.orange(),
  ];
  static const _labels = ['红色', '蓝色', '绿色', '橙色'];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyRadialProgressIndicator(
            value: 5000,
            total: 9364,
            size: 200,
            gapAngle: math.pi / 3,
            style: _styles[_index],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _styles.length; i++) ...[
                if (i > 0) const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => setState(() => _index = i),
                  child: Text(_labels[i]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ========== EasyRadialProgressIndicator 参数说明 ==========
class _ParameterTable extends StatelessWidget {
  const _ParameterTable();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
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
              DataCell(Text('value')),
              DataCell(Text('double')),
              DataCell(Text('-')),
              DataCell(Text('是')),
              DataCell(Text('当前值')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('total')),
              DataCell(Text('double')),
              DataCell(Text('-')),
              DataCell(Text('是')),
              DataCell(Text('总值')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('size')),
              DataCell(Text('double')),
              DataCell(Text('326')),
              DataCell(Text('否')),
              DataCell(Text('组件尺寸（宽高）')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('tickCount')),
              DataCell(Text('int')),
              DataCell(Text('60')),
              DataCell(Text('否')),
              DataCell(Text('刻度数量')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('style')),
              DataCell(Text('EasyRadialProgressIndicatorStyle')),
              DataCell(Text('red()')),
              DataCell(Text('否')),
              DataCell(Text('样式配置，包含所有颜色和尺寸参数')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('valueTextStyle')),
              DataCell(Text('TextStyle?')),
              DataCell(Text('null')),
              DataCell(Text('否')),
              DataCell(Text('当前值文本样式（覆盖 style 中的 valueColor）')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('totalTextStyle')),
              DataCell(Text('TextStyle?')),
              DataCell(Text('null')),
              DataCell(Text('否')),
              DataCell(Text('总值文本样式（覆盖 style 中的 totalColor）')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('startAngle')),
              DataCell(Text('double')),
              DataCell(Text('-π/2')),
              DataCell(Text('否')),
              DataCell(Text('起始角度（弧度），默认12点方向')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('gapAngle')),
              DataCell(Text('double?')),
              DataCell(Text('null')),
              DataCell(Text('否')),
              DataCell(Text('缺口角度（弧度），null 则闭合')),
            ],
          ),
          DataRow(
            cells: [
              DataCell(Text('child')),
              DataCell(Text('Widget?')),
              DataCell(Text('null')),
              DataCell(Text('否')),
              DataCell(Text('自定义中心内容，替换默认数字文本')),
            ],
          ),
        ],
      ),
    );
  }
}

// ========== EasyRadialProgressIndicatorStyle 参数说明 ==========
class _StyleParameterTable extends StatelessWidget {
  const _StyleParameterTable();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        p('尺寸参数（基于 326 基准按比例缩放）：'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('参数名')),
              DataColumn(label: Text('类型')),
              DataColumn(label: Text('默认值')),
              DataColumn(label: Text('说明')),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('outerRingWidth')),
                  DataCell(Text('double')),
                  DataCell(Text('5')),
                  DataCell(Text('最外层实心圆环宽度')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('trackWidth')),
                  DataCell(Text('double')),
                  DataCell(Text('50')),
                  DataCell(Text('轨道圆环宽度')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('tickWidth')),
                  DataCell(Text('double')),
                  DataCell(Text('5')),
                  DataCell(Text('刻度线宽度')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('tickHeight')),
                  DataCell(Text('double')),
                  DataCell(Text('18')),
                  DataCell(Text('刻度线高度')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('dotOuterSize')),
                  DataCell(Text('double')),
                  DataCell(Text('32')),
                  DataCell(Text('圆形指示器外圆直径')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('dotInnerSize')),
                  DataCell(Text('double')),
                  DataCell(Text('25')),
                  DataCell(Text('圆形指示器内圆直径')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        p('颜色参数：'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('参数名')),
              DataColumn(label: Text('类型')),
              DataColumn(label: Text('说明')),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('outerRingGradient')),
                  DataCell(Text('LinearGradient')),
                  DataCell(Text('最外层圆环渐变')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('trackOpacity')),
                  DataCell(Text('double')),
                  DataCell(Text('轨道透明度（基于最外层圆环颜色），默认0.2')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('tickActiveColor')),
                  DataCell(Text('Color')),
                  DataCell(Text('高亮刻度颜色')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('tickActiveMinOpacity')),
                  DataCell(Text('double')),
                  DataCell(Text('高亮刻度起始透明度（0.0~1.0），默认0.3')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('tickInactiveColor')),
                  DataCell(Text('Color')),
                  DataCell(Text('未高亮刻度颜色')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('dotOuterColor')),
                  DataCell(Text('Color')),
                  DataCell(Text('指示器外圆颜色')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('dotInnerGradient')),
                  DataCell(Text('LinearGradient')),
                  DataCell(Text('指示器内圆渐变')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('valueColor')),
                  DataCell(Text('Color')),
                  DataCell(Text('当前值文本颜色')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('totalColor')),
                  DataCell(Text('Color')),
                  DataCell(Text('总值文本颜色')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        p('预设主题工厂方法：'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('方法名')),
              DataColumn(label: Text('主色调')),
              DataColumn(label: Text('说明')),
            ],
            rows: const [
              DataRow(
                cells: [
                  DataCell(Text('red()')),
                  DataCell(Text('#FB3F40')),
                  DataCell(Text('红色主题（默认）')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('blue()')),
                  DataCell(Text('#3F6FFB')),
                  DataCell(Text('蓝色主题')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('green()')),
                  DataCell(Text('#31DA6F')),
                  DataCell(Text('绿色主题')),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('orange()')),
                  DataCell(Text('#FB8E3F')),
                  DataCell(Text('橙色主题')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
