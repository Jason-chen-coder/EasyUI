import 'package:flutter/material.dart';
import 'dart:async';

import '../../easy_ui.dart';

/// 抽屉渲染模式
enum DrawerRenderMode {
  /// 全屏模式：使用 PageRoute，抽屉显示在整个屏幕上
  route,

  /// 容器模式：使用 Overlay，抽屉显示在容器内，会跟随容器滚动
  /// 注意：使用此模式时，容器必须包含 Overlay widget
  overlay,
}

/// 提供抽屉关闭能力到子树，便于头部返回按钮直接关闭当前由 EasyDrawerWrapper 打开的抽屉
class EasyDrawerScope extends InheritedWidget {
  final VoidCallback close;

  const EasyDrawerScope({super.key, required this.close, required super.child});

  static EasyDrawerScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EasyDrawerScope>();
  }

  /// 异步关闭抽屉，等待关闭动画完成后再返回
  ///
  /// 使用示例：
  /// ```dart
  /// await EasyDrawerScope.tryCloseAsync(context);
  /// // 后续代码在关闭动画完成后执行
  /// context.push('/nextPage');
  /// ```
  static Future<bool> tryCloseAsync(BuildContext context) async {
    // 检查 context 是否仍然有效，避免在 dispose 时访问已失效的 widget
    if (!context.mounted) {
      return false;
    }

    try {
      final scope = context.getInheritedWidgetOfExactType<EasyDrawerScope>();
      if (scope != null) {
        // 延迟到下一帧再关闭，确保动画能完整播放
        await Future.microtask(() {});
        // 即使 context 在 microtask 后失效，也尝试关闭抽屉
        // 因为 scope.close() 不依赖于 context，可以安全调用
        scope.close();
        // 等待关闭动画完成（默认300ms）
        await Future.delayed(const Duration(milliseconds: 350));
        return true;
      }
    } catch (_) {
      // 如果 context 已失效，忽略错误
      return false;
    }
    return false;
  }

  @override
  bool updateShouldNotify(covariant EasyDrawerScope oldWidget) {
    return oldWidget.close != close;
  }
}

class EasyDrawerWrapper {
  EasyDrawerWrapper();

  // Route 模式使用的变量
  EasyDrawerRoute<dynamic>? _route;

  // Overlay 模式使用的变量
  OverlayEntry? _overlayEntry;

  // 共用变量
  LocalHistoryEntry? _historyEntry;
  Completer<dynamic>? _completer;
  final GlobalKey<_DrawerAnimationWrapperState> _wrapperKey =
      GlobalKey<_DrawerAnimationWrapperState>();

  DrawerRenderMode? _currentMode;

  bool get isShowing => _route != null || _overlayEntry != null;

