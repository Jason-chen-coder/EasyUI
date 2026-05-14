import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class DataTableDemo extends StatelessWidget {
  const DataTableDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('DataTable2 单元格组件示例'),
        h2('表头组件'),
        p('展示不同类型的表头组件'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '文本表头:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextHeader(text: '用户名'),
              ],
            );
          },
          codeSnippet: '''
```dart
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '文本表头:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextHeader(text: '用户名'),
              ],
            );
```
''',
        ),
        h2('文本单元格'),
        p('展示文本单元格的不同样式和交互'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '普通文本:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(text: '这是一段普通文本'),
                const SizedBox(height: 16),
                const Text(
                  '空文本处理:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(text: ''),
                const SizedBox(height: 16),
                const Text(
                  '自定义样式:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(
                  text: '红色文本',
                  textStyle: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  '可点击文本:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(
                  text: '点击我',
                  onTapText: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('单元格被点击')));
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '长文本截断:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 200,
                  child: EasyDataTableTextCell(
                    text: '这是一段非常非常非常非常非常非常长的文本',
                    maxLines: 1,
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
                const Text(
                  '普通文本:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(text: '这是一段普通文本'),
                const SizedBox(height: 16),
                const Text(
                  '空文本处理:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(text: ''),
                const SizedBox(height: 16),
                const Text(
                  '自定义样式:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(
                  text: '红色文本',
                  textStyle: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                const Text(
                  '可点击文本:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableTextCell(
                  text: '点击我',
                  onTapText: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('单元格被点击')));
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  '长文本截断:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 200,
                  child: EasyDataTableTextCell(
                    text: '这是一段非常非常非常非常非常非常长的文本',
                    maxLines: 1,
                  ),
                ),
              ],
            );
```
''',
        ),
        h2('复选框单元格'),
        p('展示复选框单元格的不同状态'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '选中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableCheckboxCell(value: true, onChanged: (value) {}),
                const SizedBox(height: 16),
                const Text(
                  '未选中状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableCheckboxCell(value: false, onChanged: (value) {}),
                const SizedBox(height: 16),
                const Text(
                  '禁用状态:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableCheckboxCell(value: true, onChanged: null),
              ],
            );
          },
          codeSnippet: '''
        ```dart
            Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '选中状态:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EasyDataTableCheckboxCell(value: true, onChanged: (value) {}),
                        const SizedBox(height: 16),
                        const Text(
                          '未选中状态:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EasyDataTableCheckboxCell(value: false, onChanged: (value) {}),
                        const SizedBox(height: 16),
                        const Text(
                          '禁用状态:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EasyDataTableCheckboxCell(value: true, onChanged: null),
                      ],
                    );
        ```
        ''',
        ),
        h2('操作按钮单元格'),
        p('展示包含操作按钮的单元格'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '单个操作按钮:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableOperationsCell(
                  operations: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  '多个操作按钮:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                EasyDataTableOperationsCell(
                  operations: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {},
                    ),
                    IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                  ],
                ),
              ],
            );
          },
          codeSnippet: '''
        ```dart
            Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '单个操作按钮:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EasyDataTableOperationsCell(
                          operations: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '多个操作按钮:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        EasyDataTableOperationsCell(
                          operations: [
                            IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {},
                            ),
                            IconButton(icon: const Icon(Icons.share), onPressed: () {}),
                          ],
                        ),
                      ],
                    );
        ```
        ''',
        ),
        h2('组合使用示例'),
        p('展示如何在表格中组合使用这些单元格组件'),
        WidgetHighlight(
          builder: (_) {
            return SizedBox(height: 600, child: _DataTableView());
          },
          codeSnippet: '''
```dart
class _DataTable2View extends StatefulWidget {
  const _DataTable2View({super.key});

  @override
  State<_DataTable2View> createState() => _DataTable2ViewState();
}

class _DataTable2ViewState extends State<_DataTable2View> {
  bool _loading = false;
  int _page = 1;
  int _pageSize = 100;
  final int _total = 1000;
  List<List<String>> _data = [];

