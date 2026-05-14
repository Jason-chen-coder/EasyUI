import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class EasyLottieIconDemo extends StatelessWidget {
  const EasyLottieIconDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyLottieIcon 组件示例'),
        h2('基本用法'),
        p('展示EasyLottieIcon的基本使用方式，通过type枚举指定动画类型'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '设备运行动画:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                EasyLottieIcon(
                  type: EasyLottieIconType.deviceRunning,
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  '黑色加载动画:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.white,
                  child: EasyLottieIcon(
                    type: EasyLottieIconType.loadingBlack,
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '白色加载动画:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  color: Colors.black,
                  child: EasyLottieIcon(
                    type: EasyLottieIconType.loadingWhite,
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    EasyLottieIcon(
      type: EasyLottieIconType.deviceRunning,
      width: 80,
      height: 80,
    ),
    EasyLottieIcon(
      type: EasyLottieIconType.loadingBlack,
      width: 80,
      height: 80,
    ),
    EasyLottieIcon(
      type: EasyLottieIconType.loadingWhite,
      width: 80,
      height: 80,
    ),
  ],
)
```
''',
        ),
        h2('尺寸控制'),
        p('通过width和height参数控制动画尺寸'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '小尺寸 (50x50):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                EasyLottieIcon(
                  type: EasyLottieIconType.deviceRunning,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 24),
                const Text(
                  '中尺寸 (100x100):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                EasyLottieIcon(
                  type: EasyLottieIconType.deviceRunning,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 24),
                const Text(
                  '大尺寸 (200x200):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                EasyLottieIcon(
                  type: EasyLottieIconType.deviceRunning,
                  width: 200,
                  height: 200,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
Column(
  children: [
    EasyLottieIcon(
      type: EasyLottieIconType.deviceRunning,
      width: 50,
      height: 50,
    ),
    EasyLottieIcon(
      type: EasyLottieIconType.deviceRunning,
      width: 100,
      height: 100,
    ),
    EasyLottieIcon(
      type: EasyLottieIconType.deviceRunning,
      width: 200,
      height: 200,
    ),
  ],
)
```
''',
        ),
        h2('适配方式'),
        p('通过fit参数控制动画的填充方式'),
        WidgetHighlight(
          builder: (context) {
            EasyLottieIconType getThemedType() {
              final brightness = Theme.of(context).brightness;
              return brightness == Brightness.dark
                  ? EasyLottieIconType.loadingWhite
                  : EasyLottieIconType.loadingBlack;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BoxFit.contain (默认):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: EasyLottieIcon(
                    type: getThemedType(),
                    width: 200,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'BoxFit.cover:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ClipRect(
                  child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: EasyLottieIcon(
                      type: getThemedType(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'BoxFit.fill:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: EasyLottieIcon(
                    type: getThemedType(),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// BoxFit.contain - 保持比例，完整显示
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
  ),
  child: EasyLottieIcon(
    type: EasyLottieIconType.loadingBlack,
    width: 200,
    height: 100,
    fit: BoxFit.contain,
  ),
)

// BoxFit.cover - 填充容器，可能裁剪
ClipRect(
  child: Container(
    width: 200,
    height: 100,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
    ),
    child: EasyLottieIcon(
      type: EasyLottieIconType.loadingBlack,
      fit: BoxFit.cover,
    ),
  ),
)

// BoxFit.fill - 拉伸填充
Container(
  width: 200,
  height: 100,
  decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
  ),
  child: EasyLottieIcon(
    type: EasyLottieIconType.loadingBlack,
    fit: BoxFit.fill,
  ),
)
```
''',
        ),
        h2('自定义路径'),
        p(
          '通过path参数使用自定义动画路径。可以从 LottieFiles (https://lottiefiles.com/) 网站搜索并导出 JSON 格式的动画文件，然后将文件放置在项目的 assets 目录中。',
        ),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '使用自定义路径:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                EasyLottieIcon(
                  path: 'assets/animations/device_running.json',
                  package: 'easy_ui',
                  width: 100,
                  height: 100,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// 1. 访问 https://lottiefiles.com/ 搜索并下载动画 JSON 文件
// 2. 将 JSON 文件放置在项目的 assets 目录中
// 3. 使用 path 参数指定文件路径
EasyLottieIcon(
  path: 'assets/animations/device_running.json',
  package: 'easy_ui', // 如果文件在其他包中，需要指定包名，比如 'easy_studio'
  width: 100,
  height: 100,
)
```
''',
        ),
        h2('实际应用场景'),
        p('展示在加载状态、设备状态等场景中的使用'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '加载状态 (深色背景):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: EasyLottieIcon(
                    type: EasyLottieIconType.loadingWhite,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '加载状态 (浅色背景):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: EasyLottieIcon(
                    type: EasyLottieIconType.loadingBlack,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  '设备运行状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: EasyLottieIcon(
                    type: EasyLottieIconType.deviceRunning,
                    width: 80,
                    height: 80,
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// 深色背景使用白色加载动画
Container(
  color: Colors.grey[900],
  child: EasyLottieIcon(
    type: EasyLottieIconType.loadingWhite,
    width: 60,
    height: 60,
  ),
)

// 浅色背景使用黑色加载动画
Container(
  color: Colors.grey[100],
  child: EasyLottieIcon(
    type: EasyLottieIconType.loadingBlack,
    width: 60,
    height: 60,
  ),
)

// 设备运行状态
Container(
  color: Colors.blue[50],
  child: EasyLottieIcon(
    type: EasyLottieIconType.deviceRunning,
    width: 80,
    height: 80,
  ),
)
```
''',
        ),
        h2('EasyLottieIcon参数说明'),
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
                        DataCell(Text('type')),
                        DataCell(Text('EasyLottieIconType')),
                        DataCell(Text('defaultType')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '动画类型枚举，可选：deviceRunning、loadingBlack、loadingWhite',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('path')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '自定义动画路径，如果提供则优先使用path而非type。可以从 LottieFiles (https://lottiefiles.com/) 导出 JSON 文件',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('package')),
                        DataCell(Text('String')),
                        DataCell(Text('easy_ui')),
                        DataCell(Text('否')),
                        DataCell(Text('资源所属的包名')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('动画宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('动画高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fit')),
                        DataCell(Text('BoxFit?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('动画填充方式：contain、cover、fill等')),
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
