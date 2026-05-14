import 'package:collection/collection.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../easy_menu/easy_list_pop_menu.dart';
import '../base/easy_pagination_select_base_controller.dart';

class EasyPaginationMultipleSelectController<T>
    extends EasyPaginationSelectBaseController<T> {
  EasyPaginationMultipleSelectController({
    this.initialValues,
    this.initialOptions,
    this.fetcher,
    this.pagedFetcher,
    this.pageSize = 20,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : assert(
         initialValues == null || initialOptions == null,
         'initialValues 与 initialOptions 不能同时提供',
       ),
       assert(
         (fetcher != null) != (pagedFetcher != null),
         '必须且只能提供一个: fetcher 或 pagedFetcher',
       ) {
    if (initialValues != null && fetcher != null) {
      pagingController.fetchNextPage();
      _selectedOptions =
          initialValues!.map((v) => (value: v, title: null)).toList();
    }

    if (initialOptions != null) {
      _selectedOptions =
          initialOptions!.map((o) => (value: o.value, title: o.title)).toList();
    }
  }

  @override
  final EasySelectFetcher<T>? fetcher;

  @override
  final EasySelectPagedFetcher<T>? pagedFetcher;

  @override
  final int pageSize;

  @override
  final Duration debounceDuration;

  @override
  bool get hasSelected => _selectedOptions.isNotEmpty;

  /// 初始值（会自动寻找当前选中项对应的option）
  /// 适用于非分页的情况（因为分页的选中项可能不在当前页）
  final List<T>? initialValues;

  /// 初始选中项（不会检查value是否存在于下拉列表）
  /// 适用于分页的情况
  final List<EasyListPopMenuOption<T>>? initialOptions;

  // 选中项的信息
  // ! 注意：title 可能为 null
  List<({T value, String? title})> _selectedOptions = [];
  List<({T value, String? title})> get selectedOptions => _selectedOptions;

  Set<T> get selectedValues => _selectedOptions.map((e) => e.value).toSet();

  /// 是否全部选中
  bool? get isAllSelected {
    final items = pagingController.items;
    if (items == null || items.isEmpty) return false;
    final allValues = items.map((e) => e.value).toSet();
    if (SetEquality().equals(allValues, selectedValues)) {
      return true;
    } else if (selectedValues.isEmpty) {
      return false;
    } else {
      return null;
    }
  }

  ///内置选中方法，常用于点击选项时的选中
  void select(T value) {
    EasyListPopMenuOption<T>? found;
    final items = pagingController.items;
    if (items != null) {
      found = items.firstWhereOrNull((o) => o.value == value);
    }
    addSelectedOption(found);
  }

  /// 移除某项
  void removeSelection(T value) {
    _selectedOptions.removeWhere((e) => e.value == value);
    notifyListeners();
  }

  /// 外部添加选中项
  void addSelection(T? value) {
    if (value == null) return;

    select(value);
  }

  /// 直接添加选项
  /// 注意：该方法不会检查该选项是否存在于当前列表中
  /// 如果该选项已存在，则不会重复添加
  void addSelectedOption(EasyListPopMenuOption<T>? option) {
    if (option == null) return;
    if (_selectedOptions.any((e) => e.value == option.value)) return;
    _selectedOptions.add((value: option.value, title: option.title));
    notifyListeners();
  }

  /// 全选
  void selectAll() {
    final items = pagingController.items;
    if (items == null || items.isEmpty) return;
    _selectedOptions =
        items.map((e) => (value: e.value, title: e.title)).toList();
    notifyListeners();
  }

  @override
  void clear() {
    _selectedOptions = [];
    notifyListeners();
  }
}
