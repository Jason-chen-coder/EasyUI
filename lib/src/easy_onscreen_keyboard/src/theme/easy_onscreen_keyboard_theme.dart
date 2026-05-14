import 'package:flutter/widgets.dart';
import '../../easy_onscreen_keyboard.dart';

/// An [InheritedWidget] that provides [EasyOnscreenKeyboardThemeData] to
/// its descendants.
///
/// Use this widget to apply consistent theming to all onscreen keyboard
/// widgets within its subtree. You can access the theme data
/// using [EasyOnscreenKeyboardTheme.of].
class EasyOnscreenKeyboardTheme extends InheritedWidget {
  /// Creates an [EasyOnscreenKeyboardTheme].
  ///
  /// The [data] parameter holds the theme configuration,
  /// and [child] is the subtree that will receive the theme.
  const EasyOnscreenKeyboardTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The theme data that will be propagated to all descendants.
  final EasyOnscreenKeyboardThemeData data;

  @override
  bool updateShouldNotify(EasyOnscreenKeyboardTheme oldWidget) =>
      data != oldWidget.data;

  /// Retrieves the nearest [EasyOnscreenKeyboardThemeData] up the widget tree.
  ///
  /// This allows any descendant widget to access the keyboard theme data using:
  /// ```dart
  /// final theme = EasyOnscreenKeyboardTheme.of(context);
  /// ```
  static EasyOnscreenKeyboardThemeData of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<EasyOnscreenKeyboardTheme>()!
        .data;
  }
}
