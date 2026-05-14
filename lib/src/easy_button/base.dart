// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show
        InteractiveInkFeatureFactory,
        Tooltip,
        Colors,
        InkWell,
        Material,
        MaterialType,
        AnimatedTheme,
        ThemeData,
        Theme;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'easy_button_style.dart';

/// The base [StatefulWidget] class for buttons whose style is defined by a [EasyButtonStyle] object.
///
/// Concrete subclasses must override [defaultStyleOf] and [themeStyleOf].
///
/// See also:
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled button that doesn't elevate when pressed.
///  * [FilledButton.tonal], a filled button variant that uses a secondary fill color.
///  * [OutlinedButton], a button with an outlined border and no fill color.
///  * [TextButton], a button with no outline or fill color.
///  * <https://m3.material.io/components/buttons/overview>, an overview of each of
///    the Material Design button types and how they should be used in designs.
abstract class BaseButton extends StatefulWidget {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  const BaseButton({
    super.key,
    required this.onPressed,
    required this.onLongPress,
    required this.onHover,
    required this.onFocusChange,
    required this.style,
    required this.focusNode,
    required this.autofocus,
    required this.clipBehavior,
    this.statesController,
    this.tooltip,
    this.withDebounce = true,
    required this.child,
  });

  /// Called when the button is tapped or otherwise activated.
  ///
  /// If this callback and [onLongPress] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  ///
  /// If this callback and [onPressed] are null, then the button will be disabled.
  ///
  /// See also:
  ///
  ///  * [enabled], which is true if the button is enabled.
  final VoidCallback? onLongPress;

  /// Called when a pointer enters or exits the button response area.
  ///
  /// The value passed to the callback is true if a pointer has entered this
  /// part of the material and false if a pointer has exited this part of the
  /// material.
  final ValueChanged<bool>? onHover;

  /// Handler called when the focus changes.
  ///
  /// Called with true if this widget's node gains focus, and false if it loses
  /// focus.
  final ValueChanged<bool>? onFocusChange;

