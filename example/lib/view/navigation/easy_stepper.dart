import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class EasyStepperDemo extends StatelessWidget {
  const EasyStepperDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyStepper 步骤条组件'),

        // 基本介绍
        h2('组件概述'),
        p('EasyStepper 是一个灵活的步骤指示器组件，支持水平和垂直布局，提供丰富的自定义选项，适用于向导流程、订单跟踪等场景。'),

        // 基本水平步骤条
        h2('基本水平步骤条'),
        p('展示水平方向的步骤条'),
        WidgetHighlight(
          builder: (_) => _HorizontalStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
          activeStep: _activeStep,
          steps: const [
            EasyStep(title: '第一步', icon: Icon(Icons.check)),
            EasyStep(
              title: '第二步',
              icon: Icon(Icons.payment),
              activeIcon: Icon(Icons.payment),
            ),
            EasyStep(title: '第三步', icon: Icon(Icons.done)),
          ],
          direction: Axis.horizontal,
          onStepReached: (index) => setState(() => _activeStep = index),
          unreachedStepIconColor: Colors.grey,
          activeStepBackgroundColor: Colors.red,
          activeStepTextColor: Colors.red,
          activeStepIconColor: Colors.red,
        ),
```
''',
        ),

        // 基本垂直步骤条
        h2('基本垂直步骤条'),
        p('展示垂直方向的步骤条'),
        WidgetHighlight(
          builder: (_) => _VerticalStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
          activeStep: _activeStep,
          steps: const [
            EasyStep(title: '下单', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '支付', icon: Icon(Icons.payment)),
            EasyStep(title: '发货', icon: Icon(Icons.local_shipping)),
            EasyStep(title: '完成', icon: Icon(Icons.done)),
          ],
          direction: Axis.vertical,
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
```
''',
        ),

        // 自定义样式
        h2('自定义样式'),
        p('自定义步骤条的外观'),
        WidgetHighlight(
          builder: (_) => _StyledStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
      activeStep: _activeStep,
      steps: [
        EasyStep(title: '第一步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第二步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第三步', icon: Icon(Icons.shopping_cart)),
      ],
      activeStepBackgroundColor: Colors.blue,
      activeStepTextColor: Colors.white,
      finishedStepBackgroundColor: Colors.green,
      finishedStepTextColor: Colors.white,
      unreachedStepBackgroundColor: Colors.grey[200],
      unreachedStepTextColor: Colors.grey,
      stepRadius: 20,
      lineStyle: const LineStyle(
        lineLength: 80,
        lineThickness: 2,
        lineType: LineType.dashed,
      ),
      onStepReached: (index) => setState(() => _activeStep = index),
    );
```
''',
        ),

        // 禁用步骤点击
        h2('禁用步骤点击'),
        p('禁止用户点击切换步骤'),
        WidgetHighlight(
          builder: (_) => _NonClickableStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
      activeStep: 0,
      steps: [
        EasyStep(title: '第一步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第二步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第三步', icon: Icon(Icons.shopping_cart)),
      ],
      enableStepTapping: false,
    );
```
''',
        ),

        // 自定义形状
        h2('自定义形状'),
        p('使用不同形状的步骤指示器'),
        WidgetHighlight(
          builder: (_) => _CustomShapeStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
          activeStep: _activeStep,
          steps: [
            EasyStep(title: '矩形', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '圆角矩形', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '三角形', icon: Icon(Icons.shopping_cart)),
          ],
          stepShape: StepShape.rRectangle,
          stepBorderRadius: 4,
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
```
''',
        ),

        // 带进度线条
        h2('带进度线条'),
        p('显示进度效果的连接线'),
        WidgetHighlight(
          builder: (_) => _ProgressLineStepperDemo(),
          codeSnippet: '''
