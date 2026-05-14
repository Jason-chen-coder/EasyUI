import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class ImageDemo extends StatelessWidget {
  const ImageDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Image 组件示例'),
        h2('基本用法'),
        p('展示网络图片、本地资源和文件图片的基本用法'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '网络图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 200,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 16),
                const Text(
                  '本地资源图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'assets/images/placeholder.png',
                  width: 300,
                  height: 200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
     Column(
              children: [
                const Text(
                  '网络图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 200,
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 16),
                const Text(
                  '本地资源图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'assets/images/placeholder.png',
                  width: 300,
                  height: 200,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            );
```
''',
        ),
        h2('加载状态处理'),
        p('展示加载中和加载失败时的占位图'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '加载中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://slow-loading-image.com/image.jpg', // 故意使用慢加载URL
                  width: 300,
                  height: 200,
                  loadingPlaceholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://invalid-url.com/image.jpg',
                  width: 300,
                  height: 200,
                  errorPlaceholder: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      Text('图片加载失败', style: TextStyle(color: Colors.red)),
                    ],
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
                  '加载中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://slow-loading-image.com/image.jpg', // 故意使用慢加载URL
                  width: 300,
                  height: 200,
                  loadingPlaceholder: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '加载失败状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://invalid-url.com/image.jpg',
                  width: 300,
                  height: 200,
                  errorPlaceholder: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red),
                      Text('图片加载失败', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('图片适配方式'),
        p('展示不同的BoxFit适配方式'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  'BoxFit.cover:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BoxFit.contain:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BoxFit.fill:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                const Text(
                  'BoxFit.cover:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BoxFit.contain:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.contain,
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 16),
                const Text(
                  'BoxFit.fill:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 150,
                  fit: BoxFit.fill,
                ),
              ],
            );
```
''',
        ),
        h2('圆角与背景色'),
        p('展示图片圆角和背景色的设置'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.circular(20),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.circular(100),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(20),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
      Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.circular(20),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.circular(100),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.all(20),
                ),
              ],
            );
```
''',
        ),
        h2('图片颜色混合'),
        p('展示图片颜色混合效果'),
        WidgetHighlight(
          builder: (_) {
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  colorBlendMode: BlendMode.color,
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.red.withOpacity(0.5),
                  colorBlendMode: BlendMode.multiply,
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.green,
                  colorBlendMode: BlendMode.screen,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
       Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                  colorBlendMode: BlendMode.color,
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.red.withOpacity(0.5),
                  colorBlendMode: BlendMode.multiply,
                ),
                EasyImage(
                  src: 'https://picsum.photos/200/200',
                  width: 200,
                  height: 200,
                  color: Colors.green,
                  colorBlendMode: BlendMode.screen,
                ),
              ],
            );
```
''',
        ),
        h2('图片预览'),
        p('展示图片预览功能，包括缩放和切换图片操作'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const Text('单张图片预览'),
                EasyImage(
                  src:
                      'https://images.unsplash.com/photo-1542332213-9b5a5a3fad35?q=80&w=2070&auto=format&fit=crop',
                  height: 100,
                  preview: true,
                ),
                const Text('多张图片预览'),
                Builder(
                  builder: (context) {
                    final imgList = const [
                      'https://images.unsplash.com/photo-1542332213-9b5a5a3fad35?q=80&w=2070&auto=format&fit=crop', // 山
                      'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=2070&auto=format&fit=crop', // 草原
                      'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1948&auto=format&fit=crop', // 森林
                    ];

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (int i = 0; i < imgList.length; i++)
                          EasyImage(
                            src: imgList[i],
                            height: 100,
                            preview: true,
                            previewImages: imgList,
                            previewIndex: i,
                          ),
                      ],
                    );
                  },
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
/// 单张图片预览
const Text('单张图片预览'),
EasyImage(
  src:
      'https://images.unsplash.com/photo-1542332213-9b5a5a3fad35?q=80&w=2070&auto=format&fit=crop',
  height: 100,
  preview: true,
),


/// 多张图片预览
final imgList = const [
  'https://images.unsplash.com/photo-1542332213-9b5a5a3fad35?q=80&w=2070&auto=format&fit=crop', // 山
  'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=2070&auto=format&fit=crop', // 草原
  'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=1948&auto=format&fit=crop', // 森林
];

return Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    for (int i = 0; i < imgList.length; i++)
      EasyImage(
        src: imgList[i],
        height: 100,
        preview: true,
        previewImages: imgList,
        previewIndex: i,
      ),
  ],
);
```
''',
        ),
        h2('缩略图'),
        p('加载缩略图以提高性能'),
        p(
          '可以通过设置`displayThumbnail`启用缩略图展示\n默认会先通过`height`和`width`属性生成缩略图\n如果`height`和`width`均未设置，则使用图片容器在当前位置的约束生成缩略图',
        ),
        tip('亦可通过 `cacheWidth` 和 `cacheHeight` 手动控制图片解析尺寸，单位为`像素`'),
        tip(
          '`cacheWidth`, `cacheHeight` 与 `width`, `height` 的单位不相同，前者为`像素`，后者为`逻辑像素`'
          '\n\n`像素` = `逻辑像素` * `设备像素比`',
          type: TipType.warning,
        ),
        WidgetHighlight(
          builder: (_) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                const Text('通过宽高自动加载缩略图'),
                EasyImage(
                  src: 'https://picsum.photos/600/400',
                  displayThumbnail: true,
                  width: 300,
                  height: 200,
                ),
                const Text('手动控制解析尺寸'),
                EasyImage(
                  src: 'https://picsum.photos/600/400',
                  width: 300,
                  height: 200,
                  cacheWidth: 30,
                  cacheHeight: 20,
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
const Text('通过宽高自动加载缩略图'),
EasyImage(
  src: 'https://picsum.photos/600/400',
  displayThumbnail: true,
  width: 300,
  height: 200,
),
const Text('手动控制解析尺寸'),
EasyImage(
  src: 'https://picsum.photos/600/400',
  width: 300,
  height: 200,
  cacheWidth: 30,
  cacheHeight: 20,
),
```
''',
        ),
        h2('高级功能'),
        p('展示缓存控制、语义标签等高级功能'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              children: [
                const Text(
                  '缓存控制 (300x200像素):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/600/400',
                  width: 300,
                  height: 200,
                  cacheWidth: 300,
                  cacheHeight: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  '带语义标签的图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 200,
                  semanticLabel: '这是一张示例图片',
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
    Column(
              children: [
                const Text(
                  '缓存控制 (300x200像素):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/600/400',
                  width: 300,
                  height: 200,
                  cacheWidth: 300,
                  cacheHeight: 200,
                ),
                const SizedBox(height: 16),
                const Text(
                  '带语义标签的图片:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyImage(
                  src: 'https://picsum.photos/300/200',
                  width: 300,
                  height: 200,
                  semanticLabel: '这是一张示例图片',
                ),
              ],
            );
```
''',
        ),
        h2('Image参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyImage 参数说明：'),
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
                        DataCell(Text('src')),
                        DataCell(Text('String')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('图片资源路径，支持网络URL、本地assets路径和文件路径')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片宽度，不设置时根据高度和宽高比自动计算')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('height')),
                        DataCell(Text('double?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片高度，不设置时根据宽度和宽高比自动计算')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fit')),
                        DataCell(Text('BoxFit?')),
                        DataCell(Text('BoxFit.cover')),
                        DataCell(Text('否')),
                        DataCell(Text('图片填充方式：cover、contain、fill、fitWidth等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('borderRadius')),
                        DataCell(Text('BorderRadius?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片圆角设置')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('backgroundColor')),
                        DataCell(Text('Color?')),
                        DataCell(Text('Colors.transparent')),
                        DataCell(Text('否')),
                        DataCell(Text('背景颜色，当图片有透明区域或加载时显示')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('loadingPlaceholder')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('CircularProgressIndicator()')),
                        DataCell(Text('否')),
                        DataCell(Text('图片加载中时显示的占位组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('errorPlaceholder')),
                        DataCell(Text('Widget?')),
                        DataCell(Text('Icon(Icons.broken_image)')),
                        DataCell(Text('否')),
                        DataCell(Text('图片加载失败时显示的占位组件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('color')),
                        DataCell(Text('Color?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片颜色混合时使用的颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('colorBlendMode')),
                        DataCell(Text('BlendMode?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('颜色混合模式，如color、multiply、screen等')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cacheWidth')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('缓存图片的宽度（像素），用于优化内存使用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cacheHeight')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('缓存图片的高度（像素），用于优化内存使用')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('semanticLabel')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片的语义标签，用于无障碍访问')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('图片内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('preview')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否启用预览功能')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('previewImages')),
                        DataCell(Text('List<String>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('预览时的图片列表；为 null 时仅预览当前图片')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('previewIndex')),
                        DataCell(Text('int?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('预览起始索引，为 null 时默认从第一张图片开始')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('displayThumbnail')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否显示缩略图')),
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
