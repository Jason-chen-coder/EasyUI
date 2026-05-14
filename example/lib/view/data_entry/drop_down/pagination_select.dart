import 'dart:async';
import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

import '../../../widgets/body_widget.dart';
import '../../../widgets/paragraph_helper.dart';
import '../../../widgets/widget_highlight.dart';

List<EasyListPopMenuOption<String>> _fetchFruit(searchKey) {
  final items = [
    EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
    EasyListPopMenuOption.simple(value: 'banana', title: '香蕉'),
    EasyListPopMenuOption.simple(value: 'cherry', title: '樱桃'),
    EasyListPopMenuOption.simple(value: 'orange', title: '橙子'),
    EasyListPopMenuOption.simple(value: 'grape', title: '葡萄'),
    EasyListPopMenuOption.simple(value: 'watermelon', title: '西瓜'),
    EasyListPopMenuOption.simple(value: 'mango', title: '芒果'),
    EasyListPopMenuOption.simple(value: 'strawberry', title: '草莓'),
    EasyListPopMenuOption.simple(value: 'peach', title: '桃子'),
    EasyListPopMenuOption.simple(value: 'pineapple', title: '菠萝'),
    EasyListPopMenuOption.simple(value: 'kiwi', title: '猕猴桃'),
    EasyListPopMenuOption.simple(value: 'lemon', title: '柠檬'),
  ];
  return items
      .where(
        (option) =>
            searchKey == null ||
            searchKey.isEmpty ||
            option.title.contains(searchKey),
      )
      .toList();
}

Future<List<EasyListPopMenuOption<int>>> _fetchPaginationData(
  int pageNum,
  int pageSize,
  String? searchKey,
) async {
  await Future.delayed(const Duration(milliseconds: 800));

  const totalCount = 100;
  final List<EasyListPopMenuOption<int>> allOptions = List.generate(
    totalCount,
    (index) => EasyListPopMenuOption<int>.simple(
      value: index,
      title: '分页选项 ${index + 1}',
    ),
  );

  List<EasyListPopMenuOption<int>> filteredOptions = allOptions;
  if (searchKey != null && searchKey.isNotEmpty) {
    filteredOptions =
        allOptions.where((option) => option.title.contains(searchKey)).toList();
  }

  final startIndex = (pageNum - 1) * pageSize;
  final endIndex = (startIndex + pageSize).clamp(0, filteredOptions.length);

  if (startIndex >= filteredOptions.length || startIndex < 0) {
    return [];
  }

  final List<EasyListPopMenuOption<int>> pageData = filteredOptions.sublist(
    startIndex,
    endIndex,
  );
  return pageData;
}