  /// Customizes this button's appearance.
  ///
  /// Non-null properties of this style override the corresponding
  /// properties in [themeStyleOf] and [defaultStyleOf]. [WidgetStateProperty]s
  /// that resolve to non-null values will similarly override the corresponding
  /// [WidgetStateProperty]s in [themeStyleOf] and [defaultStyleOf].
  ///
  /// Null by default.
  final EasyButtonStyle? style;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.none] unless [EasyButtonStyle.backgroundBuilder] or
  /// [EasyButtonStyle.foregroundBuilder] is specified. In those
  /// cases the default is [Clip.antiAlias].
  final Clip? clipBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro flutter.material.inkwell.statesController}
  final WidgetStatesController? statesController;

  /// 描述按钮被按下或悬停时将发生的操作的文本。
  ///
  /// 当用户长按或将鼠标悬停在按钮上时，此文本将在工具提示中显示。此字符串也用于无障碍访问。
  ///
  /// 如果为空，按钮将不会显示工具提示。
  final String? tooltip;

  /// Typically the button's label.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  /// 是否开启防抖
  /// 默认值为 `true`
  /// 当开启防抖时，如果`onPressed`是`Future Function()`，则在该Future未完成前，按钮将被禁用，防止重复点击
  final bool withDebounce;

  /// Returns a [EasyButtonStyle] that's based primarily on the [Theme]'s
  /// [ThemeData.textTheme] and [ThemeData.colorScheme], but has most values
  /// filled out (non-null).
  ///
  /// The returned style can be overridden by the [style] parameter and by the
  /// style returned by [themeStyleOf] that some button-specific themes like
  /// [TextButtonTheme] or [ElevatedButtonTheme] override. For example the
  /// default style of the [TextButton] subclass can be overridden with its
  /// [TextButton.style] constructor parameter, or with a [TextButtonTheme].
  ///
  /// Concrete button subclasses should return a [EasyButtonStyle] with as many
  /// non-null properties as possible, where all of the non-null
  /// [WidgetStateProperty] properties resolve to non-null values.
  ///
  /// ## Properties that can be null
  ///
  /// Some properties, like [EasyButtonStyle.fixedSize] would override other values
  /// in the same [EasyButtonStyle] if set, so they are allowed to be null.  Here is
  /// a summary of properties that are allowed to be null when returned in the
  /// [EasyButtonStyle] returned by this function, an why:
  ///
  /// - [EasyButtonStyle.fixedSize] because it would override other values in the
  ///   same [EasyButtonStyle], like [EasyButtonStyle.maximumSize].
  /// - [EasyButtonStyle.side] because null is a valid value for a button that has
  ///   no side. [OutlinedButton] returns a non-null default for this, however.
  /// - [EasyButtonStyle.backgroundBuilder] and [EasyButtonStyle.foregroundBuilder]
  ///   because they would override the [EasyButtonStyle.foregroundColor] and
  ///   [EasyButtonStyle.backgroundColor] of the same [EasyButtonStyle].
  ///
  /// See also:
  ///
  /// * [themeStyleOf], returns the EasyButtonStyle of this button's component
  ///   theme.
  @protected
  EasyButtonStyle defaultStyleOf(BuildContext context);

  /// Returns the EasyButtonStyle that belongs to the button's component theme.
  ///
  /// The returned style can be overridden by the [style] parameter.
  ///
  /// Concrete button subclasses should return the EasyButtonStyle for the
  /// nearest subclass-specific inherited theme, and if no such theme
  /// exists, then the same value from the overall [Theme].
  ///
  /// See also:
  ///
  ///  * [defaultStyleOf], Returns the default [EasyButtonStyle] for this button.
  @protected
  EasyButtonStyle? themeStyleOf(BuildContext context);

  /// Whether the button is enabled or disabled.
  ///
  /// Buttons are disabled by default. To enable a button, set its [onPressed]
  /// or [onLongPress] properties to a non-null value.
  bool get enabled => onPressed != null || onLongPress != null;

  @override
  State<BaseButton> createState() => _EasyButtonStyleState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      FlagProperty('enabled', value: enabled, ifFalse: 'disabled'),
    );
    properties.add(
      DiagnosticsProperty<EasyButtonStyle>('style', style, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<FocusNode>(
        'focusNode',
        focusNode,
        defaultValue: null,
      ),
    );
  }

  /// Returns null if [value] is null, otherwise `WidgetStatePropertyAll<T>(value)`.
  ///
  /// A convenience method for subclasses.
  static WidgetStateProperty<T>? allOrNull<T>(T? value) =>
      value == null ? null : WidgetStatePropertyAll<T>(value);

  /// Returns null if [enabled] and [disabled] are null.
  /// Otherwise, returns a [WidgetStateProperty] that resolves to [disabled]
  /// when [WidgetState.disabled] is active, and [enabled] otherwise.
  ///
  /// A convenience method for subclasses.
  static WidgetStateProperty<Color?>? defaultColor(
    Color? enabled,
    Color? disabled,
  ) {
    if ((enabled ?? disabled) == null) {
      return null;
    }
    return WidgetStateProperty<Color?>.fromMap(<WidgetStatesConstraint, Color?>{
      WidgetState.disabled: disabled,
      WidgetState.any: enabled,
    });
  }
}

