import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class CarouselDemo extends StatelessWidget {
  const CarouselDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyCarousel 轮播图组件示例'),
        h2('基本用法'),
        p('展示基础的轮播图，包含指示器'),
        WidgetHighlight(
          builder: (_) {
            return const _CarouselBaseDemo();
          },
          codeSnippet: '''
```dart
class _CarouselBaseDemo extends StatefulWidget {
  const _CarouselBaseDemo();

  @override
  State<_CarouselBaseDemo> createState() => _CarouselBaseDemoState();
}

class _CarouselBaseDemoState extends State<_CarouselBaseDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          EasyCarousel(
            controller: _controller,
            itemCount: _colors.length,
            transition: EasyCarouselTransition.sliding(),
            autoplaySpeed: const Duration(seconds: 3),
            pauseOnHover: true,
            itemBuilder: (context, index) {
              return Container(
                color: _colors[index],
                alignment: Alignment.center,
                child: Text(
                  'Page \${index + 1}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: EasyCarouselDotIndicator(
              itemCount: _colors.length,
              controller: _controller,
              unselectedRadius: 16,
              selectedRadius: 22,
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
        h2('自定义控制'),
        p('使用外部按钮控制轮播图'),
        WidgetHighlight(
          builder: (_) {
            return const _CarouselControlDemo();
          },
          codeSnippet: '''
```dart
class _CarouselControlDemo extends StatefulWidget {
  const _CarouselControlDemo();

  @override
  State<_CarouselControlDemo> createState() => _CarouselControlDemoState();
}

class _CarouselControlDemoState extends State<_CarouselControlDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Animate to previous slide.
              _controller.animatePrevious(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 200,
              child: EasyCarousel(
                // Slide items with a 24px gap.
                transition: EasyCarouselTransition.sliding(gap: 24),
                controller: _controller,
                // Each item has a fixed dimension of 200.
                sizeConstraint: const EasyCarouselFractionalConstraint(0.8),
                // Automatically advance every 2 seconds.
                autoplaySpeed: const Duration(seconds: 2),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: _colors[index],
                    alignment: Alignment.center,
                    child: Text(
                      'Page \${index + 1}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                // Duration of the slide transition animation.
                speed: const Duration(seconds: 1),
              ),
            ),
          ),
          const SizedBox(width: 24),
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Animate to next slide.
              _controller.animateNext(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
```
''',
        ),

        h2('跑马灯效果'),
        p('自动连续滚动的轮播图'),
        WidgetHighlight(
          builder: (_) {
            return const _CarouselMarqueeDemo();
          },
          codeSnippet: '''
```dart
class _CarouselMarqueeDemo extends StatefulWidget {
  const _CarouselMarqueeDemo();

  @override
  State<_CarouselMarqueeDemo> createState() => _CarouselMarqueeDemoState();
}

class _CarouselMarqueeDemoState extends State<_CarouselMarqueeDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: EasyCarousel(
        transition: EasyCarouselTransition.sliding(gap: 24),
        controller: _controller,
        draggable: false,
        autoplaySpeed: const Duration(seconds: 2),
        curve: Curves.linear,
        itemCount: _colors.length, // 5
        sizeConstraint: const EasyCarouselFixedConstraint(200),
        itemBuilder: (context, index) {
          return Container(
            color: _colors[index],
            alignment: Alignment.center,
            child: Text(
              'Page \${index + 1}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        duration: Duration.zero,
      ),
    );
  }
}
```
''',
        ),

        h2('垂直方向'),
        p('垂直方向滚动的轮播图'),
        WidgetHighlight(
          builder: (_) {
            return const _CarouselVerticalDemo();
          },
          codeSnippet: '''
```dart
class _CarouselVerticalDemo extends StatefulWidget {
  const _CarouselVerticalDemo();

  @override
  State<_CarouselVerticalDemo> createState() => _CarouselVerticalDemoState();
}

class _CarouselVerticalDemoState extends State<_CarouselVerticalDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Move to previous item (upwards).
              _controller.animatePrevious(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SizedBox(
              width: 200,
              child: EasyCarousel(
                transition: EasyCarouselTransition.sliding(gap: 24),
                // Center the visible item.
                alignment: EasyCarouselAlignment.center,
                controller: _controller,
                // Rotate layout to vertical flow.
                direction: Axis.vertical,
                // Fix item extent to 200.
                sizeConstraint: const EasyCarouselFixedConstraint(200),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: _colors[index],
                    alignment: Alignment.center,
                    child: Text(
                      'Page \${index + 1}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Move to next item (downwards).
              _controller.animateNext(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }
}
```
''',
        ),
        h2('参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyCarousel 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('默认值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('itemBuilder')),
                        DataCell(Text('CarouselItemBuilder')),
                        DataCell(Text('required')),
                        DataCell(Text('构建子项的回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('itemCount')),
                        DataCell(Text('int?')),
                        DataCell(Text('-')),
                        DataCell(Text('子项数量')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasyCarouselController?')),
                        DataCell(Text('-')),
                        DataCell(Text('控制器')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('transition')),
                        DataCell(Text('CarouselTransition')),
                        DataCell(Text('required')),
                        DataCell(Text('切换过渡效果')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('EasyCarouselAlignment')),
                        DataCell(Text('center')),
                        DataCell(Text('对齐方式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('direction')),
                        DataCell(Text('Axis')),
                        DataCell(Text('horizontal')),
                        DataCell(Text('滚动方向')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('wrap')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('是否循环滚动')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('pauseOnHover')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('悬停是否暂停')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('autoplaySpeed')),
                        DataCell(Text('Duration?')),
                        DataCell(Text('-')),
                        DataCell(Text('自动播放间隔')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('waitOnStart')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('启动时是否等待')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('draggable')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('是否可拖拽')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reverse')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('是否反向')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('autoplayReverse')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('自动播放是否反向')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('sizeConstraint')),
                        DataCell(Text('CarouselSizeConstraint')),
                        DataCell(Text('Fractional(1)')),
                        DataCell(Text('尺寸约束')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('speed')),
                        DataCell(Text('Duration')),
                        DataCell(Text('200ms')),
                        DataCell(Text('切换动画时长')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('curve')),
                        DataCell(Text('Curve')),
                        DataCell(Text('easeInOut')),
                        DataCell(Text('切换动画曲线')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onIndexChanged')),
                        DataCell(Text('ValueChanged<int>?')),
                        DataCell(Text('-')),
                        DataCell(Text('索引改变回调')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyCarouselDotIndicator 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(140),
                    ),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('itemCount')),
                        DataCell(Text('int')),
                        DataCell(Text('required')),
                        DataCell(Text('子项数量')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasyCarouselController')),
                        DataCell(Text('required')),
                        DataCell(Text('控制器')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('duration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('300ms')),
                        DataCell(Text('动画时长')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('curve')),
                        DataCell(Text('Curve')),
                        DataCell(Text('easeInOut')),
                        DataCell(Text('动画曲线')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unselectedRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('16')),
                        DataCell(Text('未选中圆点直径')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('selectedRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('22')),
                        DataCell(Text('选中圆点直径')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyCarouselController 方法说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('参数')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('animatePrevious')),
                        DataCell(Text('Duration duration, {Curve curve}')),
                        DataCell(Text('带动画滚动到上一页')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('animateNext')),
                        DataCell(Text('Duration duration, {Curve curve}')),
                        DataCell(Text('带动画滚动到下一页')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('animateTo')),
                        DataCell(
                          Text('double value, Duration duration, Curve curve'),
                        ),
                        DataCell(Text('带动画滚动到指定位置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('jumpTo')),
                        DataCell(Text('double value')),
                        DataCell(Text('跳转到指定位置')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '',
        ),
      ],
    );
  }
}

class _CarouselBaseDemo extends StatefulWidget {
  const _CarouselBaseDemo();

  @override
  State<_CarouselBaseDemo> createState() => _CarouselBaseDemoState();
}

class _CarouselBaseDemoState extends State<_CarouselBaseDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Stack(
        children: [
          EasyCarousel(
            controller: _controller,
            itemCount: _colors.length,
            transition: EasyCarouselTransition.sliding(),
            autoplaySpeed: const Duration(seconds: 3),
            pauseOnHover: true,
            itemBuilder: (context, index) {
              return Container(
                color: _colors[index],
                alignment: Alignment.center,
                child: Text(
                  'Page ${index + 1}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: EasyTheme.of(context).onBackground,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: EasyCarouselDotIndicator(
              itemCount: _colors.length,
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselControlDemo extends StatefulWidget {
  const _CarouselControlDemo();

  @override
  State<_CarouselControlDemo> createState() => _CarouselControlDemoState();
}

class _CarouselControlDemoState extends State<_CarouselControlDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EasyButton2(
            type: EasyButtonType.outline,
            style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
            onPressed: () {
              // Animate to previous slide.
              _controller.animatePrevious(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: SizedBox(
              height: 300,
              child: EasyCarousel(
                // Slide items with a 24px gap.
                transition: EasyCarouselTransition.sliding(gap: 24),
                controller: _controller,
                // Each item has a fixed dimension of 200.
                sizeConstraint: const EasyCarouselFractionalConstraint(0.8),
                // Automatically advance every 2 seconds.
                autoplaySpeed: const Duration(seconds: 2),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: _colors[index],
                    alignment: Alignment.center,
                    child: Text(
                      'Page ${index + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: EasyTheme.of(context).onBackground,
                      ),
                    ),
                  );
                },
                // Duration of the slide transition animation.
                speed: const Duration(seconds: 1),
              ),
            ),
          ),
          const SizedBox(width: 24),
          EasyButton2(
            type: EasyButtonType.outline,
            style: EasyButtonStyle.styleFrom(shape: CircleBorder()),
            onPressed: () {
              // Animate to next slide.
              _controller.animateNext(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class _CarouselMarqueeDemo extends StatefulWidget {
  const _CarouselMarqueeDemo();

  @override
  State<_CarouselMarqueeDemo> createState() => _CarouselMarqueeDemoState();
}

class _CarouselMarqueeDemoState extends State<_CarouselMarqueeDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: EasyCarousel(
        transition: EasyCarouselTransition.sliding(gap: 24),
        controller: _controller,
        draggable: false,
        autoplaySpeed: const Duration(seconds: 2),
        curve: Curves.linear,
        itemCount: _colors.length,
        sizeConstraint: const EasyCarouselFixedConstraint(200),
        itemBuilder: (context, index) {
          return Container(
            color: _colors[index],
            alignment: Alignment.center,
            child: Text(
              'Page ${index + 1}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: EasyTheme.of(context).onBackground,
              ),
            ),
          );
        },
        duration: Duration.zero,
      ),
    );
  }
}

class _CarouselVerticalDemo extends StatefulWidget {
  const _CarouselVerticalDemo();

  @override
  State<_CarouselVerticalDemo> createState() => _CarouselVerticalDemoState();
}

class _CarouselVerticalDemoState extends State<_CarouselVerticalDemo> {
  final EasyCarouselController _controller = EasyCarouselController();

  final List<Color> _colors = [
    Colors.red[100]!,
    Colors.blue[100]!,
    Colors.green[100]!,
    Colors.orange[100]!,
    Colors.purple[100]!,
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Move to previous item (upwards).
              _controller.animatePrevious(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_upward),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SizedBox(
              width: 200,
              child: EasyCarousel(
                transition: EasyCarouselTransition.sliding(gap: 24),
                alignment: EasyCarouselAlignment.center,
                controller: _controller,
                direction: Axis.vertical,
                sizeConstraint: const EasyCarouselFixedConstraint(200),
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: _colors[index],
                    alignment: Alignment.center,
                    child: Text(
                      'Page ${index + 1}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: EasyTheme.of(context).onBackground,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          EasyButton2(
            type: EasyButtonType.outline,
            onPressed: () {
              // Move to next item (downwards).
              _controller.animateNext(const Duration(milliseconds: 500));
            },
            child: const Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }
}
