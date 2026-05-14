import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

class DialogDemo extends StatelessWidget {
  const DialogDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyNotifyDialog 通知对话框'),

        // 基本介绍
        h2('组件概述'),
        p('EasyNotifyDialog 是一个灵活的通知对话框组件，支持多种预设样式和自定义配置，用于显示重要信息或需要用户确认的操作。'),

        // 基本用法
        h2('基本用法'),
        p('自定义图标、标题和内容的基本对话框'),
        WidgetHighlight(
          builder: (_) => _BasicNotifyDialogDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog(
                icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                title: '提示标题',
                body: const Text('这里是对话框的主要内容文本'),
                actions: Row(
                  children: [
                    Expanded(
                      child: EasyNotifyDialogOutlinedButton(
                        text: '取消',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: EasyNotifyDialogElevatedButton(
                        text: '确认',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
      child: const Text('显示基本对话框'),
    );
```
''',
        ),

        // 警告对话框
        h2('警告对话框'),
        p('预设的警告样式对话框，带确认和取消按钮'),
        WidgetHighlight(
          builder: (_) => _AlertDialogDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alert(
                title: '删除确认',
                body: const Text('确定要删除这条数据吗？此操作不可撤销。'),
                confirmButtonText: '删除',
                cancelButtonText: '取消',
                onConfirmButtonPressed: () {
                  // 执行删除操作
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('已删除')));
                  Navigator.pop(context);
                },
                onCancelButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
      child: const Text('显示警告对话框'),
    );
```
''',
        ),

        // 单按钮对话框
        h2('单按钮对话框'),
        p('只有一个确认按钮的简单对话框'),
        WidgetHighlight(
          builder: (_) => _SingleButtonDialogDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alertWithSingleButton(
                title: '操作成功',
                body: const Text('您的操作已成功完成！'),
                buttonText: '确定',
                onButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
      child: const Text('显示单按钮对话框'),
    );
```
''',
        ),

        // 不同尺寸
        h2('不同尺寸对话框'),
        p('支持小、中、大三种尺寸'),
        WidgetHighlight(
          builder: (_) => _DifferentSizeDialogDemo(),
          codeSnippet: '''
```dart
Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.small,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '小尺寸对话框',
                    body: const Text('这是小尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示小尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.medium,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '中尺寸对话框',
                    body: const Text('这是中尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示中尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.large,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '大尺寸对话框',
                    body: const Text('这是大尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示大尺寸对话框'),
        ),
      ],
    );
```
''',
        ),

        // 自定义按钮
        h2('自定义按钮样式'),
        p('使用内置的三种按钮样式或自定义按钮'),
        WidgetHighlight(
          builder: (_) => _CustomButtonDialogDemo(),
          codeSnippet: '''
```dart
ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog(
                icon: const Icon(Icons.settings, size: 50, color: Colors.blue),
                title: '自定义按钮',
                body: const Text('这个对话框展示了不同的按钮样式'),
                actions: Column(
                  children: [
                    EasyNotifyDialogTextButton(
                      text: '文本按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    EasyNotifyDialogOutlinedButton(
                      text: '描边按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    EasyNotifyDialogElevatedButton(
                      text: '填充按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
        );
      },
      child: const Text('显示自定义按钮对话框'),
    );
```
''',
        ),

        // 实际应用场景
        h2('实际应用场景'),
        p('在删除操作中使用确认对话框'),
        WidgetHighlight(
          builder: (_) => _DeleteConfirmationDemo(),
          codeSnippet: '''
```dart
ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('删除示例项目'),
      subtitle: const Text('点击显示删除确认对话框'),
      onTap: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alert(
                title: '删除确认',
                body: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('确定要删除这个项目吗？'),
                    SizedBox(height: 8),
                    Text(
                      '项目名称: 示例项目',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('删除后将无法恢复', style: TextStyle(color: Colors.red)),
                  ],
                ),
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                onConfirmButtonPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('示例项目已删除')));
                  Navigator.pop(context);
                },
                onCancelButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
    );
```
''',
        ),
        h2('ToolTip参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyToolTipWidget 参数说明：'),
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
                        DataCell(Text('msg')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('提示信息内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('icon')),
                        DataCell(Text('Widget')),
                        DataCell(Text('Icon(Icons.info_outline, size: 16)')),
                        DataCell(Text('否')),
                        DataCell(Text('提示图标')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('iconColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('iconSize')),
                        DataCell(Text('double')),
                        DataCell(Text('16.0')),
                        DataCell(Text('否')),
                        DataCell(Text('图标大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(4)')),
                        DataCell(Text('否')),
                        DataCell(Text('图标内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('margin')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.zero')),
                        DataCell(Text('否')),
                        DataCell(Text('图标外边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tooltipWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('200.0')),
                        DataCell(Text('否')),
                        DataCell(Text('提示框宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tooltipPadding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(8)')),
                        DataCell(Text('否')),
                        DataCell(Text('提示框内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tooltipDecoration')),
                        DataCell(Text('Decoration')),
                        DataCell(
                          Text(
                            'BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)])',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('提示框装饰样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('tooltipTextStyle')),
                        DataCell(Text('TextStyle')),
                        DataCell(
                          Text(
                            'TextStyle(color: Colors.black87, fontSize: 12)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('提示文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('preferBelow')),
                        DataCell(Text('bool')),
                        DataCell(Text('true')),
                        DataCell(Text('否')),
                        DataCell(Text('是否优先在下方显示')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('verticalOffset')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('垂直偏移量')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('waitDuration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 200)')),
                        DataCell(Text('否')),
                        DataCell(Text('显示前的等待时间')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showDuration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 1500)')),
                        DataCell(Text('否')),
                        DataCell(Text('显示持续时间')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
        h1('EasyInputDialog 输入型对话框'),

        p('显示一个输入对话框。标题、副标题、按钮文本等可自定义。'),
        h2('基本用法'),
        WidgetHighlight(
          builder: (context) {
            return _InputDialogBaseDemo();
          },
          codeSnippet: '''
```dart
class _InputDialogBaseDemo extends StatelessWidget {
  const _InputDialogBaseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final easyTheme = EasyTheme.of(context);
            return EasyInputDialog(
              title: '标题',
              subtitle: '副标题',
              input: Column(
                children: [
                  EasyTextFormField(
                    style: EasyInputDialog.getUnitTextFieldStyle(easyTheme),
                    decoration: EasyInputDialog.getUnitTextFieldDecoration(
                      easyTheme,
                      '单位',
                    ),
                  ),
                ],
              ),
              cancelButtonText: '取消按钮',
              confirmButtonText: '确认按钮',
              onCancelPressed: () {
                Navigator.pop(context);
              },
              onConfirmPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Text('弹出对话框'),
    );
  }
}
```
''',
        ),
        h2('EasyInputDialog参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyInputDialog 参数说明：'),
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
                        DataCell(Text('EasyDialogSize')),
                        DataCell(Text('EasyDialogSize.small')),
                        DataCell(Text('否')),
                        DataCell(Text('对话框尺寸')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('title')),
                        DataCell(Text('String')),
                        DataCell(Text('')),
                        DataCell(Text('是')),
                        DataCell(Text('标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('subtitle')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('副标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cancelButtonText')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('取消按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('confirmButtonText')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('confirmButtonTextWidget')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮文本Widget')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onCancelPressed')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('取消按钮点击回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onConfirmPressed')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('确认按钮点击回调')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: "",
        ),
        h1('EasyContentDialog 内容对话框'),
        p('用于展示自定义内容区域的通用对话框，适合承载说明信息、富文本内容或自定义布局。'),
        h2('按钮类型'),
        p('支持文本按钮、描边按钮和填充按钮等常见操作样式。'),
        WidgetHighlight(
          builder: (_) => const _ContentDialogButtonTypesDemo(),
          codeSnippet: '''
```dart
class _ContentDialogButtonTypesDemo extends StatelessWidget {
  const _ContentDialogButtonTypesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog(
                    title: '文本按钮对话框',
                    body: const Text('适合轻量级提示与单一确认操作。'),
                    actions: EasyNotifyDialogTextButton(
                      text: '我知道了',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('文本按钮'),
        ),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withTwoActions(
                    title: '双按钮对话框',
                    body: const Text('可同时提供取消和确认两种操作。'),
                    leftAction: EasyNotifyDialogOutlinedButton(
                      text: '取消',
                      onPressed: () => Navigator.pop(context),
                    ),
                    rightAction: EasyNotifyDialogElevatedButton(
                      text: '确认',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('描边 + 填充'),
        ),
      ],
    );
  }
}
```
''',
        ),
        h2('对话框尺寸'),
        p('支持小、中、大三种尺寸，可根据内容复杂度选择。'),
        WidgetHighlight(
          builder: (_) => const _ContentDialogSizesDemo(),
          codeSnippet: '''
```dart
class _ContentDialogSizesDemo extends StatelessWidget {
  const _ContentDialogSizesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.small,
                    title: '小尺寸对话框',
                    body: const Text('适合简短说明或简单确认场景。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示小尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.medium,
                    title: '中尺寸对话框',
                    body: const Text('适合中等长度内容或带有更多说明文本的场景。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示中尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.large,
                    title: '大尺寸对话框',
                    body: const Text('适合放置更复杂的内容布局，例如表单、说明列表或嵌套组件。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示大尺寸对话框'),
        ),
      ],
    );
  }
}
```
''',
        ),
      ],
    );
  }
}

// 基本对话框演示
class _BasicNotifyDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog(
                icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                title: '提示标题',
                body: const Text('这里是对话框的主要内容文本'),
                actions: Row(
                  children: [
                    Expanded(
                      child: EasyNotifyDialogOutlinedButton(
                        text: '取消',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: EasyNotifyDialogElevatedButton(
                        text: '确认',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
        );
      },
      child: const Text('显示基本对话框'),
    );
  }
}

// 警告对话框演示
class _AlertDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alert(
                title: '删除确认',
                body: const Text('确定要删除这条数据吗？此操作不可撤销。'),
                confirmButtonText: '删除',
                cancelButtonText: '取消',
                onConfirmButtonPressed: () {
                  // 执行删除操作
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('已删除')));
                  Navigator.pop(context);
                },
                onCancelButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
      child: const Text('显示警告对话框'),
    );
  }
}

// 单按钮对话框演示
class _SingleButtonDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alertWithSingleButton(
                title: '操作成功',
                body: const Text('您的操作已成功完成！'),
                buttonText: '确定',
                onButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
      child: const Text('显示单按钮对话框'),
    );
  }
}

// 不同尺寸对话框演示
class _DifferentSizeDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.small,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '小尺寸对话框',
                    body: const Text('这是小尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示小尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.medium,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '中尺寸对话框',
                    body: const Text('这是中尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示中尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyNotifyDialog(
              context: context,
              builder:
                  (context) => EasyNotifyDialog(
                    size: EasyDialogSize.large,
                    icon: const Icon(Icons.info, size: 50, color: Colors.blue),
                    title: '大尺寸对话框',
                    body: const Text('这是大尺寸对话框的内容区域'),
                    actions: EasyNotifyDialogTextButton(
                      text: '确定',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('显示大尺寸对话框'),
        ),
      ],
    );
  }
}

// 自定义按钮演示
class _CustomButtonDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog(
                icon: const Icon(Icons.settings, size: 50, color: Colors.blue),
                title: '自定义按钮',
                body: const Text('这个对话框展示了不同的按钮样式'),
                actions: Column(
                  children: [
                    EasyNotifyDialogTextButton(
                      text: '文本按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    EasyNotifyDialogOutlinedButton(
                      text: '描边按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 8),
                    EasyNotifyDialogElevatedButton(
                      text: '填充按钮',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
        );
      },
      child: const Text('显示自定义按钮对话框'),
    );
  }
}

// 删除确认演示
class _DeleteConfirmationDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('删除示例项目'),
      subtitle: const Text('点击显示删除确认对话框'),
      onTap: () {
        showEasyNotifyDialog(
          context: context,
          builder:
              (context) => EasyNotifyDialog.alert(
                title: '删除确认',
                body: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('确定要删除这个项目吗？'),
                    SizedBox(height: 8),
                    Text(
                      '项目名称: 示例项目',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('删除后将无法恢复', style: TextStyle(color: Colors.red)),
                  ],
                ),
                confirmButtonText: '确认删除',
                cancelButtonText: '取消',
                onConfirmButtonPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('示例项目已删除')));
                  Navigator.pop(context);
                },
                onCancelButtonPressed: () => Navigator.pop(context),
              ),
        );
      },
    );
  }
}

