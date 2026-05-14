class EasyPaginationState<T> {
  EasyPaginationState({
    this.data = const [],
    this.pageNum = 1,
    this.pageSize = 10,
    this.total = 0,
    this.loading = false,
    this.error,
  });

  /// 数据
  List<T> data;

  /// 页码
  int pageNum;

  /// 每页条数
  int pageSize;

  /// 总数据数
  int total;

  /// 加载中
  bool loading;

  /// 错误
  Object? error;

  /// 最大页码，至少为1
  int get maxPageNum {
    if (total == 0) {
      return 1;
    }
    return (total / pageSize).ceil();
  }

  /// 重置所有状态
  void reset({
    List<T> data = const [],
    int pageNum = 1,
    int pageSize = 10,
    int total = 0,
    bool loading = false,
    Object? error,
  }) {
    this.data = data;
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.total = total;
    this.loading = loading;
    this.error = error;
  }
}
