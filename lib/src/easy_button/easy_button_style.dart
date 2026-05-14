// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show InteractiveInkFeatureFactory;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'base.dart';

/// {@template flutter.material.BaseButton.iconPosition}
/// Determines the alignment of the icon within the widgets such as:
///   - [ElevatedButton.icon],
///   - [FilledButton.icon],
///   - [FilledButton.tonalIcon].
///   - [OutlinedButton.icon],
///   - [TextButton.icon],
///
/// The effect of `iconPosition` depends on [TextDirection]. If textDirection is
/// [TextDirection.ltr] then [IconPosition.start] and [IconPosition.end] align the
/// icon on the left or right respectively.  If textDirection is [TextDirection.rtl] the
/// the alignments are reversed.
///
/// Defaults to [IconPosition.start].
///
/// {@tool dartpad}
/// This sample demonstrates how to use `iconPosition` to align the button icon to the start
/// or the end of the button.
///
/// ** See code in examples/api/lib/material/button_style_button/button_style_button.icon_alignment.0.dart **
/// {@end-tool}
///
/// {@endtemplate}
enum IconPosition {
  /// The icon is placed at the start of the button.
  start,

  /// The icon is placed at the end of the button.
  end,
}

// Examples can assume:
// late BuildContext context;
// typedef MyAppHome = Placeholder;

/// The type for [EasyButtonStyle.backgroundBuilder] and [EasyButtonStyle.foregroundBuilder].
///
/// The [states] parameter is the button's current pressed/hovered/etc state. The [child] is
/// typically a descendant of the returned widget.
typedef ButtonLayerBuilder =
    Widget Function(
      BuildContext context,
      Set<WidgetState> states,
      Widget? child,
    );

