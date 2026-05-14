import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class SkeletonDemo extends StatelessWidget {
  const SkeletonDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasySkeleton 骨架屏组件示例'),
        h2('1. 默认骨架（isLoading=true）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              child: Container(height: 120, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              child: Container(height: 120, color: Colors.transparent),
            );
```
''',
        ),

        h2('2. 内置骨架：列表（preset: list）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.list,
              child: Container(height: 120, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.list,
              child: Container(height: 120, color: Colors.transparent),
            );
```
''',
        ),

        h2('3. 内置骨架：头像行（preset: avatar）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.avatar,
              child: Container(height: 80, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.avatar,
              child: Container(height: 80, color: Colors.transparent),
            );
```
''',
        ),

        h2('4. 网格骨架：行列控制（rows: 2, columns: 3）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              rows: 2,
              columns: 3,
              child: Container(height: 160, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              rows: 2,
              columns: 3,
              child: Container(height: 160, color: Colors.transparent),
            );
```
''',
        ),

        h2('5. 自定义元素骨架（customElementSkeleton）'),
        WidgetHighlight(
          builder: (_) {
            final easyTheme = EasyTheme.of(context);
            final customItem = Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(easyTheme.cornerSmall),
              ),
            );

            return EasySkeleton(
              isLoading: true,
              rows: 2,
              columns: 2,
              customElementSkeleton: customItem,
              child: Container(height: 200, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
        {
            final easyTheme = EasyTheme.of(context);
            final customItem = Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(easyTheme.cornerSmall),
              ),
            );

            return EasySkeleton(
              isLoading: true,
              rows: 2,
              columns: 2,
              customElementSkeleton: customItem,
              child: Container(height: 200, color: Colors.transparent),
            );
          },
```
''',
        ),

        h2('6. 自定义骨架整体（customSkeleton 优先级最高）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              customSkeleton: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('自定义整体骨架')),
              ),
              child: Container(height: 100, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              customSkeleton: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('自定义整体骨架')),
              ),
              child: Container(height: 100, color: Colors.transparent),
            );
```
''',
        ),

        h2('7. 错误状态（isError=true，展示重试）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: false,
              isError: true,
              onRetry: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('点击了重试')));
              },
              child: Container(height: 80, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: false,
              isError: true,
              onRetry: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('点击了重试')));
              },
              child: Container(height: 80, color: Colors.transparent),
            );
```
''',
        ),

        h2('8. 网格 + 预设：头像（rows: 4, columns: 4, preset: avatar）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              columns: 4,
              rows: 4,
              preset: SkeletonPreset.avatar,
              child: Container(height: 320, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              columns: 4,
              rows: 4,
              preset: SkeletonPreset.avatar,
              child: Container(height: 320, color: Colors.transparent),
            );
```
''',
        ),

        h2('9. 网格 + 预设：聊天（rows: 1, columns: 1, preset: chat）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              columns: 1,
              rows: 1,
              preset: SkeletonPreset.chat,
              child: Container(height: 320, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              columns: 1,
              rows: 1,
              preset: SkeletonPreset.chat,
              child: Container(height: 320, color: Colors.transparent),
            );
```
''',
        ),

        h2('10. 文本骨架：自定义文本内容和颜色'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.text,
              textContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '这是一段较长的文本内容，用于展示文本骨架效果。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('这是第二段文本。', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text(
                    '这是第三段更长的文本内容，可以展示多行文本的骨架效果，让用户了解内容正在加载中。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text('最后一段文本。', style: TextStyle(fontSize: 16)),
                ],
              ),
              baseColor: const Color(0xff7C7C7C),
              highlightColor: Colors.white,
              child: Container(height: 100, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.text,
              textContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '这是一段较长的文本内容，用于展示文本骨架效果。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '这是第二段文本。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '这是第三段更长的文本内容，可以展示多行文本的骨架效果，让用户了解内容正在加载中。',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '最后一段文本。',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              baseColor: const Color(0xff7C7C7C),
              highlightColor: Colors.white,
              child: Container(height: 100, color: Colors.transparent),
            );
