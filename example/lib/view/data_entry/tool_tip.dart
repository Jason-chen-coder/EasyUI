import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class ToolTip extends StatelessWidget {
  const ToolTip({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('ToolTip 提示组件示例'),
        h2('基本用法'),
        p('展示基本的提示信息功能'),
        WidgetHighlight(
          builder: (_) {
            return Row(
              children: [
                const Text('点击图标查看提示信息:'),
                const SizedBox(width: 10),
                EasyToolTipWidget(msg: '这是一个基本的提示信息示例'),
              ],
            );
          },
          codeSnippet: '''
```dart
       Row(
              children: [
                const Text('点击图标查看提示信息:'),
                const SizedBox(width: 10),
                EasyToolTipWidget(msg: '这是一个基本的提示信息示例'),
              ],
            );
```
''',
        ),

        h2('长文本提示'),
        p('展示长文本提示信息的显示效果'),
        WidgetHighlight(
          builder: (_) {
            return Row(
              children: [
                const Text('点击查看详细说明:'),
                const SizedBox(width: 10),
                EasyToolTipWidget(
                  msg:
                      '这是一个较长的提示信息，用于展示组件如何处理多行文本。'
                      '提示信息可以包含详细的说明和注意事项，帮助用户更好地理解当前功能。',
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Row(
              children: [
                const Text('点击查看详细说明:'),
                const SizedBox(width: 10),
                EasyToolTipWidget(
                  msg:
                      '这是一个较长的提示信息，用于展示组件如何处理多行文本。'
                      '提示信息可以包含详细的说明和注意事项，帮助用户更好地理解当前功能。',
                ),
              ],
            );
```
''',
        ),

        h2('表单中的提示'),
        p('在表单字段旁边添加提示信息'),
        WidgetHighlight(
          builder: (_) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('用户名:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入您的登录用户名，长度为6-20个字符'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入用户名',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('密码:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '密码必须包含大小写字母和数字，长度至少8位'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入密码',
                    ),
                  ),
                ],
              ),
            );
          },
          codeSnippet: '''
```dart
        Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('用户名:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入您的登录用户名，长度为6-20个字符'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入用户名',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('密码:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '密码必须包含大小写字母和数字，长度至少8位'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入密码',
                    ),
                  ),
                ],
              ),
            );
```
''',
        ),

        h2('实际应用场景'),
        p('在复杂表单中使用提示组件'),
        WidgetHighlight(
          builder: (_) {
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('个人信息', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('身份证号:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入18位身份证号码，用于实名认证'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入身份证号',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('手机号码:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入11位手机号码，用于接收验证码'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入手机号',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('邮箱地址:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入有效的邮箱地址，用于接收重要通知'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入邮箱',
                    ),
                  ),
                ],
              ),
            );
          },
          codeSnippet: '''
```dart
      Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('个人信息', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('身份证号:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入18位身份证号码，用于实名认证'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入身份证号',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('手机号码:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入11位手机号码，用于接收验证码'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入手机号',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('邮箱地址:'),
                      const SizedBox(width: 5),
                      EasyToolTipWidget(msg: '请输入有效的邮箱地址，用于接收重要通知'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '请输入邮箱',
                    ),
                  ),
                ],
              ),
            );
```
''',
        ),
        h2('ToolTip参数说明'),
        WidgetHighlight(
          builder: (_) {
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
                          overflow: TextOverflow.ellipsis,
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
                        Text('TextStyle(color: Colors.black87, fontSize: 12)'),
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
            );
          },
          codeSnippet: "",
        ),
      ],
    );
  }
}
