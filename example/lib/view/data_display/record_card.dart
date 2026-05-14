import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class RecordCardDemo extends StatelessWidget {
  const RecordCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('RecordCard 记录卡片组件示例'),
        h2('基本用法'),
        p('展示最基本的记录卡片，包含标题和内容'),
        WidgetHighlight(
          builder: (_) {
            return const EasyRecordCard(
              title: '用户信息',
              propertyRows: [
                Text('姓名: 张三'),
                Text('年龄: 28'),
                Text('邮箱: zhangsan@example.com'),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyRecordCard(
              title: '用户信息',
              propertyRows: [
                Text('姓名: 张三'),
                Text('年龄: 28'),
                Text('邮箱: zhangsan@example.com'),
              ],
            );
```
''',
        ),
        h2('带左侧图标'),
        p('展示带左侧图标的记录卡片'),
        WidgetHighlight(
          builder: (_) {
            return EasyRecordCard(
              title: '项目进度',
              leading: Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assignment, color: Colors.blue),
              ),
              propertyRows: [
                const Text('项目名称: 移动端UI重构'),
                const Text('负责人: 李四'),
                const Text('进度: 75%'),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
 EasyRecordCard(
              title: '项目进度',
              leading: Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.assignment, color: Colors.blue),
              ),
              propertyRows: [
                const Text('项目名称: 移动端UI重构'),
                const Text('负责人: 李四'),
                const Text('进度: 75%'),
                LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                ),
              ],
            );
```
''',
        ),
        h2('带操作按钮'),
        p('展示带右侧操作按钮的记录卡片'),
        WidgetHighlight(
          builder: (_) {
            return EasyRecordCard(
              title: '订单详情',
              propertyRows: [
                const Text('订单号: ORD-20230001'),
                const Text('金额: \$199.99'),
                const Text('状态: 已发货'),
              ],
              endSideButtons: [
                EasyCardButton(
                  text: '查看详情',
                  icon: const Icon(Icons.visibility, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '取消订单',
                  icon: const Icon(Icons.cancel, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.red,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyRecordCard(
              title: '订单详情',
              propertyRows: [
                const Text('订单号: ORD-20230001'),
                const Text('金额: \$199.99'),
                const Text('状态: 已发货'),
              ],
              endSideButtons: [
                EasyCardButton(
                  text: '查看详情',
                  icon: const Icon(Icons.visibility, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '取消订单',
                  icon: const Icon(Icons.cancel, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.red,
                ),
              ],
            );
```
''',
        ),
        h2('带额外内容'),
        p('展示如何在卡片底部添加额外内容'),
        WidgetHighlight(
          builder: (_) {
            return EasyRecordCard(
              title: '会议安排',
              propertyRows: [
                const Text('时间: 2023-06-15 14:00'),
                const Text('地点: 会议室A'),
                const Text('主题: 项目进度汇报'),
              ],
              extra: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '注意事项: 请提前准备项目演示材料',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
          },
          codeSnippet: '''
```dart
EasyRecordCard(
              title: '会议安排',
              propertyRows: [
                const Text('时间: 2023-06-15 14:00'),
                const Text('地点: 会议室A'),
                const Text('主题: 项目进度汇报'),
              ],
              extra: Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '注意事项: 请提前准备项目演示材料',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            );
```
''',
        ),
        h2('EasyCardButton 按钮组件'),
        p('展示卡片按钮的不同样式和状态'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '默认按钮:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '确认',
                  icon: const Icon(Icons.check, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                const Text(
                  '自定义颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '删除',
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  '禁用状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '不可操作',
                  icon: const Icon(Icons.block, size: 16),
                  onPressed: null,
                ),
                const SizedBox(height: 16),
                const Text(
                  '自定义文字颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '警告',
                  icon: const Icon(Icons.warning, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '默认按钮:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '确认',
                  icon: const Icon(Icons.check, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                const Text(
                  '自定义颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '删除',
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  '禁用状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '不可操作',
                  icon: const Icon(Icons.block, size: 16),
                  onPressed: null,
                ),
                const SizedBox(height: 16),
                const Text(
                  '自定义文字颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyCardButton(
                  text: '警告',
                  icon: const Icon(Icons.warning, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                ),
              ],
            );
```
''',
        ),
        h2('复杂组合示例'),
        p('展示如何组合使用这些组件创建复杂的记录卡片'),
        WidgetHighlight(
          builder: (_) {
            return EasyRecordCard(
              title: '员工档案',
              leading: Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              propertyRows: [
                const Text('姓名: 王五'),
                const Text('工号: EMP-10086'),
                const Text('部门: 技术研发部'),
                const Text('职位: 高级前端工程师'),
                const Text('入职日期: 2020-05-15'),
              ],
              extra: Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('React')),
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('TypeScript')),
                    Chip(label: Text('Node.js')),
                  ],
                ),
              ),
              endSideButtons: [
                EasyCardButton(
                  text: '编辑资料',
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '查看考勤',
                  icon: const Icon(Icons.calendar_today, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '联系',
                  icon: const Icon(Icons.message, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
EasyRecordCard(
              title: '员工档案',
              leading: Container(
                width: 64,
                height: 64,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/avatar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              propertyRows: [
                const Text('姓名: 王五'),
                const Text('工号: EMP-10086'),
                const Text('部门: 技术研发部'),
                const Text('职位: 高级前端工程师'),
                const Text('入职日期: 2020-05-15'),
              ],
              extra: Container(
                margin: const EdgeInsets.only(top: 16),
                child: const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(label: Text('React')),
                    Chip(label: Text('Flutter')),
                    Chip(label: Text('TypeScript')),
                    Chip(label: Text('Node.js')),
                  ],
                ),
              ),
              endSideButtons: [
                EasyCardButton(
                  text: '编辑资料',
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '查看考勤',
                  icon: const Icon(Icons.calendar_today, size: 16),
                  onPressed: () {},
                ),
                const SizedBox(height: 8),
                EasyCardButton(
                  text: '联系',
                  icon: const Icon(Icons.message, size: 16),
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                ),
              ],
            );
```
''',
        ),
        h2('RecordCard参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyRecordCard 参数说明：'),
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
                        DataCell(Text('卡片标题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('propertyRows')),
                        DataCell(Text('List<Widget>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('卡片内容行列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('leading')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('左侧引导组件，通常是图标或头像')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('endSideButtons')),
                        DataCell(Text('List<Widget>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('右侧操作按钮列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('extra')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('底部额外内容')),
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
                        DataCell(Text('EdgeInsets.only(bottom: 16)')),
                        DataCell(Text('否')),
                        DataCell(Text('外边距')),
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
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius')),
                        DataCell(Text('BorderRadius.circular(8)')),
                        DataCell(Text('否')),
                        DataCell(Text('圆角大小')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('elevation')),
                        DataCell(Text('double')),
                        DataCell(Text('2.0')),
                        DataCell(Text('否')),
                        DataCell(Text('阴影高度')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyCardButton 参数说明：'),
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
                        DataCell(Text('按钮文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('icon')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('按钮图标')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onPressed')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('点击回调函数，为null时按钮禁用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey[200]!')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.black')),
                        DataCell(Text('否')),
                        DataCell(Text('文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text(
                            'EdgeInsets.symmetric(horizontal: 12, vertical: 8)',
                          ),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
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
                        DataCell(Text('iconSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('图标与文本间距')),
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