/// The base [State] class for buttons whose style is defined by a [EasyButtonStyle] object.
///
/// See also:
///
///  * [BaseButton], the [StatefulWidget] subclass for which this class is the [State].
///  * [ElevatedButton], a filled button whose material elevates when pressed.
///  * [FilledButton], a filled BaseButton that doesn't elevate when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///  * [TextButton], a simple button without a shadow.
class _EasyButtonStyleState extends State<BaseButton>
    with TickerProviderStateMixin {
  AnimationController? controller;
  double? elevation;
  Color? backgroundColor;
  WidgetStatesController? internalStatesController;

  bool _isProcessing = false;

  void handleStatesControllerChange() {
    // Force a rebuild to resolve WidgetStateProperty properties
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) setState(() {});
    });
  }

  WidgetStatesController get statesController =>
      widget.statesController ?? internalStatesController!;

  void initStatesController() {
    if (widget.statesController == null) {
      internalStatesController = WidgetStatesController();
    }
    statesController.update(WidgetState.disabled, !widget.enabled);
    statesController.addListener(handleStatesControllerChange);
  }

  @override
  void initState() {
    super.initState();
    initStatesController();
  }

  @override
  void didUpdateWidget(BaseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statesController != oldWidget.statesController) {
      oldWidget.statesController?.removeListener(handleStatesControllerChange);
      if (widget.statesController != null) {
        internalStatesController?.dispose();
        internalStatesController = null;
      }
      initStatesController();
    }
    if (widget.enabled != oldWidget.enabled) {
      statesController.update(WidgetState.disabled, !widget.enabled);
      if (!widget.enabled) {
        // The button may have been disabled while a press gesture is currently underway.
        statesController.update(WidgetState.pressed, false);
      }
    }
  }

  @override
  void dispose() {
    statesController.removeListener(handleStatesControllerChange);
    internalStatesController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IconThemeData iconTheme = IconTheme.of(context);
    final EasyButtonStyle? widgetStyle = widget.style;
    final EasyButtonStyle? themeStyle = widget.themeStyleOf(context);
    final EasyButtonStyle defaultStyle = widget.defaultStyleOf(context);

    T? effectiveValue<T>(T? Function(EasyButtonStyle? style) getProperty) {
      final T? widgetValue = getProperty(widgetStyle);
      final T? themeValue = getProperty(themeStyle);
      final T? defaultValue = getProperty(defaultStyle);
      return widgetValue ?? themeValue ?? defaultValue;
    }

    T? resolve<T>(
      WidgetStateProperty<T>? Function(EasyButtonStyle? style) getProperty,
    ) {
      return effectiveValue((EasyButtonStyle? style) {
        return getProperty(style)?.resolve(statesController.value);
      });
    }

    Color? effectiveIconColor() {
      return widgetStyle?.iconColor?.resolve(statesController.value) ??
          themeStyle?.iconColor?.resolve(statesController.value) ??
          widgetStyle?.foregroundColor?.resolve(statesController.value) ??
          themeStyle?.foregroundColor?.resolve(statesController.value) ??
          defaultStyle.iconColor?.resolve(statesController.value) ??
          // Fallback to foregroundColor if iconColor is null.
          defaultStyle.foregroundColor?.resolve(statesController.value);
    }

    final double? resolvedElevation = resolve<double?>(
      (EasyButtonStyle? style) => style?.elevation,
    );
    final TextStyle? defaultTextStyle = defaultStyle.textStyle?.resolve(
      statesController.value,
    );
    final TextStyle? themeTextStyle = themeStyle?.textStyle?.resolve(
      statesController.value,
    );
    final TextStyle? widgetTextStyle = widgetStyle?.textStyle?.resolve(
      statesController.value,
    );
    final TextStyle? resolvedTextStyle =
        defaultTextStyle?.merge(themeTextStyle).merge(widgetTextStyle) ??
        themeTextStyle?.merge(widgetTextStyle) ??
        widgetTextStyle;
    Color? resolvedBackgroundColor = resolve<Color?>(
      (EasyButtonStyle? style) => style?.backgroundColor,
    );
    final Color? resolvedForegroundColor = resolve<Color?>(
      (EasyButtonStyle? style) => style?.foregroundColor,
    );
    final Color? resolvedShadowColor = resolve<Color?>(
      (EasyButtonStyle? style) => style?.shadowColor,
    );
    final Color? resolvedSurfaceTintColor = resolve<Color?>(
      (EasyButtonStyle? style) => style?.surfaceTintColor,
    );
    final EdgeInsetsGeometry? resolvedPadding = resolve<EdgeInsetsGeometry?>(
      (EasyButtonStyle? style) => style?.padding,
    );
    final Size? resolvedMinimumSize = resolve<Size?>(
      (EasyButtonStyle? style) => style?.minimumSize,
    );
    final Size? resolvedFixedSize = resolve<Size?>(
      (EasyButtonStyle? style) => style?.fixedSize,
    );
    final Size? resolvedMaximumSize = resolve<Size?>(
      (EasyButtonStyle? style) => style?.maximumSize,
    );
    final Color? resolvedIconColor = effectiveIconColor();
    final double? resolvedIconSize = resolve<double?>(
      (EasyButtonStyle? style) => style?.iconSize,
    );
    final BorderSide? resolvedSide = resolve<BorderSide?>(
      (EasyButtonStyle? style) => style?.side,
    );
    final OutlinedBorder? resolvedShape = resolve<OutlinedBorder?>(
      (EasyButtonStyle? style) => style?.shape,
    );

    final WidgetStateMouseCursor mouseCursor = _MouseCursor(
      (Set<WidgetState> states) => effectiveValue(
        (EasyButtonStyle? style) => style?.mouseCursor?.resolve(states),
      ),
    );

    final WidgetStateProperty<Color?> overlayColor =
        WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) => effectiveValue(
            (EasyButtonStyle? style) => style?.overlayColor?.resolve(states),
          ),
        );

    final Duration? resolvedAnimationDuration = effectiveValue(
      (EasyButtonStyle? style) => style?.animationDuration,
    );
    final bool resolvedEnableFeedback =
        effectiveValue((EasyButtonStyle? style) => style?.enableFeedback) ??
        true;
    final AlignmentGeometry? resolvedAlignment = effectiveValue(
      (EasyButtonStyle? style) => style?.alignment,
    );
    final InteractiveInkFeatureFactory? resolvedSplashFactory = effectiveValue(
      (EasyButtonStyle? style) => style?.splashFactory,
    );
    final ButtonLayerBuilder? resolvedBackgroundBuilder = effectiveValue(
      (EasyButtonStyle? style) => style?.backgroundBuilder,
    );
    final ButtonLayerBuilder? resolvedForegroundBuilder = effectiveValue(
      (EasyButtonStyle? style) => style?.foregroundBuilder,
    );

    final Clip effectiveClipBehavior =
        widget.clipBehavior ??
        ((resolvedBackgroundBuilder ?? resolvedForegroundBuilder) != null
            ? Clip.antiAlias
            : Clip.none);

    BoxConstraints effectiveConstraints = BoxConstraints(
      minWidth: resolvedMinimumSize!.width,
      minHeight: resolvedMinimumSize.height,
      maxWidth: resolvedMaximumSize!.width,
      maxHeight: resolvedMaximumSize.height,
    );

    if (resolvedFixedSize != null) {
      final Size size = effectiveConstraints.constrain(resolvedFixedSize);
      if (size.width.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minWidth: size.width,
          maxWidth: size.width,
        );
      }
      if (size.height.isFinite) {
        effectiveConstraints = effectiveConstraints.copyWith(
          minHeight: size.height,
          maxHeight: size.height,
        );
      }
    }

    // Per the Material Design team: don't allow the VisualDensity
    // adjustment to reduce the width of the left/right padding. If we
    // did, VisualDensity.compact, the default for desktop/web, would
    // reduce the horizontal padding to zero.
    final EdgeInsetsGeometry padding = resolvedPadding!.clamp(
      EdgeInsets.zero,
      EdgeInsetsGeometry.infinity,
    );

    // If an opaque button's background is becoming translucent while its
    // elevation is changing, change the elevation first. Material implicitly
    // animates its elevation but not its color. SKIA renders non-zero
    // elevations as a shadow colored fill behind the Material's background.
    if (resolvedAnimationDuration! > Duration.zero &&
        elevation != null &&
        backgroundColor != null &&
        elevation != resolvedElevation &&
        backgroundColor!.value != resolvedBackgroundColor!.value &&
        backgroundColor!.opacity == 1 &&
        resolvedBackgroundColor.opacity < 1 &&
        resolvedElevation == 0) {
      if (controller?.duration != resolvedAnimationDuration) {
        controller?.dispose();
        controller = AnimationController(
          duration: resolvedAnimationDuration,
          vsync: this,
        )..addStatusListener((AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            setState(() {}); // Rebuild with the final background color.
          }
        });
      }
      resolvedBackgroundColor =
          backgroundColor; // Defer changing the background color.
      controller!.value = 0;
      controller!.forward();
    }
    elevation = resolvedElevation;
    backgroundColor = resolvedBackgroundColor;

    Widget result = Padding(
      padding: padding,
      child: Align(
        alignment: resolvedAlignment!,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child:
            resolvedForegroundBuilder != null
                ? resolvedForegroundBuilder(
                  context,
                  statesController.value,
                  widget.child,
                )
                : widget.child,
      ),
    );
    if (resolvedBackgroundBuilder != null) {
      result = resolvedBackgroundBuilder(
        context,
        statesController.value,
        result,
      );
    }

    result = AnimatedTheme(
      duration: resolvedAnimationDuration,
      data: theme.copyWith(
        iconTheme: iconTheme.merge(
          IconThemeData(color: resolvedIconColor, size: resolvedIconSize),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (widget.withDebounce && widget.onPressed is Future Function()) {
            if (_isProcessing) return null;
            return () {
              setState(() => _isProcessing = true);
              (widget.onPressed as Future Function())().whenComplete(() {
                if (context.mounted) setState(() => _isProcessing = false);
              });
            };
          } else {
            return widget.onPressed;
          }
        }(),
        onLongPress: widget.onLongPress,
        onHover: widget.onHover,
        mouseCursor: mouseCursor,
        enableFeedback: resolvedEnableFeedback,
        focusNode: widget.focusNode,
        canRequestFocus: widget.enabled,
        onFocusChange: widget.onFocusChange,
        autofocus: widget.autofocus,
        splashFactory: resolvedSplashFactory,
        overlayColor: overlayColor,
        highlightColor: Colors.transparent,
        customBorder: resolvedShape!.copyWith(side: resolvedSide),
        statesController: statesController,
        child: result,
      ),
    );

    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }

    final Size minSize = Size.zero;

    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: _InputPadding(
        minSize: minSize,
        child: ConstrainedBox(
          constraints: effectiveConstraints,
          child: Material(
            elevation: resolvedElevation!,
            textStyle: resolvedTextStyle?.copyWith(
              color: resolvedForegroundColor,
            ),
            shape: resolvedShape.copyWith(side: resolvedSide),
            color: resolvedBackgroundColor,
            shadowColor: resolvedShadowColor,
            surfaceTintColor: resolvedSurfaceTintColor,
            type:
                resolvedBackgroundColor == null
                    ? MaterialType.transparency
                    : MaterialType.button,
            animationDuration: resolvedAnimationDuration,
            clipBehavior: effectiveClipBehavior,
            borderOnForeground: false,
            child: result,
          ),
        ),
      ),
    );
  }
}

