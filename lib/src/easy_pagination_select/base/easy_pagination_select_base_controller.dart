import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../easy_menu/easy_list_pop_menu.dart';

typedef EasySelectFetcher<T> =
    FutureOr<List<EasyListPopMenuOption<T>>> Function(String? searchKey);

typedef EasySelectPagedFetcher<T> =
    FutureOr<List<EasyListPopMenuOption<T>>> Function(
      int pageNum,
      int pageSize,
      String? searchKey,
    );

abstract class EasyPaginationSelectBaseController<T> extends ChangeNotifier {
  EasyPaginationSelectBaseController() {
    _pagingController = PagingController<int, EasyListPopMenuOption<T>>(
      getNextPageKey: (PagingState<int, EasyListPopMenuOption<T>> state) {
        if (fetcher != null && state.nextIntPageKey > 1) return null;
        final lastPage = state.pages?.lastOrNull;
        if (lastPage != null && lastPage.length < pageSize) return null;
        return state.nextIntPageKey;
      },
      fetchPage: (int pageKey) {
        if (pagedFetcher != null) {
          return pagedFetcher!(pageKey, pageSize, _searchKey);
        } else if (fetcher != null) {
          return fetcher!(_searchKey);
        } else {
          return [];
        }
      },
    );
  }

  /// 非分页数据获取器
  EasySelectFetcher<T>? get fetcher;

  /// 分页数据获取器
  EasySelectPagedFetcher<T>? get pagedFetcher;

  /// 每页数据量，仅适用于分页情况
  int get pageSize;

  /// 防抖时间间隔
  Duration get debounceDuration;

  late final PagingController<int, EasyListPopMenuOption<T>> _pagingController;
  PagingController<int, EasyListPopMenuOption<T>> get pagingController =>
      _pagingController;

  String? _searchKey;
  String? get searchKey => _searchKey;

  Timer? _debounceTimer;

  /// 搜索，具有防抖功能
  void search(String? key) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounceDuration, () {
      if (_searchKey == key?.trim()) return;
      _searchKey = key?.trim();
      _pagingController.refresh();
    });
  }

  /// 是否有选中项
  bool get hasSelected;

  /// 清除所有选中项
  void clear();

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
