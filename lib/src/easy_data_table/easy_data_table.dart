import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pixel_snap/material.dart' show PixelSnap, PixelSnapExtNum;
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

typedef EasyDataTableCellBuilder =
    Widget Function(BuildContext context, TableVicinity vicinity);

typedef EasyDataTableHeaderBuilder =
    Widget Function(BuildContext context, int column);

class EasyDataTableColumnConfig {
  const EasyDataTableColumnConfig({
    required this.visibilityOptionName,
    required this.width,
    this.alwaysVisible = false,
  });

  /// 筛选列菜单选项名称，值为null时不出现在菜单中
  final String? visibilityOptionName;

  /// 列宽
  final double width;

  /// 该列是否总是可见，总是可见的话无法被筛选，在筛选列菜单中对应选项无法取消勾选
  final bool alwaysVisible;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasyDataTableColumnConfig &&
          runtimeType == other.runtimeType &&
          visibilityOptionName == other.visibilityOptionName &&
          width == other.width &&
          alwaysVisible == other.alwaysVisible;

  @override
  int get hashCode => Object.hash(visibilityOptionName, width, alwaysVisible);
}

class EasyDataTable extends StatefulWidget {
  const EasyDataTable({
    super.key,
    required this.loadingData,
    this.headerHeight = 48.0,
    required this.headerBuilder,
    required this.rowCount,
    this.rowHeight = 48.0,
    required this.columnConfigs,
    required this.cellBuilder,
    this.initialInvisibleColumnIndices = const [],
    this.frozenLeftColumnCount = 0,
    this.frozenLastColumn = false,
    this.searchWidget,
    this.operationsWidget,
    required this.emptyWidget,
    this.calculateDelegate,
    this.showHoverEffect = false,
  }) : assert(
         frozenLastColumn
             ? frozenLeftColumnCount <= columnConfigs.length - 1
             : frozenLeftColumnCount <= columnConfigs.length,
         '冻结的列数不能超过表格总列数',
       );

  /// 是否正在加载
  final bool loadingData;

  /// 表头高度
  final double headerHeight;

  /// 表头构建函数
  final EasyDataTableHeaderBuilder headerBuilder;

  /// 行数
  final int rowCount;

  /// 行高
  final double rowHeight;

  /// 每列配置
  final List<EasyDataTableColumnConfig> columnConfigs;

  /// 表格单元构建函数
  final EasyDataTableCellBuilder cellBuilder;

  /// 初始不可见列
  final List<int> initialInvisibleColumnIndices;

  /// 冻结表单左边前几列
  final int frozenLeftColumnCount;

  /// 冻结表单最后一列
  final bool frozenLastColumn;

  /// 搜素Widget插槽
  final Widget? searchWidget;

  /// 操作Widget插槽
  final Widget? operationsWidget;

  /// 空占位视图
  final Widget emptyWidget;

  /// 计算委托，目前用于行高计算.
  /// 值为null时行高直接使用[rowHeight]，不会再经过计算
  final EasyDataTableCalculateDelegate? calculateDelegate;

  /// 是否让鼠标指针所在行高亮
  final bool showHoverEffect;

  @override
  State<EasyDataTable> createState() => _EasyDataTableState();
}

class _EasyDataTableState extends State<EasyDataTable> {
  /// 不可见列索引
  late Set<int> _invisibleColumnIndices;

  @override
  void initState() {
    super.initState();
    _invisibleColumnIndices = Set.of(widget.initialInvisibleColumnIndices);
  }

  /// 选择所有筛选选项
  void _selectAllFilterOptions(bool? select, Iterable<int> items) {
    setState(() {
      if (select != null) {
        _invisibleColumnIndices = {};
      } else {
        _invisibleColumnIndices = {..._invisibleColumnIndices, ...items};
      }
    });
  }

