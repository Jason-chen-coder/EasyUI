import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class SvgDemo extends StatelessWidget {
  const SvgDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySvgIcon 组件示例'),
        h2('基本用法'),
        p('展示EasySvgIcon的基本使用方式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '基本图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
              ],
            );
          },
          codeSnippet: '''
```dart
                EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
```
''',
        ),
        h2('尺寸控制'),
        p('通过width/height控制图标大小'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '小尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 16),
                const Text(
                  '中尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '大尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 64,
                  height: 64,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
Column(
              children: [
                const Text(
                  '小尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 24,
                  height: 24,
                ),
                const SizedBox(height: 16),
                const Text(
                  '中尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  '大尺寸:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  width: 64,
                  height: 64,
                ),
              ],
            );
```
''',
        ),
        h2('颜色控制'),
        p('通过colorFilter控制图标颜色'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '默认颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
                const SizedBox(height: 16),
                const Text(
                  '蓝色图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.blue,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '红色图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
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
                  '默认颜色:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset('assets/svgs/ic_lab.svg'),
                const SizedBox(height: 16),
                const Text(
                  '蓝色图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.blue,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '红色图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('加载状态处理'),
        p('展示加载中和加载失败时的处理方式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '加载中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  placeholderBuilder: (_) => const CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/non_existent.svg',
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
 Column(
              children: [
                const Text(
                  '加载中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  placeholderBuilder: (_) => const CircularProgressIndicator(),
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/non_existent.svg',
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ],
            );
```
''',
        ),
        h2('高级功能'),
        p('展示语义标签、裁剪行为等高级功能'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '带语义标签的图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  semanticsLabel: '实验室图标',
                ),
                const SizedBox(height: 16),
                const Text(
                  '不同裁剪行为:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  color: Colors.grey[200],
                  child: EasySvgIcon.asset(
                    'assets/svgs/ic_lab.svg',
                    fit: BoxFit.cover,
                    clipBehavior: Clip.antiAlias,
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
                  '带语义标签的图标:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasySvgIcon.asset(
                  'assets/svgs/ic_lab.svg',
                  semanticsLabel: '实验室图标',
                ),
                const SizedBox(height: 16),
                const Text(
                  '不同裁剪行为:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: 100,
                  height: 50,
                  color: Colors.grey[200],
                  child: EasySvgIcon.asset(
                    'assets/svgs/ic_lab.svg',
                    fit: BoxFit.cover,
                    clipBehavior: Clip.antiAlias,
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('EasySvgIcon.asset参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        DataCell(Text('assetName')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('资源文件路径，如"assets/svgs/ic_lab.svg"')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图标宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图标高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('colorFilter')),
                        DataCell(Text('ColorFilter?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('颜色过滤器，用于控制图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fit')),
                        DataCell(Text('BoxFit')),
                        DataCell(Text('BoxFit.contain')),
                        DataCell(Text('否')),
                        DataCell(Text('图标填充方式：contain、cover、fill等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('AlignmentGeometry')),
                        DataCell(Text('Alignment.center')),
                        DataCell(Text('否')),
                        DataCell(Text('图标对齐方式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('clipBehavior')),
                        DataCell(Text('Clip')),
                        DataCell(Text('Clip.hardEdge')),
                        DataCell(Text('否')),
                        DataCell(Text('裁剪行为：none、hardEdge、antiAlias等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('semanticsLabel')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('语义标签，用于无障碍访问')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('excludeFromSemantics')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否从语义树中排除')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('placeholderBuilder')),
                        DataCell(Text('WidgetBuilder?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('加载中时显示的占位组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('errorBuilder')),
                        DataCell(Text('SvgErrorBuilder?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('加载失败时显示的组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('matchTextDirection')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否匹配文本方向')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('package')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('资源所属的包名')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('bundle')),
                        DataCell(Text('AssetBundle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('用于加载资源的AssetBundle')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('theme')),
                        DataCell(Text('SvgTheme?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('SVG主题配置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('colorMapper')),
                        DataCell(Text('ColorMapper?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('颜色映射器，用于更复杂的颜色控制')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('renderingStrategy')),
                        DataCell(Text('RenderingStrategy')),
                        DataCell(Text('RenderingStrategy.picture')),
                        DataCell(Text('否')),
                        DataCell(Text('渲染策略：picture或drawable')),
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
