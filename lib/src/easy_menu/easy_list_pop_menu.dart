import 'dart:math';

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'easy_menu_anchor_layout_delegate.dart';

/// 菜单定位委托
class EasyListPopMenuLayoutDelegate extends EasyMenuAnchorLayoutDelegate {
  final double emptyOptionHeight;

  const EasyListPopMenuLayoutDelegate(this.emptyOptionHeight);

  /// 当底部空间放不下空选项时，向上弹出菜单
  @override
  ({Alignment followerAnchor, Offset offset, Alignment targetAnchor})
  getAlignmentsAndOffset(
    Size? menuSize,
    Rect anchorRect,
    Size overlaySize,
    Offset originOffset,
  ) {
    // anchor左侧到overlay右侧的距离
    final leftSpace = overlaySize.width - anchorRect.left - originOffset.dx;

    // anchor下侧到overlay下侧的距离
    final bottomSpace =
        overlaySize.height - anchorRect.bottom - originOffset.dy;

    var targetAnchor = Alignment.bottomLeft;
    var followerAnchor = Alignment.topLeft;

    if (menuSize != null) {
      if (menuSize.width > leftSpace) {
        targetAnchor = Alignment(1.0, targetAnchor.y);
        followerAnchor = Alignment(1.0, followerAnchor.y);
        originOffset = Offset(-originOffset.dx, originOffset.dy);
      }
      if (emptyOptionHeight > bottomSpace) {
        targetAnchor = Alignment(targetAnchor.x, -1.0);
        followerAnchor = Alignment(targetAnchor.x, 1.0);
        originOffset = Offset(originOffset.dx, -originOffset.dy);
      }
    }

    return (
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      offset: originOffset,
    );
  }

  /// 当底部空间放不下空选项时，高度约束使用顶部空间
  @override
  BoxConstraints getMenuConstraints(
    Rect anchorRect,
    Size overlaySize,
    Offset originOffset,
  ) {
    // anchor左侧到overlay右侧的距离
    final leftSpace = overlaySize.width - anchorRect.left - originOffset.dx;

    // anchor右侧到overlay左侧的距离
    final rightSpace = anchorRect.right - originOffset.dx;

    // anchor上侧到overlay上侧的距离
    final topSpace = anchorRect.top - originOffset.dy;

    // anchor下侧到overlay下侧的距离
    final bottomSpace =
        overlaySize.height - anchorRect.bottom - originOffset.dy;

    return BoxConstraints(
      maxWidth: max(leftSpace, rightSpace),
      maxHeight: emptyOptionHeight > bottomSpace ? topSpace : bottomSpace,
    );
  }
}

/// 菜单选项模型
sealed class EasyListPopMenuOption<T> {
  final T value;
  final String title;

  const factory EasyListPopMenuOption.simple({
    required T value,
    required String title,
  }) = SimpleEasyListPopMenuOption<T>._;

  const factory EasyListPopMenuOption.user({
    required T value,
    required String title,
    required String avatarUrl,
    required String email,
  }) = UserEasyListPopMenuOption<T>._;

  const EasyListPopMenuOption._({required this.value, required this.title});
}

class SimpleEasyListPopMenuOption<T> extends EasyListPopMenuOption<T> {
  const SimpleEasyListPopMenuOption._({
    required super.value,
    required super.title,
  }) : super._();
}

class UserEasyListPopMenuOption<T> extends EasyListPopMenuOption<T> {
  final String avatarUrl;
  final String email;

  const UserEasyListPopMenuOption._({
    required super.value,
    required super.title,
    required this.avatarUrl,
    required this.email,
  }) : super._();
}

/// 菜单选项状态
class EasyListPopMenuOptionsState<T> {
  final bool loading;
  final bool error;
  final List<EasyListPopMenuOption<T>> options;

  const EasyListPopMenuOptionsState({
    required this.loading,
    required this.error,
    required this.options,
  });

  EasyListPopMenuOptionsState<T> copyWith({
    bool? loading,
    bool? error,
    List<EasyListPopMenuOption<T>>? options,
  }) {
    return EasyListPopMenuOptionsState<T>(
      loading: loading ?? this.loading,
      error: error ?? this.error,
      options: options ?? this.options,
    );
  }
}

/// 菜单约束构建函数
typedef EasyListPopMenuConstraintsBuilder =
    BoxConstraints Function(EasyMenuOverlayInfo);