class _InputDialogBaseDemo extends StatelessWidget {
  const _InputDialogBaseDemo();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final easyTheme = EasyTheme.of(context);
            return EasyInputDialog(
              title: '标题',
              subtitle: '副标题',
              input: Column(
                children: [
                  EasyTextFormField(
                    style: EasyInputDialog.getUnitTextFieldStyle(easyTheme),
                    decoration: EasyInputDialog.getUnitTextFieldDecoration(
                      easyTheme,
                      '单位',
                    ),
                  ),
                ],
              ),
              cancelButtonText: '取消按钮',
              confirmButtonText: '确认按钮',
              onCancelPressed: () {
                Navigator.pop(context);
              },
              onConfirmPressed: () {
                Navigator.pop(context);
              },
            );
          },
        );
      },
      child: Text('弹出对话框'),
    );
  }
}

class _ContentDialogButtonTypesDemo extends StatelessWidget {
  const _ContentDialogButtonTypesDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog(
                    title: '文本按钮对话框',
                    body: const Text('适合轻量级提示与单一确认操作。'),
                    actions: EasyNotifyDialogTextButton(
                      text: '我知道了',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('文本按钮'),
        ),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withTwoActions(
                    title: '双按钮对话框',
                    body: const Text('可同时提供取消和确认两种操作。'),
                    leftAction: EasyNotifyDialogOutlinedButton(
                      text: '取消',
                      onPressed: () => Navigator.pop(context),
                    ),
                    rightAction: EasyNotifyDialogElevatedButton(
                      text: '确认',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
            );
          },
          child: const Text('描边 + 填充'),
        ),
      ],
    );
  }
}

class _ContentDialogSizesDemo extends StatelessWidget {
  const _ContentDialogSizesDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.small,
                    title: '小尺寸对话框',
                    body: const Text('适合简短说明或简单确认场景。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示小尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.medium,
                    title: '中尺寸对话框',
                    body: const Text('适合中等长度内容或带有更多说明文本的场景。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示中尺寸对话框'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            showEasyContentDialog(
              context: context,
              builder:
                  (context) => EasyContentDialog.withSingleButton(
                    size: EasyDialogSize.large,
                    title: '大尺寸对话框',
                    body: const Text('适合放置更复杂的内容布局，例如表单、说明列表或嵌套组件。'),
                    buttonText: '关闭',
                    onButtonPressed: () => Navigator.pop(context),
                  ),
            );
          },
          child: const Text('显示大尺寸对话框'),
        ),
      ],
    );
  }
}
