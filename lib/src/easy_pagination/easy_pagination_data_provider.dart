import 'dart:async';

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/widgets.dart';

abstract class EasyPaginationDataProvider<T> extends ChangeNotifier {
  EasyPaginationDataProvider(this._state);

  @override
  void dispose() {
    super.dispose();
    if (_loadDataUpdateCancelToken?.isCompleted != true) {
      _loadDataUpdateCancelToken?.complete();
    }
    _loadDataUpdateCancelToken = null;
  }

  Completer<void>? _loadDataUpdateCancelToken;

  final EasyPaginationState<T> _state;

  List<T> get data => _state.data;

  int get pageNum => _state.pageNum;

  int get pageSize => _state.pageSize;

  int get total => _state.total;

  bool get loading => _state.loading;

  Object? get error => _state.error;

  int get maxPageNum => _state.maxPageNum;

  /// 拉取分页数据
  @protected
  Future<(List<T> data, int total)> dataFetcher(int pageNum, int pageSize);

  /// 加载当前页数据
  Future<void> loadData() async {
    if (_loadDataUpdateCancelToken?.isCompleted == false) {
      _loadDataUpdateCancelToken?.complete();
    }

    final completer = Completer<void>();
    _loadDataUpdateCancelToken = completer;

    _state.error = null;
    _state.loading = true;
    notifyListeners();

    (List<T>, int)? value;
    Object? error;
    try {
      value = await dataFetcher(_state.pageNum, _state.pageSize);
    } catch (e) {
      error = e;
    } finally {
      if (!completer.isCompleted) {
        completer.complete();

        if (error != null) {
          _state.error = error;
        } else {
          _state.data = value?.$1 ?? [];
          _state.total = value?.$2 ?? 0;
        }

        _state.loading = false;
        notifyListeners();
      }
    }
  }

  /// 换页，并自动加载新数据
  Future<void> setPageNumAndLoadData(int pageNum) async {
    if (pageNum < 1 || pageNum > _state.maxPageNum) {
      return;
    }

    _state.pageNum = pageNum;
    return loadData();
  }

  /// 更新每页条数并切换到第一页，并自动加载新数据
  Future<void> setPageSizeAndLoadData(int pageSize) async {
    _state.pageSize = pageSize;
    return setPageNumAndLoadData(1);
  }

  /// 重置分页状态并刷新数据
  Future<void> resetPaginationStateAndLoadData({
    List<T> data = const [],
    int pageNum = 1,
    int pageSize = 10,
    int total = 0,
    bool loading = false,
    Object? error,
  }) {
    _state.reset(
      data: data,
      pageNum: pageNum,
      pageSize: pageSize,
      total: total,
      loading: loading,
      error: error,
    );
    return loadData();
  }
}
