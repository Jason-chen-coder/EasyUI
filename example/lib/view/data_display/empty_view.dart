import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class EmptyViewDemo extends StatelessWidget {
  const EmptyViewDemo({super.key});

  Future<void> _mockReload() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EmptyView 空状态组件示例'),
        h2('基本用法'),
        p('展示默认的空状态视图'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(height: 300, child: EasyEmptyView());
          },
          codeSnippet: '''
```dart
SizedBox(height: 300, child: EasyEmptyView());
```
''',
        ),
        h2('自定义文本'),
        p('展示如何自定义空状态的标题和描述文本'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '没有找到数据',
                text: '当前筛选条件下没有找到符合要求的数据\n请尝试调整筛选条件或创建新数据',
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '没有找到数据',
                text: '当前筛选条件下没有找到符合要求的数据\n请尝试调整筛选条件或创建新数据',
              ),
            );
```
''',
        ),
        h2('自定义图片'),
        p('展示如何使用自定义图片作为空状态图示'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '网络异常',
                text: '无法连接到服务器，请检查您的网络设置',
                image: 'assets/images/custom_empty.png',
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '网络异常',
                text: '无法连接到服务器，请检查您的网络设置',
                image: 'assets/images/custom_empty.png',
              ),
            );
```
''',
        ),
        h2('带重试按钮'),
        p('展示如何添加重试按钮并处理重试逻辑'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '加载失败',
                text: '数据加载失败，请点击重试按钮重新加载',
                reload: _mockReload,
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '加载失败',
                text: '数据加载失败，请点击重试按钮重新加载',
                reload: _mockReload,
              ),
            );
```
''',
        ),
        h2('完全自定义'),
        p('展示如何完全自定义空状态的所有元素，包括按钮样式、文字颜色和图标颜色'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '自定义空状态',
                text: '这是一个完全自定义的空状态视图\n包含自定义图片、文本和操作按钮',
                image: 'assets/images/custom_empty.png',
                reload: _mockReload,
                reloadButtonTextColor: Colors.yellow,
                reloadButtonIconColor: Colors.yellow,
                reloadButtonStyle: FilledButton.styleFrom(
                  backgroundColor: Color(0xff333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 300,
              child: EasyEmptyView(
                title: '自定义空状态',
                text: '这是一个完全自定义的空状态视图\n包含自定义图片、文本和操作按钮',
                image: 'assets/images/custom_empty.png',
                reload: _mockReload,
                reloadButtonTextColor: Colors.yellow,
                reloadButtonIconColor: Colors.yellow,
                reloadButtonStyle: FilledButton.styleFrom(
                  backgroundColor: Color(0xff333333),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
              ),
            );
```
''',
        ),
        h2('敬请期待'),
        p('展示敬请期待功能'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(height: 350, child: EasyEmptyView.comingSoon());
          },
          codeSnippet: '''
```dart
SizedBox(
              height: 350,
              child: EasyEmptyView.comingSoon(),
            )
''',
        ),
        h2('在表格中使用'),
        p('展示如何在表格中使用空状态组件'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 400,
              child: EasyDataTable(
                headerBuilder: (context, column) {
                  switch (column) {
                    case 0:
                      return const EasyDataTableTextHeader(text: '姓名');
                    case 1:
                      return const EasyDataTableTextHeader(text: '年龄');
                  }
                  return const SizedBox();
                },
                emptyWidget: EasyEmptyView(
                  title: '没有数据',
                  text: '当前没有数据，请点击刷新按钮获取数据',
                ),
                calculateDelegate:
                    const EasyDataTableCalculateDelegate.normal(),
                loadingData: false,
                rowCount: 0,
                columnConfigs: [
                  EasyDataTableColumnConfig(
                    visibilityOptionName: '',
                    width: 100,
                  ),
                  EasyDataTableColumnConfig(
                    visibilityOptionName: '',
                    width: 100,
                  ),
                ],
                cellBuilder: (BuildContext context, TableVicinity vicinity) {
                  return const SizedBox();
                },
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 400,
              child: EasyDataTable(
                headerList: [
                  EasyDataTableHeaderData(
                    columnName: '姓名',
                    header: const EasyDataTableTextHeader(text: '姓名'),
                  ),
                  EasyDataTableHeaderData(
                    columnName: '年龄',
                    header: const EasyDataTableTextHeader(text: '年龄'),
                  ),
                ],
                rows: [],
                emptyWidget: EasyEmptyView(
                  title: '没有数据',
                  text: '当前没有数据，请点击刷新按钮获取数据',
                ),
              ),
            );
```
''',
        ),
        h2('在列表中使用'),
        p('展示如何在列表中使用空状态组件'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(
              height: 300,
              child: ListView(
                children: [EasyEmptyView(title: '空列表', text: '当前列表为空，请添加新的项目')],
              ),
            );
          },
          codeSnippet: '''
```dart
  SizedBox(
              height: 300,
              child: ListView(
                children: [EasyEmptyView(title: '空列表', text: '当前列表为空，请添加新的项目')],
              ),
            );
```
''',
        ),
        h2('EmptyView参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyEmptyView 参数说明：'),
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
                        DataCell(Text('String?')),
                        DataCell(Text('"暂无数据"')),
                        DataCell(Text('否')),
                        DataCell(Text('空状态标题，为空时不显示')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('text')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('空状态描述文本，为空时不显示')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('image')),
                        DataCell(Text('String?')),
                        DataCell(Text('默认空状态图片')),
                        DataCell(Text('否')),
                        DataCell(Text('自定义空状态图片路径，支持网络和本地资源')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reload')),
                        DataCell(Text('Future<void> Function()?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('重试按钮点击回调，为空时不显示重试按钮')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reloadButtonTextColor')),
                        DataCell(Text('Color?')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('重试按钮文字颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reloadButtonIconColor')),
                        DataCell(Text('Color?')),
                        DataCell(Text('Colors.white')),
                        DataCell(Text('否')),
                        DataCell(Text('重试按钮图标颜色')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('reloadButtonStyle')),
                        DataCell(Text('ButtonStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('重试按钮样式，为空时使用默认样式')),
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
