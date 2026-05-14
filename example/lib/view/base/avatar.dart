import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class AvatarDemo extends StatelessWidget {
  const AvatarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Avatar 和 AvatarGroup 示例'),
        h2('基本用法'),
        p('使用 initials 或 src 创建头像'),
        WidgetHighlight(
          builder: (_) {
            return Row(
              children: const [
                EasyAvatar(initials: 'JD', backgroundColor: Colors.blue),
                SizedBox(width: 16),
                EasyAvatar(src: '', backgroundColor: Colors.blue),
                SizedBox(width: 16),
                EasyAvatar(initials: 'AB', backgroundColor: Colors.blue),
                SizedBox(width: 16),
                EasyAvatar(src: '', backgroundColor: Colors.blue),
              ],
            );
          },
          codeSnippet: '''
```dart
          Row(
              children: const [
                EasyAvatar(initials: 'JD', backgroundColor: Colors.blue),
                SizedBox(width: 16),
                EasyAvatar(
                  src: 'https://picsum.photos/200',
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(initials: 'AB', backgroundColor: Colors.blue),
                SizedBox(width: 16),
                EasyAvatar(
                  src: 'https://invalid-url.com/image.jpg',
                  backgroundColor: Colors.blue,
                ),
              ],
            );
```
              ''',
        ),
        h2('不同尺寸'),
        p('通过 size 参数控制头像大小'),
        WidgetHighlight(
          builder: (_) {
            return Row(
              children: const [
                EasyAvatar(
                  initials: 'XS',
                  size: 24,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'SM',
                  size: 32,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'MD',
                  size: 48,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'LG',
                  size: 64,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'XL',
                  size: 80,
                  backgroundColor: Colors.blue,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
         Row(
              children: const [
                EasyAvatar(
                  initials: 'XS',
                  size: 24,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'SM',
                  size: 32,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'MD',
                  size: 48,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'LG',
                  size: 64,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'XL',
                  size: 80,
                  backgroundColor: Colors.blue,
                ),
              ],
            );
```
''',
        ),
        h2('边框显示'),
        p('通过 showBorder 参数控制是否显示边框'),
        WidgetHighlight(
          builder: (_) {
            return Row(
              children: const [
                EasyAvatar(
                  initials: 'NB',
                  showBorder: false,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'WB',
                  showBorder: true,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  src: '',
                  showBorder: false,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  src: '',
                  showBorder: true,
                  backgroundColor: Colors.blue,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
         Row(
              children: const [
                EasyAvatar(
                  initials: 'NB',
                  showBorder: false,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  initials: 'WB',
                  showBorder: true,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  src: 'https://picsum.photos/200',
                  showBorder: false,
                  backgroundColor: Colors.blue,
                ),
                SizedBox(width: 16),
                EasyAvatar(
                  src: 'https://picsum.photos/201',
                  showBorder: true,
                  backgroundColor: Colors.blue,
                ),
              ],
            );
```
''',
        ),
        h2('AvatarGroup 基本用法'),
        p('创建一组头像，可控制方向和间距'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'AA'),
                    EasyAvatarItem(initials: 'BB'),
                    EasyAvatarItem(initials: 'CC'),
                    EasyAvatarItem(initials: 'DD'),
                  ],
                  avatarGap: 18,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(src: ''),
                    EasyAvatarItem(src: ''),
                    EasyAvatarItem(src: ''),
                  ],
                  avatarGap: 28,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
     Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'AA'),
                    EasyAvatarItem(initials: 'BB'),
                    EasyAvatarItem(initials: 'CC'),
                    EasyAvatarItem(initials: 'DD'),
                  ],
                  avatarGap: 18,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(src: 'https://picsum.photos/200'),
                    EasyAvatarItem(src: 'https://picsum.photos/201'),
                    EasyAvatarItem(src: 'https://picsum.photos/202'),
                  ],
                  avatarGap: 28,
                ),
              ],
            );
```
''',
        ),
        h2('不同方向'),
        p('通过 direction 参数控制头像组排列方向'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'L1'),
                    EasyAvatarItem(initials: 'L2'),
                    EasyAvatarItem(initials: 'L3'),
                  ],
                  direction: AvatarGroupDirection.left,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'R1'),
                    EasyAvatarItem(initials: 'R2'),
                    EasyAvatarItem(initials: 'R3'),
                  ],
                  direction: AvatarGroupDirection.right,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'T1'),
                    EasyAvatarItem(initials: 'T2'),
                    EasyAvatarItem(initials: 'T3'),
                  ],
                  direction: AvatarGroupDirection.top,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'B1'),
                    EasyAvatarItem(initials: 'B2'),
                    EasyAvatarItem(initials: 'B3'),
                  ],
                  direction: AvatarGroupDirection.bottom,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
     Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'L1'),
                    EasyAvatarItem(initials: 'L2'),
                    EasyAvatarItem(initials: 'L3'),
                  ],
                  direction: AvatarGroupDirection.left,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'R1'),
                    EasyAvatarItem(initials: 'R2'),
                    EasyAvatarItem(initials: 'R3'),
                  ],
                  direction: AvatarGroupDirection.right,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'T1'),
                    EasyAvatarItem(initials: 'T2'),
                    EasyAvatarItem(initials: 'T3'),
                  ],
                  direction: AvatarGroupDirection.top,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(initials: 'B1'),
                    EasyAvatarItem(initials: 'B2'),
                    EasyAvatarItem(initials: 'B3'),
                  ],
                  direction: AvatarGroupDirection.bottom,
                ),
              ],
            );
