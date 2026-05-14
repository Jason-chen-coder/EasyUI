import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class EasyRichEditorDemo extends StatefulWidget {
  const EasyRichEditorDemo({super.key});

  @override
  State<EasyRichEditorDemo> createState() => _EasyRichEditorDemoState();
}

class _EasyRichEditorDemoState extends State<EasyRichEditorDemo> {
  final _singleController = EasyRichEditorController();
  final _controller1 = EasyRichEditorController();
  final _controller2 = EasyRichEditorController();
  final _previewController = EasyRichEditorController();
  final ScrollController _pageScrollController = ScrollController();

  static const String _previewInitialHtml =
      r'''<p style="text-align: center;"><img src="https://cdn.vuetifyjs.com/docs/images/one/logos/vuetify-logo-light.png" alt="logo" data-href="https://cdn.vuetifyjs.com/docs/images/one/logos/vuetify-logo-light.png" style="width: 384.00px;height: 120.00px;"></p><h1 style="text-align: center;"><span style="color: rgb(231, 95, 51);">标题</span></h1><h2 style="text-align: center;"><span style="color: rgb(255, 255, 255); background-color: rgb(54, 88, 226);">标题A</span></h2><h3><u>标题A1</u></h3><p><strong>文本</strong></p><blockquote><em>文本</em></blockquote><p><s>文本</s></p><p>示例公式：<span data-w-e-type="formula" data-w-e-is-void data-w-e-is-inline data-value="c = \\pm\\sqrt{a^2 + b^2}"></span></p><p>示例链接： </p><div data-w-e-type="link-card" data-w-e-is-void data-title="https://vuetifyjs.com/en/" data-link="https://vuetifyjs.com/en/" data-iconImgSrc="https://vuetifyjs.com/favicon.ico">
    <div class="info-container">
      <div class="title-container"><p>https://vuetifyjs.com/en/</p></div>
      <div class="link-container"><span>https://vuetifyjs.com/en/</span></div>
    </div>
    <div class="icon-container">
      <img src="https://vuetifyjs.com/favicon.ico"/>
    </div>
  </div><p> </p><p>示例表格：</p><table style="width: 100%;"><tbody><tr><th colSpan="1" rowSpan="1" width="auto">姓名</th><th colSpan="1" rowSpan="1" width="auto">年龄</th></tr><tr><td colspan="1" rowspan="1" width="auto" style="text-align: center;">小明</td><td colspan="1" rowspan="1" width="auto" style="text-align: center;">6</td></tr><tr><td colspan="1" rowspan="1" width="auto" style="text-align: center;">小红</td><td colspan="1" rowspan="1" width="auto" style="text-align: center;">5</td></tr></tbody></table><p>示例代码：</p><pre><code class="language-javascript">let a = 1;</code></pre><p><br></p>''';

