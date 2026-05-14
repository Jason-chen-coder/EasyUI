import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../easy_menu/easy_list_pop_menu.dart';
import '../easy_menu/easy_menu_anchor.dart';
import '../easy_menu/easy_menu_style.dart';
import '../easy_theme.dart';
import '../l10n/gen/easy_ui_localizations.dart';
import 'easy_pagination_select_option_item.dart';
import 'base/easy_pagination_select_base_controller.dart';
import 'base/easy_pagination_select_base_option_list.dart';
import 'multiple/easy_pagination_multiple_select_controller.dart';
import 'single/easy_pagination_single_select_controller.dart';

part 'multiple/easy_pagination_multiple_select.dart';
part 'single/easy_pagination_single_select.dart';

sealed class EasyPaginationSelect<T> extends StatefulWidget {
  const EasyPaginationSelect({
    super.key,
    this.placeholder,
    this.width,
    this.height = 38,
    this.style,
    this.menuConstraintsBuilder,
    this.clearable = false,
    this.filterable = false,
    required this.controller,
    this.textStyle,
    this.placeholderTextStyle,
    this.padding,
    this.searchHintText,
    this.borderColor,
    this.autoDisposeController = true,
  });

  final String? placeholder;
  final double? width;
  final double height;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final bool clearable;
  final bool filterable;
  final EasyPaginationSelectBaseController<T> controller;
  final TextStyle? textStyle;
  final TextStyle? placeholderTextStyle;
  final EdgeInsets? padding;
  final String? searchHintText;
  final Color? borderColor;

  /// 是否在组件销毁时自动释放 controller
  /// 默认值为`true` 适用于大多数场景
  final bool autoDisposeController;

  @override
  State<EasyPaginationSelect<T>> createState();

  /// 创建一个单选的下拉选择器
  const factory EasyPaginationSelect.single({
    ValueChanged<T?>? onChanged,
    String? placeholder,
    double? width,
    double height,
    EasyMenuStyle? style,
    EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder,
    bool clearable,
    bool filterable,
    required EasyPaginationSingleSelectController<T> controller,
    TextStyle? textStyle,
    TextStyle? placeholderTextStyle,
    EdgeInsets? padding,
    String? searchHintText,
    Color? borderColor,
    bool autoDisposeController,
  }) = EasyPaginationSingleSelect<T>._;

  /// 创建一个多选的下拉选择器
  const factory EasyPaginationSelect.multiple({
    ValueChanged<List<T>>? onChanged,
    String? placeholder,
    double? width,
    double height,
    EasyMenuStyle? style,
    EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder,
    bool clearable,
    bool filterable,
    required EasyPaginationMultipleSelectController<T> controller,
    TextStyle? textStyle,
    TextStyle? placeholderTextStyle,
    EdgeInsets? padding,
    String? searchHintText,
    Color? borderColor,
    bool autoDisposeController,
    bool showSelectAllItem,
    String? selectAllItemTitle,
  }) = EasyPaginationMultipleSelect<T>._;
}

abstract class EasyPaginationSelectState<T>
    extends State<EasyPaginationSelect<T>> {
  final _isHover = ValueNotifier<bool>(false);
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    if (mounted && widget.autoDisposeController) {
      widget.controller.dispose();
    }
    super.dispose();
  }

  void handelClearSelection() {
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.controller,
      builder: (context, _) {
        return EasyPaginationSelectBaseOptionList<T>(
          style: widget.style,
          filterable: widget.filterable,
          childBuilder: (context, controller, child) {
            return _buildTrigger(controller);
          },
          itemBuilder: menuItemBuilder,
          prototypeItemBuilder: prototypeItemBuilder,
          menuConstraintsBuilder: widget.menuConstraintsBuilder,
          onOpen: _focusNode.requestFocus,
          onClose: () {
            _focusNode.unfocus();
            _isHover.value = false;
          },
          searchHintText: widget.searchHintText,
          beforeMenuListitemBuilder: beforeMenuListitemBuilder,
          selectorController: widget.controller,
        );
      },
    );
  }

  _buildTrigger(EasyMenuController menuController) {
    return Builder(
      builder: (context) {
        final theme = EasyTheme.of(context);
        return InkWell(
          focusNode: _focusNode,
          onTap: () {
            if (menuController.isOpen) {
              menuController.close();
            } else {
              menuController.open();
            }
          },
          onTapDown: (details) {
            /// hover 状态兼容触屏设备
            if (details.kind == PointerDeviceKind.touch) {
              if (!menuController.isOpen) {
                _isHover.value = true;
              }
            }
          },
          borderRadius: BorderRadius.all(EasyTheme.of(context).cornerSmall),
          child: MouseRegion(
            onEnter: (_) => _isHover.value = true,
            onExit: (_) => _isHover.value = false,
            child: Container(
              width: widget.width,
              height: widget.height,
              padding:
                  widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.all(theme.cornerSmall),
                border: Border.all(
                  color: widget.borderColor ?? theme.neutralEE,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 当 filterable 为 true 时，根据状态切换输入框/展示UI
                  Expanded(child: labelBuilder(menuController.isOpen)),
                  _buildTrailing(menuController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailing(EasyMenuController menuController) {
    return ValueListenableBuilder(
      valueListenable: _isHover,
      builder: (context, isHover, _) {
        final theme = EasyTheme.of(context);
        final haveSelected = context
            .select<EasyPaginationSelectBaseController<T>, bool>(
              (controller) => controller.hasSelected,
            );
        if (widget.clearable && haveSelected && isHover) {
          return InkWell(
            onTap: () => handelClearSelection(),
            borderRadius: BorderRadius.circular(10),
            child: Icon(Icons.close, size: 16, color: theme.neutral99),
          );
        } else {
          return Icon(
            menuController.isOpen
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            size: 16,
            color: theme.neutral99,
          );
        }
      },
    );
  }

  /// 构建显示选中项的区域
  Widget labelBuilder(bool menuIsOpen);

  /// 菜单列表前的组件 (用于放置多选状态时的"选择全部"选项等)
  Widget? beforeMenuListitemBuilder(TextStyle defaultTitleStyle) => null;

  /// 构建菜单列表项
  Widget menuItemBuilder(
    BuildContext context,
    EasyListPopMenuOption<T> option,
    int index,
    EasyMenuController menuController,
    TextStyle defaultTitleStyle,
  );

  /// 构建菜单列表项的原型组件，用于性能优化
  Widget? prototypeItemBuilder(
    EasyListPopMenuOption<T> option,
    TextStyle defaultTitleStyle,
  ) => null;
}