```
''',
        ),
        h2('数量限制'),
        p('通过 count 参数限制显示的头像数量，超出部分会显示 +N'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyAvatarGroup(
                  items: List.generate(
                    10,
                    (index) => EasyAvatarItem(initials: 'U${index + 1}'),
                  ),
                  count: 3,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: List.generate(
                    5,
                    (index) => EasyAvatarItem(initials: 'T${index + 1}'),
                  ),
                  count: 4,
                  avatarGap: -12,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                EasyAvatarGroup(
                  items: List.generate(
                    10,
                    (index) => EasyAvatarItem(initials: 'U\${index + 1}'),
                  ),
                  count: 3,
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: List.generate(
                    5,
                    (index) => EasyAvatarItem(initials: 'T\${index + 1}'),
                  ),
                  count: 4,
                  avatarGap: -12,
                ),
              ],
            );
```
''',
        ),
        h2('自定义样式'),
        p('自定义头像的背景色、文字颜色等'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(
                      initials: 'R',
                      backgroundColor: Colors.red,
                      initialsColor: Colors.white,
                    ),
                    EasyAvatarItem(
                      initials: 'G',
                      backgroundColor: Colors.green,
                      initialsColor: Colors.black,
                    ),
                    EasyAvatarItem(
                      initials: 'B',
                      backgroundColor: Colors.blue,
                      initialsColor: Colors.yellow,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(src: '', backgroundColor: Colors.purple),
                    EasyAvatarItem(src: '', backgroundColor: Colors.orange),
                  ],
                  showBorder: true,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
     Column(
              children: [
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(
                      initials: 'R',
                      backgroundColor: Colors.red,
                      initialsColor: Colors.white,
                    ),
                    EasyAvatarItem(
                      initials: 'G',
                      backgroundColor: Colors.green,
                      initialsColor: Colors.black,
                    ),
                    EasyAvatarItem(
                      initials: 'B',
                      backgroundColor: Colors.blue,
                      initialsColor: Colors.yellow,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                EasyAvatarGroup(
                  items: [
                    EasyAvatarItem(
                      src: 'https://picsum.photos/200',
                      backgroundColor: Colors.purple,
                    ),
                    EasyAvatarItem(
                      src: 'https://picsum.photos/201',
                      backgroundColor: Colors.orange,
                    ),
                  ],
                  showBorder: true,
                ),
              ],
            );
```
''',
        ),
        h2('Avatar参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyAvatar 参数说明：'),
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
                        DataCell(Text('initials')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('头像首字母，与src二选一')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('src')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('头像图片URL，与initials二选一')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('size')),
                        DataCell(Text('double')),
                        DataCell(Text('40.0')),
                        DataCell(Text('否')),
                        DataCell(Text('头像尺寸')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialsColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('首字母文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showBorder')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示边框')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('边框颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('2.0')),
                        DataCell(Text('否')),
                        DataCell(Text('边框宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('首字母文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onTap')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('点击回调')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyAvatarGroup 参数说明：'),
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
                        DataCell(Text('items')),
                        DataCell(Text('List<EasyAvatarItem>')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('头像项列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('direction')),
                        DataCell(Text('AvatarGroupDirection')),
                        DataCell(Text('AvatarGroupDirection.left')),
                        DataCell(Text('否')),
                        DataCell(Text('排列方向')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('avatarGap')),
                        DataCell(Text('double')),
                        DataCell(Text('-12.0')),
                        DataCell(Text('否')),
                        DataCell(Text('头像间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('count')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('显示的头像数量限制')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showBorder')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示边框')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('边框颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderWidth')),
                        DataCell(Text('double')),
                        DataCell(Text('2.0')),
                        DataCell(Text('否')),
                        DataCell(Text('边框宽度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('overflowTextStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('超出数量文本样式')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyAvatarItem 参数说明：'),
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
                        DataCell(Text('initials')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('头像首字母')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('src')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('头像图片URL')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.grey')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialsColor')),
                        DataCell(Text('Color')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('首字母文本颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('首字母文本样式')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('AvatarGroupDirection 枚举说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('枚举值')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [DataCell(Text('left')), DataCell(Text('从左到右排列'))],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('right')),
                        DataCell(Text('从右到左排列')),
                      ],
                    ),
                    DataRow(
                      cells: [DataCell(Text('top')), DataCell(Text('从上到下排列'))],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('bottom')),
                        DataCell(Text('从下到上排列')),
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
