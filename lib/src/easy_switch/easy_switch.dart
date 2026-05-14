import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../easy_theme.dart';

/// label 位置
enum EasySwitchLabelPosition { left, right }

/// 开关组件
class EasySwitch extends StatefulWidget {
  const EasySwitch({
    super.key,
    this.checked,
    this.checkedChildren,
    this.unCheckedChildren,
    this.defaultChecked = false,
    this.disabled = false,
    this.loading = false,
    this.size,
    this.value,
    this.onChange,

    /// 内容最小缩放比例（内容太长时会缩小；缩小低于该值则可选择滚动）
    this.minContentScale = 0.65,

    /// 当内容需要缩放到低于 minContentScale 时，是否改为横向滚动（避免内容太小看不清）
    this.scrollWhenTooSmall = true,
    this.contentEdgeInset = 2.0,
    this.contentThumbGap = 2.0,

    // ===== ✅ label =====
    this.label,
    this.labelPosition = EasySwitchLabelPosition.left,
    this.labelSpacing = 8.0,

    /// 是否整行（label + switch）都可点击切换
    this.onTapWholeRow = true,

    // ===== ✅ 背景颜色控制 =====
    this.checkedColor,
    this.uncheckedColor,
    this.disabledCheckedColor,
    this.disabledUncheckedColor,
  });

  /// 指定当前是否选中（受控模式）
  final bool? checked;

  /// 选中时的内容
  final Widget? checkedChildren;

  /// 非选中时的内容
  final Widget? unCheckedChildren;

  /// 初始是否选中，默认 false（非受控模式）
  final bool defaultChecked;

  /// 是否禁用，默认 false
  final bool disabled;

  /// 加载中的开关，默认 false
  final bool loading;

  /// 可指定宽高
  final Size? size;

  /// 当前值（与 checked 相同，用于兼容）
  final bool? value;

  /// 变化时的回调函数
  final ValueChanged<bool>? onChange;

  /// 内容最小缩放比例
  final double minContentScale;

  /// 当内容缩放会低于 minContentScale 时是否改为横向滚动
  final bool scrollWhenTooSmall;

  /// 内容距离轨道左右边缘的额外内边距（越大越往里）
  final double contentEdgeInset;

  /// 内容与滑块之间的最小间距（越大越往里）
  final double contentThumbGap;

  // ===== ✅ label props =====

  /// 外部 label（例如 Text、Icon+Text）
  final Widget? label;

  /// label 在左还是右
  final EasySwitchLabelPosition labelPosition;

  /// label 和 switch 间距
  final double labelSpacing;

  /// 是否整行都可点击
  final bool onTapWholeRow;

  // ===== ✅ 背景颜色 props =====
  final Color? checkedColor;
  final Color? uncheckedColor;
  final Color? disabledCheckedColor;
  final Color? disabledUncheckedColor;

  @override
  State<EasySwitch> createState() => _EasySwitchState();
}