  /// 显示抽屉
  ///
  /// [mode] 渲染模式：
  /// - [DrawerRenderMode.route] (默认): 全屏模式，抽屉显示在整个屏幕上
  /// - [DrawerRenderMode.overlay]: 容器模式，抽屉显示在容器内
  ///
  /// 使用 overlay 模式时注意事项：
  /// 1. 必须确保 context 所在的容器包含 Overlay widget
  /// 2. 抽屉会跟随容器滚动
  /// 3. 抽屉会被容器边界裁剪
  Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    DrawerRenderMode mode = DrawerRenderMode.route,
    Duration duration = const Duration(milliseconds: 250),
    bool fromRight = true,
    Color scrimColor = Colors.black54,
    bool barrierDismissible = true,
    Curve curve = Curves.easeOut,
    Curve reverseCurve = Curves.easeIn,
    bool enableSwipeToClose = false,
    double closeVelocity = 600,
    bool confirmBeforeClose = false,
  }) {
    if (isShowing) {
      return (_completer?.future ?? Future.value()).then((v) => v as T?);
    }

    _completer = Completer<T?>();
    _currentMode = mode;

    if (mode == DrawerRenderMode.route) {
      return _showWithRoute<T>(
        context: context,
        child: child,
        duration: duration,
        fromRight: fromRight,
        scrimColor: scrimColor,
        barrierDismissible: barrierDismissible,
        curve: curve,
        reverseCurve: reverseCurve,
        enableSwipeToClose: enableSwipeToClose,
        closeVelocity: closeVelocity,
        confirmBeforeClose: confirmBeforeClose,
      );
    } else {
      return _showWithOverlay<T>(
        context: context,
        child: child,
        duration: duration,
        fromRight: fromRight,
        scrimColor: scrimColor,
        barrierDismissible: barrierDismissible,
        curve: curve,
        reverseCurve: reverseCurve,
        enableSwipeToClose: enableSwipeToClose,
        closeVelocity: closeVelocity,
        confirmBeforeClose: confirmBeforeClose,
      );
    }
  }

  /// Route 模式实现（全屏）
  Future<T?> _showWithRoute<T>({
    required BuildContext context,
    required Widget child,
    required Duration duration,
    required bool fromRight,
    required Color scrimColor,
    required bool barrierDismissible,
    required Curve curve,
    required Curve reverseCurve,
    required bool enableSwipeToClose,
    required double closeVelocity,
    required bool confirmBeforeClose,
  }) {
    _route = EasyDrawerRoute(
      builder: (ctx) {
        return _DrawerAnimationWrapper(
          key: _wrapperKey,
          navigatorContext: context,
          duration: duration,
          fromRight: fromRight,
          onHide: _onHideAfterReverse,
          scrimColor: scrimColor,
          barrierDismissible: barrierDismissible,
          curve: curve,
          reverseCurve: reverseCurve,
          enableSwipeToClose: enableSwipeToClose,
          closeVelocity: closeVelocity,
          confirmBeforeClose: confirmBeforeClose,
          isOverlayMode: false,
          child: EasyDrawerScope(close: close, child: child),
        );
      },
      settings: RouteSettings(name: 'EasyDrawer'),
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      drawerTransitionDuration: duration,
      navigatorContext: context,
    );

    Navigator.of(context, rootNavigator: false).push(_route!).then((result) {
      if (_completer != null && !_completer!.isCompleted) {
        _completer!.complete(result);
      }
    });

    // _historyEntry = LocalHistoryEntry(
    //   onRemove: () {
    //     _animateClose(initiatedByHistory: true);
    //   },
    // );
    // ModalRoute.of(context)?.addLocalHistoryEntry(_historyEntry!);

    return _completer!.future.then((v) => v as T?);
  }

  /// Overlay 模式实现（容器内）
  Future<T?> _showWithOverlay<T>({
    required BuildContext context,
    required Widget child,
    required Duration duration,
    required bool fromRight,
    required Color scrimColor,
    required bool barrierDismissible,
    required Curve curve,
    required Curve reverseCurve,
    required bool enableSwipeToClose,
    required double closeVelocity,
    required bool confirmBeforeClose,
  }) {
    // 获取容器内的 Overlay（不使用 root overlay）
    final overlay = Overlay.of(context, rootOverlay: false);

    _overlayEntry = OverlayEntry(
      builder: (ctx) {
        return _DrawerAnimationWrapper(
          key: _wrapperKey,
          navigatorContext: context,
          duration: duration,
          fromRight: fromRight,
          onHide: _onHideAfterReverse,
          scrimColor: scrimColor,
          barrierDismissible: barrierDismissible,
          curve: curve,
          reverseCurve: reverseCurve,
          enableSwipeToClose: enableSwipeToClose,
          closeVelocity: closeVelocity,
          confirmBeforeClose: confirmBeforeClose,
          isOverlayMode: true,
          child: EasyDrawerScope(close: close, child: child),
        );
      },
    );

    overlay.insert(_overlayEntry!);

    // 添加返回键支持
    _historyEntry = LocalHistoryEntry(
      onRemove: () {
        _animateClose(initiatedByHistory: true);
      },
    );
    ModalRoute.of(context)?.addLocalHistoryEntry(_historyEntry!);

    return _completer!.future.then((v) => v as T?);
  }

  void hide() {
    // 兼容旧接口：立即移除，无动画
    _historyEntry?.remove();
    _historyEntry = null;

    if (_currentMode == DrawerRenderMode.route) {
      if (_route != null && _route!._isActive) {
        try {
          final element = _route!.navigatorContext as Element;
          if (element.mounted) {
            if (ModalRoute.isCurrentOf(element) == true) {
              Navigator.of(_route!.navigatorContext).pop();
            } else {
              Navigator.removeRoute(element, _route!);
            }
          }
        } catch (_) {
          // context 已失活，忽略错误
        }
      }
      _route = null;
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }

    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(null);
    }
    _completer = null;
    _currentMode = null;
  }

  Future<void> close() async {
    return _animateClose(initiatedByHistory: false);
  }

  Future<void> _animateClose({required bool initiatedByHistory}) async {
    final state = _wrapperKey.currentState;
    if (state != null) {
      // 统一通过内部 state 触发关闭（包含动画与 route pop），避免依赖可能失效的外部 context
      await state.requestClose();
      return;
    }
    // 兜底：如果没有 state（极端情况），仍按旧逻辑清理 Overlay
    if (_currentMode == DrawerRenderMode.overlay) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (!initiatedByHistory) {
        _historyEntry?.remove();
      }
      _historyEntry = null;
      _completer?.complete();
      _completer = null;
      _currentMode = null;
    }
  }

  void _onHideAfterReverse() {
    // 仅作为兜底：动画结束时确保清理
    _historyEntry?.remove();
    _historyEntry = null;

    if (_currentMode == DrawerRenderMode.route) {
      // Route 模式下不再在这里 pop，避免使用可能失效的 navigatorContext
      _route = null;
    } else {
      try {
        _overlayEntry?.remove();
      } catch (_) {}
      _overlayEntry = null;
    }

    _completer?.complete();
    _completer = null;
    _currentMode = null;
  }
}

