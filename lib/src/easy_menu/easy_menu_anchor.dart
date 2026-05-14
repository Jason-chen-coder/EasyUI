import 'dart:async';

import 'package:easy_ui/src/easy_menu/easy_menu_anchor_layout_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../easy_theme.dart';
import 'easy_menu_style.dart';

/// Anchor and menu information passed to [EasyMenuAnchor].
@immutable
class EasyMenuOverlayInfo {
  /// Creates a [EasyMenuOverlayInfo].
  const EasyMenuOverlayInfo({
    required this.anchorRect,
    required this.overlaySize,
  });

  /// The position of the anchor widget that the menu is attached to, relative to
  /// the nearest ancestor [Overlay] when [RawMenuAnchor.useRootOverlay] is false,
  /// or the root [Overlay] when [RawMenuAnchor.useRootOverlay] is true.
  final Rect anchorRect;

  /// The [Size] of the overlay that the menu is being shown in.
  final Size overlaySize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is EasyMenuOverlayInfo &&
        other.anchorRect == anchorRect &&
        other.overlaySize == overlaySize;
  }

  @override
  int get hashCode {
    return Object.hash(anchorRect, overlaySize);
  }
}

typedef EasyMenuAnchorMenuBuilder =
    Widget Function(
      BuildContext context,
      EasyMenuController controller,
      EasyMenuOverlayInfo overlayInfo,
    );

typedef EasyMenuAnchorChildBuilder =
    Widget Function(
      BuildContext context,
      EasyMenuController controller,
      Widget? child,
    );

typedef EasyMenuAnchorTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

class EasyMenuAnchor extends StatefulWidget {
  const EasyMenuAnchor({
    super.key,
    required this.childBuilder,
    required this.menuBuilder,
    this.style,
    this.child,
    this.offset = const Offset(0, 2),
    this.layoutDelegate = const EasyMenuAnchorLayoutDelegate(),
    this.onOpen,
    this.onClose,
    this.transitionBuilder,
  });

  /// 被挂载的组件builder
  final EasyMenuAnchorChildBuilder childBuilder;

  /// 菜单builder
  final EasyMenuAnchorMenuBuilder menuBuilder;

  /// 被挂载的Widget
  final Widget? child;

  /// 样式
  final EasyMenuStyle? style;

  /// 相对于锚点的偏移量.
  ///
  /// 在[layoutDelegate]为[EasyMenuAnchorLayoutDelegateDefault]时按以下方式生效：
  ///
  /// 当菜单左侧对齐child左侧时,正数的横轴偏移量会使菜单向右移动,负数的横轴偏移量会使菜单向左移动.
  ///
  /// 当菜单右侧对齐child右侧时,正数的横轴偏移量会使菜单向左移动,负数的横轴偏移量会使菜单向右移动.
  ///
  /// 当菜单位于child下方时,正数的纵轴偏移量会使菜单向下移动,负数的纵轴偏移量会使菜单向上移动.
  ///
  /// 当菜单位于child下方时,正数的纵轴偏移量会使菜单向上移动,负数的纵轴偏移量会使菜单向下移动.
  final Offset offset;

  /// 菜单定位和约束代理
  final EasyMenuAnchorLayoutDelegate layoutDelegate;

  /// 菜单打开回调
  final VoidCallback? onOpen;

  /// 菜单关闭回调
  final VoidCallback? onClose;

  /// 自定义菜单动画函数
  final EasyMenuAnchorTransitionBuilder? transitionBuilder;

  @override
  State<EasyMenuAnchor> createState() => _EasyMenuAnchorState();
}

