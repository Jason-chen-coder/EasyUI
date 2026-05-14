class EasyDataTableCalculateRowHeightResult {
  final bool shareRemainingHeight;
  final double value;

  const EasyDataTableCalculateRowHeightResult({
    required this.shareRemainingHeight,
    required this.value,
  });
}

/// 表格行高计算委托
abstract class EasyDataTableCalculateDelegate {
  const EasyDataTableCalculateDelegate();

  /// 一般表格
  const factory EasyDataTableCalculateDelegate.normal() =
      _EasyDataTableNormalCalculateDelegate;

  /// 分页表格
  const factory EasyDataTableCalculateDelegate.pagination({
    required int pageSize,
  }) = _EasyDataTablePaginationCalculateDelegate;

  EasyDataTableCalculateRowHeightResult calculateRowHeight({
    required int rowCount,
    required double defaultRowHeight,
    required double viewportHeightExceptHeader,
  });
}

/// 一般表格计算委托
class _EasyDataTableNormalCalculateDelegate
    extends EasyDataTableCalculateDelegate {
  const _EasyDataTableNormalCalculateDelegate();

  /// 当前行数正好是视口高度能容纳最大行数时，所有行均分剩余空间
  @override
  EasyDataTableCalculateRowHeightResult calculateRowHeight({
    required int rowCount,
    required double defaultRowHeight,
    required double viewportHeightExceptHeader,
  }) {
    if (viewportHeightExceptHeader.isInfinite) {
      return EasyDataTableCalculateRowHeightResult(
        shareRemainingHeight: false,
        value: defaultRowHeight,
      );
    }
    final defaultRowCount = viewportHeightExceptHeader / defaultRowHeight;
    if (rowCount == defaultRowCount.floor() && rowCount > 0) {
      return EasyDataTableCalculateRowHeightResult(
        shareRemainingHeight: true,
        value: viewportHeightExceptHeader / rowCount,
      );
    } else {
      return EasyDataTableCalculateRowHeightResult(
        shareRemainingHeight: false,
        value: defaultRowHeight,
      );
    }
  }
}

/// 分页表格计算委托
class _EasyDataTablePaginationCalculateDelegate
    extends EasyDataTableCalculateDelegate {
  const _EasyDataTablePaginationCalculateDelegate({required this.pageSize});

  final int pageSize;

  /// 当前行数正好是每页条数且小于视口高度能容纳的最大条数时，所有行均分剩余空间
  @override
  EasyDataTableCalculateRowHeightResult calculateRowHeight({
    required int rowCount,
    required double defaultRowHeight,
    required double viewportHeightExceptHeader,
  }) {
    if (viewportHeightExceptHeader.isInfinite) {
      return EasyDataTableCalculateRowHeightResult(
        shareRemainingHeight: false,
        value: defaultRowHeight,
      );
    }
    final defaultRowCount = viewportHeightExceptHeader / defaultRowHeight;
    if (rowCount == pageSize && rowCount < defaultRowCount && rowCount > 0) {
      return EasyDataTableCalculateRowHeightResult(
        shareRemainingHeight: true,
        value: viewportHeightExceptHeader / rowCount,
      );
    }
    return EasyDataTableCalculateRowHeightResult(
      shareRemainingHeight: false,
      value: defaultRowHeight,
    );
  }
}