  /// 选择一个筛选选项
  void _selectFilterOption(bool? select, int index) {
    if (select != null) {
      setState(() {
        if (select) {
          _invisibleColumnIndices = Set.of(_invisibleColumnIndices)
            ..remove(index);
        } else {
          _invisibleColumnIndices = Set.of(_invisibleColumnIndices)..add(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final table = LayoutBuilder(
      builder: (context, constraints) {
        return _EasyDataTableView(
          loadingData: widget.loadingData,
          headerHeight: widget.headerHeight,
          headerBuilder: widget.headerBuilder,
          rowCount: widget.rowCount,
          rowHeight: widget.rowHeight,
          columnConfigs: widget.columnConfigs,
          cellBuilder: widget.cellBuilder,
          frozenLeftColumnCount: widget.frozenLeftColumnCount,
          frozenLastColumn: widget.frozenLastColumn,
          searchWidget: widget.searchWidget,
          operationsWidget: widget.operationsWidget,
          emptyWidget: widget.emptyWidget,
          calculateDelegate: widget.calculateDelegate,
          showHoverEffect: widget.showHoverEffect,
          size: constraints.biggest,
          invisibleColumnIndices: _invisibleColumnIndices,
        );
      },
    );

    if (widget.searchWidget != null || widget.operationsWidget != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.searchWidget != null)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: widget.searchWidget!,
            ),
          if (widget.operationsWidget != null)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(child: widget.operationsWidget!),
                  _EasyDataTableFilter(
                    loadingData: widget.loadingData,
                    columnConfigs: widget.columnConfigs,
                    invisibleColumnIndices: _invisibleColumnIndices,
                    selectAllFilterOptions: _selectAllFilterOptions,
                    selectFilterOption: _selectFilterOption,
                  ),
                ],
              ),
            ),
          Expanded(child: table),
        ],
      );
    } else {
      return table;
    }
  }
}

class _EasyDataTableView extends StatefulWidget {
  const _EasyDataTableView({
    required this.loadingData,
    this.headerHeight = 48.0,
    required this.headerBuilder,
    required this.rowCount,
    this.rowHeight = 48.0,
    required this.columnConfigs,
    required this.cellBuilder,
    this.frozenLeftColumnCount = 0,
    this.frozenLastColumn = false,
    this.searchWidget,
    this.operationsWidget,
    required this.emptyWidget,
    this.calculateDelegate,
    this.showHoverEffect = false,
    required this.size,
    required this.invisibleColumnIndices,
  }) : columnCount = columnConfigs.length,
       assert(
         frozenLastColumn
             ? frozenLeftColumnCount <= columnConfigs.length - 1
             : frozenLeftColumnCount <= columnConfigs.length,
         '冻结的列数不能超过表格总列数',
       );

  /// 是否正在加载
  final bool loadingData;

  /// 表头高度
  final double headerHeight;

  /// 表头构建函数
  final EasyDataTableHeaderBuilder headerBuilder;

  /// 行数
  final int rowCount;

  /// 行高
  final double rowHeight;

  /// 列数
  final int columnCount;

  /// 每列配置
  final List<EasyDataTableColumnConfig> columnConfigs;

  /// 表格单元构建函数
  final EasyDataTableCellBuilder cellBuilder;

  /// 冻结表单左边前几列
  final int frozenLeftColumnCount;

  /// 冻结表单最后一列
  final bool frozenLastColumn;

  /// 搜素Widget插槽
  final Widget? searchWidget;

  /// 操作Widget插槽
  final Widget? operationsWidget;

  /// 空占位视图
  final Widget emptyWidget;

  /// 计算委托，目前用于行高计算.
  /// 值为null时行高直接使用[rowHeight]，不会再经过计算
  final EasyDataTableCalculateDelegate? calculateDelegate;

  /// 是否让鼠标指针所在行高亮
  final bool showHoverEffect;

  /// 不可见列索引
  final Set<int> invisibleColumnIndices;

  /// 大小
  final Size size;

  @override
  State<_EasyDataTableView> createState() => _EasyDataTableViewState();
}

class _EasyDataTableViewState extends State<_EasyDataTableView> {
  /// 是否显示被固定的最后一列
  bool? _showPinnedLastColumn;

  /// 是否显示除了被固定的最后一列的其他列
  bool? _showTableView;

  /// TableView的每列宽度
  late Map<int, TableSpanExtent> _tableViewColumnSpanExtent;

  /// 被固定的最后一列宽度
  late double _pinnedLastColumnWidth;

  /// 可见列索引映射
  late Map<int, int> _tableVisibleColumnIndexMapping;

  late EasyDataTableCalculateRowHeightResult _rowHeight;

  /// 最后一列索引
  late int _lastColumnIndex;

  /// 鼠标指针所在行索引
  int? _hoverRowIndex;

  late ScrollController _tableVerticalScrollController;
  late final ScrollController _tableHorizontalScrollController;
  late ScrollController _lastColumnScrollController;

