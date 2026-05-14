import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class ToastDemo extends StatelessWidget {
  const ToastDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyToast 消息提示组件'),

        // 基本介绍
        h2('组件概述'),
        p('EasyToast 是一个优雅的消息提示组件，支持多种类型、自定义显示时长和位置，提供悬浮暂停自动关闭功能。'),

        // 错误提示
        h2('错误提示'),
        p('显示错误类型的提示消息'),
        WidgetHighlight(
          builder: (_) => _ErrorToastDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showToastError(
          text: '操作失败，请重试',
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
        );
      },
      child: const Text('显示错误提示'),
    );
```
''',
        ),

        // 警告提示
        h2('警告提示'),
        p('显示警告类型的提示消息'),
        WidgetHighlight(
          builder: (_) => _WarningToastDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showToastWarning(
          text: '请注意操作风险',
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 3),
        );
      },
      child: const Text('显示警告提示'),
    );
```
''',
        ),

        // 信息提示
        h2('信息提示'),
        p('显示普通信息类型的提示消息'),
        WidgetHighlight(
          builder: (_) => _InfoToastDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showToastInfo(
          text: '系统将于今晚10点进行维护',
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
        );
      },
      child: const Text('显示信息提示'),
    );
```
''',
        ),

        // 成功提示
        h2('成功提示'),
        p('显示成功类型的提示消息'),
        WidgetHighlight(
          builder: (_) => _SuccessToastDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showToastOk(
          text: '操作成功完成',
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 2),
        );
      },
      child: const Text('显示成功提示'),
    );
```
''',
        ),

        // 自定义显示位置
        h2('自定义显示位置'),
        p('支持在屏幕不同位置显示提示'),
        WidgetHighlight(
          builder: (_) => _PositionToastDemo(),
          codeSnippet: '''
```dart
Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '顶部居中提示', alignment: Alignment.topCenter);
          },
          child: const Text('顶部居中'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '顶部右侧提示', alignment: Alignment.topRight);
          },
          child: const Text('顶部右侧'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '底部居中提示', alignment: Alignment.bottomCenter);
          },
          child: const Text('底部居中'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '底部左侧提示', alignment: Alignment.bottomLeft);
          },
          child: const Text('底部左侧'),
        ),
      ],
    );
```
''',
        ),

        // 自定义显示时长
        h2('自定义显示时长'),
        p('设置不同的自动关闭时间'),
        WidgetHighlight(
          builder: (_) => _DurationToastDemo(),
          codeSnippet: '''
```dart
Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '短时间提示 (2秒)',
              autoCloseDuration: const Duration(seconds: 2),
            );
          },
          child: const Text('短时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '中等时间提示 (5秒)',
              autoCloseDuration: const Duration(seconds: 5),
            );
          },
          child: const Text('中等时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '长时间提示 (10秒)',
              autoCloseDuration: const Duration(seconds: 10),
            );
          },
          child: const Text('长时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '需手动关闭的提示', autoCloseDuration: null);
          },
          child: const Text('手动关闭提示'),
        ),
      ],
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在表单提交后显示提示'),
        WidgetHighlight(
          builder: (_) => _FormSubmitToastDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () async {
        // 模拟表单提交
        await Future.delayed(const Duration(seconds: 1));

        // 随机显示成功或失败
        final random = DateTime.now().second % 2 == 0;
        if (random) {
          showToastOk(text: '表单提交成功', alignment: Alignment.topCenter);
        } else {
          showToastError(text: '表单提交失败，请检查网络', alignment: Alignment.topCenter);
        }
      },
      child: const Text('模拟表单提交'),
    );