```
''',
        ),

        h2('11. 内置骨架：卡片（preset: card）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.card,
              child: Container(height: 150, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.card,
              child: Container(height: 150, color: Colors.transparent),
            );
```
''',
        ),

        h2('12. 内置骨架：报告详情页（preset: report）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.report,
              child: Container(height: 400, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.report,
              child: Container(height: 400, color: Colors.transparent),
            );
```
''',
        ),

        h2('13. 内置骨架：H5页面（preset: h5）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.h5,
              child: Container(height: 400, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.h5,
              child: Container(height: 400, color: Colors.transparent),
            );
```
''',
        ),

        h2('14. 内置骨架：实验耗材列表（preset: labwareList）'),
        WidgetHighlight(
          builder: (_) {
            return EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.labwareList,
              child: Container(height: 400, color: Colors.transparent),
            );
          },
          codeSnippet: '''
```dart
EasySkeleton(
              isLoading: true,
              preset: SkeletonPreset.labwareList,
              child: Container(height: 400, color: Colors.transparent),
            );
```
''',
        ),

        h2('Skeleton参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasySkeleton 参数说明：'),
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
                        DataCell(Text('isLoading')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('是')),
                        DataCell(Text('是否显示骨架屏，true时显示骨架，false时显示child')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('isError')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示错误状态，true时显示错误提示和重试按钮')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onRetry')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('重试按钮点击回调，isError=true时生效')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('preset')),
                        DataCell(Text('SkeletonPreset?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('预设骨架样式：list/avatar/chat等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('rows')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('骨架行数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('columns')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('骨架列数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('customElementSkeleton')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义骨架元素，用于替换默认的骨架单元')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('customSkeleton')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义整体骨架，优先级最高')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textContent')),
                        DataCell(Text('Widget')),
                        DataCell(Text('SizedBox()')),
                        DataCell(Text('否')),
                        DataCell(Text('文本骨架的自定义内容，配合preset: text使用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('baseColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Color(0xff7C7C7C)')),
                        DataCell(Text('否')),
                        DataCell(Text('Shimmer动画的基础颜色，用于文本骨架')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('highlightColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('Shimmer动画的高亮颜色，用于文本骨架')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('child')),
                        DataCell(Text('Widget')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('骨架屏隐藏时要显示的实际内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fadeDuration')),
                        DataCell(Text('Duration')),
                        DataCell(Text('Duration(milliseconds: 300)')),
                        DataCell(Text('否')),
                        DataCell(Text('淡入淡出动画时长')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.all(16.0)')),
                        DataCell(Text('否')),
                        DataCell(Text('骨架屏内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('elementHeight')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('网格骨架元素高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('spacing')),
                        DataCell(Text('double')),
                        DataCell(Text('12.0')),
                        DataCell(Text('否')),
                        DataCell(Text('网格骨架元素间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('elementBorderRadius')),
                        DataCell(Text('double')),
                        DataCell(Text('4.0')),
                        DataCell(Text('否')),
                        DataCell(Text('默认骨架子元素圆角')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('SkeletonPreset 枚举说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('枚举值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('list')),
                        DataCell(Text('列表样式，适合展示列表数据加载')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('avatar')),
                        DataCell(Text('头像行样式，适合展示带头像的列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('chat')),
                        DataCell(Text('聊天样式，适合展示聊天消息')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('text')),
                        DataCell(
                          Text(
                            '文本样式，适合展示文本内容加载，可配合textContent、baseColor、highlightColor使用',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('card')),
                        DataCell(Text('卡片样式，适合展示卡片类型的内容加载')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('report')),
                        DataCell(Text('报告详情页样式，适合展示报告详情页的内容加载')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('h5')),
                        DataCell(Text('H5页面样式，适合展示简单H5页面的内容加载')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('labwareList')),
                        DataCell(Text('实验耗材列表样式，4列网格布局，适合展示耗材库列表的加载状态')),
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