/// PopMenu通用代码
mixin EasyListPopMenuMixin {
  /// 空选项的高度
  final double emptyOptionHeight = 120.0;

  /// 错误选项的高度
  final double errorOptionHeight = 48.0;

  /// 菜单默认constraints
  BoxConstraints defaultMenuConstraintsBuilder(
    EasyMenuOverlayInfo overlayInfo,
  ) {
    return BoxConstraints(
      maxHeight: 300,
      maxWidth: overlayInfo.anchorRect.width,
    );
  }

  /// 菜单选项为空时显示的选项
  Widget emptyOptionBuilder(BuildContext context) {
    return Container(
      height: emptyOptionHeight,
      alignment: Alignment.center,
      child: Text(EasyUiLocalizations.of(context).noOptionsYet),
    );
  }

  /// 加载选项错误界面（分页首次加载错误）
  Widget loadOptionsErrorViewBuilder({VoidCallback? reload}) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: EasyEmptyView(reload: reload),
    );
  }

  /// 加载新项错误的选项（分页加载下一页错误）
  Widget loadNewOptionsErrorBuilder(
    BuildContext context, {
    VoidCallback? reload,
  }) {
    return Container(
      height: errorOptionHeight,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(EasyUiLocalizations.of(context).loadError),
          EasyButton2(
            type: EasyButtonType.text,
            onPressed: reload,
            child: Text(EasyUiLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }

  /// 选项加载中界面
  Widget loadingOptionsViewBuilder(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        color: EasyTheme.of(context).primaryGreen,
      ),
    );
  }

  /// 默认选项标题样式
  TextStyle defaultTitleStyleBuilder(BuildContext context) {
    return TextStyle(fontSize: 14, color: EasyTheme.of(context).neutral66);
  }
}

class EasySingleCheckboxListPopMenu<T> extends StatefulWidget {
  const EasySingleCheckboxListPopMenu({
    super.key,
    this.style,
    required this.optionsState,
    this.reloadOptions,
    required this.initialSelected,
    required this.builder,
    this.onValueChanged,
    this.menuConstraintsBuilder,
    this.searchWidget,
    this.onOpen,
    this.onClose,
  });

  final T? initialSelected;
  final EasyListPopMenuOptionsState<T> optionsState;

  /// 错误界面重新加载按钮点击回调
  final VoidCallback? reloadOptions;
  final EasyMenuAnchorChildBuilder builder;
  final ValueChanged<T>? onValueChanged;
  final EasyMenuStyle? style;

  /// 值为null时使用[EasyListPopMenuMixin]提供的默认值
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;

  /// 搜索组件
  final Widget? searchWidget;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  @override
  State<EasySingleCheckboxListPopMenu<T>> createState() =>
      _EasySingleCheckboxListPopMenuState<T>();
}