extension on BuildContext {
  void showMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

class PaginationSelectDemo extends StatelessWidget {
  const PaginationSelectDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Body.multi(
      children: [
        h1('EasyPaginationSelect'),
        // 基本介绍
        h2('组件概述'),
        p(
          'EasyPaginationSelect 支持非分页和分页两种数据加载方式、单选和多选，\n支持搜索过滤功能，适用于数据量较大或需要动态加载选项的场景。',
        ),

        h2('分页数据'),
        p('通过`pagedFetcher`属性来定义分页数据的获取方式，支持同步和异步。'),
        p('* 通过`controller`中`pagedFetcher`的 `searchKey` 参数可以实现搜索过滤功能。'),
        p('* 如需启用过滤功能，还需要将`filterable`属性设置为`true`。'),
        tip(
          '可以通过设置 `controller` 的 `debounceDuration` 属性来控制搜索输入的防抖时间，避免频繁请求数据。',
        ),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text('单选：'),
                EasyPaginationSelect<int>.single(
                  clearable: true,
                  filterable: true,
                  controller: EasyPaginationSingleSelectController<int>(
                    pagedFetcher: _fetchPaginationData,
                  ),
                  placeholder: '请选择',
                  onChanged: (value) {
                    context.showMessage('选中了id: $value');
                  },
                ),
                Text('多选：'),
                EasyPaginationSelect<int>.multiple(
                  clearable: true,
                  filterable: true,
                  controller: EasyPaginationMultipleSelectController<int>(
                    pagedFetcher: _fetchPaginationData,
                  ),
                  placeholder: '请选择',
                  onChanged: (value) {
                    context.showMessage('选中了ids: $value');
                  },
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
/// 数据源
Future<List<EasyListPopMenuOption<int>>> _fetchPaginationData(
  int pageNum,
  int pageSize,
  String? searchKey,
) async {
  await Future.delayed(const Duration(milliseconds: 800));

  const totalCount = 100;
  final List<EasyListPopMenuOption<int>> allOptions = List.generate(
    totalCount,
    (index) => EasyListPopMenuOption<int>.simple(
      value: index,
      title: '分页选项 \${index + 1}',
    ),
  );

  List<EasyListPopMenuOption<int>> filteredOptions = allOptions;
  if (searchKey != null && searchKey.isNotEmpty) {
    filteredOptions =
        allOptions.where((option) => option.title.contains(searchKey)).toList();
  }

  final startIndex = (pageNum - 1) * pageSize;
  final endIndex = (startIndex + pageSize).clamp(0, filteredOptions.length);

  if (startIndex >= filteredOptions.length || startIndex < 0) {
    return [];
  }

  final List<EasyListPopMenuOption<int>> pageData = filteredOptions.sublist(
    startIndex,
    endIndex,
  );
  return pageData;
}

/// 单选分页下拉选择
EasyPaginationSelect<int>.single(
  clearable: true,
  filterable: true,
  controller: EasyPaginationSingleSelectController<int>(
    pagedFetcher: _fetchPaginationData,
  ),
  placeholder: '请选择',
  onChanged: (value) {
    //TODO 处理选中值
  },
)

/// 多选分页下拉选择
EasyPaginationSelect<int>.multiple(
  clearable: true,
  filterable: true,
  controller: EasyPaginationMultipleSelectController<int>(
    pagedFetcher: _fetchPaginationData,
  ),
  placeholder: '请选择',
  onChanged: (value) {
    //TODO 处理选中值
  },
)
```
''',
        ),
        h2('非分页数据'),
        p('通过`fetcher`属性来定义非分页数据的获取方式，支持同步和异步。'),
        p('* 通过`controller`中`fetcher`的 `searchKey` 参数可以实现搜索过滤功能。'),
        p('* 如需启用过滤功能，还需要将`filterable`属性设置为`true`。'),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text('单选：'),
                EasyPaginationSelect<String>.single(
                  clearable: true,
                  filterable: true,
                  controller: EasyPaginationSingleSelectController<String>(
                    fetcher: _fetchFruit,
                  ),
                  placeholder: '请选择水果',
                  onChanged: (value) {
                    context.showMessage('选中了: $value');
                  },
                ),
                Text('多选：'),
                EasyPaginationSelect<String>.multiple(
                  clearable: true,
                  filterable: true,
                  controller: EasyPaginationMultipleSelectController<String>(
                    fetcher: _fetchFruit,
                  ),
                  placeholder: '请选择水果',
                  onChanged: (value) {
                    context.showMessage('选中了: $value');
                  },
                ),
              ],
            );
          },
          codeSnippet: '''
```dart
/// 数据源
List<EasyListPopMenuOption<String>> _fetchFruit(searchKey) {
  final items = [
    EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
    EasyListPopMenuOption.simple(value: 'banana', title: '香蕉'),
    EasyListPopMenuOption.simple(value: 'cherry', title: '樱桃'),
    EasyListPopMenuOption.simple(value: 'orange', title: '橙子'),
    EasyListPopMenuOption.simple(value: 'grape', title: '葡萄'),
    EasyListPopMenuOption.simple(value: 'watermelon', title: '西瓜'),
    EasyListPopMenuOption.simple(value: 'mango', title: '芒果'),
    EasyListPopMenuOption.simple(value: 'strawberry', title: '草莓'),
    EasyListPopMenuOption.simple(value: 'peach', title: '桃子'),
    EasyListPopMenuOption.simple(value: 'pineapple', title: '菠萝'),
    EasyListPopMenuOption.simple(value: 'kiwi', title: '猕猴桃'),
    EasyListPopMenuOption.simple(value: 'lemon', title: '柠檬'),
  ];
  return items
      .where(
        (option) =>
            searchKey == null ||
            searchKey.isEmpty ||
            option.title.contains(searchKey),
      )
      .toList();
}

/// 单选非分页下拉选择
EasyPaginationSelect<String>.single(
  clearable: true,
  filterable: true,
  controller: EasyPaginationSingleSelectController<String>(
    fetcher: _fetchFruit,
  ),
  placeholder: '请选择水果',
  onChanged: (value) {
    //TODO 处理选中值
  },
)

/// 多选非分页下拉选择
EasyPaginationSelect<String>.multiple(
  clearable: true,
  filterable: true,
  controller: EasyPaginationMultipleSelectController<String>(
    fetcher: _fetchFruit,
  ),
  placeholder: '请选择水果',
  onChanged: (value) {
    //TODO 处理选中值
  },
)
```
''',
        ),

        //外部控制的控制器
        h2('Controller'),
        h3('通过 Controller 控制选中项'),
        p(
          '通过`controller`的`setSelection/addSelection`和`setSelectedOption/addSelectedOption`等方法可以控制选中项。',
        ),
        tip(
          '如果想要设置初始值，请使用`initialValue`或`initialOption`。\n\n使用`setSelection/addSelection`方法时，组件会校验该值是否存在于当前选项列表中。如果列表未加载则会设置失败。使用`setSelectedOption/addSelectedOption`方法时，不会校验该值是否存在于当前选项列表中。\n\n一般情况`controller`无需手动销毁，可以通过设置 `autoDisposeController` 为 `false` 以手动管理 Controller 的生命周期。',
          type: TipType.warning,
        ),
        WidgetHighlight(
          builder:
              (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text('单选：'),
                  _SingleExtControllerDemo(),
                  Text('多选：'),
                  _MultipleExtControllerDemo(),
                ],
              ),
          codeSnippet: '''
```dart
/// 数据源
List<EasyListPopMenuOption<String>> _fetchFruit(searchKey) {
  final items = [
    EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
    EasyListPopMenuOption.simple(value: 'banana', title: '香蕉'),
    EasyListPopMenuOption.simple(value: 'cherry', title: '樱桃'),
    EasyListPopMenuOption.simple(value: 'orange', title: '橙子'),
    EasyListPopMenuOption.simple(value: 'grape', title: '葡萄'),
    EasyListPopMenuOption.simple(value: 'watermelon', title: '西瓜'),
    EasyListPopMenuOption.simple(value: 'mango', title: '芒果'),
    EasyListPopMenuOption.simple(value: 'strawberry', title: '草莓'),
    EasyListPopMenuOption.simple(value: 'peach', title: '桃子'),
    EasyListPopMenuOption.simple(value: 'pineapple', title: '菠萝'),
    EasyListPopMenuOption.simple(value: 'kiwi', title: '猕猴桃'),
    EasyListPopMenuOption.simple(value: 'lemon', title: '柠檬'),
  ];
  return items
      .where(
        (option) =>
            searchKey == null ||
            searchKey.isEmpty ||
            option.title.contains(searchKey),
      )
      .toList();
}

/// 单选
class _SingleExtControllerDemoState extends State<_SingleExtControllerDemo> {
  // 外部控制的控制器
  late EasyPaginationSingleSelectController<String> _externalController;

  @override
  void initState() {
    super.initState();
    // 初始化外部控制控制器
    _externalController = EasyPaginationSingleSelectController<String>(
      initialValue: null,
      fetcher: _fetchFruit,
    );
  }

  @override
  void dispose() {
    //! 默认情况下 EasyPaginationSingleSelectController 无需手动销毁
    //! 如果将 autoDisposeController 设置为 false
    //! 则需要在此处手动调用 dispose 方法释放资源
    _externalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyPaginationSelect<String>.single(
          controller: _externalController,
          autoDisposeController: false, // 手动管理生命周期
          placeholder: '请选择水果',
          width: 300,
          clearable: true,
          filterable: true,
          searchHintText: '搜索水果',
          onChanged: (value) {
            context.showMessage('选中了: \$value');
          },
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            EasyButton2(
              onPressed: () => _externalController.setSelection('apple'),
              child: const Text('选择苹果'),
            ),
            EasyButton2(
              onPressed: () {
                _externalController.setSelectedOption(
                  EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
                );
              },
              child: const Text('选择苹果（不校验）'),
            ),
            EasyButton2(
              type: EasyButtonType.defalut,
              onPressed: () => _externalController.clear(),
              child: const Text('清空选择'),
            ),
          ],
        ),

        ListenableBuilder(
          listenable: _externalController,
          builder: (context, _) {
            final selected = _externalController.selectedOption;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.neutralF8,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '当前选中: \${selected?.title ?? "未选择"}',
                style: TextStyle(fontSize: 14, color: theme.neutral33),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 多选

class _MultipleExtControllerDemo extends StatefulWidget {
  const _MultipleExtControllerDemo();

  @override
  State<_MultipleExtControllerDemo> createState() =>
      _MultipleExtControllerDemoState();
}

class _MultipleExtControllerDemoState
    extends State<_MultipleExtControllerDemo> {
  late EasyPaginationMultipleSelectController<String> _multiController;

  @override
  void initState() {
    super.initState();
    _multiController = EasyPaginationMultipleSelectController<String>(
      initialValues: null,
      fetcher: _fetchFruit,
    );
  }

  @override
  void dispose() {
    //! 如果将 autoDisposeController 设置为 false
    //! 则需要在此处手动调用 dispose 方法释放资源
    _multiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyPaginationSelect<String>.multiple(
          controller: _multiController,
          autoDisposeController: false,
          placeholder: '请选择水果',
          width: 500,
          clearable: true,
          filterable: true,
          showSelectAllItem: true,
          searchHintText: '搜索水果',
          onChanged: (values) {
            context.showMessage('选中了: \${values.join(", ")}');
          },
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            EasyButton2(
              onPressed: () => _multiController.addSelection('lemon'),
              child: const Text('添加柠檬'),
            ),
            EasyButton2(
              onPressed: () {
                _multiController.addSelectedOption(
                  EasyListPopMenuOption.simple(value: 'lemon', title: '柠檬'),
                );
              },
              child: const Text('添加柠檬（不校验）'),
            ),
            EasyButton2(
              onPressed: () => _multiController.removeSelection('lemon'),
              child: const Text('移除柠檬'),
            ),
            EasyButton2(
              onPressed: () => _multiController.selectAll(),
              child: const Text('全选'),
            ),
            EasyButton2(
              type: EasyButtonType.defalut,
              onPressed: () => _multiController.clear(),
              child: const Text('清空选择'),
            ),
          ],
        ),
        ListenableBuilder(
          listenable: _multiController,
          builder: (context, _) {
            final selected = _multiController.selectedOptions;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.neutralF8,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '当前已选择 \${selected.length} 项: \${selected.map((e) => e.title).join(", ")}',
                style: TextStyle(fontSize: 14, color: theme.neutral33),
              ),
            );
          },
        ),
      ],
    );
  }
}
```
''',
        ),

        /// 表单中使用
        h2('在表单中使用'),
        p(
          '可以通过使用`EasyPaginationSingleSelectFormField`和`EasyPaginationMultipleSelectFormField`在表单中快速使用分页下拉选择组件。',
        ),
        WidgetHighlight(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Text('单选：'),
                _SingleSelectFormDemo(),
                Text('多选：'),
                _MultipleSelectFormDemo(),
              ],
            );
          },
          codeSnippet: '''
```dart
/// 数据源
Future<List<EasyListPopMenuOption<int>>> _fetchPaginationData(
  int pageNum,
  int pageSize,
  String? searchKey,
) async {
  await Future.delayed(const Duration(milliseconds: 800));

  const totalCount = 100;
  final List<EasyListPopMenuOption<int>> allOptions = List.generate(
    totalCount,
    (index) => EasyListPopMenuOption<int>.simple(
      value: index,
      title: '分页选项 \${index + 1}',
    ),
  );

  List<EasyListPopMenuOption<int>> filteredOptions = allOptions;
  if (searchKey != null && searchKey.isNotEmpty) {
    filteredOptions =
        allOptions.where((option) => option.title.contains(searchKey)).toList();
  }

  final startIndex = (pageNum - 1) * pageSize;
  final endIndex = (startIndex + pageSize).clamp(0, filteredOptions.length);

  if (startIndex >= filteredOptions.length || startIndex < 0) {
    return [];
  }

  final List<EasyListPopMenuOption<int>> pageData = filteredOptions.sublist(
    startIndex,
    endIndex,
  );
  return pageData;
}
/// 单选
class _SingleSelectFormDemo extends StatefulWidget {
  @override
  State<_SingleSelectFormDemo> createState() => _SingleSelectFormDemoState();
}

class _SingleSelectFormDemoState extends State<_SingleSelectFormDemo> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          EasyPaginationSingleSelectFormField<int>(
            filterable: true,
            clearable: true,
            controller: EasyPaginationSingleSelectController<int>(
              pagedFetcher: _fetchPaginationData,
            ),
            placeholder: '请选择',
            onChanged: (value) {
              context.showMessage('选中了id: \$value');
            },
            validator: (value) => value == null ? '请选择一个选项' : null,
            onSaved: (newValue) {
              context.showMessage('已保存选择id: \$newValue');
            },
          ),
          EasyButton2(
            child: Text('表单验证'),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (_formKey.currentState?.validate() ?? false) {
                // 验证通过，输出表单内容
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('表单验证通过，可以保存'),
                    action: SnackBarAction(
                      label: '保存表单',
                      onPressed: () {
                        _formKey.currentState?.save();
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('表单验证失败')));
              }
            },
          ),
        ],
      ),
    );
  }
}

