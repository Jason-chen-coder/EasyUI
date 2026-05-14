part of '../easy_pagination_select.dart';

class EasyPaginationSingleSelect<T> extends EasyPaginationSelect<T> {
  const EasyPaginationSingleSelect._({
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
  });

  final ValueChanged<T?>? onChanged;

  @override
  State<EasyPaginationSelect<T>> createState() =>
      _EasyPaginationSingleSelectState<T>();
}

class _EasyPaginationSingleSelectState<T> extends EasyPaginationSelectState<T> {
  @override
  void handelClearSelection() {
    super.handelClearSelection();
    (widget as EasyPaginationSingleSelect<T>).onChanged?.call(null);
  }

  @override
  Widget labelBuilder(bool menuIsOpen) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final theme = EasyTheme.of(context);
        final selectController =
            widget.controller as EasyPaginationSingleSelectController<T>;
        return PagingListener(
          controller: selectController.pagingController,
          builder: (context, state, _) {
            ///加载完列表后，如果`selectedOption`没有提供`title`，则更新`selectedOption`的`title`
            String? title;
            final selected = selectController.selectedOption;
            if (selected?.title == null) {
              title =
                  state.items
                      ?.firstWhereOrNull(
                        (item) => item.value == selected?.value,
                      )
                      ?.title ??
                  selected?.value.toString();
            } else {
              title = selected?.title;
            }
            return Text(
              widget.controller.hasSelected
                  ? title ?? ''
                  : widget.placeholder ?? '',
              style:
                  (widget.controller.hasSelected
                      ? widget.textStyle
                      : widget.placeholderTextStyle) ??
                  TextStyle(fontSize: 14, color: theme.neutral66),
              overflow: TextOverflow.ellipsis,
            );
          },
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
        widget.controller as EasyPaginationSingleSelectController<T>;
    return ListenableBuilder(
      key: ValueKey(option.value),
      listenable: widget.controller,
      builder: (context, _) {
        final selected = option.value == selectController.selectedOption?.value;
        return EasyPaginationSingleSelectOptionItem<T>(
          index: index,
          option: option,
          selected: selected,
          menuController: menuController,
          onSelectChanged: (val) {
            selectController.select(option.value);
            (widget as EasyPaginationSingleSelect<T>).onChanged?.call(val);
          },
          defaultTitleStyle: defaultTitleStyle,
        );
      },
    );
  }
}