class _EasySingleCheckboxListPopMenuState<T>
    extends State<EasySingleCheckboxListPopMenu<T>>
    with EasyListPopMenuMixin {
  late final ValueNotifier<T?> _selectedValue;
  late final ValueNotifier<EasyListPopMenuOptionsState<T>> _optionsValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier(widget.initialSelected);
    _optionsValue = ValueNotifier(widget.optionsState);
  }

  @override
  void didUpdateWidget(covariant EasySingleCheckboxListPopMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != oldWidget.initialSelected) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (oldWidget.initialSelected != widget.initialSelected) {
            _selectedValue.value = widget.initialSelected;
          }
        }
      });
    }
    if (widget.optionsState != oldWidget.optionsState) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (oldWidget.optionsState != widget.optionsState) {
            _optionsValue.value = widget.optionsState;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _selectedValue.dispose();
    _optionsValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EasyMenuAnchor(
      style: widget.style,
      childBuilder: widget.builder,
      layoutDelegate: EasyListPopMenuLayoutDelegate(emptyOptionHeight),
      onOpen: widget.onOpen,
      onClose: widget.onClose,
      menuBuilder: (context, controller, overlayInfo) {
        final constraints =
            widget.menuConstraintsBuilder == null
                ? defaultMenuConstraintsBuilder(overlayInfo)
                : widget.menuConstraintsBuilder!.call(overlayInfo);

        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.searchWidget != null) widget.searchWidget!,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: _optionsValue,
                  builder: (context, optionsState, _) {
                    if (optionsState.loading) {
                      return loadingOptionsViewBuilder(context);
                    } else if (optionsState.error) {
                      return loadOptionsErrorViewBuilder(
                        reload: widget.reloadOptions,
                      );
                    } else {
                      final options = optionsState.options;
                      final itemsIsEmpty = options.isEmpty;

                      if (itemsIsEmpty) {
                        return emptyOptionBuilder(context);
                      }

                      final itemsCount = options.length;
                      return ValueListenableBuilder(
                        valueListenable: _selectedValue,
                        builder: (context, selectedValue, _) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final item = options[index];
                              final selected = item.value == selectedValue;
                              final easyTheme = EasyTheme.of(context);

                              return CheckboxListTile(
                                key: ValueKey(item),
                                value: selected,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                side:
                                    selected
                                        ? BorderSide(color: Colors.transparent)
                                        : BorderSide(
                                          color: easyTheme.neutralEE,
                                        ),
                                fillColor: WidgetStateProperty.resolveWith((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return const Color(0xFFD9D9D9);
                                  }
                                  if (states.contains(WidgetState.selected)) {
                                    return easyTheme.primaryGreen;
                                  }
                                  return Colors.white;
                                }),
                                checkColor: Colors.white,
                                title: Text(
                                  item.title,
                                  style: defaultTitleStyleBuilder(context),
                                ),
                                onChanged: (select) {
                                  if (select == true) {
                                    _selectedValue.value = item.value;
                                    if (controller.isOpen) {
                                      controller.close();
                                    }
                                    widget.onValueChanged?.call(item.value);
                                  }
                                },
                              );
                            },
                            itemCount: itemsCount,
                          );
                        },
                      );
                    }
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

class EasyMultiCheckBoxListPopMenu<T> extends StatefulWidget {
  const EasyMultiCheckBoxListPopMenu({
    super.key,
    this.style,
    required this.optionsState,
    this.reloadOptions,
    required this.initialSelected,
    required this.builder,
    this.onValueChanged,
    this.menuConstraintsBuilder,
    this.showSelectAllItem = true,
    this.selectAllItemTitle,
    this.optionTitleStyle,
    this.searchWidget,
    this.onOpen,
    this.onClose,
  });

  final Iterable<T>? initialSelected;
  final EasyListPopMenuOptionsState<T> optionsState;

  /// 错误界面重新加载按钮点击回调
  final VoidCallback? reloadOptions;
  final EasyMenuAnchorChildBuilder builder;
  final ValueChanged<Iterable<T>>? onValueChanged;
  final EasyMenuStyle? style;

  /// 值为null时使用[EasyListPopMenuMixin]提供的默认值
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;

  /// 是否显示全选选项
  final bool showSelectAllItem;

  /// 全选选项标题
  final String? selectAllItemTitle;

  /// 选项标题样式
  final WidgetStateProperty<TextStyle?>? optionTitleStyle;

  /// 搜索组件
  final Widget? searchWidget;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  @override
  State<EasyMultiCheckBoxListPopMenu<T>> createState() =>
      _EasyMultiCheckBoxListPopMenuState<T>();
}

