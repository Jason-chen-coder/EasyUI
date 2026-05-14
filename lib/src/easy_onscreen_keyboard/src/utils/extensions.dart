import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../../easy_onscreen_keyboard.dart';
import '../theme/easy_onscreen_keyboard_theme.dart';

/// Extension on [BuildContext] to simplify access to
/// [EasyOnscreenKeyboardThemeData].
extension ContextExt on BuildContext {
  /// Returns the [EasyOnscreenKeyboardThemeData] from the nearest
  /// [EasyOnscreenKeyboardTheme] ancestor.
  EasyOnscreenKeyboardThemeData get theme => EasyOnscreenKeyboardTheme.of(this);

  /// Returns the [EasyOnscreenKeyboardController] from the [BuildContext].
  EasyOnscreenKeyboardController get controller =>
      EasyOnscreenKeyboard.of(this);
}

/// Extension on [Color] to easily adjust opacity.
extension ColorExt on Color {
  /// Returns a new color with the given [alpha] applied.
  ///
  /// Defaults to 0.5 opacity.
  Color fade([double alpha = 0.5]) => withValues(alpha: alpha);
}

/// Extension to easily log any value to the console.
///
/// For debugging purposes only.
extension LoggerExt<T> on T {
  /// Logs the value to the console with the given [name].
  @Deprecated('Should not used in production')
  T logger([String? name]) {
    if (kDebugMode) log(toString(), name: name ?? 'flutter_onscreen_keyboard');
    return this;
  }
}

/// Extension on [TextEditingController] to easily access text selection.
extension TextEditingControllerExt on TextEditingController {
  /// Text selection start.
  int get start => selection.start;

  /// Text selection end.
  int get end => selection.end;
}