```
''',
        ),
        h2('Toast参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('Toast 通用参数说明：'),
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
                        DataCell(Text('text')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('提示文本内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('Alignment')),
                        DataCell(Text('Alignment.topCenter')),
                        DataCell(Text('否')),
                        DataCell(Text('提示框在屏幕中的位置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('autoCloseDuration')),
                        DataCell(Text('Duration?')),
                        DataCell(Text('Duration(seconds: 3)')),
                        DataCell(Text('否')),
                        DataCell(Text('自动关闭时间，null表示不自动关闭')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('pauseOnHover')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('鼠标悬停时是否暂停计时')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('margin')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(16)')),
                        DataCell(Text('否')),
                        DataCell(Text('外边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text(
                            'EdgeInsets.symmetric(horizontal: 24, vertical: 12)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
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
                        DataCell(Text('textStyle')),
                        DataCell(Text('TextStyle')),
                        DataCell(
                          Text(
                            'TextStyle(color: Colors.black87, fontSize: 14)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius')),
                        DataCell(Text('BorderRadius.circular(8)')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('shadow')),
                        DataCell(Text('List<BoxShadow>')),
                        DataCell(
                          Text(
                            '[BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 1)]',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('阴影效果')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('icon')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('左侧图标')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onClose')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('关闭回调')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('不同类型Toast的默认样式：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('背景颜色')),
                    DataColumn(label: Text('文本颜色')),
                    DataColumn(label: Text('图标')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('showToastError')),
                        DataCell(Text('Color(0xFFFEEFEF)')),
                        DataCell(Text('Color(0xFFD32F2F)')),
                        DataCell(Text('Icons.error_outline')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showToastWarning')),
                        DataCell(Text('Color(0xFFFFF8E6)')),
                        DataCell(Text('Color(0xFFF57C00)')),
                        DataCell(Text('Icons.warning_amber')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showToastInfo')),
                        DataCell(Text('Color(0xFFE8F4FD)')),
                        DataCell(Text('Color(0xFF1976D2)')),
                        DataCell(Text('Icons.info_outline')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showToastOk')),
                        DataCell(Text('Color(0xFFE8F5E9)')),
                        DataCell(Text('Color(0xFF388E3C)')),
                        DataCell(Text('Icons.check_circle_outline')),
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

// 错误提示演示
class _ErrorToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showToastError(
          text: '操作失败，请重试',
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 5),
        );
      },
      child: const Text('显示错误提示'),
    );
  }
}

// 警告提示演示
class _WarningToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showToastWarning(
          text: '请注意操作风险',
          alignment: Alignment.topRight,
          autoCloseDuration: const Duration(seconds: 3),
        );
      },
      child: const Text('显示警告提示'),
    );
  }
}

// 信息提示演示
class _InfoToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showToastInfo(
          text: '系统将于今晚10点进行维护',
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
        );
      },
      child: const Text('显示信息提示'),
    );
  }
}

// 成功提示演示
class _SuccessToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showToastOk(
          text: '操作成功完成',
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 2),
        );
      },
      child: const Text('显示成功提示'),
    );
  }
}

// 位置演示
class _PositionToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '顶部居中提示', alignment: Alignment.topCenter);
          },
          child: const Text('顶部居中'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '顶部右侧提示', alignment: Alignment.topRight);
          },
          child: const Text('顶部右侧'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '底部居中提示', alignment: Alignment.bottomCenter);
          },
          child: const Text('底部居中'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '底部左侧提示', alignment: Alignment.bottomLeft);
          },
          child: const Text('底部左侧'),
        ),
      ],
    );
  }
}

// 显示时长演示
class _DurationToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '短时间提示 (2秒)',
              autoCloseDuration: const Duration(seconds: 2),
            );
          },
          child: const Text('短时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '中等时间提示 (5秒)',
              autoCloseDuration: const Duration(seconds: 5),
            );
          },
          child: const Text('中等时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(
              text: '长时间提示 (10秒)',
              autoCloseDuration: const Duration(seconds: 10),
            );
          },
          child: const Text('长时间提示'),
        ),
        ElevatedButton(
          onPressed: () {
            showToastInfo(text: '需手动关闭的提示', autoCloseDuration: null);
          },
          child: const Text('手动关闭提示'),
        ),
      ],
    );
  }
}

// 表单提交演示
class _FormSubmitToastDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // 模拟表单提交
        await Future.delayed(const Duration(seconds: 1));

        // 随机显示成功或失败
        final random = DateTime.now().second % 2 == 0;
        if (random) {
          showToastOk(text: '表单提交成功', alignment: Alignment.topCenter);
        } else {
          showToastError(text: '表单提交失败，请检查网络', alignment: Alignment.topCenter);
        }
      },
      child: const Text('模拟表单提交'),
    );
  }
}