class _EasyMenuAnchorState extends State<EasyMenuAnchor>
    with SingleTickerProviderStateMixin {
  final _controller = EasyMenuController();
  final _anchorKey = GlobalKey();

  late final AnimationController _animationController;

  /// 开始执行收起动画时为false.Overlay插入菜单时为true.中断收起动画时为true.
  late final ValueNotifier<bool> _isOpen;

  /// 菜单大小.在Overlay插入菜单前会赋值为null,获取到菜单大小后下一帧会赋值给这
  /// 个变量.
  ///
  /// 当这个值为null时,Overlay上的菜单会通过[Offstage]渲染但不显示.
  late final ValueNotifier<Size?> _menuSize;

  /// 每次在Overlay插入OverlayEntry时会创建一个Completer并赋值给该变量,
  /// 当通过[_EasyMenuSizeMeasurer]获取到菜单的大小后下一帧会完成这个Completer.
  ///
  /// 每次调用[_showOverlay]和[_hideOverlay]前都会等待这个Completer完成.
  Completer<void>? _menuSizeMeasureCompleter;

  final _overlayPortalController = OverlayPortalController();

  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.medium2,
    );
    _controller._attach(this);
    _isOpen = ValueNotifier(false);
    _menuSize = ValueNotifier(null);
  }

  @override
  void dispose() {
    _controller._detach(this);
    _animationController.dispose();
    _isOpen.dispose();
    _menuSize.dispose();
    _menuSizeMeasureCompleter?.complete();
    _menuSizeMeasureCompleter = null;
    super.dispose();
  }

  /// 每次在Overlay插菜单前会创建一个[Completer]并赋值给[_menuSizeMeasureCompleter],
  /// 当通过[_EasyMenuSizeMeasurer]获取到菜单的大小后下一帧会完成这个Completer.
  /// 每次调用[_showOverlay]和[_hideOverlay]前都会等待这个Completer完成.
  ///
  /// 为了能够获取到菜单完整展开后的大小再对菜单进行定位.通过Overlay插入菜单前会设置
  /// [_animationController]值为上界,直到[_EasyMenuSizeMeasurer]获取到菜单大小的下一
  /// 帧再把[_animationController]的值设置为下界并播放动画.
  ///
  void _showOverlay() async {
    if (_overlayPortalController.isShowing) {
      _isOpen.value = true;
      _animationController.forward();
      return;
    }

    if (_menuSizeMeasureCompleter?.isCompleted == false) {
      return;
    }

    _menuSizeMeasureCompleter = Completer();
    _menuSizeMeasureCompleter!.future.whenComplete(
      () => _menuSizeMeasureCompleter = null,
    );

    _isOpen.value = true;
    _menuSize.value = null;
    _animationController.value = 1.0;
    _overlayPortalController.show();
    widget.onOpen?.call();
  }

  void _hideOverlay() async {
    if (_menuSizeMeasureCompleter?.isCompleted == false || !_isOpen.value) {
      return;
    }

    _isOpen.value = false;
    _animationController.reverse().then((_) {
      _overlayPortalController.hide();
      widget.onClose?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    final style =
        widget.style == null
            ? theme.easyMenuStyle
            : widget.style!.merge(theme.easyMenuStyle);
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayPortalController,
        overlayChildBuilder: (context) {
          final anchorContext = _anchorKey.currentContext!;

          final anchorBox = anchorContext.findRenderObject()! as RenderBox;

          final upperLeft = anchorBox.localToGlobal(Offset.zero);
          final bottomRight = anchorBox.localToGlobal(
            anchorBox.size.bottomRight(Offset.zero),
          );
          final anchorRect = Rect.fromPoints(upperLeft, bottomRight);
          // 由于使用了OverlayPortal,所以overlay的size就是窗口大小
          final overlaySize = MediaQuery.of(context).size;
          final overlayInfo = EasyMenuOverlayInfo(
            anchorRect: anchorRect,
            overlaySize: overlaySize,
          );

          final childConstraints = widget.layoutDelegate.getMenuConstraints(
            anchorRect,
            overlaySize,
            widget.offset,
          );

          return ValueListenableBuilder(
            valueListenable: _menuSize,
            builder: (context, menuSize, _) {
              final (:targetAnchor, :followerAnchor, :offset) = widget
                  .layoutDelegate
                  .getAlignmentsAndOffset(
                    menuSize,
                    anchorRect,
                    overlaySize,
                    widget.offset,
                  );

              final child = _EasyMenuSizeMeasurer(
                onChildSizeChange: (childSize) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _menuSize.value = childSize;
                    _animationController.reset();
                    _animationController.forward();
                    if (_menuSizeMeasureCompleter?.isCompleted == false) {
                      _menuSizeMeasureCompleter?.complete();
                    }
                  });
                },
                child: ConstrainedBox(
                  constraints: childConstraints,
                  child: Material(
                    color: Colors.transparent,
                    child: widget.menuBuilder(
                      context,
                      _controller,
                      overlayInfo,
                    ),
                  ),
                ),
              );

              return Positioned(
                left: 0,
                top: 0,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor: targetAnchor,
                  followerAnchor: followerAnchor,
                  offset: offset,
                  child: Offstage(
                    offstage: menuSize == null,
                    child: TapRegion(
                      groupId: _controller,
                      onTapOutside: (event) {
                        _hideOverlay();
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: style.backgroundColor,
                          borderRadius: style.borderRadius,
                          boxShadow: style.boxShadows,
                          border: style.boxBorder,
                        ),
                        child:
                            widget.transitionBuilder != null
                                ? AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) {
                                    return widget.transitionBuilder!.call(
                                      context,
                                      _animationController,
                                      child!,
                                    );
                                  },
                                  child: child,
                                )
                                : SizeTransition(
                                  sizeFactor: _animationController.drive(
                                    Tween(begin: .0, end: 1.0).chain(
                                      CurveTween(curve: Curves.easeInOut),
                                    ),
                                  ),
                                  fixedCrossAxisSizeFactor: 1.0,
                                  axisAlignment: -1.0,
                                  child: child,
                                ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: TapRegion(
          groupId: _controller,
          onTapOutside: (event) {
            _hideOverlay();
          },
          child: ValueListenableBuilder(
            key: _anchorKey,
            valueListenable: _isOpen,
            builder: (context, value, child) {
              return widget.childBuilder(context, _controller, child);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// 菜单控制器
class EasyMenuController {
  _EasyMenuAnchorState? _anchor;

  bool get isAttached => _anchor != null;

  /// 菜单是否处于打开状态
  bool get isOpen {
    assert(_anchor != null);
    return _anchor!._isOpen.value;
  }

  void _attach(_EasyMenuAnchorState anchor) {
    assert(_anchor == null);
    _anchor = anchor;
  }

  void _detach(_EasyMenuAnchorState anchor) {
    assert(_anchor == anchor);
    _anchor = null;
  }

  /// 打开菜单
  void open() {
    assert(isAttached);
    _anchor!._showOverlay();
  }

  /// 关闭菜单
  void close() {
    assert(isAttached);
    _anchor!._hideOverlay();
  }
}

/// 在第一次 layout 时把 child 的尺寸通过回调抛出。
class _EasyMenuSizeMeasurer extends SingleChildRenderObjectWidget {
  const _EasyMenuSizeMeasurer({
    super.child,
    required this.onChildSizeChange,
  });

  /// 发生在第一次布局阶段.
  final ValueChanged<Size> onChildSizeChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderEasyMenuSizeMeasurer(onChildSizeChange);
  }
}

class _RenderEasyMenuSizeMeasurer extends RenderProxyBox {
  _RenderEasyMenuSizeMeasurer(this.onChildSizeChange);

  final ValueChanged<Size> onChildSizeChange;

  bool _measured = false;

  @override
  void performLayout() {
    super.performLayout();

    if (!_measured) {
      _measured = true;
      onChildSizeChange(child!.size);
    }
  }
}