  @override
  void initState() {
    super.initState();
    _tableVerticalScrollController = ScrollController();
    _tableHorizontalScrollController = ScrollController();
    _lastColumnScrollController = ScrollController();
    _tableVerticalScrollController.addListener(_onTableVerticalScroll);
    _lastColumnScrollController.addListener(_onLastColumnScroll);
    _initColumnContext();
    _calculateRowHeight();
  }

  @override
  void didUpdateWidget(covariant _EasyDataTableView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.frozenLastColumn != oldWidget.frozenLastColumn ||
        widget.columnCount != oldWidget.columnCount ||
        widget.rowCount != oldWidget.rowCount ||
        widget.invisibleColumnIndices != oldWidget.invisibleColumnIndices ||
        widget.size != oldWidget.size ||
        !listEquals(widget.columnConfigs, oldWidget.columnConfigs)) {
      _initColumnContext();
    }

    if (widget.rowHeight != oldWidget.rowHeight ||
        widget.rowCount != oldWidget.rowCount ||
        widget.calculateDelegate != oldWidget.calculateDelegate ||
        widget.headerHeight != oldWidget.headerHeight ||
        widget.size.height != oldWidget.size.height) {
      _calculateRowHeight();
    }

    /// 高度变高时，新的maxScrollExtent会变小，如果offset不变小则会在变高时出现
    /// 表格缓缓下降的问题。因为原来的offset已经超过新的maxScrollExtent了。
    if (widget.size.height > oldWidget.size.height) {
      final heightDifference = widget.size.height - oldWidget.size.height;

      if (_tableVerticalScrollController.hasClients) {
        if (_rowHeight.shareRemainingHeight) {
          _tableVerticalScrollController.jumpTo(0);
        } else {
          final offset = _tableVerticalScrollController.offset;
          final maxScrollExtent =
              _tableVerticalScrollController.position.maxScrollExtent;
          if (offset >= maxScrollExtent - heightDifference) {
            _tableVerticalScrollController.jumpTo(
              maxScrollExtent - heightDifference,
            );
          }
        }
      }

      if (_lastColumnScrollController.hasClients) {
        if (_rowHeight.shareRemainingHeight) {
          _lastColumnScrollController.jumpTo(0);
        } else {
          final offset = _lastColumnScrollController.offset;
          final maxScrollExtent =
              _lastColumnScrollController.position.maxScrollExtent;
          if (offset >= maxScrollExtent - heightDifference) {
            _lastColumnScrollController.jumpTo(
              maxScrollExtent - heightDifference,
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _tableVerticalScrollController.dispose();
    _tableHorizontalScrollController.dispose();
    _lastColumnScrollController.dispose();
    super.dispose();
  }

  /// 初始化表格列的相关数据
  void _initColumnContext() {
    _lastColumnIndex = widget.columnCount - 1;
    // 可见列配置
    final visibleColumnConfigs = <int, EasyDataTableColumnConfig>{};
    _tableViewColumnSpanExtent = {};
    _pinnedLastColumnWidth = 0;
    _tableVisibleColumnIndexMapping = {};
    double visibleColumnTotalWidth = 0;

    final preShowPinnedLastColumn = _showPinnedLastColumn;
    // 是否显示被固定的最后一列
    _showPinnedLastColumn =
        widget.frozenLastColumn &&
        !widget.invisibleColumnIndices.contains(_lastColumnIndex) &&
        widget.rowCount > 0;

    for (final config in widget.columnConfigs.indexed) {
      if (widget.invisibleColumnIndices.contains(config.$1)) {
      } else {
        visibleColumnTotalWidth += config.$2.width;
        visibleColumnConfigs[config.$1] = config.$2;
        _tableVisibleColumnIndexMapping[visibleColumnConfigs.length - 1] =
            config.$1;
      }
    }

    // 可见列总宽度小于视口宽度，所有可见列均分剩余宽度
    final shareRemainingWidth = visibleColumnTotalWidth < widget.size.width;

    if (_showPinnedLastColumn == true) {
      _pinnedLastColumnWidth =
          shareRemainingWidth
              ? visibleColumnConfigs[_lastColumnIndex]!.width /
                  visibleColumnTotalWidth *
                  widget.size.width
              : visibleColumnConfigs[_lastColumnIndex]!.width;
    }

    final tableViewVisibleColumnTotalWidth =
        _showPinnedLastColumn == true
            ? visibleColumnTotalWidth -
                visibleColumnConfigs[_lastColumnIndex]!.width
            : visibleColumnTotalWidth;
    for (final entry in visibleColumnConfigs.entries) {
      if (_showPinnedLastColumn != true || entry.key != _lastColumnIndex) {
        _tableViewColumnSpanExtent[entry.key] =
            shareRemainingWidth
                ? FractionalSpanExtent(
                  entry.value.width / tableViewVisibleColumnTotalWidth,
                )
                : FixedSpanExtent(entry.value.width);
      }
    }

    final preShowTableView = _showTableView;
    // 是否显示除了被固定的最后一列的其他列
    _showTableView =
        _tableViewColumnSpanExtent.isNotEmpty && widget.rowCount > 0;

    // 如果被固定的最后一列由隐到现且tabview一直保持出现，同步滚动位置
    if (preShowPinnedLastColumn == false &&
        _showPinnedLastColumn == true &&
        preShowTableView == true &&
        _showTableView == true &&
        _tableVerticalScrollController.hasClients) {
      _lastColumnScrollController.removeListener(_onLastColumnScroll);
      _lastColumnScrollController = ScrollController(
        initialScrollOffset: _tableVerticalScrollController.offset,
      );
      _lastColumnScrollController.addListener(_onLastColumnScroll);
    }

    // 如果tabview由隐到现且被固定的最后一列一直保持出现，同步滚动位置
    if (preShowTableView == false &&
        _showTableView == true &&
        preShowPinnedLastColumn == true &&
        _showPinnedLastColumn == true &&
        _lastColumnScrollController.hasClients) {
      _tableVerticalScrollController.removeListener(_onTableVerticalScroll);
      _tableVerticalScrollController = ScrollController(
        initialScrollOffset: _lastColumnScrollController.offset,
      );
      _tableVerticalScrollController.addListener(_onTableVerticalScroll);
    }
  }

  /// 计算行高
  void _calculateRowHeight() {
    var rowHeight = EasyDataTableCalculateRowHeightResult(
      shareRemainingHeight: false,
      value: widget.rowHeight,
    );
    if (widget.calculateDelegate != null) {
      rowHeight = widget.calculateDelegate!.calculateRowHeight(
        rowCount: widget.rowCount,
        defaultRowHeight: widget.rowHeight,
        viewportHeightExceptHeader: widget.size.height - widget.headerHeight,
      );
    }
    _rowHeight = rowHeight;
  }

  void _onLastColumnScroll() {
    // 同步滚动位置
    if (_tableVerticalScrollController.hasClients &&
        _lastColumnScrollController.hasClients) {
      if (_tableVerticalScrollController.offset !=
          _lastColumnScrollController.offset) {
        _tableVerticalScrollController.jumpTo(
          _lastColumnScrollController.offset,
        );
      }
    }
  }

  void _onTableVerticalScroll() {
    // 同步滚动位置
    if (_tableVerticalScrollController.hasClients &&
        _lastColumnScrollController.hasClients) {
      if (_lastColumnScrollController.offset !=
          _tableVerticalScrollController.offset) {
        _lastColumnScrollController.jumpTo(
          _tableVerticalScrollController.offset,
        );
      }
    }
  }

  /// 获取行背景色
  Color _getRowBackgroundColor(int rowIndex, EasyThemeData easyTheme) {
    return rowIndex == _hoverRowIndex
        ? easyTheme.primaryGreen.withAlpha(0x1F)
        : easyTheme.background;
  }

  void _onMouseEnterRowEvent(PointerEnterEvent event, int rowIndex) {
    if (_hoverRowIndex != rowIndex) {
      setState(() {
        _hoverRowIndex = rowIndex;
      });
    }
  }

  void _onMouseExitRowEvent(PointerExitEvent event, int rowIndex) {
    if (_hoverRowIndex == rowIndex) {
      setState(() {
        _hoverRowIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final headerBackground = easyTheme.neutralF8;
    final borderColor = easyTheme.neutral33.withAlpha(0x0F);
    final rowCount = widget.rowCount;

    final tableView =
        _showTableView == true
            ? TableView.builder(
              verticalDetails: ScrollableDetails.vertical(
                controller: _tableVerticalScrollController,
                physics: ClampingScrollPhysics(),
              ),
              horizontalDetails: ScrollableDetails.horizontal(
                controller: _tableHorizontalScrollController,
                physics: ClampingScrollPhysics(),
              ),
              pinnedRowCount: 1,
              pinnedColumnCount: widget.frozenLeftColumnCount,
              columnCount: _tableViewColumnSpanExtent.length,
              columnBuilder: (column) {
                final index = _tableVisibleColumnIndexMapping[column]!;
                return TableSpan(extent: _tableViewColumnSpanExtent[index]!);
              },
              rowCount: rowCount + 1,
              rowBuilder: (row) {
                if (row == 0) {
                  return TableSpan(
                    backgroundDecoration: SpanDecoration(
                      color: headerBackground,
                    ),
                    extent: FixedSpanExtent(widget.headerHeight),
                  );
                } else {
                  return TableSpan(
                    backgroundDecoration: SpanDecoration(
                      color: _getRowBackgroundColor(row - 1, easyTheme),
                      border: SpanBorder(
                        trailing: BorderSide(
                          color: borderColor,
                          width: 1.pixelSnap(PixelSnap.of(context)),
                        ),
                      ),
                    ),
                    extent: FixedSpanExtent(_rowHeight.value),
                    onEnter:
                        widget.showHoverEffect
                            ? (event) => _onMouseEnterRowEvent(event, row - 1)
                            : null,
                    onExit:
                        widget.showHoverEffect
                            ? (event) => _onMouseExitRowEvent(event, row - 1)
                            : null,
                  );
                }
              },
              cellBuilder: (context, vicinity) {
                final index = _tableVisibleColumnIndexMapping[vicinity.column]!;
                if (vicinity.row == 0) {
                  return TableViewCell(
                    child: widget.headerBuilder(context, index),
                  );
                }
                return TableViewCell(
                  child: widget.cellBuilder(
                    context,
                    vicinity.copyWith(row: vicinity.row - 1, column: index),
                  ),
                );
              },
            )
            : null;

    final pinnedLastColumnWidget =
        _showPinnedLastColumn == true
            ? SizedBox(
              width: _pinnedLastColumnWidth,
              child: CustomScrollView(
                controller: _lastColumnScrollController,
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _MyHeaderDelegate(
                      child: Container(
                        decoration: BoxDecoration(color: headerBackground),
                        width: double.infinity,
                        height: widget.headerHeight,
                        child: widget.headerBuilder(context, _lastColumnIndex),
                      ),
                      minHeight: widget.headerHeight,
                      maxHeight: widget.headerHeight,
                    ),
                  ),
                  SliverFixedExtentList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return MouseRegion(
                        onEnter:
                            widget.showHoverEffect
                                ? (event) => _onMouseEnterRowEvent(event, index)
                                : null,
                        onExit:
                            widget.showHoverEffect
                                ? (event) => _onMouseExitRowEvent(event, index)
                                : null,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getRowBackgroundColor(index, easyTheme),
                            border: Border(
                              bottom: BorderSide(
                                color: borderColor,
                                width: 1.pixelSnap(PixelSnap.of(context)),
                              ),
                            ),
                          ),
                          height: _rowHeight.value,
                          child: widget.cellBuilder(
                            context,
                            TableVicinity(row: index, column: _lastColumnIndex),
                          ),
                        ),
                      );
                    }, childCount: rowCount),
                    itemExtent: _rowHeight.value,
                  ),
                ],
              ),
            )
            : null;

    Widget table = switch ((tableView, pinnedLastColumnWidget)) {
      (Widget a, Widget b) => Row(children: [Expanded(child: a), b]),
      (Widget a, null) => a,
      (null, Widget b) => b,
      _ => widget.emptyWidget,
    };
    table = ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        overscroll: false,
        scrollbars: false,
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: table,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(easyTheme.cornerMedium),
        border: Border.all(
          color: borderColor,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: table),
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: Durations.short4,
              child:
                  widget.loadingData
                      ? Container(
                        key: UniqueKey(),
                        color: easyTheme.background.withValues(alpha: .8),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: easyTheme.primaryGreen,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                      : SizedBox(key: UniqueKey()),
            ),
          ),
        ],
      ),
    );
  }
}