  bool _hoverHighlight = false;
  bool _frozenLastColumn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    _data = List.generate(_pageSize, (row) {
      return List.generate(7, (column) {
        return 'column\${(_page - 1) * 7 + column} row\${(_page - 1) * _pageSize + row}';
      });
    });
    _loading = false;
    setState(() {});
  }

  void _changePageSize(int pageSize) {
    _page = 1;
    _pageSize = pageSize;
    _loadData();
  }

  void _changePage(int page) {
    _page = page;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final columnNames = ['序号', '邮箱', '用户名', '姓名', '状态', '创建人', '操作'];
    final columnWidths = [80.0, 185.0, 140.0, 140.0, 96.0, 140.0, 225.0];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text('选中行高亮'),
                  selected: _hoverHighlight,
                  onSelected: (v) {
                    setState(() {
                      _hoverHighlight = v;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('固定最后一列'),
                  selected: _frozenLastColumn,
                  onSelected: (v) {
                    setState(() {
                      _frozenLastColumn = v;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: EasyDataTable2(
                showHoverEffect: _hoverHighlight,
                loadingData: _loading,
                rowCount: _data.length,
                headerBuilder: (context, column) {
                  return EasyDataTableTextHeader2(text: columnNames[column]);
                },
                cellBuilder: (context, vicinity) {
                  final TableVicinity(:row, :column) = vicinity;
                  return EasyDataTableTextCell2(text: _data[row][column]);
                },
                operationsWidget: const SizedBox(),
                frozenLeftColumnCount: 1,
                frozenLastColumn: _frozenLastColumn,
                columnConfigs: List.generate(columnNames.length, (index) {
                  return EasyDataTable2ColumnConfig(
                    visibilityOptionName: columnNames[index],
                    width: columnWidths[index],
                  );
                }),
                emptyWidget: EasyEmptyView(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: EasyPagination(
                pageSize: _pageSize,
                total: _total,
                currentPage: _page,
                pageSizeList: [50, 100],
                onPageSizeChanged: _changePageSize,
                onPageChanged: _changePage,
                loadingData: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
''',
        ),
        h2('DataTable参数说明'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                p('EasyDataTable 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(
                      label: Text('类型'),
                      columnWidth: FixedColumnWidth(120),
                    ),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(120),
                    ),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('loading')),
                        DataCell(Text('bool')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('是否正在加载数据')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('headerHeight')),
                        DataCell(Text('double')),
                        DataCell(Text('48.0')),
                        DataCell(Text('否')),
                        DataCell(Text('表头高度')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('headerBuilder')),
                        DataCell(
                          Text(
                            'Widget Function(BuildContext context, int column)',
                          ),
                        ),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('表头构建函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('rowCount')),
                        DataCell(Text('int')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('行数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('rowHeight')),
                        DataCell(Text('double')),
                        DataCell(Text('48.0')),
                        DataCell(Text('否')),
                        DataCell(Text('行高')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('columnCount')),
                        DataCell(Text('int')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('列数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('columnConfigs')),
                        DataCell(Text('List<EasyDataTable2ColumnConfig>')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('列配置列表')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('cellBuilder')),
                        DataCell(
                          Text(
                            'Widget Function(BuildContext context, TableVicinity vicinity)',
                          ),
                        ),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('单元格构建函数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('initialInvisibleColumnIndices')),
                        DataCell(Text('List<int>')),
                        DataCell(Text('[]')),
                        DataCell(Text('否')),
                        DataCell(Text('初始不可见列索引')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('frozenLeftColumnCount')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('冻结表单左边前几列')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('frozenLastColumn')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('冻结表单最后一列')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('searchWidget')),
                        DataCell(Text('Widget')),
                        DataCell(Text('-')),
                        DataCell(Text('否')),
                        DataCell(Text('搜索组件占位')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('operationsWidget')),
                        DataCell(Text('Widget')),
                        DataCell(Text('-')),
                        DataCell(Text('否')),
                        DataCell(Text('操作按钮占位')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('emptyView')),
                        DataCell(Text('Widget')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('表数据为空时的占位视图')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('calculateDelegate')),
                        DataCell(Text('EasyDataTableCalculateDelegate?')),
                        DataCell(Text('-')),
                        DataCell(Text('否')),
                        DataCell(
                          Text(
                            '计算委托，目前用于行高计算.值为null时行高直接使用[rowHeight]，不会再经过计算',
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('showHoverEffect')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(Text('是否让鼠标指针所在行高亮')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyDataTableColumnConfig 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(140),
                    ),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('visibilityOptionName')),
                        DataCell(Text('String?')),
                        DataCell(Text('null')),
                        DataCell(Text('是')),
                        DataCell(Text('筛选列菜单选项名称，值为null时不出现在菜单中')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('width')),
                        DataCell(Text('double')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('列宽')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alwaysVisible')),
                        DataCell(Text('bool')),
                        DataCell(Text('false')),
                        DataCell(Text('否')),
                        DataCell(
                          Text('该列是否总是可见，总是可见的话无法被筛选，在筛选列菜单中对应选项无法取消勾选'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyDataTableTextHeader 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(140),
                    ),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('text')),
                        DataCell(Text('String')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('显示的文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(Text('EdgeInsets.only(left: 16, right: 16)')),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('AlignmentGeometry')),
                        DataCell(Text('AlignmentDirectional.centerStart')),
                        DataCell(Text('否')),
                        DataCell(Text('对齐方式')),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                p('EasyDataTableTextCell 参数说明：'),
                DataTable(
                  dataRowMaxHeight: 100,
                  columns: const [
                    DataColumn(label: Text('参数名')),
                    DataColumn(label: Text('类型')),
                    DataColumn(
                      label: Text('默认值'),
                      columnWidth: FixedColumnWidth(140),
                    ),
                    DataColumn(label: Text('是否必填')),
                    DataColumn(label: Text('说明')),
                  ],
                  rows: const [
                    DataRow(
                      cells: [
                        DataCell(Text('text')),
                        DataCell(Text('String')),
                        DataCell(Text('-')),
                        DataCell(Text('是')),
                        DataCell(Text('显示的文本')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('padding')),
                        DataCell(Text('EdgeInsets')),
                        DataCell(
                          Text('const EdgeInsets.symmetric(horizontal: 16)'),
                        ),
                        DataCell(Text('否')),
                        DataCell(Text('内边距')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textStyle')),
                        DataCell(Text('TextStyle?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本样式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('alignment')),
                        DataCell(Text('AlignmentGeometry')),
                        DataCell(Text('AlignmentDirectional.centerStart')),
                        DataCell(Text('否')),
                        DataCell(Text('对齐方式')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('maxLines')),
                        DataCell(Text('int')),
                        DataCell(Text('1')),
                        DataCell(Text('否')),
                        DataCell(Text('最大行数')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onTap')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('单元格点击回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('onTapText')),
                        DataCell(Text('VoidCallback?')),
                        DataCell(Text('null')),
                        DataCell(Text('否')),
                        DataCell(Text('文本点击回调')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('textFormater')),
                        DataCell(Text('String Function(String text)?')),
                        DataCell(Text('-')),
                        DataCell(Text('否')),
                        DataCell(Text('文本格式化函数')),
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

class _DataTableView extends StatefulWidget {
  const _DataTableView();

  @override
  State<_DataTableView> createState() => _DataTableViewState();
}

class _DataTableViewState extends State<_DataTableView> {
  bool _loading = false;
  int _page = 1;
  int _pageSize = 100;
  final int _total = 1000;
  List<List<String>> _data = [];

  bool _hoverHighlight = false;
  bool _frozenLastColumn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });
    await Future.delayed(Duration(milliseconds: 300));
    _data = List.generate(_pageSize, (row) {
      return List.generate(7, (column) {
        return 'column${(_page - 1) * 7 + column} row${(_page - 1) * _pageSize + row}';
      });
    });
    _loading = false;
    setState(() {});
  }

  void _changePageSize(int pageSize) {
    _page = 1;
    _pageSize = pageSize;
    _loadData();
  }

  void _changePage(int page) {
    _page = page;
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final columnNames = ['序号', '邮箱', '用户名', '姓名', '状态', '创建人', '操作'];
    final columnWidths = [80.0, 185.0, 140.0, 140.0, 96.0, 140.0, 225.0];

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: Text('鼠标所在行高亮'),
                  selected: _hoverHighlight,
                  onSelected: (v) {
                    setState(() {
                      _hoverHighlight = v;
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('固定最后一列'),
                  selected: _frozenLastColumn,
                  onSelected: (v) {
                    setState(() {
                      _frozenLastColumn = v;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: EasyDataTable(
                showHoverEffect: _hoverHighlight,
                loadingData: _loading,
                rowCount: _data.length,
                headerBuilder: (context, column) {
                  return EasyDataTableTextHeader(text: columnNames[column]);
                },
                cellBuilder: (context, vicinity) {
                  final TableVicinity(:row, :column) = vicinity;
                  return EasyDataTableTextCell(text: _data[row][column]);
                },
                operationsWidget: const SizedBox(),
                frozenLeftColumnCount: 1,
                frozenLastColumn: _frozenLastColumn,
                columnConfigs: List.generate(columnNames.length, (index) {
                  return EasyDataTableColumnConfig(
                    visibilityOptionName: columnNames[index],
                    width: columnWidths[index],
                  );
                }),
                emptyWidget: EasyEmptyView(),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: EasyPagination(
                pageSize: _pageSize,
                total: _total,
                currentPage: _page,
                pageSizeList: [50, 100],
                onPageSizeChanged: _changePageSize,
                onPageChanged: _changePage,
                loadingData: _loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