/// 多选
class _MultipleSelectFormDemo extends StatefulWidget {
  @override
  State<_MultipleSelectFormDemo> createState() =>
      _MultipleSelectFormDemoState();
}

class _MultipleSelectFormDemoState extends State<_MultipleSelectFormDemo> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          EasyPaginationMultipleSelectFormField<int>(
            filterable: true,
            clearable: true,
            controller: EasyPaginationMultipleSelectController<int>(
              pagedFetcher: _fetchPaginationData,
            ),
            placeholder: '请选择',
            onChanged: (value) {
              context.showMessage('选中了ids: \$value');
            },
            validator: (value) => value?.isEmpty == true ? '请至少选择一个选项' : null,
            onSaved: (newValue) {
              context.showMessage('已保存选择ids: \$newValue');
            },
          ),
          EasyButton2(
            child: Text('表单验证'),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (_formKey.currentState?.validate() ?? false) {
                // 验证通过，输出表单内容
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('表单验证通过，可以保存'),
                    action: SnackBarAction(
                      label: '保存表单',
                      onPressed: () {
                        _formKey.currentState?.save();
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('表单验证失败')));
              }
            },
          ),
        ],
      ),
    );
  }
}
```
        ''',
        ),
      ],
    );
  }
}

class _SingleExtControllerDemo extends StatefulWidget {
  const _SingleExtControllerDemo();

  @override
  State<_SingleExtControllerDemo> createState() =>
      _SingleExtControllerDemoState();
}

class _SingleExtControllerDemoState extends State<_SingleExtControllerDemo> {
  // 外部控制的控制器
  late EasyPaginationSingleSelectController<String> _externalController;

  @override
  void initState() {
    super.initState();
    // 初始化外部控制控制器
    _externalController = EasyPaginationSingleSelectController<String>(
      initialValue: null,
      fetcher: _fetchFruit,
    );
  }

  @override
  void dispose() {
    //! 默认情况下 EasyPaginationSingleSelectController 无需手动销毁
    //! 如果将 autoDisposeController 设置为 false
    //! 则需要在此处手动调用 dispose 方法释放资源
    _externalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyPaginationSelect<String>.single(
          controller: _externalController,
          autoDisposeController: false, // 手动管理生命周期
          placeholder: '请选择水果',
          width: 300,
          clearable: true,
          filterable: true,
          searchHintText: '搜索水果',
          onChanged: (value) {
            context.showMessage('选中了: $value');
          },
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            EasyButton2(
              onPressed: () => _externalController.setSelection('apple'),
              child: const Text('选择苹果'),
            ),
            EasyButton2(
              onPressed: () {
                _externalController.setSelectedOption(
                  EasyListPopMenuOption.simple(value: 'apple', title: '苹果'),
                );
              },
              child: const Text('选择苹果（不校验）'),
            ),
            EasyButton2(
              type: EasyButtonType.defalut,
              onPressed: () => _externalController.clear(),
              child: const Text('清空选择'),
            ),
          ],
        ),

        ListenableBuilder(
          listenable: _externalController,
          builder: (context, _) {
            final selected = _externalController.selectedOption;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.neutralF8,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '当前选中: ${selected?.title ?? "未选择"}',
                style: TextStyle(fontSize: 14, color: theme.neutral33),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _MultipleExtControllerDemo extends StatefulWidget {
  const _MultipleExtControllerDemo();

  @override
  State<_MultipleExtControllerDemo> createState() =>
      _MultipleExtControllerDemoState();
}

class _MultipleExtControllerDemoState
    extends State<_MultipleExtControllerDemo> {
  late EasyPaginationMultipleSelectController<String> _multiController;

  @override
  void initState() {
    super.initState();
    _multiController = EasyPaginationMultipleSelectController<String>(
      initialValues: null,
      fetcher: _fetchFruit,
    );
  }

  @override
  void dispose() {
    //! 如果将 autoDisposeController 设置为 false
    //! 则需要在此处手动调用 dispose 方法释放资源
    _multiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EasyPaginationSelect<String>.multiple(
          controller: _multiController,
          autoDisposeController: false,
          placeholder: '请选择水果',
          width: 500,
          clearable: true,
          filterable: true,
          showSelectAllItem: true,
          searchHintText: '搜索水果',
          onChanged: (values) {
            context.showMessage('选中了: ${values.join(", ")}');
          },
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            EasyButton2(
              onPressed: () => _multiController.addSelection('lemon'),
              child: const Text('添加柠檬'),
            ),
            EasyButton2(
              onPressed: () {
                _multiController.addSelectedOption(
                  EasyListPopMenuOption.simple(value: 'lemon', title: '柠檬'),
                );
              },
              child: const Text('添加柠檬（不校验）'),
            ),
            EasyButton2(
              onPressed: () => _multiController.removeSelection('lemon'),
              child: const Text('移除柠檬'),
            ),
            EasyButton2(
              onPressed: () => _multiController.selectAll(),
              child: const Text('全选'),
            ),
            EasyButton2(
              type: EasyButtonType.defalut,
              onPressed: () => _multiController.clear(),
              child: const Text('清空选择'),
            ),
          ],
        ),
        ListenableBuilder(
          listenable: _multiController,
          builder: (context, _) {
            final selected = _multiController.selectedOptions;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.neutralF8,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '当前已选择 ${selected.length} 项: ${selected.map((e) => e.title).join(", ")}',
                style: TextStyle(fontSize: 14, color: theme.neutral33),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SingleSelectFormDemo extends StatefulWidget {
  @override
  State<_SingleSelectFormDemo> createState() => _SingleSelectFormDemoState();
}

class _SingleSelectFormDemoState extends State<_SingleSelectFormDemo> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          EasyPaginationSingleSelectFormField<int>(
            filterable: true,
            clearable: true,
            controller: EasyPaginationSingleSelectController<int>(
              pagedFetcher: _fetchPaginationData,
            ),
            placeholder: '请选择',
            onChanged: (value) {
              context.showMessage('选中了id: $value');
            },
            validator: (value) => value == null ? '请选择一个选项' : null,
            onSaved: (newValue) {
              context.showMessage('已保存选择id: $newValue');
            },
          ),
          EasyButton2(
            child: Text('表单验证'),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (_formKey.currentState?.validate() ?? false) {
                // 验证通过，输出表单内容
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('表单验证通过，可以保存'),
                    action: SnackBarAction(
                      label: '保存表单',
                      onPressed: () {
                        _formKey.currentState?.save();
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('表单验证失败')));
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MultipleSelectFormDemo extends StatefulWidget {
  @override
  State<_MultipleSelectFormDemo> createState() =>
      _MultipleSelectFormDemoState();
}

class _MultipleSelectFormDemoState extends State<_MultipleSelectFormDemo> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          EasyPaginationMultipleSelectFormField<int>(
            filterable: true,
            clearable: true,
            controller: EasyPaginationMultipleSelectController<int>(
              pagedFetcher: _fetchPaginationData,
            ),
            placeholder: '请选择',
            onChanged: (value) {
              context.showMessage('选中了ids: $value');
            },
            validator: (value) => value?.isEmpty == true ? '请至少选择一个选项' : null,
            onSaved: (newValue) {
              context.showMessage('已保存选择ids: $newValue');
            },
          ),
          EasyButton2(
            child: Text('表单验证'),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (_formKey.currentState?.validate() ?? false) {
                // 验证通过，输出表单内容
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('表单验证通过，可以保存'),
                    action: SnackBarAction(
                      label: '保存表单',
                      onPressed: () {
                        _formKey.currentState?.save();
                      },
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('表单验证失败')));
              }
            },
          ),
        ],
      ),
    );
  }
}
