import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:flutter/material.dart';

import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class StepIndicatorDemo extends StatelessWidget {
  const StepIndicatorDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyStepIndicator 步骤指示器示例'),
        h2('基本用法'),
        p('展示基础的步骤指示器，包含多个步骤和当前进度指示。'),
        WidgetHighlight(
          builder: (_) {
            return const _StepIndicatorBaseDemo();
          },
          codeSnippet: '''
```dart
class _StepIndicatorBaseDemo extends StatefulWidget {
  const _StepIndicatorBaseDemo();

  @override
  State<_StepIndicatorBaseDemo> createState() => _StepIndicatorBaseDemoState();
}

class _StepIndicatorBaseDemoState extends State<_StepIndicatorBaseDemo> {
  int _currentStep = 0;
  final List<String> _steps = ['准备工作', '校准 X 轴', '校准 Y 轴', '完成校准'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyStepIndicator(
          stepsLength: _steps.length,
          stepNames: _steps,
          currentStep: _currentStep,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed: _currentStep > 0
                  ? () {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  : null,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 16),
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed: _currentStep < _steps.length - 1
                  ? () {
                      setState(() {
                        _currentStep++;
                      });
                    }
                  : null,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
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
                p('EasyStepIndicator 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
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
                        DataCell(Text('stepsLength')),
                        DataCell(Text('int')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('步骤总数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('stepNames')),
                        DataCell(Text('List<String>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('各步骤的名称列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('currentStep')),
                        DataCell(Text('int')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('当前所处的步骤索引（从0开始）')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double')),
                        DataCell(Text('76')),
                        DataCell(Text('否')),
                        DataCell(Text('步骤总数')),
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

class _StepIndicatorBaseDemo extends StatefulWidget {
  const _StepIndicatorBaseDemo();

  @override
  State<_StepIndicatorBaseDemo> createState() => _StepIndicatorBaseDemoState();
}

class _StepIndicatorBaseDemoState extends State<_StepIndicatorBaseDemo> {
  int _currentStep = 0;
  final List<String> _steps = ['准备工作', '校准 X 轴', '校准 Y 轴', '完成校准'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyStepIndicator(
          stepsLength: _steps.length,
          stepNames: _steps,
          currentStep: _currentStep,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed:
                  _currentStep > 0
                      ? () {
                        setState(() {
                          _currentStep--;
                        });
                      }
                      : null,
              child: const Text('上一步'),
            ),
            const SizedBox(width: 16),
            EasyButton2(
              type: EasyButtonType.outline,
              onPressed:
                  _currentStep < _steps.length - 1
                      ? () {
                        setState(() {
                          _currentStep++;
                        });
                      }
                      : null,
              child: const Text('下一步'),
            ),
          ],
        ),
      ],
    );
  }
}
