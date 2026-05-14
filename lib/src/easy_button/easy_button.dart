import 'package:easy_ui/src/easy_button/easy_button_style.dart';
import 'package:flutter/material.dart';

import '../easy_theme.dart';
import 'base.dart';

/// 按钮尺寸枚举
enum EasyButtonSize {
  /// 小 水平padding: 16, 垂直padding: 8
  small,

  /// 大 水平padding: 16, 垂直padding: 12
  big,
}

enum EasyButtonType {
  defalut(EasyButtonSize.big), // 默认按钮
  primary(EasyButtonSize.big), // 主色按钮
  secondary(EasyButtonSize.small), // 主色按钮（蓝色）
  outline(EasyButtonSize.big), // 描边按钮
  info(EasyButtonSize.small), // 信息按钮
  text(EasyButtonSize.small), // 文字按钮

  iconDefault(EasyButtonSize.big), //默认图标按钮
  iconPrimary(EasyButtonSize.big); //主色图标按钮

  final EasyButtonSize size;

  const EasyButtonType(this.size);

  EasyButtonStyle defaultStyleOf(
    BuildContext context,
    EasyButtonSize? buttonSize,
  ) {
    final size = buttonSize ?? this.size;
    return switch (this) {
      EasyButtonType.defalut => _DefalutButtonDefaultStyle(context, size),
      EasyButtonType.primary => _PrimaryButtonDefaultStyle(context, size),
      EasyButtonType.secondary => _SecondaryButtonDefaultStyle(context, size),
      EasyButtonType.outline => _OutlineButtonDefaultStyle(context, size),
      EasyButtonType.info => _InfoButtonDefaultStyle(context, size),
      EasyButtonType.text => _TextButtonDefaultStyle(context, size),
      EasyButtonType.iconDefault => _DefalutIconButtonDefaultStyle(
        context,
        size,
      ),
      EasyButtonType.iconPrimary => _PrimaryIconButtonDefaultStyle(
        context,
        size,
      ),
    };
  }
}

class EasyButton2 extends BaseButton {
  const EasyButton2({
    super.key,
    super.onPressed,
    super.onLongPress,
    super.onHover,
    super.onFocusChange,
    super.style,
    super.focusNode,
    super.autofocus = false,
    super.clipBehavior,
    super.statesController,
    super.withDebounce,
    super.tooltip,
    this.showHover = true,
    this.showSplash = true,
    this.type = EasyButtonType.primary,
    this.size,
    required super.child,
  });

  /// 按钮类型，默认为`EasyButtonType.primary`
  final EasyButtonType type;

  /// 按钮尺寸（不同风格的按钮具有不同的默认尺寸）
  final EasyButtonSize? size;

  /// 是否展示 `Hover` 状态
  /// 默认值为 `true`
  /// 当设置为 `false` 时，按钮将不会展示悬停时的交互动效
  final bool showHover;

  /// 是否展示按下等交互动效
  /// 默认值为 `true`
  /// 当设置为 `false` 时，按钮将不会展示按下时的交互动效
  final bool showSplash;

  @override
  EasyButtonStyle defaultStyleOf(BuildContext context) {
    final defaultStyle = type.defaultStyleOf(context, size);

    final defualtOverlayColor = defaultStyle.overlayColor;
    return defaultStyle.copyWith(
      overlayColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          if (!showSplash) {
            Colors.transparent;
          } else {
            return defualtOverlayColor?.resolve(states);
          }
        }
        if (states.contains(WidgetState.hovered)) {
          if (!showHover) {
            return Colors.transparent;
          } else {
            return defualtOverlayColor?.resolve(
              states.difference({WidgetState.pressed}),
            );
          }
        }
        return defualtOverlayColor?.resolve(states);
      }),
      splashFactory: !showSplash ? NoSplash.splashFactory : null,
    );
  }

  /// TODO 暂时不支持通过主题配置，只支持默认样式和组件自定义样式
  @override
  EasyButtonStyle? themeStyleOf(BuildContext context) => null;

  factory EasyButton2.icon({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    ValueChanged<bool>? onFocusChange,
    EasyButtonStyle? style,
    FocusNode? focusNode,
    bool? autofocus,
    Clip? clipBehavior,
    WidgetStatesController? statesController,
    Widget? icon,
    required Widget child,
    bool? withDebounce,
    double? spacing,
    EasyButtonType? type,
    EasyButtonSize? size,
    bool? showHover,
    bool? showSplash,
  }) {
    assert(
      type != EasyButtonType.iconDefault && type != EasyButtonType.iconPrimary,
      'EasyButtonType.iconDefault 和 EasyButtonType.iconPrimary 不支持 .icon 构造函数。\nEasyButtonType.iconDefault and EasyButtonType.iconPrimary do not support .icon Constructor.',
    );

    if (icon == null) {
      return EasyButton2(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        clipBehavior: clipBehavior ?? Clip.none,
        statesController: statesController,
        withDebounce: withDebounce ?? true,
        type: type ?? EasyButtonType.primary,
        size: size,
        showHover: showHover ?? true,
        showSplash: showSplash ?? true,
        child: child,
      );
    }
    return EasyButton2(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      clipBehavior: clipBehavior ?? Clip.none,
      statesController: statesController,
      withDebounce: withDebounce ?? true,
      type: type ?? EasyButtonType.primary,
      size: size,
      showHover: showHover ?? true,
      showSplash: showSplash ?? true,
      child: _EasyButtonWithIconChild(
        icon: icon,
        label: child,
        buttonStyle: style,
        spacing: spacing ?? 8.0,
      ),
    );
  }
}

