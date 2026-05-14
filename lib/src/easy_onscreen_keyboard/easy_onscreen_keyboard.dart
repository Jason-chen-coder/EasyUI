/// A fully customizable on-screen keyboard widget for Flutter.
///
/// The `flutter_onscreen_keyboard` package provides both a high-level keyboard
/// interface (`EasyOnscreenKeyboard`) and a low-level stateless version
/// for building embedded or floating virtual keyboards.
///
/// Features:
/// - Text and action keys with customizable layout
/// - Shift/CapsLock support with smart secondary character switching
/// - Dedicated [EasyOnscreenKeyboardTextField] for ease of use
/// - Movable/floating keyboard with drag support
/// - Theming and layout customization
///
/// Ideal for POS interfaces, desktop apps, or accessibility tools.
///
/// See also:
/// - [EasyRawOnscreenKeyboard] - a low-level keyboard widget
/// - [EasyOnscreenKeyboardTextField] - dedicated text field widget
/// - [EasyOnscreenKeyboardTextFormField] - dedicated text form field widget
/// - [EasyOnscreenKeyboardController] - interface for controlling the keyboard
library;

export 'src/layouts/layouts.dart';
export 'src/models/keys.dart';
export 'src/models/layout.dart';
export 'src/easy_onscreen_keyboard.dart'
    show
        EasyOnscreenKeyboard,
        EasyOnscreenKeyboardController,
        EasyOnscreenKeyboardTextField,
        EasyOnscreenKeyboardTextFieldBuilder,
        EasyOnscreenKeyboardTextFormField,
        EasyOnscreenKeyboardTextFormFieldBuilder;
export 'src/easy_raw_onscreen_keyboard.dart' show EasyRawOnscreenKeyboard;
export 'src/theme/easy_onscreen_keyboard_theme_data.dart';
export 'src/easy_onscreen_text_form_field.dart';
