import 'package:easy_ui/easy_ui.dart';
import 'package:example/widgets/body_widget.dart';
import 'package:example/widgets/paragraph_helper.dart';
import 'package:example/widgets/widget_highlight.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EasyFileDragAreaDemo extends StatelessWidget {
  const EasyFileDragAreaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyFileDragArea'),
        p('文件拖拽上传组件，支持点击选择和拖拽上传文件'),

        h2('基础用法'),
        p('只允许选择一个文件'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              showFileList: true,
              allowMultiple: false,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('选中了文件：\n${files.join('\n')}'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  showFileList: true,
  allowMultiple: false,
  onFilesChanged: (files) {
    // 处理选中的文件
  },
)
```
''',
        ),
        h2('多选模式'),
        p('多选模式，显示文件列表'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              showFileList: true,
              allowMultiple: true,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '选中了${files.length}个文件：\n${files.join('\n')}',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  showFileList: true,
  allowMultiple: true,
  onFilesChanged: (files) {
    // 处理选中的文件
  },
)
```
''',
        ),
        h2('文件类型过滤'),
        p('只允许选择图片文件'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              type: FileType.image,
              showFileList: true,
              allowMultiple: true,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '选中了${files.length}个图片文件：\n${files.join('\n')}',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  type: FileType.image,
  showFileList: true,
  allowMultiple: true,
  onFilesChanged: (files) {
    setState(() => imageFiles = files);
  },
)
```
''',
        ),

        h2('自定义扩展名'),
        p('只允许选择特定扩展名的文件'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
              showFileList: true,
              allowMultiple: true,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '选中了${files.length}个文档文件：\n${files.join('\n')}',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  type: FileType.custom,
  allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
  showFileList: true,
  allowMultiple: true,
  onFilesChanged: (files) {
    // 处理选中的文档文件
  },
)
```
''',
        ),

        h2('隐藏文件列表'),
        p('不显示文件列表，只通过回调获取文件信息'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              showFileList: false,
              allowMultiple: true,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '选择了${files.length}个文件：\n${files.join('\n')}',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  showFileList: false,
  allowMultiple: true,
  onFilesChanged: (files) {
    // 通过回调处理文件，不显示文件列表
  },
)
```
''',
        ),

        h2('自定义间距'),
        p('调整组件和文件列表的间距'),
        WidgetHighlight(
          builder: (context) {
            return EasyFileDragArea(
              showFileList: true,
              allowMultiple: true,
              spacing: 24.0,
              fileItemSpacing: 12.0,
              onFilesChanged: (files) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '选中了${files.length}个文件：\n${files.join('\n')}',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
            );
          },
          codeSnippet: '''
```dart
EasyFileDragArea(
  showFileList: true,
  allowMultiple: true,
  spacing: 24.0,          // 按钮和文件列表间距
  fileItemSpacing: 12.0,  // 文件列表项间距
  onFilesChanged: (files) {
    // 处理文件
  },
)
```
''',
        ),
        h2('使用控制器进行删除/清空'),
        p('通过 EasyFileDragAreaController 在父组件中主动删除或清空已选文件（示例隐藏内置文件列表）。'),
        WidgetHighlight(
          builder: (context) {
            return const _EasyFileDragAreaControllerExample();
          },
          codeSnippet: '''
```dart
class _DemoState extends State<Demo> {
  final _controller = EasyFileDragAreaController();
  List<EasyFileDraggedItem> files = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EasyButton2(
              child: const Text('删除第一个'),
              onPressed: files.isEmpty ? null : () => _controller.removeAt(0),
            ),
            EasyButton2(
              child: const Text('清空文件'),
              onPressed: files.isEmpty ? null : _controller.clear,
            ),
          ],
        ),
        EasyFileDragArea(
          controller: _controller,
          showFileList: false, // 不展示内置文件列表
          allowMultiple: true,
          onFilesChanged: (items) => setState(() => files = items),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```
''',
        ),
        h2('参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                p('EasyFileDragArea 参数说明：'),
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
                        DataCell(Text('FileType')),
                        DataCell(Text('FileType.any')),
                        DataCell(Text('否')),
                        DataCell(Text('文件类型过滤器，桌面端按扩展名过滤')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('allowMultiple')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否允许多选')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('allowedExtensions')),
                        DataCell(Text('List<String>?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义扩展名，仅 type=FileType.custom 时生效')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onFilesChanged')),
                        DataCell(
                          Text('ValueChanged<List<EasyFileDraggedItem>>?'),
                        ),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文件变更回调，返回规范化的文件信息')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showFileList')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否展示内置文件列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('spacing')),
                        DataCell(Text('double')),
                        DataCell(Text('16.0')),
                        DataCell(Text('否')),
                        DataCell(Text('拖拽区域与文件列表的垂直间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fileItemSpacing')),
                        DataCell(Text('double')),
                        DataCell(Text('8.0')),
                        DataCell(Text('否')),
                        DataCell(Text('文件列表项之间的间距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('controller')),
                        DataCell(Text('EasyFileDragAreaController?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('外部控制删除或清空文件')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                p('EasyFileDragAreaController 参数说明：'),
                DataTable(
                  columns: const [
                    DataColumn(label: Text('方法')),
                    DataColumn(label: Text('签名')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('removeAt')),
                        DataCell(Text('void removeAt(int index)')),
                        DataCell(Text('根据索引删除指定文件')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('removeItem')),
                        DataCell(
                          Text('void removeItem(EasyFileDraggedItem item)'),
                        ),
                        DataCell(Text('根据文件实例删除，常用于自定义列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('clear')),
                        DataCell(Text('void clear()')),
                        DataCell(Text('清空所有已选文件')),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
// 详细参数可参考下方表格
```
''',
        ),
      ],
    );
  }
}

class _EasyFileDragAreaControllerExample extends StatefulWidget {
  const _EasyFileDragAreaControllerExample();

  @override
  State<_EasyFileDragAreaControllerExample> createState() =>
      _EasyFileDragAreaControllerExampleState();
}

class _EasyFileDragAreaControllerExampleState
    extends State<_EasyFileDragAreaControllerExample> {
  final EasyFileDragAreaController _controller = EasyFileDragAreaController();
  List<EasyFileDraggedItem> _files = const [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EasyButton2(
              size: EasyButtonSize.small,
              onPressed: _files.isEmpty ? null : () => _controller.removeAt(0),
              child: const Text('删除第一个'),
            ),
            EasyButton2(
              size: EasyButtonSize.small,
              onPressed:
                  _files.isEmpty
                      ? null
                      : () => _controller.removeAt(_files.length - 1),
              child: const Text('删除最后一个'),
            ),
            EasyButton2(
              size: EasyButtonSize.small,
              type: EasyButtonType.primary,
              onPressed: _files.isEmpty ? null : _controller.clear,
              child: const Text('清空文件'),
            ),
          ],
        ),
        Text('当前已选择 ${_files.length} 个文件'),
        EasyFileDragArea(
          controller: _controller,
          showFileList: false,
          allowMultiple: true,
          onFilesChanged: (items) => setState(() => _files = items),
        ),
      ],
    );
  }
}
