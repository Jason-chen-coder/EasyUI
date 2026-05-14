import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class ThemeDemo extends StatelessWidget {
  const ThemeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Theme 组件示例'),
        h2('基本用法'),
        p('展示如何使用EasyTheme包裹应用'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '在应用顶层使用EasyTheme:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('MaterialApp('),
                const Text('  theme: easyBuildMaterialTheme(),'),
                const Text('  home: MyApp(),'),
                const Text(')'),
                const SizedBox(height: 16),
                const Text(
                  '或在Widget树中使用:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('EasyTheme('),
                const Text('  data: EasyThemeData(),'),
                const Text('  child: MyWidget(),'),
                const Text(')'),
              ],
            );
          },
          codeSnippet: '''
''',
        ),
        h2('颜色系统'),
        p('展示主题中定义的颜色系统'),
        WidgetHighlight(
          builder: (_) {
            final theme = EasyTheme.of(context);
            return Column(
              children: [
                const Text(
                  '中性色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorBox(theme.neutral33, 'neutral33'),
                    _buildColorBox(theme.neutral66, 'neutral66'),
                    _buildColorBox(theme.neutral99, 'neutral99'),
                    _buildColorBox(theme.neutralEE, 'neutralEE'),
                    _buildColorBox(theme.neutralF8, 'neutralF8'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '主色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildColorBox(theme.primaryGreen, 'primaryGreen'),
                const SizedBox(height: 16),
                const Text(
                  '辅助色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorBox(theme.secondaryBlue, 'secondaryBlue'),
                    _buildColorBox(theme.secondaryPurple, 'secondaryPurple'),
                    _buildColorBox(
                      theme.secondaryPurpleBlue,
                      'secondaryPurpleBlue',
                    ),
                    _buildColorBox(theme.secondaryCyan, 'secondaryCyan'),
                    _buildColorBox(theme.secondaryGreen, 'secondaryGreen'),
                    _buildColorBox(theme.secondaryAmber, 'secondaryAmber'),
                    _buildColorBox(theme.secondaryOrange, 'secondaryOrange'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '特殊色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorBox(theme.logoBlue, 'logoBlue'),
                    _buildColorBox(theme.termination, 'termination'),
                    _buildColorBox(theme.warning, 'warning'),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart

// 获取主题颜色

final theme = EasyTheme.of(context);

// 使用颜色

Container(

color: theme.primaryGreen,

child: Text('文本', style: TextStyle(color: theme.neutral33)),

)
```
''',
        ),
        h2('圆角系统'),
        p('展示主题中定义的圆角系统'),
        WidgetHighlight(
          builder: (_) {
            final theme = EasyTheme.of(context);
            return Column(
              children: [
                const Text(
                  '小圆角 (4px):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.primaryGreen,
                    borderRadius: BorderRadius.all(theme.cornerSmall),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '中圆角 (8px):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.secondaryBlue,
                    borderRadius: BorderRadius.all(theme.cornerMedium),
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                const Text(
                  '小圆角 (4px):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.primaryGreen,
                    borderRadius: BorderRadius.all(theme.cornerSmall),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '中圆角 (8px):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.secondaryBlue,
                    borderRadius: BorderRadius.all(theme.cornerMedium),
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('表单输入样式'),
        p('展示主题中定义的表单输入样式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: '默认输入框',
                    hintText: '使用主题样式',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: '错误状态',
                    errorText: '这是错误提示',
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: '默认输入框',
                    hintText: '使用主题样式',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: '错误状态',
                    errorText: '这是错误提示',
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('按钮样式'),
        p('展示主题中定义的按钮样式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('主色按钮')),
                const SizedBox(height: 16),
                TextButton(onPressed: () {}, child: const Text('文字按钮')),
                const SizedBox(height: 16),
                FilledButton(onPressed: () {}, child: const Text('填充按钮')),
              ],
            );
          },
          codeSnippet: '''
```dart

// 使用主题按钮样式

ElevatedButton(
onPressed: () {},
child: Text('主色按钮'),
)

TextButton(
onPressed: () {},
child: Text('文字按钮'),
)
```
''',
        ),
        h2('菜单样式'),
        p('展示主题中定义的菜单样式'),
        WidgetHighlight(
          builder: (_) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: EasyTheme.of(context).background,
                borderRadius: BorderRadius.all(
                  EasyTheme.of(context).cornerSmall,
                ),
                boxShadow: [
                  BoxShadow(
                    color: EasyTheme.of(context).secondaryBlue.withAlpha(0x40),
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: const Text('菜单内容'),
            );
          },
          codeSnippet: '''
```dart
  Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  EasyTheme.of(context).cornerSmall,
                ),
                boxShadow: [
                  BoxShadow(
                    color: EasyTheme.of(context).secondaryBlue.withAlpha(0x40),
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: const Text('菜单内容'),
            );
```
''',
        ),
        h2('开关样式'),
        p('展示主题中定义的开关样式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                Switch(value: true, onChanged: (value) {}),
                const SizedBox(height: 16),
                Switch(value: false, onChanged: (value) {}),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                Switch(value: true, onChanged: (value) {}),
                const SizedBox(height: 16),
                Switch(value: false, onChanged: (value) {}),
              ],
            );
```
''',
        ),
        h2('自定义主题'),
        p('展示如何自定义主题'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '自定义主题数据:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('final customTheme = EasyThemeData('),
                const Text('  primaryGreen: Colors.blue,'),
                const Text('  neutral33: Colors.black,'),
                const Text(');'),
                const SizedBox(height: 16),
                const Text(
                  '应用自定义主题:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('MaterialApp('),
                const Text(
                  '  theme: easyBuildMaterialTheme(data: customTheme),',
                ),
                const Text('  home: MyApp(),'),
                const Text(')'),
              ],
            );
          },
          codeSnippet: "",
        ),
        h2('Theme参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyThemeData 参数说明：'),
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
                        DataCell(Text('primaryGreen')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF00C853)')),
                        DataCell(Text('否')),
                        DataCell(Text('主色绿色，用于主要按钮、强调元素等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('neutral33')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF333333)')),
                        DataCell(Text('否')),
                        DataCell(Text('深灰色，用于主要文字')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('neutral66')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF666666)')),
                        DataCell(Text('否')),
                        DataCell(Text('中等灰色，用于次要文字')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('neutral99')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF999999)')),
                        DataCell(Text('否')),
                        DataCell(Text('浅灰色，用于占位文字')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('neutralEE')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFEEEEEE)')),
                        DataCell(Text('否')),
                        DataCell(Text('极浅灰色，用于分割线')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('neutralF8')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFF8F8F8)')),
                        DataCell(Text('否')),
                        DataCell(Text('背景灰色，用于页面背景')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryBlue')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF2196F3)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助蓝色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryPurple')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF9C27B0)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助紫色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryPurpleBlue')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF673AB7)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助紫蓝色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryCyan')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF00BCD4)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助青色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryGreen')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF4CAF50)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助绿色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryAmber')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFFFC107)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助琥珀色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('secondaryOrange')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFFF9800)')),
                        DataCell(Text('否')),
                        DataCell(Text('辅助橙色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('logoBlue')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFF1976D2)')),
                        DataCell(Text('否')),
                        DataCell(Text('品牌蓝色，用于logo等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('termination')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFF44336)')),
                        DataCell(Text('否')),
                        DataCell(Text('终止色，用于错误、危险操作')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('warning')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xFFFF5722)')),
                        DataCell(Text('否')),
                        DataCell(Text('警告色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cornerSmall')),
                        DataCell(Text('Radius')),
                        DataCell(Text('Radius.circular(4)')),
                        DataCell(Text('否')),
                        DataCell(Text('小圆角，4像素')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cornerMedium')),
                        DataCell(Text('Radius')),
                        DataCell(Text('Radius.circular(8)')),
                        DataCell(Text('否')),
                        DataCell(Text('中圆角，8像素')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cornerLarge')),
                        DataCell(Text('Radius')),
                        DataCell(Text('Radius.circular(12)')),
                        DataCell(Text('否')),
                        DataCell(Text('大圆角，12像素')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textTheme')),
                        DataCell(Text('TextTheme')),
                        DataCell(Text('自定义文本主题')),
                        DataCell(Text('否')),
                        DataCell(Text('文本样式主题，包含各种字体大小和样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('buttonTheme')),
                        DataCell(Text('ButtonThemeData')),
                        DataCell(Text('自定义按钮主题')),
                        DataCell(Text('否')),
                        DataCell(Text('按钮样式主题')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('inputDecorationTheme')),
                        DataCell(Text('InputDecorationTheme')),
                        DataCell(Text('自定义输入框主题')),
                        DataCell(Text('否')),
                        DataCell(Text('输入框样式主题')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyTheme 方法说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法名')),
                    DataColumn(label: Text('返回值')),
                    DataColumn(label: Text('参数')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('of')),
                        DataCell(Text('EasyThemeData')),
                        DataCell(Text('BuildContext context')),
                        DataCell(Text('获取当前上下文中的主题数据')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('easyBuildMaterialTheme')),
                        DataCell(Text('ThemeData')),
                        DataCell(Text('{EasyThemeData? data}')),
                        DataCell(Text('构建Material主题数据，可传入自定义EasyThemeData')),
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

  Widget _buildColorBox(Color color, String label) {
    return Column(
      children: [
        Container(width: 60, height: 60, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