class _EasyMultiCheckBoxListPopMenuState<T>
    extends State<EasyMultiCheckBoxListPopMenu<T>>
    with EasyListPopMenuMixin {
  late final ValueNotifier<Set<T>> _selectedValue;
  late final ValueNotifier<EasyListPopMenuOptionsState<T>> _optionsValue;

  @override
  void initState() {
    super.initState();
    final set = <T>{};
    if (widget.initialSelected != null) {
      set.addAll(widget.initialSelected!);
    }
    _selectedValue = ValueNotifier(set);
    _optionsValue = ValueNotifier(widget.optionsState);
  }

  @override
  void didUpdateWidget(covariant EasyMultiCheckBoxListPopMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 initialSelected 发生变化时，同步更新内部状态
    if (widget.initialSelected != oldWidget.initialSelected) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final set = <T>{};
          if (widget.initialSelected != null) {
            set.addAll(widget.initialSelected!);
          }
          _selectedValue.value = set;
        }
      });
    }
    if (widget.optionsState != oldWidget.optionsState) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _optionsValue.value = widget.optionsState;
        }
      });
    }
  }

  @override
  void dispose() {
    _selectedValue.dispose();
    _optionsValue.dispose();
    super.dispose();
  }

  bool? isAllItemSelected(List<EasyListPopMenuOption<T>> options) {
    final firstItem = options.firstOrNull;
    if (firstItem == null) {
      return true;
    }

    final selectedValue = _selectedValue.value;
    var selected = selectedValue.contains(firstItem.value);
    for (var item in options) {
      if (selected != selectedValue.contains(item.value)) {
        return null;
      }
    }

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    return EasyMenuAnchor(
      style: widget.style,
      childBuilder: widget.builder,
      layoutDelegate: EasyListPopMenuLayoutDelegate(emptyOptionHeight),
      onOpen: widget.onOpen,
      onClose: widget.onClose,
      menuBuilder: (context, controller, overlayInfo) {
        final constraints =
            widget.menuConstraintsBuilder == null
                ? defaultMenuConstraintsBuilder(overlayInfo)
                : widget.menuConstraintsBuilder!.call(overlayInfo);

        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.searchWidget != null) widget.searchWidget!,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: _optionsValue,
                  builder: (context, optionsState, _) {
                    if (optionsState.loading) {
                      return loadingOptionsViewBuilder(context);
                    } else if (optionsState.error) {
                      return loadOptionsErrorViewBuilder(
                        reload: widget.reloadOptions,
                      );
                    } else {
                      final options = optionsState.options;
                      final itemsIsEmpty = options.isEmpty;

                      if (itemsIsEmpty) {
                        return emptyOptionBuilder(context);
                      }

                      TextStyle? getTitleStyle(
                        BuildContext context,
                        bool selected,
                      ) {
                        return widget.optionTitleStyle != null
                            ? widget.optionTitleStyle!.resolve(
                              selected ? {WidgetState.selected} : {},
                            )
                            : defaultTitleStyleBuilder(context);
                      }

                      final contentPadding = EdgeInsets.only(
                        left: 16,
                        right: 16,
                      );

                      return ValueListenableBuilder(
                        valueListenable: _selectedValue,
                        builder: (context, selected, _) {
                          final easyTheme = EasyTheme.of(context);
                          final isAllSelected = isAllItemSelected(options);
                          return CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              if (widget.showSelectAllItem)
                                SliverToBoxAdapter(
                                  child: CheckboxListTile(
                                    key: UniqueKey(),
                                    value: isAllSelected,
                                    contentPadding: contentPadding,
                                    tristate: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    side:
                                        isAllSelected == true
                                            ? BorderSide(
                                              color: Colors.transparent,
                                            )
                                            : BorderSide(
                                              color: easyTheme.neutralEE,
                                            ),
                                    fillColor: WidgetStateProperty.resolveWith((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.disabled,
                                      )) {
                                        return const Color(0xFFD9D9D9);
                                      }
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return isAllSelected == null
                                            ? easyTheme.primaryGreen.withAlpha(
                                              0x33,
                                            )
                                            : easyTheme.primaryGreen;
                                      }
                                      return Colors.white;
                                    }),
                                    checkColor:
                                        isAllSelected == null
                                            ? easyTheme.primaryGreen
                                            : Colors.white,
                                    title: Text(
                                      widget.selectAllItemTitle ??
                                          EasyUiLocalizations.of(
                                            context,
                                          ).pickAll,
                                      style: getTitleStyle(
                                        context,
                                        isAllSelected == true,
                                      ),
                                    ),
                                    onChanged: (_) {
                                      if (isAllSelected == true) {
                                        _selectedValue.value = {};
                                        widget.onValueChanged?.call(
                                          _selectedValue.value,
                                        );
                                      } else {
                                        _selectedValue.value = Set.of(
                                          options.map((e) => e.value),
                                        );
                                        widget.onValueChanged?.call(
                                          _selectedValue.value,
                                        );
                                      }
                                    },
                                  ),
                                ),
                              SliverPrototypeExtentList(
                                delegate: SliverChildBuilderDelegate((
                                  context,
                                  index,
                                ) {
                                  final item = options[index];
                                  final selected = _selectedValue.value
                                      .contains(item.value);

                                  void onChanged(bool? _) {
                                    final preValue = Set.of(
                                      _selectedValue.value,
                                    );
                                    if (!selected) {
                                      _selectedValue.value =
                                          preValue..add(item.value);
                                      widget.onValueChanged?.call(
                                        _selectedValue.value,
                                      );
                                    } else {
                                      _selectedValue.value =
                                          preValue..remove(item.value);
                                      widget.onValueChanged?.call(
                                        _selectedValue.value,
                                      );
                                    }
                                  }

                                  final titleStyle = getTitleStyle(
                                    context,
                                    selected,
                                  );

                                  return switch (item) {
                                    SimpleEasyListPopMenuOption<T>() =>
                                      CheckboxListTile(
                                        key: ValueKey(item),
                                        contentPadding: contentPadding,
                                        value: selected,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        side:
                                            selected
                                                ? BorderSide(
                                                  color: Colors.transparent,
                                                )
                                                : BorderSide(
                                                  color: easyTheme.neutralEE,
                                                ),
                                        fillColor:
                                            WidgetStateProperty.resolveWith((
                                              states,
                                            ) {
                                              if (states.contains(
                                                WidgetState.disabled,
                                              )) {
                                                return const Color(0xFFD9D9D9);
                                              }
                                              if (states.contains(
                                                WidgetState.selected,
                                              )) {
                                                return easyTheme.primaryGreen;
                                              }
                                              return Colors.white;
                                            }),
                                        checkColor: Colors.white,
                                        title: Tooltip(
                                          message: item.title,
                                          preferBelow: false,
                                          child: Text(
                                            item.title,
                                            style: titleStyle,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        onChanged: onChanged,
                                      ),
                                    UserEasyListPopMenuOption<T>() =>
                                      _UserCheckBoxListTile(
                                        key: ValueKey(item),
                                        padding: contentPadding,
                                        value: selected,
                                        titleStyle: titleStyle,
                                        onChanged: onChanged,
                                        title: item.title,
                                        avatar: item.avatarUrl,
                                        email: item.email,
                                      ),
                                  };
                                }, childCount: options.length),
                                prototypeItem: switch (options.first) {
                                  SimpleEasyListPopMenuOption<T>() =>
                                    CheckboxListTile(
                                      title: Text(
                                        'data',
                                        style: getTitleStyle(context, false),
                                        maxLines: 1,
                                      ),
                                      value: false,
                                      onChanged: null,
                                    ),
                                  UserEasyListPopMenuOption<T>() => SizedBox(
                                    height: _UserCheckBoxListTile.height,
                                  ),
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
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

class EasySingleCheckListTilePopMenu<T> extends StatefulWidget {
  const EasySingleCheckListTilePopMenu({
    super.key,
    this.style,
    required this.optionsState,
    this.reloadOptions,
    required this.initialSelected,
    required this.builder,
    this.onValueChanged,
    this.menuConstraintsBuilder,
    this.searchWidget,
    this.onOpen,
    this.onClose,
  });

  final T? initialSelected;
  final EasyListPopMenuOptionsState<T> optionsState;

  /// 错误界面重新加载按钮点击回调
  final VoidCallback? reloadOptions;
  final EasyMenuAnchorChildBuilder builder;
  final ValueChanged<T>? onValueChanged;
  final EasyMenuStyle? style;

  /// 值为null时使用[EasyListPopMenuMixin]提供的默认值
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;

  /// 搜索组件
  final Widget? searchWidget;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  @override
  State<EasySingleCheckListTilePopMenu<T>> createState() =>
      _EasySingleCheckListTilePopMenuState<T>();
}

class _EasySingleCheckListTilePopMenuState<T>
    extends State<EasySingleCheckListTilePopMenu<T>>
    with EasyListPopMenuMixin {
  late final ValueNotifier<T?> _selectedValue;
  late final ValueNotifier<EasyListPopMenuOptionsState<T>> _optionsValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = ValueNotifier(widget.initialSelected);
    _optionsValue = ValueNotifier(widget.optionsState);
  }

  @override
  void didUpdateWidget(covariant EasySingleCheckListTilePopMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelected != oldWidget.initialSelected) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (oldWidget.initialSelected != widget.initialSelected) {
            _selectedValue.value = widget.initialSelected;
          }
        }
      });
    }
    if (widget.optionsState != oldWidget.optionsState) {
      // 使用 addPostFrameCallback 避免在构建过程中触发重建
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          if (oldWidget.optionsState != widget.optionsState) {
            _optionsValue.value = widget.optionsState;
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _selectedValue.dispose();
    _optionsValue.dispose();
    super.dispose();
  }

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
      childBuilder: widget.builder,
      layoutDelegate: EasyListPopMenuLayoutDelegate(emptyOptionHeight),
      onOpen: widget.onOpen,
      onClose: widget.onClose,
      menuBuilder: (context, controller, overlayInfo) {
        final constraints =
            widget.menuConstraintsBuilder == null
                ? defaultMenuConstraintsBuilder(overlayInfo)
                : widget.menuConstraintsBuilder!.call(overlayInfo);

        return ConstrainedBox(
          constraints: constraints,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.searchWidget != null) widget.searchWidget!,
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: _optionsValue,
                  builder: (context, optionsState, _) {
                    if (optionsState.loading) {
                      return loadingOptionsViewBuilder(context);
                    } else if (optionsState.error) {
                      return loadOptionsErrorViewBuilder(
                        reload: widget.reloadOptions,
                      );
                    } else {
                      final options = optionsState.options;
                      final itemsIsEmpty = options.isEmpty;

                      if (itemsIsEmpty) {
                        return emptyOptionBuilder(context);
                      }

                      final itemsCount = options.length;
                      return ValueListenableBuilder(
                        valueListenable: _selectedValue,
                        builder: (context, selectedValue, _) {
                          return Material(
                            color: Colors.transparent,
                            borderRadius: menuBorderRadius,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = options[index];
                                final selected = item.value == selectedValue;
                                final easyTheme = EasyTheme.of(context);
                                final titleStyle = TextStyle(
                                  color:
                                      selected
                                          ? easyTheme.primaryGreen
                                          : easyTheme.neutral66,
                                  fontSize: 16,
                                  height: 1,
                                );
                                final contentPadding = EdgeInsets.only(
                                  left: 24,
                                  right: 16,
                                );

                                return switch (item) {
                                  SimpleEasyListPopMenuOption<T>() => ListTile(
                                    key: ValueKey(item),
                                    contentPadding: contentPadding,
                                    title: Text(item.title, style: titleStyle),
                                    trailing:
                                        selected
                                            ? SvgPicture.asset(
                                              'assets/svgs/ic_selected.svg',
                                              package: 'easy_ui',
                                            )
                                            : null,
                                    onTap:
                                        selected
                                            ? null
                                            : () {
                                              _selectedValue.value = item.value;
                                              if (controller.isOpen) {
                                                controller.close();
                                              }
                                              widget.onValueChanged?.call(
                                                item.value,
                                              );
                                            },
                                  ),
                                  UserEasyListPopMenuOption<T>() =>
                                    _UserCheckBoxListTile(
                                      value: selected,
                                      avatar: item.avatarUrl,
                                      title: item.title,
                                      email: item.email,
                                      titleStyle: defaultTitleStyleBuilder(
                                        context,
                                      ),
                                      padding: contentPadding,
                                      checkBoxShape: CircleBorder(),
                                      onChanged: (_) {
                                        if (selected) {
                                          return;
                                        }
                                        _selectedValue.value = item.value;
                                        if (controller.isOpen) {
                                          controller.close();
                                        }
                                        widget.onValueChanged?.call(item.value);
                                      },
                                    ),
                                };
                              },
                              itemCount: itemsCount,
                            ),
                          );
                        },
                      );
                    }
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

class _UserCheckBoxListTile extends StatelessWidget {
  const _UserCheckBoxListTile({
    super.key,
    required this.value,
    this.onChanged,
    required this.avatar,
    required this.title,
    required this.email,
    required this.titleStyle,
    required this.padding,
    this.checkBoxShape,
  });

  static const double height = 50.0;

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String avatar;
  final String title;
  final String email;
  final TextStyle? titleStyle;
  final EdgeInsets padding;
  final OutlinedBorder? checkBoxShape;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final initials = computeInitials(title);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () {
          onChanged?.call(!value);
        },
        child: Container(
          height: height,
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                shape: checkBoxShape,
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.disabled)) {
                    return const Color(0xFFD9D9D9);
                  }
                  if (states.contains(WidgetState.selected)) {
                    return easyTheme.primaryGreen;
                  }
                  return Colors.white;
                }),
                checkColor: Colors.white,
                side:
                    value
                        ? BorderSide(color: Colors.transparent)
                        : BorderSide(color: easyTheme.neutralEE),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12, right: 8),
                child: EasyAvatar.withUsername(
                  size: 32,
                  src: avatar,
                  username: title,
                ),
              ),
              Expanded(
                child: Tooltip(
                  message: '$title\n$email',
                  preferBelow: false,
                  exitDuration: Duration.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 12,
                          color: easyTheme.neutral99,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
