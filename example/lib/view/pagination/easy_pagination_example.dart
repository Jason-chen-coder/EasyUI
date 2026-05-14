import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/body_widget.dart';
import '../../widgets/paragraph_helper.dart';
import '../../widgets/widget_highlight.dart';

class EasyPaginationExample extends StatelessWidget {
  const EasyPaginationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyPaginationDataProvider 分页组件示例'),
        h2('基本用法'),
        WidgetHighlight(
          builder: (_) {
            return _EasyPaginationBaseExample();
          },
          codeSnippet: '''
```dart
class _EasyPaginationBaseExample extends StatefulWidget {
  const _EasyPaginationBaseExample({super.key});

  @override
  State<_EasyPaginationBaseExample> createState() =>
      _EasyPaginationBaseExampleState();
}

class _EasyPaginationBaseExampleState
    extends State<_EasyPaginationBaseExample> {
  final _dataProvider = _MockPaginationDataProvider();

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListenableBuilder(
        listenable: _dataProvider,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child:
                    _dataProvider.loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.separated(
                          itemBuilder: (context, index) {
                            final data = _dataProvider.data[index];
                            return ListTile(title: Text(data));
                          },
                          itemCount: _dataProvider.data.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: EasyPagination(
                  pageSize: _dataProvider.pageSize,
                  total: _dataProvider.total,
                  currentPage: _dataProvider.pageNum,
                  loadingData: _dataProvider.loading,
                  onPageChanged: (pageNum) {
                    _dataProvider.setPageNumAndLoadData(pageNum);
                  },
                  onPageSizeChanged: (pageSize) {
                    _dataProvider.setPageSizeAndLoadData(pageSize);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```
''',
        ),
        h2('结合Provider使用'),
        WidgetHighlight(
          builder: (_) {
            return _EasyPaginationProviderExample();
          },
          codeSnippet: '''
```dart
class _EasyPaginationProviderExample extends StatefulWidget {
  const _EasyPaginationProviderExample({super.key});

  @override
  State<_EasyPaginationProviderExample> createState() =>
      _EasyPaginationProviderExampleState();
}

class _EasyPaginationProviderExampleState
    extends State<_EasyPaginationProviderExample> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ChangeNotifierProvider(
        create: (context) => _MockPaginationDataProvider(),
        builder: (context, _) {
          final _MockPaginationDataProvider dataProvider = context.watch();
          return Column(
            children: [
              Expanded(
                child:
                    dataProvider.loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.separated(
                          itemBuilder: (context, index) {
                            final data = dataProvider.data[index];
                            return ListTile(title: Text(data));
                          },
                          itemCount: dataProvider.data.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: EasyPagination(
                  pageSize: dataProvider.pageSize,
                  total: dataProvider.total,
                  currentPage: dataProvider.pageNum,
                  loadingData: dataProvider.loading,
                  onPageChanged: (pageNum) {
                    dataProvider.setPageNumAndLoadData(pageNum);
                  },
                  onPageSizeChanged: (pageSize) {
                    dataProvider.setPageSizeAndLoadData(pageSize);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
```
''',
        ),
        const SizedBox(height: 16),
        p('EasyPagination 参数说明：'),
        DataTable(
          dataRowMaxHeight: 100,
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
                DataCell(Text('pageSize')),
                DataCell(Text('int')),
                DataCell(Text('')),
                DataCell(Text('是')),
                DataCell(Text('每页大小')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('total')),
                DataCell(Text('int')),
                DataCell(Text('')),
                DataCell(Text('是')),
                DataCell(Text('总条数')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('currentPage')),
                DataCell(Text('int')),
                DataCell(Text('')),
                DataCell(Text('是')),
                DataCell(Text('当前页码')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('onPageChanged')),
                DataCell(Text('Function(int)')),
                DataCell(Text('')),
                DataCell(Text('是')),
                DataCell(Text('页码改变回调')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('totalTextStyle')),
                DataCell(Text('TextStyle')),
                DataCell(
                  Text(
                    'const TextStyle(color: Color(0xFF666666), fontSize: 12)',
                  ),
                ),
                DataCell(Text('否')),
                DataCell(Text('总数文本样式')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('pageSizeList')),
                DataCell(Text('List<int>')),
                DataCell(Text('const [10, 20, 50, 100]')),
                DataCell(Text('否')),
                DataCell(Text('每页大小列表')),
              ],
            ),
            DataRow(
              cells: [
                DataCell(Text('onPageSizeChanged')),
                DataCell(Text('ValueChanged<int>?')),
                DataCell(Text('null')),
                DataCell(Text('否')),
                DataCell(Text('每页大小改变回调')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _MockPaginationDataProvider extends EasyPaginationDataProvider<String> {
  _MockPaginationDataProvider() : super(EasyPaginationState()) {
    loadData();
  }

  @override
  Future<(List<String>, int)> dataFetcher(int pageNum, int pageSize) async {
    await Future.delayed(Duration(milliseconds: 300)); // 模拟网络请求
    final total = 1000;
    final data = List.generate(
      pageSize,
      (index) => 'item ${(pageNum - 1) * pageSize + index}',
    );
    return (data, total);
  }
}

class _EasyPaginationBaseExample extends StatefulWidget {
  const _EasyPaginationBaseExample();

  @override
  State<_EasyPaginationBaseExample> createState() =>
      _EasyPaginationBaseExampleState();
}

class _EasyPaginationBaseExampleState
    extends State<_EasyPaginationBaseExample> {
  final _dataProvider = _MockPaginationDataProvider();

  @override
  void dispose() {
    _dataProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ListenableBuilder(
        listenable: _dataProvider,
        builder: (context, _) {
          return Column(
            children: [
              Expanded(
                child:
                    _dataProvider.loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.separated(
                          itemBuilder: (context, index) {
                            final data = _dataProvider.data[index];
                            return ListTile(title: Text(data));
                          },
                          itemCount: _dataProvider.data.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: EasyPagination(
                  pageSize: _dataProvider.pageSize,
                  total: _dataProvider.total,
                  currentPage: _dataProvider.pageNum,
                  loadingData: _dataProvider.loading,
                  onPageChanged: (pageNum) {
                    _dataProvider.setPageNumAndLoadData(pageNum);
                  },
                  onPageSizeChanged: (pageSize) {
                    _dataProvider.setPageSizeAndLoadData(pageSize);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EasyPaginationProviderExample extends StatefulWidget {
  const _EasyPaginationProviderExample();

  @override
  State<_EasyPaginationProviderExample> createState() =>
      _EasyPaginationProviderExampleState();
}

class _EasyPaginationProviderExampleState
    extends State<_EasyPaginationProviderExample> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ChangeNotifierProvider(
        create: (context) => _MockPaginationDataProvider(),
        builder: (context, _) {
          final _MockPaginationDataProvider dataProvider = context.watch();
          return Column(
            children: [
              Expanded(
                child:
                    dataProvider.loading
                        ? Center(child: CircularProgressIndicator())
                        : ListView.separated(
                          itemBuilder: (context, index) {
                            final data = dataProvider.data[index];
                            return ListTile(title: Text(data));
                          },
                          itemCount: dataProvider.data.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: EasyPagination(
                  pageSize: dataProvider.pageSize,
                  total: dataProvider.total,
                  currentPage: dataProvider.pageNum,
                  loadingData: dataProvider.loading,
                  onPageChanged: (pageNum) {
                    dataProvider.setPageNumAndLoadData(pageNum);
                  },
                  onPageSizeChanged: (pageSize) {
                    dataProvider.setPageSizeAndLoadData(pageSize);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
