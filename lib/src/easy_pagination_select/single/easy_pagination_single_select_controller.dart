import 'package:collection/collection.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../easy_menu/easy_list_pop_menu.dart';
import '../base/easy_pagination_select_base_controller.dart';

class EasyPaginationSingleSelectController<T>
    extends EasyPaginationSelectBaseController<T> {
  EasyPaginationSingleSelectController({
    this.initialValue,
    this.initialOption,
    this.fetcher,
    this.pagedFetcher,
    this.pageSize = 20,
    this.debounceDuration = const Duration(milliseconds: 500),
  }) : assert(
         initialValue == null || initialOption == null,
         'initialValue 与 initialOption 不能同时提供',
       ),
       assert(
         (fetcher != null) != (pagedFetcher != null),
         '必须且只能提供一个: fetcher 或 pagedFetcher',
       ) {
    if (initialValue != null && fetcher != null) {
      pagingController.fetchNextPage();
      _selectedOption = (value: initialValue as T, title: null);
    }

    if (initialOption != null) {
      _selectedOption = (
        value: initialOption!.value,
        title: initialOption!.title,
      );
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
  bool get hasSelected => _selectedOption != null;

  /// 初始值（会自动寻找当前选中项对应的option）
  /// 适用于非分页的情况（因为分页的选中项可能不在当前页）
  final T? initialValue;

  /// 初始选中项（不会检查value是否存在于下拉列表）
  /// 适用于分页的情况
  final EasyListPopMenuOption<T>? initialOption;

  // 选中项的信息
  // ! 注意：title 可能为 null
  ({T value, String? title})? _selectedOption;
  ({T value, String? title})? get selectedOption => _selectedOption;

  ///内置选中方法，常用于点击选项时的选中
  void select(T value) {
    EasyListPopMenuOption<T>? found;
    final items = pagingController.items;
    if (items != null) {
      found = items.firstWhereOrNull((o) => o.value == value);
    }
    setSelectedOption(found);
  }

  /// 外部控制选中项，为null时表示清除选中
  void setSelection(T? value) {
    if (value == null) {
      if (_selectedOption != null) {
        _selectedOption = null;
        notifyListeners();
      }
      return;
    }
    select(value);
  }

  /// 直接设置选项
  /// 注意：该方法不会检查该选项是否存在于当前列表中
  void setSelectedOption(EasyListPopMenuOption<T>? option) {
    if (option == null) {
      _selectedOption = null;
    } else {
      _selectedOption = (value: option.value, title: option.title);
    }
    notifyListeners();
  }

  @override
  void clear() {
    _selectedOption = null;
    notifyListeners();
  }
}
