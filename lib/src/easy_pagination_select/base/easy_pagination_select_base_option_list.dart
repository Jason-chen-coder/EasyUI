import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../easy_menu/easy_list_pop_menu.dart';
import '../../easy_menu/easy_menu_anchor.dart';
import '../../easy_menu/easy_menu_style.dart';
import '../../easy_theme.dart';
import 'easy_pagination_select_base_controller.dart';

typedef EasyPaginationSelectItemBuilder<T> =
    Widget Function(
      BuildContext context,
      EasyListPopMenuOption<T> option,
      int index,
      EasyMenuController menuController,
      TextStyle defaultTitleStyle,
    );

typedef EasyPaginationSelectPrototypeItemBuilder<T> =
    Widget? Function(
      EasyListPopMenuOption<T> option,
      TextStyle defaultTitleStyle,
    );

class EasyPaginationSelectBaseOptionList<T> extends StatefulWidget {
  const EasyPaginationSelectBaseOptionList({
    super.key,
    this.style,
    required this.childBuilder,
    required this.itemBuilder,
    required this.prototypeItemBuilder,
    this.menuConstraintsBuilder,
    this.onOpen,
    this.onClose,
    this.filterable = false,
    required this.searchHintText,
    required this.selectorController,
    this.beforeMenuListitemBuilder,
  });

  final EasyMenuAnchorChildBuilder childBuilder;
  final EasyPaginationSelectItemBuilder<T> itemBuilder;
  final EasyPaginationSelectPrototypeItemBuilder<T> prototypeItemBuilder;
  final EasyMenuStyle? style;

  /// 值为null时使用[EasyListPopMenuMixin]提供的默认值
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  /// 是否可以搜索
  final bool filterable;

  final String? searchHintText;

  final EasyPaginationSelectBaseController<T> selectorController;

  /// 列表前的组件 (用于放置多选状态时的"选择全部"选项等)
  final Widget? Function(TextStyle defaultTitleStyle)?
  beforeMenuListitemBuilder;

  @override
  State<EasyPaginationSelectBaseOptionList<T>> createState() =>
      _EasyPaginationSelectBaseOptionListState<T>();
}

class _EasyPaginationSelectBaseOptionListState<T>
    extends State<EasyPaginationSelectBaseOptionList<T>>
    with EasyListPopMenuMixin {
  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    var menuStyle =
        widget.style ??
        EasyMenuStyle(
          boxShadows: [],
          boxBorder: Border.all(color: easyTheme.neutralEE),
        );
    menuStyle = menuStyle.merge(easyTheme.easyMenuStyle);
    final menuBorderRadius = menuStyle.borderRadius?.resolve(
      Directionality.of(context),
    );

    return EasyMenuAnchor(
      style: menuStyle,
      childBuilder: widget.childBuilder,
      layoutDelegate: EasyListPopMenuLayoutDelegate(emptyOptionHeight),
      onOpen: widget.onOpen,
      onClose: widget.onClose,
      menuBuilder: (context, menuController, overlayInfo) {
        final constraints =
            widget.menuConstraintsBuilder == null
                ? defaultMenuConstraintsBuilder(overlayInfo)
                : widget.menuConstraintsBuilder!.call(overlayInfo);

        final pagingController = widget.selectorController.pagingController;

        final defaultTextStyle = defaultTitleStyleBuilder(context);

        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.filterable)
                _EasySelectSearchBar<T>(
                  initialSearchWord: widget.selectorController.searchKey,
                  onSearchWordChanged: widget.selectorController.search,
                  hintText: widget.searchHintText,
                ),
              Flexible(
                child:
                /// [PagingListener] 是一个监听控制器并
                /// 根据控制器状态重建 UI 的小部件。
                /// 这是将控制器绑定到分页布局的最简单方法。
                PagingListener(
                  controller: pagingController,
                  builder: (context, state, fetchNextPage) {
                    /// 分页布局依赖于 [PagingState] 和 [fetchNextPage] 函数。
                    return Material(
                      color: Colors.transparent,
                      borderRadius: menuBorderRadius,
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          if (widget.beforeMenuListitemBuilder != null &&
                              (state.status == PagingStatus.completed ||
                                  state.status == PagingStatus.ongoing))
                            SliverToBoxAdapter(
                              child: widget.beforeMenuListitemBuilder!(
                                defaultTextStyle,
                              ),
                            ),
                          PagedSliverList<int, EasyListPopMenuOption<T>>(
                            shrinkWrapFirstPageIndicators: true,
                            addAutomaticKeepAlives: false,
                            state: state,
                            fetchNextPage: fetchNextPage,
                            prototypeItem: () {
                              final option = state.items?.firstOrNull;
                              if (option == null) return null;
                              return widget.prototypeItemBuilder(
                                option,
                                defaultTextStyle,
                              );
                            }(),
                            builderDelegate: PagedChildBuilderDelegate(
                              animateTransitions: true,
                              firstPageProgressIndicatorBuilder:
                                  loadingOptionsViewBuilder,
                              firstPageErrorIndicatorBuilder: (context) {
                                return loadOptionsErrorViewBuilder(
                                  reload: pagingController.refresh,
                                );
                              },
                              newPageProgressIndicatorBuilder:
                                  loadingOptionsViewBuilder,
                              newPageErrorIndicatorBuilder:
                                  (context) => loadNewOptionsErrorBuilder(
                                    context,
                                    reload: pagingController.fetchNextPage,
                                  ),
                              noItemsFoundIndicatorBuilder: emptyOptionBuilder,
                              itemBuilder: (context, item, index) {
                                return widget.itemBuilder(
                                  context,
                                  item,
                                  index,
                                  menuController,
                                  defaultTextStyle,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EasySelectSearchBar<T> extends StatefulWidget {
  const _EasySelectSearchBar({
    this.initialSearchWord,
    required this.onSearchWordChanged,
    this.hintText,
  });

  final String? initialSearchWord;
  final ValueChanged<String> onSearchWordChanged;
  final String? hintText;

  @override
  State<_EasySelectSearchBar<T>> createState() =>
      _EasySelectSearchBarState<T>();
}

class _EasySelectSearchBarState<T> extends State<_EasySelectSearchBar<T>> {
  final _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.initialSearchWord ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onSearchWordChanged,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        isDense: true,
        prefixIcon: Container(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: SvgPicture.asset(
            'assets/svgs/ic_search.svg',
            package: 'easy_ui',
            colorFilter: ColorFilter.mode(easyTheme.neutral99, BlendMode.srcIn),
            width: 16,
            height: 16,
          ),
        ),
        prefixIconConstraints: BoxConstraints.tightFor(width: 56),
        suffixIcon: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  _controller.clear();
                  widget.onSearchWordChanged('');
                },
                customBorder: CircleBorder(),
                child: Icon(Icons.close, size: 16, color: easyTheme.neutral99),
              ),
            );
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 16, color: easyTheme.neutral99),
      ),
    );
  }
}