/// 自定义路由：用 PageRoute 替代 Overlay Entry
class EasyDrawerRoute<T> extends PageRoute<T> {
  final WidgetBuilder builder;
  @override
  final bool barrierDismissible;
  final Duration drawerTransitionDuration;
  final BuildContext navigatorContext;
  bool _isActive = true;

  EasyDrawerRoute({
    required this.builder,
    required RouteSettings settings,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.drawerTransitionDuration,
    required this.navigatorContext,
  }) : super(settings: settings);

  @override
  Color? barrierColor;

  @override
  String? get barrierLabel => "Drawer";

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => drawerTransitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // 直接返回子页面，动画由 _DrawerAnimationWrapper 内部处理
    return child;
  }

  @override
  bool didPop(result) {
    _isActive = false;
    return super.didPop(result);
  }
}

/// 内部封装一个 StatefulWidget，用于提供 vsync 和动画控制
class _DrawerAnimationWrapper extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool fromRight;
  final VoidCallback onHide;
  final Color scrimColor;
  final bool barrierDismissible;
  final Curve curve;
  final Curve reverseCurve;
  final bool enableSwipeToClose;
  final double closeVelocity;
  final bool confirmBeforeClose;
  final BuildContext navigatorContext;
  final bool isOverlayMode;

  const _DrawerAnimationWrapper({
    super.key,
    required this.navigatorContext,
    required this.child,
    required this.duration,
    required this.fromRight,
    required this.onHide,
    required this.scrimColor,
    required this.barrierDismissible,
    required this.isOverlayMode,
    this.curve = Curves.easeOut,
    this.reverseCurve = Curves.easeIn,
    this.enableSwipeToClose = true,
    this.closeVelocity = 600,
    this.confirmBeforeClose = false,
  });

  @override
  State<_DrawerAnimationWrapper> createState() =>
      _DrawerAnimationWrapperState();
}