/// The visual properties that most buttons have in common.
///
/// Buttons and their themes have a EasyButtonStyle property which defines the visual
/// properties whose default values are to be overridden. The default values are
/// defined by the individual button widgets and are typically based on overall
/// theme's [ThemeData.colorScheme] and [ThemeData.textTheme].
///
/// All of the EasyButtonStyle properties are null by default.
///
/// Many of the EasyButtonStyle properties are [WidgetStateProperty] objects which
/// resolve to different values depending on the button's state. For example
/// the [Color] properties are defined with `WidgetStateProperty<Color>` and
/// can resolve to different colors depending on if the button is pressed,
/// hovered, focused, disabled, etc.
///
/// These properties can override the default value for just one state or all of
/// them. For example to create a [ElevatedButton] whose background color is the
/// color scheme’s primary color with 50% opacity, but only when the button is
/// pressed, one could write:
///
/// ```dart
/// ElevatedButton(
///   style: EasyButtonStyle(
///     backgroundColor: WidgetStateProperty.resolveWith<Color?>(
///       (Set<WidgetState> states) {
///         if (states.contains(WidgetState.pressed)) {
///           return Theme.of(context).colorScheme.primary.withOpacity(0.5);
///         }
///         return null; // Use the component's default.
///       },
///     ),
///   ),
///   child: const Text('Fly me to the moon'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// In this case the background color for all other button states would fallback
/// to the ElevatedButton’s default values. To unconditionally set the button's
/// [backgroundColor] for all states one could write:
///
/// ```dart
/// ElevatedButton(
///   style: const EasyButtonStyle(
///     backgroundColor: WidgetStatePropertyAll<Color>(Colors.green),
///   ),
///   child: const Text('Let me play among the stars'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// Configuring a EasyButtonStyle directly makes it possible to very
/// precisely control the button’s visual attributes for all states.
/// This level of control is typically required when a custom
/// “branded” look and feel is desirable. However, in many cases it’s
/// useful to make relatively sweeping changes based on a few initial
/// parameters with simple values. The button styleFrom() methods
/// enable such sweeping changes. See for example:
/// [ElevatedButton.styleFrom], [FilledButton.styleFrom],
/// [OutlinedButton.styleFrom], [TextButton.styleFrom].
///
/// For example, to override the default text and icon colors for a
/// [TextButton], as well as its overlay color, with all of the
/// standard opacity adjustments for the pressed, focused, and
/// hovered states, one could write:
///
/// ```dart
/// TextButton(
///   style: TextButton.styleFrom(foregroundColor: Colors.green),
///   child: const Text('Let me see what spring is like'),
///   onPressed: () {
///     // ...
///   },
/// ),
/// ```
///
/// To configure all of the application's text buttons in the same
/// way, specify the overall theme's `textButtonTheme`:
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     textButtonTheme: TextButtonThemeData(
///       style: TextButton.styleFrom(foregroundColor: Colors.green),
///     ),
///   ),
///   home: const MyAppHome(),
/// ),
/// ```
///
/// ## Material 3 button types
///
/// Material Design 3 specifies five types of common buttons. Flutter provides
/// support for these using the following button classes:
/// <style>table,td,th { border-collapse: collapse; padding: 0.45em; } td { border: 1px solid }</style>
///
/// | Type         | Flutter implementation  |
/// | :----------- | :---------------------- |
/// | Elevated     | [ElevatedButton]        |
/// | Filled       | [FilledButton]          |
/// | Filled Tonal | [FilledButton.tonal]    |
/// | Outlined     | [OutlinedButton]        |
/// | Text         | [TextButton]            |
///
/// {@tool dartpad}
/// This sample shows how to create each of the Material 3 button types with Flutter.
///
/// ** See code in examples/api/lib/material/button_style/button_style.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [ElevatedButtonTheme], the theme for [ElevatedButton]s.
///  * [FilledButtonTheme], the theme for [FilledButton]s.
///  * [OutlinedButtonTheme], the theme for [OutlinedButton]s.
///  * [TextButtonTheme], the theme for [TextButton]s.
@immutable
class EasyButtonStyle with Diagnosticable {
  /// Create a [EasyButtonStyle].
  const EasyButtonStyle({
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.overlayColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.elevation,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.iconColor,
    this.iconSize,
    this.iconPosition,
    this.side,
    this.shape,
    this.mouseCursor,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
    this.backgroundBuilder,
    this.foregroundBuilder,
  });

  /// The style for a button's [Text] widget descendants.
  ///
  /// The color of the [textStyle] is typically not used directly, the
  /// [foregroundColor] is used instead.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// The button's background fill color.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// The color for the button's [Text] widget descendants.
  ///
  /// This color is typically used instead of the color of the [textStyle]. All
  /// of the components that compute defaults from [EasyButtonStyle] values
  /// compute a default [foregroundColor] and use that instead of the
  /// [textStyle]'s color.
  final WidgetStateProperty<Color?>? foregroundColor;

  /// The highlight color that's typically used to indicate that
  /// the button is focused, hovered, or pressed.
  final WidgetStateProperty<Color?>? overlayColor;

  /// The shadow color of the button's [Material].
  ///
  /// The material's elevation shadow can be difficult to see for
  /// dark themes, so by default the button classes add a
  /// semi-transparent overlay to indicate elevation. See
  /// [ThemeData.applyElevationOverlayColor].
  final WidgetStateProperty<Color?>? shadowColor;

  /// The surface tint color of the button's [Material].
  ///
  /// See [Material.surfaceTintColor] for more details.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// The elevation of the button's [Material].
  final WidgetStateProperty<double?>? elevation;

  /// The padding between the button's boundary and its child.
  ///
  /// The vertical aspect of the default or user-specified padding is adjusted
  /// automatically based on [visualDensity].
  ///
  /// When the visual density is [VisualDensity.compact], the top and bottom insets
  /// are reduced by 8 pixels or set to 0 pixels if the result of the reduced padding
  /// is negative. For example: the visual density defaults to [VisualDensity.compact]
  /// on desktop and web, so if the provided padding is 16 pixels on the top and bottom,
  /// it will be reduced to 8 pixels on the top and bottom. If the provided padding
  /// is 4 pixels, the result will be no padding on the top and bottom.
  ///
  /// When the visual density is [VisualDensity.comfortable], the top and bottom insets
  /// are reduced by 4 pixels or set to 0 pixels if the result of the reduced padding
  /// is negative.
  ///
  /// When the visual density is [VisualDensity.standard] the top and bottom insets
  /// are not changed. The visual density defaults to [VisualDensity.standard] on mobile.
  ///
  /// See [ThemeData.visualDensity] for more details.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// The minimum size of the button itself before applying [visualDensity].
  ///
  /// The size of the rectangle the button lies within may be larger
  /// per [tapTargetSize].
  ///
  /// This value must be less than or equal to [maximumSize].
  ///
  /// The minimum size is adjusted automatically based on [visualDensity].
  ///
  /// When visual density is [VisualDensity.compact], the minimum size is
  /// reduced by 8 pixels on both dimensions.
  ///
  /// When visual density is [VisualDensity.comfortable], the minimum size is
  /// [minimumSize] reduced by 4 pixels on both dimensions.
  ///
  /// When visual density is [VisualDensity.standard], the minimum size is
  /// [minimumSize].
  final WidgetStateProperty<Size?>? minimumSize;

  /// The button's size.
  ///
  /// This size is still constrained by the style's [minimumSize]
  /// and [maximumSize]. Fixed size dimensions whose value is
  /// [double.infinity] are ignored.
  ///
  /// The size of the rectangle the button lies within may be larger
  /// per [tapTargetSize].
  ///
  /// To specify buttons with a fixed width and the default height use
  /// `fixedSize: Size.fromWidth(320)`. Similarly, to specify a fixed
  /// height and the default width use `fixedSize: Size.fromHeight(100)`.
  final WidgetStateProperty<Size?>? fixedSize;

  /// The maximum size of the button itself.
  ///
  /// A [Size.infinite] or null value for this property means that
  /// the button's maximum size is not constrained.
  ///
  /// This value must be greater than or equal to [minimumSize].
  final WidgetStateProperty<Size?>? maximumSize;

  /// The icon's color inside of the button.
  final WidgetStateProperty<Color?>? iconColor;

  /// The icon's size inside of the button.
  final WidgetStateProperty<double?>? iconSize;

  /// The alignment of the button's icon.
  ///
  /// This property is supported for the following button types:
  ///
  ///  * [ElevatedButton.icon].
  ///  * [FilledButton.icon].
  ///  * [FilledButton.tonalIcon].
  ///  * [OutlinedButton.icon].
  ///  * [TextButton.icon].
  ///
  /// See also:
  ///
  ///  * [IconPosition], for more information about the different icon
  ///    alignments.
  final IconPosition? iconPosition;

  /// The color and weight of the button's outline.
  ///
  /// This value is combined with [shape] to create a shape decorated
  /// with an outline.
  final WidgetStateProperty<BorderSide?>? side;

  /// The shape of the button's underlying [Material].
  ///
  /// This shape is combined with [side] to create a shape decorated
  /// with an outline.
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// The cursor for a mouse pointer when it enters or is hovering over
  /// this button's [InkWell].
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// Defines the duration of animated changes for [shape] and [elevation].
  ///
  /// Typically the component default value is [kThemeChangeDuration].
  final Duration? animationDuration;

  /// 是否检测到的手势应该提供声音和/或触觉反馈。
  ///
  /// 例如，在 Android 上，点击会发出点击声，而长按会产生短暂的振动，当启用反馈时。
  ///
  /// 通常组件的默认值为 true。
  ///
  /// 另请参阅：
  ///
  ///  * [Feedback]，用于为某些操作提供特定于平台的反馈。
  final bool? enableFeedback;

  /// The alignment of the button's child.
  ///
  /// Typically buttons are sized to be just big enough to contain the child and its
  /// padding. If the button's size is constrained to a fixed size, for example by
  /// enclosing it with a [SizedBox], this property defines how the child is aligned
  /// within the available space.
  ///
  /// Always defaults to [Alignment.center].
  final AlignmentGeometry? alignment;

  /// 创建 [InkWell] 的 splash 工厂，它定义了响应点击时 "墨水" 溅开的外观。
  ///
  /// 使用 [NoSplash.splashFactory] 可以禁用墨水溅开的渲染。例如：
  /// ```dart
  /// ElevatedButton(
  ///   style: ElevatedButton.styleFrom(
  ///     splashFactory: NoSplash.splashFactory,
  ///   ),
  ///   onPressed: () { },
  ///   child: const Text('No Splash'),
  /// )
  /// ```
  final InteractiveInkFeatureFactory? splashFactory;

  /// 创建一个小部件，该小部件成为按钮 [Material] 的子级，其子级是按钮的其余部分，包括按钮的 `child` 参数。
  ///
  /// 由 [backgroundBuilder] 创建的小部件被约束为与整个按钮的大小相同，并将出现在按钮子级的后面。
  /// 由 [foregroundBuilder] 创建的小部件被约束为与按钮子级的大小相同，即它会被 [EasyButtonStyle.padding] 缩进，并由按钮的 [EasyButtonStyle.alignment] 对齐。
  ///
  /// 默认情况下，返回的小部件会被裁剪到 Material 的 [EasyButtonStyle.shape]。
  ///
  /// 另请参阅：
  ///
  ///  * [foregroundBuilder]，用于创建与按钮子级一样大的小部件，并层叠在子级后面。
  ///  * [EasyBaseButton.clipBehavior]，有关配置裁剪的更多信息。
  final ButtonLayerBuilder? backgroundBuilder;

  /// 创建一个小部件，该小部件包含按钮的子参数，用于替代按钮的子级。
  ///
  /// 返回的小部件会被按钮的 [EasyButtonStyle.shape] 裁剪，
  /// 并由按钮的 [EasyButtonStyle.padding] 缩进，以及由按钮的 [EasyButtonStyle.alignment] 对齐。
  ///
  /// 另请参阅：
  ///
  ///  * [backgroundBuilder]，用于创建与按钮一样大的小部件，并层叠在按钮的子级后面。
  ///  * [EasyBaseButton.clipBehavior]，有关配置裁剪的更多信息。
  final ButtonLayerBuilder? foregroundBuilder;

  /// Returns a copy of this EasyButtonStyle with the given fields replaced with
  /// the new values.
  EasyButtonStyle copyWith({
    WidgetStateProperty<TextStyle?>? textStyle,
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<EdgeInsetsGeometry?>? padding,
    WidgetStateProperty<Size?>? minimumSize,
    WidgetStateProperty<Size?>? fixedSize,
    WidgetStateProperty<Size?>? maximumSize,
    WidgetStateProperty<Color?>? iconColor,
    WidgetStateProperty<double?>? iconSize,
    IconPosition? iconPosition,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<OutlinedBorder?>? shape,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    return EasyButtonStyle(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      overlayColor: overlayColor ?? this.overlayColor,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      elevation: elevation ?? this.elevation,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      fixedSize: fixedSize ?? this.fixedSize,
      maximumSize: maximumSize ?? this.maximumSize,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      iconPosition: iconPosition ?? this.iconPosition,
      side: side ?? this.side,
      shape: shape ?? this.shape,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      animationDuration: animationDuration ?? this.animationDuration,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      alignment: alignment ?? this.alignment,
      splashFactory: splashFactory ?? this.splashFactory,
      backgroundBuilder: backgroundBuilder ?? this.backgroundBuilder,
      foregroundBuilder: foregroundBuilder ?? this.foregroundBuilder,
    );
  }

  /// Returns a copy of this EasyButtonStyle where the non-null fields in [style]
  /// have replaced the corresponding null fields in this EasyButtonStyle.
  ///
  /// In other words, [style] is used to fill in unspecified (null) fields
  /// this EasyButtonStyle.
  EasyButtonStyle merge(EasyButtonStyle? style) {
    if (style == null) {
      return this;
    }
    return copyWith(
      textStyle: textStyle ?? style.textStyle,
      backgroundColor: backgroundColor ?? style.backgroundColor,
      foregroundColor: foregroundColor ?? style.foregroundColor,
      overlayColor: overlayColor ?? style.overlayColor,
      shadowColor: shadowColor ?? style.shadowColor,
      surfaceTintColor: surfaceTintColor ?? style.surfaceTintColor,
      elevation: elevation ?? style.elevation,
      padding: padding ?? style.padding,
      minimumSize: minimumSize ?? style.minimumSize,
      fixedSize: fixedSize ?? style.fixedSize,
      maximumSize: maximumSize ?? style.maximumSize,
      iconColor: iconColor ?? style.iconColor,
      iconSize: iconSize ?? style.iconSize,
      iconPosition: iconPosition ?? style.iconPosition,
      side: side ?? style.side,
      shape: shape ?? style.shape,
      mouseCursor: mouseCursor ?? style.mouseCursor,
      animationDuration: animationDuration ?? style.animationDuration,
      enableFeedback: enableFeedback ?? style.enableFeedback,
      alignment: alignment ?? style.alignment,
      splashFactory: splashFactory ?? style.splashFactory,
      backgroundBuilder: backgroundBuilder ?? style.backgroundBuilder,
      foregroundBuilder: foregroundBuilder ?? style.foregroundBuilder,
    );
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      textStyle,
      backgroundColor,
      foregroundColor,
      overlayColor,
      shadowColor,
      surfaceTintColor,
      elevation,
      padding,
      minimumSize,
      fixedSize,
      maximumSize,
      iconColor,
      iconSize,
      iconPosition,
      side,
      shape,
      mouseCursor,
      animationDuration,
      enableFeedback,
      alignment,
      splashFactory,
      backgroundBuilder,
      foregroundBuilder,
    ];
    return Object.hashAll(values);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is EasyButtonStyle &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.overlayColor == overlayColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTintColor == surfaceTintColor &&
        other.elevation == elevation &&
        other.padding == padding &&
        other.minimumSize == minimumSize &&
        other.fixedSize == fixedSize &&
        other.maximumSize == maximumSize &&
        other.iconColor == iconColor &&
        other.iconSize == iconSize &&
        other.iconPosition == iconPosition &&
        other.side == side &&
        other.shape == shape &&
        other.mouseCursor == mouseCursor &&
        other.animationDuration == animationDuration &&
        other.enableFeedback == enableFeedback &&
        other.alignment == alignment &&
        other.splashFactory == splashFactory &&
        other.backgroundBuilder == backgroundBuilder &&
        other.foregroundBuilder == foregroundBuilder;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<TextStyle?>>(
        'textStyle',
        textStyle,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'backgroundColor',
        backgroundColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'foregroundColor',
        foregroundColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'overlayColor',
        overlayColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'shadowColor',
        shadowColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'surfaceTintColor',
        surfaceTintColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<double?>>(
        'elevation',
        elevation,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<EdgeInsetsGeometry?>>(
        'padding',
        padding,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Size?>>(
        'minimumSize',
        minimumSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Size?>>(
        'fixedSize',
        fixedSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Size?>>(
        'maximumSize',
        maximumSize,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<Color?>>(
        'iconColor',
        iconColor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<double?>>(
        'iconSize',
        iconSize,
        defaultValue: null,
      ),
    );
    properties.add(
      EnumProperty<IconPosition>(
        'iconPosition',
        iconPosition,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<BorderSide?>>(
        'side',
        side,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<OutlinedBorder?>>(
        'shape',
        shape,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<WidgetStateProperty<MouseCursor?>>(
        'mouseCursor',
        mouseCursor,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<Duration>(
        'animationDuration',
        animationDuration,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'enableFeedback',
        enableFeedback,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<AlignmentGeometry>(
        'alignment',
        alignment,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ButtonLayerBuilder>(
        'backgroundBuilder',
        backgroundBuilder,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<ButtonLayerBuilder>(
        'foregroundBuilder',
        foregroundBuilder,
        defaultValue: null,
      ),
    );
  }

  /// Linearly interpolate between two [EasyButtonStyle]s.
  static EasyButtonStyle? lerp(
    EasyButtonStyle? a,
    EasyButtonStyle? b,
    double t,
  ) {
    if (identical(a, b)) {
      return a;
    }
    return EasyButtonStyle(
      textStyle: WidgetStateProperty.lerp<TextStyle?>(
        a?.textStyle,
        b?.textStyle,
        t,
        TextStyle.lerp,
      ),
      backgroundColor: WidgetStateProperty.lerp<Color?>(
        a?.backgroundColor,
        b?.backgroundColor,
        t,
        Color.lerp,
      ),
      foregroundColor: WidgetStateProperty.lerp<Color?>(
        a?.foregroundColor,
        b?.foregroundColor,
        t,
        Color.lerp,
      ),
      overlayColor: WidgetStateProperty.lerp<Color?>(
        a?.overlayColor,
        b?.overlayColor,
        t,
        Color.lerp,
      ),
      shadowColor: WidgetStateProperty.lerp<Color?>(
        a?.shadowColor,
        b?.shadowColor,
        t,
        Color.lerp,
      ),
      surfaceTintColor: WidgetStateProperty.lerp<Color?>(
        a?.surfaceTintColor,
        b?.surfaceTintColor,
        t,
        Color.lerp,
      ),
      elevation: WidgetStateProperty.lerp<double?>(
        a?.elevation,
        b?.elevation,
        t,
        lerpDouble,
      ),
      padding: WidgetStateProperty.lerp<EdgeInsetsGeometry?>(
        a?.padding,
        b?.padding,
        t,
        EdgeInsetsGeometry.lerp,
      ),
      minimumSize: WidgetStateProperty.lerp<Size?>(
        a?.minimumSize,
        b?.minimumSize,
        t,
        Size.lerp,
      ),
      fixedSize: WidgetStateProperty.lerp<Size?>(
        a?.fixedSize,
        b?.fixedSize,
        t,
        Size.lerp,
      ),
      maximumSize: WidgetStateProperty.lerp<Size?>(
        a?.maximumSize,
        b?.maximumSize,
        t,
        Size.lerp,
      ),
      iconColor: WidgetStateProperty.lerp<Color?>(
        a?.iconColor,
        b?.iconColor,
        t,
        Color.lerp,
      ),
      iconSize: WidgetStateProperty.lerp<double?>(
        a?.iconSize,
        b?.iconSize,
        t,
        lerpDouble,
      ),
      iconPosition: t < 0.5 ? a?.iconPosition : b?.iconPosition,
      side: _lerpSides(a?.side, b?.side, t),
      shape: WidgetStateProperty.lerp<OutlinedBorder?>(
        a?.shape,
        b?.shape,
        t,
        OutlinedBorder.lerp,
      ),
      mouseCursor: t < 0.5 ? a?.mouseCursor : b?.mouseCursor,
      animationDuration: t < 0.5 ? a?.animationDuration : b?.animationDuration,
      enableFeedback: t < 0.5 ? a?.enableFeedback : b?.enableFeedback,
      alignment: AlignmentGeometry.lerp(a?.alignment, b?.alignment, t),
      splashFactory: t < 0.5 ? a?.splashFactory : b?.splashFactory,
      backgroundBuilder: t < 0.5 ? a?.backgroundBuilder : b?.backgroundBuilder,
      foregroundBuilder: t < 0.5 ? a?.foregroundBuilder : b?.foregroundBuilder,
    );
  }

  // Special case because BorderSide.lerp() doesn't support null arguments
  static WidgetStateProperty<BorderSide?>? _lerpSides(
    WidgetStateProperty<BorderSide?>? a,
    WidgetStateProperty<BorderSide?>? b,
    double t,
  ) {
    if (a == null && b == null) {
      return null;
    }
    return WidgetStateBorderSide.lerp(a, b, t);
  }

  /// A static convenience method that constructs an outlined button
  /// [ButtonStyle] given simple values.
  ///
  /// The [foregroundColor] and [disabledForegroundColor] colors are used
  /// to create a [WidgetStateProperty] [ButtonStyle.foregroundColor], and
  /// a derived [ButtonStyle.overlayColor] if [overlayColor] isn't specified.
  ///
  /// The [backgroundColor] and [disabledBackgroundColor] colors are
  /// used to create a [WidgetStateProperty] [ButtonStyle.backgroundColor].
  ///
  /// Similarly, the [enabledMouseCursor] and [disabledMouseCursor]
  /// parameters are used to construct [ButtonStyle.mouseCursor].
  ///
  /// The [iconColor], [disabledIconColor] are used to construct
  /// [ButtonStyle.iconColor] and [iconSize] is used to construct
  /// [ButtonStyle.iconSize].
  ///
  /// If [iconColor] is null, the button icon will use [foregroundColor]. If [foregroundColor] is also
  /// null, the button icon will use the default icon color.
  ///
  /// If [overlayColor] is specified and its value is [Colors.transparent]
  /// then the pressed/focused/hovered highlights are effectively defeated.
  /// Otherwise a [WidgetStateProperty] with the same opacities as the
  /// default is created.
  ///
  /// All of the other parameters are either used directly or used to
  /// create a [WidgetStateProperty] with a single value for all
  /// states.
  ///
  /// All parameters default to null, by default this method returns
  /// a [ButtonStyle] that doesn't override anything.
  ///
  /// For example, to override the default shape and outline for an
  /// [OutlinedButton], one could write:
  ///
  /// ```dart
  /// OutlinedButton(
  ///   style: OutlinedButton.styleFrom(
  ///      shape: const StadiumBorder(),
  ///      side: const BorderSide(width: 2, color: Colors.green),
  ///   ),
  ///   child: const Text('Seasons of Love'),
  ///   onPressed: () {
  ///     // ...
  ///   },
  /// ),
  /// ```
  static EasyButtonStyle styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? iconColor,
    double? iconSize,
    IconPosition? iconPosition,
    Color? disabledIconColor,
    Color? overlayColor,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    OutlinedBorder? shape,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    final WidgetStateProperty<Color?>? backgroundColorProp = switch ((
      backgroundColor,
      disabledBackgroundColor,
    )) {
      (_?, null) => WidgetStatePropertyAll<Color?>(backgroundColor),
      (_, _) => BaseButton.defaultColor(
        backgroundColor,
        disabledBackgroundColor,
      ),
    };
    final WidgetStateProperty<Color?>? overlayColorProp = switch ((
      foregroundColor,
      overlayColor,
    )) {
      (null, null) => null,
      (_, Color(a: 0.0)) => WidgetStatePropertyAll<Color?>(overlayColor),
      (_, final Color color) || (final Color color, _) =>
        WidgetStateProperty<Color?>.fromMap(<WidgetState, Color?>{
          WidgetState.pressed: color.withOpacity(0.1),
          WidgetState.hovered: color.withOpacity(0.08),
          WidgetState.focused: color.withOpacity(0.1),
        }),
    };

    return EasyButtonStyle(
      textStyle: BaseButton.allOrNull<TextStyle>(textStyle),
      foregroundColor: BaseButton.defaultColor(
        foregroundColor,
        disabledForegroundColor,
      ),
      backgroundColor: backgroundColorProp,
      overlayColor: overlayColorProp,
      shadowColor: BaseButton.allOrNull<Color>(shadowColor),
      surfaceTintColor: BaseButton.allOrNull<Color>(surfaceTintColor),
      iconColor: BaseButton.defaultColor(iconColor, disabledIconColor),
      iconSize: BaseButton.allOrNull<double>(iconSize),
      iconPosition: iconPosition,
      elevation: BaseButton.allOrNull<double>(elevation),
      padding: BaseButton.allOrNull<EdgeInsetsGeometry>(padding),
      minimumSize: BaseButton.allOrNull<Size>(minimumSize),
      fixedSize: BaseButton.allOrNull<Size>(fixedSize),
      maximumSize: BaseButton.allOrNull<Size>(maximumSize),
      side: BaseButton.allOrNull<BorderSide>(side),
      shape: BaseButton.allOrNull<OutlinedBorder>(shape),
      mouseCursor: WidgetStateProperty<MouseCursor?>.fromMap(
        <WidgetStatesConstraint, MouseCursor?>{
          WidgetState.disabled: disabledMouseCursor,
          WidgetState.any: enabledMouseCursor,
        },
      ),
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
      backgroundBuilder: backgroundBuilder,
      foregroundBuilder: foregroundBuilder,
    );
  }
}