class _EasySwitchState extends State<EasySwitch>
    with SingleTickerProviderStateMixin {
  late bool _internalChecked;
  late AnimationController _animationController;
  late Animation<double> _animation;

  Size _contentSize = Size.zero;

  bool get _isControlled => widget.checked != null || widget.value != null;

  bool _checkedOf(EasySwitch w) => (w.checked ?? w.value) ?? false;

  bool get _currentChecked {
    if (_isControlled) return _checkedOf(widget);
    return _internalChecked;
  }

  bool get _isEnabled => !widget.disabled && !widget.loading;

  SystemMouseCursor get _mouseCursor {
    if (!_isEnabled) return SystemMouseCursors.forbidden;
    return SystemMouseCursors.click;
  }

  @override
  void initState() {
    super.initState();
    _internalChecked = widget.defaultChecked;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.value = _currentChecked ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant EasySwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 受控模式下：外部值变化 -> 驱动动画
    if (_isControlled) {
      final oldChecked = _checkedOf(oldWidget);
      final newChecked = _checkedOf(widget);
      if (newChecked != oldChecked) {
        if (newChecked) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.disabled || widget.loading) return;

    final newChecked = !_currentChecked;

    if (!_isControlled) {
      setState(() {
        _internalChecked = newChecked;
      });
      if (newChecked) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }

    widget.onChange?.call(newChecked);
  }

  Color _resolveBackgroundColor({
    required bool checked,
    required bool enabled,
    required EasyThemeData theme,
  }) {
    if (checked) {
      if (enabled) {
        return widget.checkedColor ?? theme.primaryGreen;
      } else {
        return widget.disabledCheckedColor ??
            (widget.checkedColor ?? theme.primaryGreen).withOpacity(0.5);
      }
    } else {
      if (enabled) {
        return widget.uncheckedColor ?? theme.neutralEE;
      } else {
        return widget.disabledUncheckedColor ??
            (widget.uncheckedColor ?? theme.neutralEE).withOpacity(0.5);
      }
    }
  }

  /// 只构建“开关本体”（不包 GestureDetector / MouseRegion）
  Widget _buildCore(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    final checked = _currentChecked;
    final size = widget.size ?? const Size(44.0, 22.0);

    // 滑块的内边距，确保滑块在轨道内部
    final thumbPadding = 2.0;
    final thumbSize = size.height - thumbPadding * 2;
    // 滑块可移动的最大距离：总宽度 - 滑块宽度 - 左边距 - 右边距
    final thumbMaxLeft = size.width - thumbSize - thumbPadding * 2;

    // 内容区域的左右内边距，根据滑块位置动态分配，保证与滑块互斥
    final edge = widget.contentEdgeInset;
    final gap = widget.contentThumbGap;

    // 内容区左右 padding：
    // - 靠边的一侧：thumbPadding + edge（往里收）
    // - 靠滑块的一侧：thumbSize + thumbPadding + gap（与滑块拉开一点）
    final double contentPaddingLeft =
        checked ? (thumbPadding + edge) : (thumbSize + thumbPadding + gap);
    final double contentPaddingRight =
        checked ? (thumbSize + thumbPadding + gap) : (thumbPadding + edge);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.height / 2),
            color: Color.lerp(
              _resolveBackgroundColor(
                checked: false,
                enabled: _isEnabled,
                theme: easyTheme,
              ),
              _resolveBackgroundColor(
                checked: true,
                enabled: _isEnabled,
                theme: easyTheme,
              ),
              _animation.value,
            ),
          ),
          child: Stack(
            children: [
              // 内容区域 - 显示在滑块的两侧（通用兜底：可缩放；太小则滚动）
              if (widget.checkedChildren != null ||
                  widget.unCheckedChildren != null)
                Positioned.fill(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.only(
                      left: contentPaddingLeft,
                      right: contentPaddingRight,
                    ),
                    child: AnimatedAlign(
                      alignment:
                          checked
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      duration: const Duration(milliseconds: 200),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final available = constraints.maxWidth;

                          final currentChild =
                              checked
                                  ? (widget.checkedChildren ??
                                      const SizedBox.shrink())
                                  : (widget.unCheckedChildren ??
                                      const SizedBox.shrink());

                          // 需要的缩放比例（用测到的内容宽度估算）
                          double neededScale;
                          if (_contentSize.width <= 0 || available <= 0) {
                            neededScale = 1.0;
                          } else {
                            neededScale = (available / _contentSize.width)
                                .clamp(0.0, 1.0);
                          }

                          final minScale = widget.minContentScale.clamp(
                            0.1,
                            1.0,
                          );
                          final useScroll =
                              widget.scrollWhenTooSmall &&
                              neededScale < minScale;

                          Widget measuredChild = IntrinsicWidth(
                            // 尽量 shrink-wrap，避免外部 Row 等“撑满”导致测量/缩放不准
                            child: _MeasureSize(
                              onChange: (s) {
                                if (!mounted) return;
                                if (s == _contentSize) return;
                                setState(() => _contentSize = s);
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: currentChild,
                              ),
                            ),
                          );

                          return ClipRect(
                            child:
                                useScroll
                                    ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: measuredChild,
                                    )
                                    : Transform.scale(
                                      scale: neededScale.clamp(minScale, 1.0),
                                      alignment:
                                          checked
                                              ? Alignment.centerLeft
                                              : Alignment.centerRight,
                                      child: measuredChild,
                                    ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

              // 滑块 - 在轨道内部
              Positioned(
                left: thumbPadding + _animation.value * thumbMaxLeft,
                top: thumbPadding,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                      widget.loading
                          ? Center(
                            child: SizedBox(
                              width: thumbSize * 0.5,
                              height: thumbSize * 0.5,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  checked
                                      ? (widget.checkedColor ??
                                          easyTheme.primaryGreen)
                                      : easyTheme.neutral66,
                                ),
                              ),
                            ),
                          )
                          : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildClickableCore(BuildContext context) {
    final core = _buildCore(context);

    return MouseRegion(
      cursor: _mouseCursor,
      child: GestureDetector(
        onTap: _isEnabled ? _handleTap : null,
        child: core,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ 没有 label：保持原行为（只点开关本体 + 悬浮 click）
    if (widget.label == null) {
      return _buildClickableCore(context);
    }

    // ✅ 有 label：根据 onTapWholeRow 决定光标/点击区域
    final switchPart =
        widget.onTapWholeRow
            ? _buildCore(context) // 整行点击：不要内层 GestureDetector，避免重复触发
            : _buildClickableCore(context); // 仅开关可点：只给开关加 click/手势

    final left = widget.labelPosition == EasySwitchLabelPosition.left;
    final labelWidget = Flexible(child: widget.label!);

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
          left
              ? <Widget>[
                labelWidget,
                SizedBox(width: widget.labelSpacing),
                switchPart,
              ]
              : <Widget>[
                switchPart,
                SizedBox(width: widget.labelSpacing),
                labelWidget,
              ],
    );

    if (!widget.onTapWholeRow) {
      // label 不可点：Row 不包点击，不要给整行 click 光标
      return row;
    }

    // 整行可点：Row 统一 click 光标 + 点击
    return MouseRegion(
      cursor: _mouseCursor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _isEnabled ? _handleTap : null,
        child: row,
      ),
    );
  }
}

/// 测量子组件实际渲染尺寸（用于估算内容缩放/滚动策略）
class _MeasureSize extends SingleChildRenderObjectWidget {
  const _MeasureSize({required this.onChange, required super.child});

  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_oldSize == newSize) return;
    _oldSize = newSize;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