class _EasyButtonWithIconChild extends StatelessWidget {
  const _EasyButtonWithIconChild({
    required this.label,
    required this.icon,
    required this.buttonStyle,
    this.spacing = 8.0,
  });

  final Widget label;
  final Widget icon;
  final EasyButtonStyle? buttonStyle;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final IconPosition effectiveIconPosition =
        buttonStyle?.iconPosition ?? IconPosition.start;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: spacing,
      children:
          effectiveIconPosition == IconPosition.start
              ? <Widget>[icon, Flexible(child: label)]
              : <Widget>[Flexible(child: label), icon],
    );
  }
}

/// 以下为按钮的默认样式类
// dart format off
class _DefalutButtonDefaultStyle extends EasyButtonStyle {
  _DefalutButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ThemeData _theme = Theme.of(context);
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStatePropertyAll<Color>(switch (size) {
    EasyButtonSize.small => easyTheme.neutralEE,
    EasyButtonSize.big => easyTheme.background,
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => easyTheme.neutral66,
      EasyButtonSize.big => easyTheme.neutral99,
    };
    if (states.contains(WidgetState.disabled)) {
      return color.withValues(alpha: 0.5);
    }
    return color;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => easyTheme.neutral66,
      EasyButtonSize.big => easyTheme.neutral99,
    };
    if (states.contains(WidgetState.pressed)) {
      return color.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return color.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return color.withValues(alpha: 0.01);
    }

    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<BorderSide>? get side => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final border = switch (size) {
      EasyButtonSize.small => BorderSide(style: BorderStyle.none),
      EasyButtonSize.big => BorderSide(color: easyTheme.neutralEE),
    };
    return border;
  });

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _PrimaryButtonDefaultStyle extends EasyButtonStyle {
  _PrimaryButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  final EasyButtonSize size;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.12);
    }
    return easyTheme.primaryGreen;
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    return Colors.white;
  });
  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.white.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return Colors.white.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return Colors.white.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _SecondaryButtonDefaultStyle extends EasyButtonStyle {
  _SecondaryButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.12);
    }
    return easyTheme.secondaryBlue;
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    return Colors.white;
  });
  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return Colors.white.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return Colors.white.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return Colors.white.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _OutlineButtonDefaultStyle extends EasyButtonStyle {
  _OutlineButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStatePropertyAll<Color>(easyTheme.background);

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    return easyTheme.primaryGreen;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<BorderSide>? get side => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return BorderSide(color: _colors.onSurface.withValues(alpha: 0.2));
    }
    return BorderSide(color: easyTheme.primaryGreen);
  });

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );
  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _InfoButtonDefaultStyle extends EasyButtonStyle {
  _InfoButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ThemeData _theme = Theme.of(context);
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return easyTheme.neutralEE.withValues(alpha: 0.8);
    }
    return easyTheme.neutralBB;
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return easyTheme.neutralBB.withValues(alpha: 0.4);
    }
    return easyTheme.neutralEE;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return easyTheme.neutralEE.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return easyTheme.neutralEE.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return easyTheme.neutralEE.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );

  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _TextButtonDefaultStyle extends EasyButtonStyle {
  _TextButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<TextStyle?> get textStyle =>
      WidgetStatePropertyAll<TextStyle?>(TextStyle(fontSize: 14, fontWeight: FontWeight.w500, fontFamily: _theme.textTheme.bodySmall?.fontFamily));

  @override
  WidgetStateProperty<Color?>? get backgroundColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    return easyTheme.primaryGreen;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return easyTheme.primaryGreen.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    EasyButtonSize.big => EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => const WidgetStatePropertyAll<double>(18.0);

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );
  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _DefalutIconButtonDefaultStyle extends EasyButtonStyle {
  _DefalutIconButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => easyTheme.neutralEE,
      EasyButtonSize.big => easyTheme.neutralF8,
    };
    if (states.contains(WidgetState.disabled)) {
      return color.withValues(alpha: 0.80);
    }
    return color;
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    if (states.contains(WidgetState.selected)) {
      return _colors.primary;
    }
    return easyTheme.neutral99;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.pressed)) {
      return easyTheme.neutral99.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return easyTheme.neutral99.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return easyTheme.neutral99.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.all(6),
    EasyButtonSize.big => EdgeInsets.all(12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => WidgetStatePropertyAll<double>(switch (size) {
    EasyButtonSize.small => 12.0,
    EasyButtonSize.big => 16.0,
  });

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );
  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}

