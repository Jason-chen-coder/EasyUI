part of '../easy_pagination_select.dart';

class EasyPaginationMultipleSelect<T> extends EasyPaginationSelect<T> {
  const EasyPaginationMultipleSelect._({
    super.key,
    this.onChanged,
    super.placeholder,
    super.width,
    super.height = 38,
    super.style,
    super.menuConstraintsBuilder,
    super.clearable = false,
    super.filterable = false,
    required super.controller,
    super.textStyle,
    super.placeholderTextStyle,
    super.padding,
    super.searchHintText,
    super.borderColor,
    super.autoDisposeController = true,
    this.showSelectAllItem = true,
    this.selectAllItemTitle,
  });

  final ValueChanged<List<T>>? onChanged;

  /// 是否显示全选选项
  final bool showSelectAllItem;

  /// 全选选项标题
  final String? selectAllItemTitle;

  @override
  State<EasyPaginationSelect<T>> createState() =>
      _EasyPaginationMultipleSelectState<T>();
}

class _EasyPaginationMultipleSelectState<T>
    extends EasyPaginationSelectState<T> {
  @override
  void handelClearSelection() {
    super.handelClearSelection();
    (widget as EasyPaginationMultipleSelect<T>).onChanged?.call([]);
  }

  @override
  Widget labelBuilder(bool menuIsOpen) {
    final selectController =
        widget.controller as EasyPaginationMultipleSelectController<T>;
    return PagingListener(
      controller: selectController.pagingController,
      builder: (context, state, _) {
        return ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final theme = EasyTheme.of(context);

            /// 未选中任何值
            if (selectController.selectedOptions.isEmpty) {
              return Text(
                widget.placeholder ?? '',
                style:
                    widget.placeholderTextStyle ??
                    TextStyle(fontSize: 14, color: theme.neutral66),
                overflow: TextOverflow.ellipsis,
              );
            }

            ///加载完列表后，如果`selectedOptions`没有提供`title`，则更新`selectedOptions`的`title`
            final List<({T value, String? title})> selectedOptions =
                selectController.selectedOptions.map((e) {
                  String? title = e.title;
                  title ??=
                      state.items
                          ?.firstWhereOrNull((item) => item.value == e.value)
                          ?.title ??
                      e.value.toString();
                  return (value: e.value, title: title);
                }).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: 8,
                children:
                    selectedOptions.map((e) {
                      return _Tag(
                        label: e.title ?? '',
                        onDeleteTap:
                            menuIsOpen
                                ? () {
                                  selectController.removeSelection(e.value);
                                  (widget as EasyPaginationMultipleSelect<T>)
                                      .onChanged
                                      ?.call(
                                        selectController.selectedValues
                                            .toList(),
                                      );
                                }
                                : null,
                      );
                    }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget? beforeMenuListitemBuilder(TextStyle defaultTitleStyle) {
    if (!(widget as EasyPaginationMultipleSelect<T>).showSelectAllItem) {
      return null;
    }
    return ListenableBuilder(
      key: UniqueKey(),
      listenable: widget.controller,
      builder: (context, _) {
        final selectController =
            widget.controller as EasyPaginationMultipleSelectController<T>;
        return EasyPaginationMultipleSelectOptionItem(
          index: -1,
          option: EasyListPopMenuOption.simple(
            value: null,
            title:
                (widget as EasyPaginationMultipleSelect<T>)
                    .selectAllItemTitle ??
                EasyUiLocalizations.of(context).pickAll,
          ),
          selected: selectController.isAllSelected,
          onSelectChanged: (val) {
            if (selectController.isAllSelected == true) {
              selectController.clear();
              (widget as EasyPaginationMultipleSelect<T>).onChanged?.call([]);
            } else {
              selectController.selectAll();
              (widget as EasyPaginationMultipleSelect<T>).onChanged?.call(
                selectController.selectedValues.toList(),
              );
            }
          },
          defaultTitleStyle: defaultTitleStyle,
        );
      },
    );
  }

  @override
  Widget menuItemBuilder(
    BuildContext context,
    EasyListPopMenuOption<T> option,
    int index,
    EasyMenuController menuController,
    TextStyle defaultTitleStyle,
  ) {
    final selectController =
        widget.controller as EasyPaginationMultipleSelectController<T>;
    return ListenableBuilder(
      key: ValueKey(option.value),
      listenable: widget.controller,
      builder: (context, _) {
        final selected = selectController.selectedValues.contains(option.value);
        return EasyPaginationMultipleSelectOptionItem<T>(
          key: ValueKey(option),
          index: index,
          option: option,
          selected: selected,
          onSelectChanged: (val) {
            if (val.select == true) {
              selectController.select(val.option);
            } else {
              selectController.removeSelection(val.option);
            }

            (widget as EasyPaginationMultipleSelect<T>).onChanged?.call(
              selectController.selectedValues.toList(),
            );
          },
          defaultTitleStyle: defaultTitleStyle,
        );
      },
    );
  }

  @override
  Widget? prototypeItemBuilder(
    EasyListPopMenuOption<T> option,
    TextStyle defaultTitleStyle,
  ) {
    return EasyPaginationMultipleSelectOptionItem<T>(
      index: -1,
      option: option,
      selected: false,
      defaultTitleStyle: defaultTitleStyle,
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.onDeleteTap});

  final String label;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.neutralEE,
        borderRadius: BorderRadius.all(theme.cornerSmall),
        border: Border.all(color: theme.neutralEE),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: theme.neutral66, height: 1),
          ),
          if (onDeleteTap != null)
            InkWell(
              onTap: onDeleteTap,
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.close, size: 12, color: theme.neutral66),
              ),
            ),
        ],
      ),
    );
  }
}
