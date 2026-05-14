import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:flutter/material.dart';

class EasyPdfViewerDemo extends StatelessWidget {
  const EasyPdfViewerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('Easy PDF Viewer'),
        p('PDF 查看器组件，基于 pdfrx 封装，支持网络 URI 加载。'),
        p('内置功能：缩放（放大 / 缩小 / 自适应）、页码滑块、回到顶部按钮。'),
        h2('基本用法'),
        p('传入一个 Uri 即可渲染 PDF 文档，组件会自动处理加载中和错误状态。'),
        WidgetHighlight(
          builder: (context) {
            return SizedBox(
              height: 500,
              child: EasyPdfViewer(
                uri: Uri.parse(
                  'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
                ),
              ),
            );
          },
          codeSnippet: '''
```dart
SizedBox(
  height: 500,
  child: EasyPdfViewer(
    uri: Uri.parse(
      'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf',
    ),
  ),
)
```
''',
        ),
      ],
    );
  }
}