class _PrimaryIconButtonDefaultStyle extends EasyButtonStyle {
  _PrimaryIconButtonDefaultStyle(this.context, this.size)
    : super(animationDuration: kThemeChangeDuration, enableFeedback: true, alignment: Alignment.center);

  final BuildContext context;
  final EasyButtonSize size;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final EasyThemeData easyTheme = EasyTheme.of(context);

  @override
  WidgetStateProperty<Color?>? get backgroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => easyTheme.primaryGreen,
      EasyButtonSize.big => easyTheme.primaryGreen.withValues(alpha: 0.2),
    };
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.12);
    }
    return color;
  });

  @override
  WidgetStateProperty<Color?>? get foregroundColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => Colors.white,
      EasyButtonSize.big => easyTheme.primaryGreen,
    };
    if (states.contains(WidgetState.disabled)) {
      return _colors.onSurface.withValues(alpha: 0.38);
    }
    if (states.contains(WidgetState.selected)) {
      return _colors.primary;
    }
    return color;
  });

  @override
  WidgetStateProperty<Color?>? get overlayColor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    final color = switch (size) {
      EasyButtonSize.small => Colors.white,
      EasyButtonSize.big => easyTheme.primaryGreen,
    };
    if (states.contains(WidgetState.pressed)) {
      return color.withValues(alpha: 0.1);
    }
    if (states.contains(WidgetState.hovered)) {
      return color.withValues(alpha: 0.08);
    }
    if (states.contains(WidgetState.focused)) {
      return color.withValues(alpha: 0.1);
    }
    return null;
  });

  @override
  WidgetStateProperty<Color>? get shadowColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<Color>? get surfaceTintColor => const WidgetStatePropertyAll<Color>(Colors.transparent);

  @override
  WidgetStateProperty<double>? get elevation => const WidgetStatePropertyAll<double>(0.0);

  @override
  WidgetStateProperty<EdgeInsetsGeometry>? get padding => WidgetStatePropertyAll<EdgeInsetsGeometry>(switch (size) {
    EasyButtonSize.small => EdgeInsets.all(6),
    EasyButtonSize.big => EdgeInsets.all(12),
  });

  @override
  WidgetStateProperty<Size>? get minimumSize => const WidgetStatePropertyAll<Size>(Size.zero);

  // No default fixedSize

  @override
  WidgetStateProperty<double>? get iconSize => WidgetStatePropertyAll<double>(switch (size) {
    EasyButtonSize.small => 12.0,
    EasyButtonSize.big => 16.0,
  });

  @override
  WidgetStateProperty<Size>? get maximumSize => const WidgetStatePropertyAll<Size>(Size.infinite);

  // No default side

  @override
  WidgetStateProperty<OutlinedBorder>? get shape => WidgetStatePropertyAll<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: BorderRadius.all(easyTheme.cornerSmall)),
  );
  @override
  WidgetStateProperty<MouseCursor?>? get mouseCursor => WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return SystemMouseCursors.click;
  });

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;
}
// dart format on