class _MouseCursor extends WidgetStateMouseCursor {
  const _MouseCursor(this.resolveCallback);

  final WidgetPropertyResolver<MouseCursor?> resolveCallback;

  @override
  MouseCursor resolve(Set<WidgetState> states) => resolveCallback(states)!;

  @override
  String get debugDescription => 'BaseButton_MouseCursor';
}

/// A widget to pad the area around a [BaseButton]'s inner [Material].
///
/// Redirect taps that occur in the padded area around the child to the center
/// of the child. This increases the size of the button and the button's
/// "tap target", but not its material or its ink splashes.
class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({super.child, required this.minSize});

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderInputPadding renderObject,
  ) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox? child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;
  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0.0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child!.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0.0;
  }

  Size _computeSize({
    required BoxConstraints constraints,
    required ChildLayouter layoutChild,
  }) {
    if (child != null) {
      final Size childSize = layoutChild(child!, constraints);
      final double height = math.max(childSize.width, minSize.width);
      final double width = math.max(childSize.height, minSize.height);
      return constraints.constrain(Size(height, width));
    }
    return Size.zero;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.dryLayoutChild,
    );
  }

  @override
  double? computeDryBaseline(
    covariant BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final RenderBox? child = this.child;
    if (child == null) {
      return null;
    }
    final double? result = child.getDryBaseline(constraints, baseline);
    if (result == null) {
      return null;
    }
    final Size childSize = child.getDryLayout(constraints);
    return result +
        Alignment.center
            .alongOffset(getDryLayout(constraints) - childSize as Offset)
            .dy;
  }

  @override
  void performLayout() {
    size = _computeSize(
      constraints: constraints,
      layoutChild: ChildLayoutHelper.layoutChild,
    );
    if (child != null) {
      final BoxParentData childParentData = child!.parentData! as BoxParentData;
      childParentData.offset = Alignment.center.alongOffset(
        size - child!.size as Offset,
      );
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child!.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        assert(position == center);
        return child!.hitTest(result, position: center);
      },
    );
  }
}
