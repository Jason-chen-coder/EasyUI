import 'dart:ui';

import 'package:flutter/material.dart' as m;
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'easy_menu/easy_menu_style.dart';
import 'easy_select/easy_select_style.dart';

class EasyTheme extends StatelessWidget {
  const EasyTheme({super.key, required this.data, required this.child});

  final EasyThemeData data;

  static EasyThemeData of(BuildContext context) {
    final InheritedEasyTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<InheritedEasyTheme>();
    assert(inheritedTheme != null, 'No EasyTheme found.');
    return inheritedTheme!.theme.data;
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorSchemes.lightGreen(),
        radius: 0,
        scaling: 1,
      ),
      child: InheritedEasyTheme(theme: this, child: child),
    );
  }
}

class InheritedEasyTheme extends InheritedTheme {
  const InheritedEasyTheme({
    super.key,
    required this.theme,
    required super.child,
  });

  final EasyTheme theme;

  @override
  bool updateShouldNotify(InheritedEasyTheme oldWidget) {
    return theme.data != oldWidget.theme.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return EasyTheme(data: theme.data, child: child);
  }
}

class EasyThemeData {
  EasyThemeData({this.brightness = Brightness.light}) {
    easyTextFormFieldInputDecorationTheme = m.InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      errorMaxLines: 3,
      errorStyle: TextStyle(color: warning, fontSize: 12),
      labelStyle: TextStyle(fontSize: 14, color: neutral66),
      helperStyle: TextStyle(fontSize: 12, color: neutral66),
      counterStyle: TextStyle(fontSize: 12, color: neutral66),
      hintStyle: TextStyle(color: neutral99),
      border: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: neutralEE),
      ),
      focusedBorder: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: neutralEE),
      ),
      enabledBorder: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: neutralEE),
      ),
      disabledBorder: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: neutralEE),
      ),
      errorBorder: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: warning),
      ),
      focusedErrorBorder: m.OutlineInputBorder(
        borderRadius: BorderRadius.all(cornerSmall),
        borderSide: BorderSide(color: warning),
      ),
    );
    easyMenuStyle = EasyMenuStyle(
      backgroundColor: background,
      borderRadius: BorderRadius.all(cornerSmall),
      boxShadows: [
        BoxShadow(
          color: secondaryBlue.withAlpha(0x40),
          offset: Offset(0, 2),
          blurRadius: 3,
        ),
      ],
    );
    easySelectStyle = EasySelectStyle(
      triggerContentPadding: const EdgeInsets.symmetric(horizontal: 12),
      triggerBorderColor: neutralEE,
      placeholderTextStyle: TextStyle(fontSize: 14, color: neutral66),
      displayTextStyle: TextStyle(fontSize: 14, color: neutral66),
      triggerConstraints: BoxConstraints.tightFor(height: 38),
    );
  }

  // 颜色模式
  final Brightness brightness;

  // 标题文字中性色
  Color get neutral33 => switch (brightness) {
    Brightness.light => Color(0xFF333333),
    Brightness.dark => Color(0xFFFFFFFF),
  };
  // 正文文字
  Color get neutral66 => switch (brightness) {
    Brightness.light => Color(0xFF666666),
    Brightness.dark => Color(0xFFABB4C5),
  };
  // 次要文字
  Color get neutral99 => switch (brightness) {
    Brightness.light => Color(0xFF999999),
    Brightness.dark => Color(0xFF535F75),
  };
  // 次要文字
  Color get neutral9B => switch (brightness) {
    Brightness.light => Color(0xFF9B9B9B),
    Brightness.dark => Color(0xFFB7B7B7),
  };
  Color get neutralB7 => switch (brightness) {
    Brightness.light => Color(0xFFB7B7B7),
    Brightness.dark => Color(0xFF9B9B9B),
  };
  Color get neutralBB => switch (brightness) {
    Brightness.light => Color(0xFFBBBBBB),
    Brightness.dark => Color(0xFF999999),
  };
  // 边框、分割线等
  Color get neutralEE => switch (brightness) {
    Brightness.light => Color(0xFFEEEEEE),
    Brightness.dark => Color(0xFF2E3543),
  };
  // 除白色外的底色
  Color get neutralF8 => switch (brightness) {
    Brightness.light => Color(0xFFF8F8F8),
    Brightness.dark => Color(0xFF18202E),
  };
  // 除白色外的底色上的文本颜色
  Color get onNeutralF8 => switch (brightness) {
    Brightness.light => Color(0xFF666666),
    Brightness.dark => Color(0xFFFFFFFF),
  };

  // 背景色
  Color get background => switch (brightness) {
    Brightness.light => Colors.white,
    Brightness.dark => Color(0xFF08121F),
  };

  // 背景色上的文本色
  Color get onBackground => switch (brightness) {
    Brightness.light => Colors.black,
    Brightness.dark => Colors.white,
  };

  // 卡片背景色
  Color get cardBackground => switch (brightness) {
    Brightness.light => Colors.white,
    Brightness.dark => Color(0xFF2E3543),
  };
  // 卡片背景色上的文本色
  Color get onCardBackground => switch (brightness) {
    Brightness.light => Color(0xFF666666),
    Brightness.dark => Colors.white,
  };

  // 主色
  final Color primaryGreen = Color(0xFF31DA9F);

  // 辅助色集合
  List<Color> get secondaryColors {
    return [
      secondaryBlue,
      secondaryPurple,
      secondaryPurpleBlue,
      secondaryCyan,
      secondaryGreen,
      secondaryAmber,
      secondaryOrange,
    ];
  }

  // 辅助色
  Color get secondaryBlue => switch (brightness) {
    Brightness.light => secondaryBlueLight,
    Brightness.dark => secondaryBlueDark,
  };
  final Color secondaryBlueLight = Color(0xFF1484FC);
  final Color secondaryBlueDark = Color(0xFF609DD6);
  final Color tertiaryBlue = Color(0xFF4CCDF0);
  final Color secondaryPurple = Color(0xFF907FF0);
  final Color secondaryPurpleBlue = Color(0xFF6E8EFF);
  final Color secondaryCyan = Color(0xFF2BC8E4);
  final Color secondaryGreen = Color(0xFF7EDA99);
  final Color secondaryAmber = Color(0xFFF4BE59);
  final Color secondaryOrange = Color(0xFFFFAF33);

  // 特殊色
  final Color logoBlue = Color(0xFF0057FF); // logo蓝
  final Color termination = Color(0xFF8D8C8D); // 终止
  Color get warning => switch (brightness) {
    Brightness.light => warningLight,
    Brightness.dark => warningDark,
  };
  final Color warningLight = Color(0xFFFF2728);
  final Color warningDark = Color(0xFFC63A3B);

  // 圆角
  final Radius cornerSmall = Radius.circular(4.0);
  final Radius cornerMedium = Radius.circular(8.0);
  final Radius cornerLarge = Radius.circular(12.0);

  /// 表单输入框主题
  late final m.InputDecorationTheme easyTextFormFieldInputDecorationTheme;
  late final EasyMenuStyle easyMenuStyle;

  /// [EasySelect]组件主题样式
  late final EasySelectStyle easySelectStyle;

  // Theme Configuration
  m.ThemeData buildMaterialTheme() {
    return m.ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: background,
      fontFamily: 'HarmonyOS_SansSC',
      primaryColor: primaryGreen,
      hintColor: const Color(0xffA5A5A5),
      colorScheme: m.ColorScheme.fromSeed(
        seedColor: primaryGreen,
        secondary: secondaryBlue,
        brightness: brightness,
      ),
      textButtonTheme: m.TextButtonThemeData(
        style: m.TextButton.styleFrom(foregroundColor: neutral66),
      ),
      elevatedButtonTheme: m.ElevatedButtonThemeData(
        style: m.ElevatedButton.styleFrom(
          backgroundColor: primaryGreen, //按钮的背景色
          foregroundColor: background, //子组件的文本颜色
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      filledButtonTheme: m.FilledButtonThemeData(
        style: m.FilledButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: background,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
      ),
      appBarTheme: m.AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
      ),
      useMaterial3: true,
      drawerTheme: m.DrawerThemeData(
        scrimColor: const Color(0xFF000000).withOpacity(0.2), // 设置遮罩颜色为透明
      ),
      switchTheme: m.SwitchThemeData(
        materialTapTargetSize: m.MaterialTapTargetSize.padded,
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => Color(0xffe2e2e3),
        ),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF31DA9F);
          } else {
            return const Color(0xffe2e2e3);
          }
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return background; // 选中时圆的颜色
          } else {
            return background; // 未选中时圆的颜色
          }
        }),
      ),
      checkboxTheme: m.CheckboxThemeData(
        checkColor: m.WidgetStatePropertyAll(background),
        fillColor: m.WidgetStateProperty.resolveWith((states) {
          if (states.contains(m.WidgetState.disabled)) {
            return Color(0xFFD9D9D9);
          }
          if (states.contains(m.WidgetState.selected)) {
            return primaryGreen;
          }
          return background;
        }),
        side: BorderSide(color: neutralEE),
      ),
    );
  }
}

m.ThemeData easyBuildMaterialTheme({
  EasyThemeData? data,
  Brightness brightness = Brightness.light,
}) {
  final EasyThemeData themeData = data ?? EasyThemeData(brightness: brightness);
  return themeData.buildMaterialTheme();
}