  Widget _buildMultiEditorPanel({
    required String title,
    required EasyRichEditorController controller,
    required String setValueHtml,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final value = await controller.getValueHtml();
                        showToastOk(text: "内容已打印至控制台");
                        debugPrint('$title getValueHtml: $value');
                      },
                      child: const Text('Get valueHtml'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await controller.setValueHtml(setValueHtml);
                      },
                      child: const Text('Set valueHtml'),
                    ),
                  ],
                ),
              ),
              EasyRichEditor(
                controller: controller,
                onChange:
                    (valueHtml) => debugPrint('$title valueHtml: $valueHtml'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      controller: _pageScrollController,
      children: [
        h1('EasyRichEditor'),
        h2('1.单个编辑器使用'),
        WidgetHighlight(
          builder: (context) {
            return SizedBox(
              height: 400,
              child: EasyRichEditor(
                controller: _singleController,
                parentScrollController: _pageScrollController,
                onChange:
                    (valueHtml) =>
                        debugPrint('Single RichEditor valueHtml: $valueHtml'),
              ),
            );
          },
          codeSnippet: '''
```dart
        final controller = EasyRichEditorController();

        EasyRichEditor(
          controller: controller,
          onChange: (valueHtml) {
            debugPrint('valueHtml: \$valueHtml');
          },
        );
```
        ''',
        ),
        h2('2.多个编辑器使用'),
        WidgetHighlight(
          builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildMultiEditorPanel(
                    title: '富文本编辑器1',
                    controller: _controller1,
                    setValueHtml: '<p>Hello Easy Rich Editor #1</p>',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildMultiEditorPanel(
                    title: '富文本编辑器2',
                    controller: _controller2,
                    setValueHtml: '<p>Hello Easy Rich Editor #2</p>',
                  ),
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
        final controller1 = EasyRichEditorController();
        final controller2 = EasyRichEditorController();

        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final value = await controller1.getValueHtml();
                      debugPrint('RichEditor #1 getValueHtml: \$value');
                    },
                    child: const Text('Get valueHtml'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller1.setValueHtml('<p>Hello Easy Rich Editor #1</p>');
                    },
                    child: const Text('Set valueHtml'),
                  ),
                  Expanded(
                    child: EasyRichEditor(
                      controller: controller1,
                      onChange: (valueHtml) {
                        debugPrint('RichEditor #1 valueHtml: \$valueHtml');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final value = await controller2.getValueHtml();
                      debugPrint('RichEditor #2 getValueHtml: \$value');
                    },
                    child: const Text('Get valueHtml'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await controller2.setValueHtml('<p>Hello Easy Rich Editor #2</p>');
                    },
                    child: const Text('Set valueHtml'),
                  ),
                  Expanded(
                    child: EasyRichEditor(
                      controller: controller2,
                      onChange: (valueHtml) {
                        debugPrint('RichEditor #2 valueHtml: \$valueHtml');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
        ```
''',
        ),
        h2('3.预览模式'),
        p('在预览模式或嵌套滚动场景下，建议传入 parentScrollController 以解决 WebView 滚动截断问题。'),
        WidgetHighlight(
          builder: (context) {
            return EasyRichEditor(
              preview: true,
              initialValue: _previewInitialHtml,
              controller: _previewController,
              parentScrollController: _pageScrollController,
              onChange:
                  (valueHtml) =>
                      debugPrint('Preview RichEditor valueHtml: $valueHtml'),
            );
          },
          codeSnippet: '''
```dart
                final controller = EasyRichEditorController();
                const initialHtml = '<p style="text-align: center;"><img src="https://cdn.vuetifyjs.com/docs/images/one/logos/vuetify-logo-light.png" alt="logo" data-href="https://cdn.vuetifyjs.com/docs/images/one/logos/vuetify-logo-light.png" style="width: 384.00px;height: 120.00px;"></p><h1 style="text-align: center;"><span style="color: rgb(231, 95, 51);">标题</span></h1><h2 style="text-align: center;"><span style="color: rgb(255, 255, 255); background-color: rgb(54, 88, 226);">标题A</span></h2><h3><u>标题A1</u></h3><p><strong>文本</strong></p><blockquote><em>文本</em></blockquote><p><s>文本</s></p><p>示例公式：<span data-w-e-type="formula" data-w-e-is-void data-w-e-is-inline data-value="c = \\pm\\sqrt{a^2 + b^2}"></span></p><p>示例链接： </p><div data-w-e-type="link-card" data-w-e-is-void data-title="https://vuetifyjs.com/en/" data-link="https://vuetifyjs.com/en/" data-iconImgSrc="https://vuetifyjs.com/favicon.ico">
                    <div class="info-container">
                      <div class="title-container"><p>https://vuetifyjs.com/en/</p></div>
                      <div class="link-container"><span>https://vuetifyjs.com/en/</span></div>
                    </div>
                    <div class="icon-container">
                      <img src="https://vuetifyjs.com/favicon.ico"/>
                    </div>
                  </div><p> </p><p>示例表格：</p><table style="width: 100%;"><tbody><tr><th colSpan="1" rowSpan="1" width="auto">姓名</th><th colSpan="1" rowSpan="1" width="auto">年龄</th></tr><tr><td colspan="1" rowspan="1" width="auto" style="text-align: center;">小明</td><td colspan="1" rowspan="1" width="auto" style="text-align: center;">6</td></tr><tr><td colspan="1" rowspan="1" width="auto" style="text-align: center;">小红</td><td colspan="1" rowspan="1" width="auto" style="text-align: center;">5</td></tr></tbody></table><p>示例代码：</p><pre><code class="language-javascript">let a = 1;</code></pre><p><br></p>';
                  EasyRichEditor(
                      preview: true,
                      initialValue: _previewInitialHtml,
                      controller: _previewController,
                      onChange:
                          (valueHtml) =>
                              debugPrint('Preview RichEditor valueHtml: \$valueHtml'),
                    );
```
        ''',
        ),
        h2('4.参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyRichEditor 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(30),
                    ),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(
                      label: Text('说明'),
                      columnWidth: FixedColumnWidth(200),
                    ),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasyRichEditorController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('编辑器控制器，用于获取/设置内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onChange')),
                        DataCell(Text('ValueChanged<String?>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('内容变化回调，返回 HTML 字符串')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('preview')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否预览模式，为 true 时仅展示预览内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialValue')),
                        DataCell(Text('String')),
                        DataCell(Text("''")),
                        DataCell(Text('否')),
                        DataCell(Text('初始 HTML 内容')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('parentScrollController')),
                        DataCell(Text('ScrollController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('父级滚动控制器，用于预览模式下解决 Webview 滚动冲突')),
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