class _EasyDataTableFilter extends StatelessWidget {
  const _EasyDataTableFilter({
    required this.loadingData,
    required this.columnConfigs,
    required this.invisibleColumnIndices,
    required this.selectAllFilterOptions,
    required this.selectFilterOption,
  });

  final bool loadingData;

  /// 每列配置
  final List<EasyDataTableColumnConfig> columnConfigs;

  /// 不可见列索引
  final Set<int> invisibleColumnIndices;

  final void Function(bool?, Iterable<int>) selectAllFilterOptions;

  final void Function(bool?, int) selectFilterOption;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    return EasyMenuAnchor(
      style: EasyMenuStyle(
        backgroundColor: easyTheme.background,
        borderRadius: BorderRadius.circular(4),
        boxShadows: [
          BoxShadow(
            color: easyTheme.secondaryBlue.withAlpha(0x40),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        boxBorder: Border.all(color: easyTheme.neutralEE),
      ),
      childBuilder: (context, controller, child) {
        return SizedBox(
          width: 38,
          height: 38,
          child: Tooltip(
            message: EasyUiLocalizations.of(context).filterFields,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: easyTheme.neutralF8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(easyTheme.cornerSmall),
                ),
                padding: EdgeInsets.all(8),
              ),
              onPressed: () {
                if (loadingData) {
                  return;
                }
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Icon(
                Icons.checklist,
                color:
                    controller.isOpen
                        ? easyTheme.primaryGreen
                        : easyTheme.termination,
                size: 20,
              ),
            ),
          ),
        );
      },
      menuBuilder: (context, controller, overlayInfo) {
        final filterMenuChildren = <Widget>[];
        final options = columnConfigs.indexed.where(
          (e) => e.$2.visibilityOptionName != null,
        );
        final selectableOptions = options.where((e) => !e.$2.alwaysVisible);
        // 所有菜单项是都选中，null为部分选中，true为全部选中，false为全部未选中
        bool? allSelected;
        if (selectableOptions.every(
          (e) => invisibleColumnIndices.contains(e.$1),
        )) {
          allSelected = false;
        } else if (selectableOptions.every(
          (e) => !invisibleColumnIndices.contains(e.$1),
        )) {
          allSelected = true;
        }

        filterMenuChildren.add(
          CheckboxListTile(
            tristate: true,
            value: allSelected,
            controlAffinity: ListTileControlAffinity.leading,
            side:
                allSelected == true
                    ? null
                    : BorderSide(color: easyTheme.neutralEE),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFFD9D9D9);
              }
              if (states.contains(WidgetState.selected)) {
                return allSelected == null
                    ? easyTheme.primaryGreen.withAlpha(0x33)
                    : easyTheme.primaryGreen;
              }
              return easyTheme.background;
            }),
            checkColor:
                allSelected == null
                    ? easyTheme.primaryGreen
                    : easyTheme.background,
            title: Text(
              EasyUiLocalizations.of(context).all,
              style: TextStyle(fontSize: 14, color: easyTheme.neutral66),
            ),
            onChanged:
                (select) => selectAllFilterOptions(
                  select,
                  selectableOptions.map((e) => e.$1),
                ),
          ),
        );

        for (var i = 0; i < options.length; ++i) {
          final (columnIndex, config) = options.elementAt(i);
          final selected =
              config.alwaysVisible
                  ? true
                  : !invisibleColumnIndices.contains(columnIndex);

          final child = CheckboxListTile(
            title: Text(
              config.visibilityOptionName ?? '',
              style: TextStyle(fontSize: 14, color: easyTheme.neutral66),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            side: selected ? null : BorderSide(color: easyTheme.neutralEE),
            value: selected,
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFFD9D9D9);
              }
              if (states.contains(WidgetState.selected)) {
                return easyTheme.primaryGreen;
              }
              return easyTheme.background;
            }),
            checkColor: easyTheme.background,
            onChanged:
                config.alwaysVisible
                    ? null
                    : (select) => selectFilterOption(select, columnIndex),
          );
          filterMenuChildren.add(child);
        }

        return SingleChildScrollView(
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: filterMenuChildren,
            ),
          ),
        );
      },
    );
  }
}

// 1. 自定义 SliverPersistentHeaderDelegate
class _MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;

  _MyHeaderDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
  });

  @override
  double get minExtent => minHeight; // 固定在顶部时的高度

  @override
  double get maxExtent => maxHeight; // 初始最大高度

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // shrinkOffset 是从 maxHeight 到 minHeight 的缩小偏移量
    // 可以根据这个值来调整组件的显示效果，例如：渐变、收缩等
    return SizedBox.expand(child: child); // 返回需要固定的组件
  }

  @override
  bool shouldRebuild(covariant _MyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.maxHeight != maxHeight;
  }
}
