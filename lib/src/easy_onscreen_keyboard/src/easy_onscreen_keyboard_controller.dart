part of 'easy_onscreen_keyboard.dart';

/// An interface for controlling the [EasyOnscreenKeyboard] programmatically.
///
/// This allows opening and closing the keyboard, changing its alignment,
/// managing focus and text input sources, and adding listeners
/// for raw key events.
abstract interface class EasyOnscreenKeyboardController {
  /// Opens the onscreen keyboard.
  void open();

  /// Closes the onscreen keyboard.
  void close();

  /// Switches the currently active text field back to the system keyboard.
  ///
  /// If there is no active field attached, this does nothing.
  void switchToSystemKeyboard();

  /// The current layout of the onscreen keyboard.
  KeyboardLayout get layout;

  /// Sets the alignment of the onscreen keyboard.
  ///
  /// [alignment] defines where the keyboard should appear in the app.
  void setAlignment(Alignment alignment);

  /// Moves the keyboard to the top-center of the available screen space.
  void moveToTop();

  /// Moves the keyboard to the bottom-center of the available screen space.
  void moveToBottom();

  /// Attaches an [OnscreenKeyboardFieldState] to the keyboard,
  /// making it the active input field for text input.
  ///
  /// > This will automatically detach any previously
  /// attached [EasyOnscreenKeyboardTextField].
  void attachTextField(OnscreenKeyboardFieldState state);

  /// Detaches a previously attached [OnscreenKeyboardFieldState].
  ///
  /// If no [state] is provided, detaches the currently active one.
  void detachTextField([OnscreenKeyboardFieldState? state]);

  /// Adds a listener to receive raw key down events from the keyboard.
  ///
  /// Useful for handling custom shortcuts or key-based interactions.
  void addRawKeyDownListener(OnscreenKeyboardListener listener);

  /// Removes a previously added raw key down listener.
  void removeRawKeyDownListener(OnscreenKeyboardListener listener);

  /// Cycles to the next keyboard layout mode in the order they are defined.
  ///
  /// Keyboard modes are defined in the [KeyboardLayout.modes] map.
  /// Calling this method switches the current mode to the next one,
  /// wrapping around to the first mode when the end is reached.
  void switchMode();

  /// Sets the keyboard mode to the one specified by [modeName].
  ///
  /// The [modeName] must exist in the current [KeyboardLayout.modes].
  void setModeNamed(String modeName);
}