```dart
EasyStepper(
          activeStep: _activeStep,
          steps: [
            EasyStep(title: '开始', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '进行中', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '完成', icon: Icon(Icons.shopping_cart)),
          ],
          lineStyle: LineStyle(progress: _progress, progressColor: Colors.blue),
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在订单跟踪中使用步骤条'),
        WidgetHighlight(
          builder: (_) => _OrderTrackingStepperDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        EasyStepper(
          activeStep: _currentStep,
          steps: const [
            EasyStep(
              title: '已下单',
              icon: Icon(Icons.shopping_cart),
              topTitle: true,
            ),
            EasyStep(title: '已支付', icon: Icon(Icons.payment), topTitle: true),
            EasyStep(
              title: '已发货',
              icon: Icon(Icons.local_shipping),
              topTitle: true,
            ),
            EasyStep(title: '已完成', icon: Icon(Icons.done), topTitle: true),
          ],
          direction: Axis.horizontal,
          activeStepBackgroundColor: Theme.of(context).primaryColor,
          activeStepTextColor: Colors.white,
          finishedStepBackgroundColor: Colors.green,
          finishedStepTextColor: Colors.white,
          lineStyle: LineStyle(
            lineLength: 50,
            lineThickness: 3,
            finishedLineColor: Colors.green,
            activeLineColor: Theme.of(context).primaryColor,
          ),
          onStepReached: (index) => setState(() => _currentStep = index),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_currentStep < 3) {
                _currentStep++;
              } else {
                _currentStep = 0;
              }
            });
          },
          child: Text(_currentStep < 3 ? '下一步' : '重新开始'),
        ),
      ],
    );
```
''',
        ),
        h2('EasyStepper参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyStepper 参数说明：'),
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
                        DataCell(Text('activeStep')),
                        DataCell(Text('int')),
                        DataCell(Text('0')),
                        DataCell(Text('是')),
                        DataCell(Text('当前激活的步骤索引')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('steps')),
                        DataCell(Text('List<EasyStep>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('步骤列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('direction')),
                        DataCell(Text('Axis')),
                        DataCell(Text('Axis.horizontal')),
                        DataCell(Text('否')),
                        DataCell(Text('方向：horizontal/vertical')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onStepReached')),
                        DataCell(Text('ValueChanged<int>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤切换回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('enableStepTapping')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否允许点击切换步骤')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepShape')),
                        DataCell(Text('StepShape')),
                        DataCell(Text('StepShape.circle')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤形状：circle/rRectangle/triangle')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('15.0')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤圆角半径')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepBorderRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤边框圆角')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('activeStepBackgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('激活步骤背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('activeStepTextColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('激活步骤文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('activeStepIconColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('激活步骤图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('finishedStepBackgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.green')),
                        DataCell(Text('否')),
                        DataCell(Text('已完成步骤背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('finishedStepTextColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('已完成步骤文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('finishedStepIconColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('已完成步骤图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unreachedStepBackgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey[200]')),
                        DataCell(Text('否')),
                        DataCell(Text('未到达步骤背景色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unreachedStepTextColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('未到达步骤文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unreachedStepIconColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('未到达步骤图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lineStyle')),
                        DataCell(Text('LineStyle')),
                        DataCell(Text('LineStyle()')),
                        DataCell(Text('否')),
                        DataCell(Text('连接线样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(8)')),
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
                p('EasyStep 参数说明：'),
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
                        DataCell(Text('title')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('步骤标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('icon')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤图标')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('activeIcon')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('激活状态图标')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('topTitle')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('标题是否显示在图标上方')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('LineStyle 参数说明：'),
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
                        DataCell(Text('lineLength')),
                        DataCell(Text('double')),
                        DataCell(Text('30.0')),
                        DataCell(Text('否')),
                        DataCell(Text('连接线长度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lineThickness')),
                        DataCell(Text('double')),
                        DataCell(Text('1.0')),
                        DataCell(Text('否')),
                        DataCell(Text('连接线粗细')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('lineType')),
                        DataCell(Text('LineType')),
                        DataCell(Text('LineType.normal')),
                        DataCell(Text('否')),
                        DataCell(Text('线型：normal/dashed/dotted')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('finishedLineColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.green')),
                        DataCell(Text('否')),
                        DataCell(Text('已完成步骤连接线颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('activeLineColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('激活步骤连接线颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('unreachedLineColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('未到达步骤连接线颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('progress')),
                        DataCell(Text('double')),
                        DataCell(Text('0.0')),
                        DataCell(Text('否')),
                        DataCell(Text('进度线条进度(0-1)')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('progressColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Theme.of(context).primaryColor')),
                        DataCell(Text('否')),
                        DataCell(Text('进度线条颜色')),
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

// 水平步骤条演示
class _HorizontalStepperDemo extends StatefulWidget {
  @override
  State<_HorizontalStepperDemo> createState() => _HorizontalStepperDemoState();
}

class _HorizontalStepperDemoState extends State<_HorizontalStepperDemo> {
  int _activeStep = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyStepper(
          activeStep: _activeStep,
          steps: const [
            EasyStep(title: '第一步', icon: Icon(Icons.check)),
            EasyStep(
              title: '第二步',
              icon: Icon(Icons.payment),
              activeIcon: Icon(Icons.payment),
            ),
            EasyStep(title: '第三步', icon: Icon(Icons.done)),
          ],
          direction: Axis.horizontal,
          onStepReached: (index) => setState(() => _activeStep = index),
          unreachedStepIconColor: Colors.grey,
          activeStepBackgroundColor: Colors.red,
          activeStepTextColor: Colors.red,
          activeStepIconColor: Colors.red,
        ),
        const SizedBox(height: 20),
        Text('当前步骤: ${_activeStep + 1}'),
      ],
    );
  }
}

// 垂直步骤条演示
class _VerticalStepperDemo extends StatefulWidget {
  @override
  State<_VerticalStepperDemo> createState() => _VerticalStepperDemoState();
}

class _VerticalStepperDemoState extends State<_VerticalStepperDemo> {
  int _activeStep = 2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EasyStepper(
          activeStep: _activeStep,
          steps: const [
            EasyStep(title: '下单', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '支付', icon: Icon(Icons.payment)),
            EasyStep(title: '发货', icon: Icon(Icons.local_shipping)),
            EasyStep(title: '完成', icon: Icon(Icons.done)),
          ],
          direction: Axis.vertical,
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
        const SizedBox(width: 20),
        Text('当前状态: ${_getStatusText(_activeStep)}'),
      ],
    );
  }

  String _getStatusText(int step) {
    switch (step) {
      case 0:
        return '等待下单';
      case 1:
        return '等待支付';
      case 2:
        return '等待发货';
      case 3:
        return '已完成';
      default:
        return '未知状态';
    }
  }
}

// 自定义样式演示
class _StyledStepperDemo extends StatefulWidget {
  @override
  State<_StyledStepperDemo> createState() => _StyledStepperDemoState();
}

class _StyledStepperDemoState extends State<_StyledStepperDemo> {
  int _activeStep = 1;

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: _activeStep,
      steps: [
        EasyStep(title: '第一步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第二步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第三步', icon: Icon(Icons.shopping_cart)),
      ],
      activeStepBackgroundColor: Colors.blue,
      activeStepTextColor: Colors.white,
      finishedStepBackgroundColor: Colors.green,
      finishedStepTextColor: Colors.white,
      unreachedStepBackgroundColor: Colors.grey[200],
      unreachedStepTextColor: Colors.grey,
      stepRadius: 20,
      lineStyle: const LineStyle(
        lineLength: 80,
        lineThickness: 2,
        lineType: LineType.dashed,
      ),
      onStepReached: (index) => setState(() => _activeStep = index),
    );
  }
}

// 不可点击步骤条演示
class _NonClickableStepperDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: 0,
      steps: [
        EasyStep(title: '第一步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第二步', icon: Icon(Icons.shopping_cart)),
        EasyStep(title: '第三步', icon: Icon(Icons.shopping_cart)),
      ],
      enableStepTapping: false,
    );
  }
}

// 自定义形状演示
class _CustomShapeStepperDemo extends StatefulWidget {
  @override
  State<_CustomShapeStepperDemo> createState() =>
      _CustomShapeStepperDemoState();
}

class _CustomShapeStepperDemoState extends State<_CustomShapeStepperDemo> {
  int _activeStep = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyStepper(
          activeStep: _activeStep,
          steps: [
            EasyStep(title: '矩形', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '圆角矩形', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '三角形', icon: Icon(Icons.shopping_cart)),
          ],
          stepShape: StepShape.rRectangle,
          stepBorderRadius: 4,
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
        const SizedBox(height: 20),
        Text('当前形状: ${_getShapeText(_activeStep)}'),
      ],
    );
  }

  String _getShapeText(int step) {
    switch (step) {
      case 0:
        return '矩形';
      case 1:
        return '圆角矩形';
      case 2:
        return '三角形';
      default:
        return '未知';
    }
  }
}

// 进度线条演示
class _ProgressLineStepperDemo extends StatefulWidget {
  @override
  State<_ProgressLineStepperDemo> createState() =>
      _ProgressLineStepperDemoState();
}

class _ProgressLineStepperDemoState extends State<_ProgressLineStepperDemo> {
  int _activeStep = 1;
  double _progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyStepper(
          activeStep: _activeStep,
          steps: [
            EasyStep(title: '开始', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '进行中', icon: Icon(Icons.shopping_cart)),
            EasyStep(title: '完成', icon: Icon(Icons.shopping_cart)),
          ],
          lineStyle: LineStyle(progress: _progress, progressColor: Colors.blue),
          onStepReached: (index) => setState(() => _activeStep = index),
        ),
        const SizedBox(height: 20),
        Slider(
          value: _progress,
          onChanged: (value) => setState(() => _progress = value),
        ),
        Text('当前进度: ${(_progress * 100).toInt()}%'),
      ],
    );
  }
}

// 订单跟踪演示
class _OrderTrackingStepperDemo extends StatefulWidget {
  @override
  State<_OrderTrackingStepperDemo> createState() =>
      _OrderTrackingStepperDemoState();
}

class _OrderTrackingStepperDemoState extends State<_OrderTrackingStepperDemo> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyStepper(
          activeStep: _currentStep,
          steps: const [
            EasyStep(
              title: '已下单',
              icon: Icon(Icons.shopping_cart),
              topTitle: true,
            ),
            EasyStep(title: '已支付', icon: Icon(Icons.payment), topTitle: true),
            EasyStep(
              title: '已发货',
              icon: Icon(Icons.local_shipping),
              topTitle: true,
            ),
            EasyStep(title: '已完成', icon: Icon(Icons.done), topTitle: true),
          ],
          direction: Axis.horizontal,
          activeStepBackgroundColor: Theme.of(context).primaryColor,
          activeStepTextColor: Colors.white,
          finishedStepBackgroundColor: Colors.green,
          finishedStepTextColor: Colors.white,
          lineStyle: LineStyle(
            lineLength: 50,
            lineThickness: 3,
            finishedLineColor: Colors.green,
            activeLineColor: Theme.of(context).primaryColor,
          ),
          onStepReached: (index) => setState(() => _currentStep = index),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_currentStep < 3) {
                _currentStep++;
              } else {
                _currentStep = 0;
              }
            });
          },
          child: Text(_currentStep < 3 ? '下一步' : '重新开始'),
        ),
      ],
    );
  }
}