class _DrawerAnimationWrapperState extends State<_DrawerAnimationWrapper>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _scrimController;
  late Animation<double> _scrimOpacity;
  late AnimationController _confirmController;
  late Animation<double> _confirmOpacity;
  late Animation<Offset> _confirmOffset;
  bool _showingConfirm = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
      reverseCurve: widget.reverseCurve,
    );
    _controller.forward();
    _scrimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _scrimOpacity = CurvedAnimation(
      parent: _scrimController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _scrimController.forward();

    // 初始化确认框动画控制器
    _confirmController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
    );
    _confirmOpacity = CurvedAnimation(
      parent: _confirmController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );
    _confirmOffset = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _confirmController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _scrimController.dispose();
    _controller.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _hide() async {
    // 为了让底层页面“立即可点击”，关闭开始就立刻移除遮罩：
    // - Route 模式：立即 pop 当当前 route
    // - Overlay 模式：由 onHide 立即移除 OverlayEntry
    if (!widget.isOverlayMode) {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
      // 立刻回调进行清理，避免等待淡出动画导致点击延迟
      widget.onHide();
    } else {
      // Overlay 模式也不等待动画，直接清理 Overlay，立即释放点击
      widget.onHide();
    }
    // 同步尝试播放反向动画（不阻塞），仅作为视觉上的补救（在 route 已 pop 时不会显示）
    try {
      if (_controller.status != AnimationStatus.dismissed) {
        unawaited(_controller.reverse());
      }
      if (_scrimController.status != AnimationStatus.dismissed) {
        unawaited(_scrimController.reverse());
      }
    } catch (_) {}
  }

  Future<void> reverseAndAwait() async {
    final List<Future<void>> animations = [];
    if (_controller.status != AnimationStatus.dismissed) {
      animations.add(_controller.reverse());
    }
    if (_scrimController.status != AnimationStatus.dismissed) {
      animations.add(_scrimController.reverse());
    }
    try {
      await Future.wait(animations);
    } catch (_) {}
  }

  Future<void> requestClose() async {
    // 统一入口：带动画关闭并触发 pop（route）或移除（overlay）
    await _hide();
  }

  void _showConfirmDialog() {
    if (!_showingConfirm) {
      setState(() {
        _showingConfirm = true;
      });
      _confirmController.forward();
    }
  }

  void _hideConfirmDialog() {
    if (_showingConfirm) {
      _confirmController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showingConfirm = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final animation = _animation;
    final begin = widget.fromRight ? const Offset(1, 0) : const Offset(-1, 0);
    final alignment =
        widget.fromRight ? Alignment.centerRight : Alignment.centerLeft;

    // 抽屉内容
    Widget drawerContent = SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: Offset.zero,
      ).animate(animation),
      child: widget.child,
    );

    // Overlay 模式不需要 SafeArea（容器会处理），Route 模式需要
    if (!widget.isOverlayMode) {
      drawerContent = SafeArea(child: drawerContent);
    }

    drawerContent = Align(
      alignment: alignment,
      child: GestureDetector(
        onHorizontalDragEnd:
            widget.enableSwipeToClose
                ? (details) {
                  final vx = details.primaryVelocity ?? 0;
                  final closingFromRight =
                      widget.fromRight && vx > widget.closeVelocity;
                  final closingFromLeft =
                      !widget.fromRight && vx < -widget.closeVelocity;
                  if (closingFromRight || closingFromLeft) {
                    _hide();
                  }
                }
                : null,
        child: drawerContent,
      ),
    );

    Widget drawerStack = Stack(
      children: [
        // 遮罩层
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap:
                widget.barrierDismissible
                    ? () async {
                      if (widget.confirmBeforeClose) {
                        _showConfirmDialog();
                      } else {
                        _hide();
                      }
                    }
                    : null,
            child: FadeTransition(
              opacity: _scrimOpacity,
              child: Container(color: widget.scrimColor),
            ),
          ),
        ),
        // 抽屉内容
        drawerContent,
        // 确认对话框
        if (_showingConfirm) ...[
          Positioned.fill(
            child: ModalBarrier(color: Colors.black54, dismissible: false),
          ),
          Center(
            child: SlideTransition(
              position: _confirmOffset,
              child: FadeTransition(
                opacity: _confirmOpacity,
                child: Builder(
                  builder: (context) {
                    final l10n = EasyUiLocalizations.of(context);
                    return EasyNotifyDialog.alert(
                      title: l10n.confirmClose,
                      body: Text(l10n.unsavedChangesWillBeLost),
                      confirmButtonText: l10n.ok,
                      cancelButtonText: l10n.cancel,
                      onCancelButtonPressed: () {
                        _hideConfirmDialog();
                      },
                      onConfirmButtonPressed: () {
                        _hideConfirmDialog();
                        _hide();
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );

    return drawerStack;
  }
}
