import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../easy_theme.dart';
import '../../l10n/gen/easy_ui_localizations.dart';
import '../easy_onscreen_keyboard.dart';
import 'constants/action_key_type.dart';
import 'theme/easy_onscreen_keyboard_theme.dart';
import 'types.dart';
import 'utils/extensions.dart';

part 'easy_onscreen_keyboard_controller.dart';
part 'easy_onscreen_keyboard_field_state.dart';
part 'easy_onscreen_keyboard_text_field.dart';
part 'easy_onscreen_keyboard_text_field_builder.dart';
part 'easy_onscreen_keyboard_text_form_field.dart';
part 'easy_onscreen_keyboard_text_form_field_builder.dart';

/// A customizable on-screen keyboard widget.
///
/// Wrap your application with this widget to enable the
/// on-screen keyboard functionality.
class EasyOnscreenKeyboard extends StatefulWidget {
  /// Creates an [EasyOnscreenKeyboard].
  const EasyOnscreenKeyboard({
    required this.child,
    super.key,
    this.layout,
    this.theme,
    this.width,
    this.dragHandle,
    this.aspectRatio,
    this.showControlBar = true,
    this.buildControlBarActions,
  });

  /// The main application child widget.
  final Widget child;

  /// The layout configuration for the keyboard.
  ///
  /// If not provided, a default layout will be selected automatically
  /// based on the current [defaultTargetPlatform] — a [MobileKeyboardLayout]
  /// for Android/iOS/Fuchsia and a [DesktopKeyboardLayout] for
  /// macOS/Windows/Linux.
  final KeyboardLayout? layout;

  /// Custom theme for the on-screen keyboard UI.
  ///
  /// If not provided, a default theme based on
  /// the current [ThemeData] will be used.
  final EasyOnscreenKeyboardThemeData? theme;

  /// An optional width configuration function for the keyboard.
  final WidthGetter? width;

  /// A widget displayed as a drag handle to move the keyboard.
  final Widget? dragHandle;

  /// {@macro keyboardLayout.aspectRatio}
  final double? aspectRatio;

  /// Whether to show the control bar at the top of the keyboard.
  /// Defaults to `true`.
  final bool showControlBar;

  /// {@macro controlBar.actions}
  final ActionsBuilder? buildControlBarActions;

  /// A builder to wrap the app with [EasyOnscreenKeyboard].
  ///
  /// This provides a convenient way to globally integrate the
  /// on-screen keyboard into your app by setting it as the
  /// `builder` of your [MaterialApp] or [WidgetsApp].
  ///
  /// ### Example
  /// ```dart
  /// MaterialApp(
  ///   builder: EasyOnscreenKeyboard.builder(
  ///     width: (context) => 600,
  ///     aspectRatio: 5 / 2,
  ///     // ...more options
  ///   ),
  ///   home: const HomeScreen(),
  /// );
  /// ```
  ///
  /// - [theme]: Custom theme configuration for the keyboard, such as color,
  ///   shadow, border, margin, and shape. If null, defaults will be applied.
  /// - [layout]: Keyboard layout to render. Falls back to default layout
  ///   if not set.
  /// - [width]: A function that returns the keyboard's width.
  /// - [showControlBar]: Whether to show the control bar at the top of the
  ///   keyboard. Defaults to `true`.
  /// - [dragHandle]: A widget to show as the drag handle above the keyboard.
  ///   If null, a default handle is shown.
  /// - [aspectRatio]: Determines the width-to-height ratio of the
  ///   keyboard widget.
  /// - [buildControlBarActions]: A callback that builds trailing action widgets
  ///   (e.g., move, close) in the keyboard's control bar. If omitted, default
  ///   actions are shown.
  /// - [builder]: An optional app-level wrapper builder. If provided, it will
  ///   receive the [EasyOnscreenKeyboard] wrapped child so callers can further wrap
  ///   with app-wide widgets.
  ///
  /// Returns a [TransitionBuilder] to be passed to [MaterialApp.builder].
  ///
  /// See also:
  ///  - [EasyOnscreenKeyboard.new], which creates an [EasyOnscreenKeyboard] widget.
  static TransitionBuilder builder({
    EasyOnscreenKeyboardThemeData? theme,
    KeyboardLayout? layout,
    WidthGetter? width,
    bool showControlBar = true,
    Widget? dragHandle,
    double? aspectRatio,
    ActionsBuilder? buildControlBarActions,
    TransitionBuilder? builder,
  }) => (context, child) {
    final keyboard = EasyOnscreenKeyboard(
      theme: theme,
      layout: layout,
      width: width,
      showControlBar: showControlBar,
      dragHandle: dragHandle,
      aspectRatio: aspectRatio,
      buildControlBarActions: buildControlBarActions,
      child: child!,
    );

    return builder?.call(context, keyboard) ?? keyboard;
  };

  /// Gets the nearest [EasyOnscreenKeyboardController] from the widget tree.
  static EasyOnscreenKeyboardController of(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<_OnscreenKeyboardProvider>();
    assert(provider != null, '''
No EasyOnscreenKeyboard found in context. Did you wrap your app with EasyOnscreenKeyboard?

    MaterialApp(
      builder: EasyOnscreenKeyboard.builder(),  // <- add this line
      home: const App(),
    )
    ''');
    return provider!.state;
  }

  @override
  State<EasyOnscreenKeyboard> createState() => _OnscreenKeyboardState();
}

class _OnscreenKeyboardState extends State<EasyOnscreenKeyboard>
    implements EasyOnscreenKeyboardController {
  EasyThemeData? _maybeEasyTheme(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<InheritedEasyTheme>();
    return inheritedTheme?.theme.data;
  }

  EasyOnscreenKeyboardThemeData _resolveDefaultTheme(BuildContext context) {
    final materialTheme = Theme.of(context);
    final colors = materialTheme.colorScheme;
    final easyTheme = _maybeEasyTheme(context);

    final keyboardBackgroundColor = easyTheme?.neutralF8 ?? colors.surface;
    final controlBarColor =
        easyTheme?.background ?? colors.surfaceContainerHighest;
    final keyBackgroundColor = easyTheme?.background ?? colors.surface;
    final keyForegroundColor = easyTheme?.neutral33 ?? colors.onSurface;
    final keyBorderColor = easyTheme?.neutralEE ?? colors.outlineVariant;
    final actionBackgroundColor =
        easyTheme?.neutralF8 ?? colors.surfaceContainer;
    final actionPressedBackgroundColor =
        easyTheme?.primaryGreen ?? colors.primary;
    final actionPressedForegroundColor =
        easyTheme?.background ?? colors.onPrimary;
    final borderRadius = BorderRadius.all(
      easyTheme?.cornerMedium ?? const Radius.circular(8),
    );

    return EasyOnscreenKeyboardThemeData(
      color: keyboardBackgroundColor,
      controlBarColor: controlBarColor,
      borderRadius: borderRadius,
      padding: const EdgeInsets.all(8),
      boxShadow: [
        BoxShadow(
          color: colors.shadow.fade(0.08),
          offset: const Offset(0, 8),
          blurRadius: 24,
        ),
      ],
      border: Border.all(color: keyBorderColor),
      textKeyThemeData: TextKeyThemeData(
        backgroundColor: keyBackgroundColor,
        foregroundColor: keyForegroundColor,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        borderRadius: borderRadius,
        border: Border.all(color: keyBorderColor),
        textStyle: materialTheme.textTheme.bodyMedium?.copyWith(
          color: keyForegroundColor,
        ),
      ),
      actionKeyThemeData: ActionKeyThemeData(
        backgroundColor: actionBackgroundColor,
        foregroundColor: keyForegroundColor,
        pressedBackgroundColor: actionPressedBackgroundColor,
        pressedForegroundColor: actionPressedForegroundColor,
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        borderRadius: borderRadius,
        border: Border.all(color: keyBorderColor),
      ),
    );
  }

  EasyOnscreenKeyboardThemeData _mergeKeyboardTheme(
    EasyOnscreenKeyboardThemeData base,
    EasyOnscreenKeyboardThemeData? override,
  ) {
    if (override == null) return base;

    return base.copyWith(
      color: override.color,
      border: override.border,
      borderRadius: override.borderRadius,
      boxShadow: override.boxShadow,
      gradient: override.gradient,
      margin: override.margin,
      padding: override.padding,
      controlBarColor: override.controlBarColor,
      useSafeArea: override.useSafeArea,
      textKeyThemeData: base.textKeyThemeData.copyWith(
        backgroundColor: override.textKeyThemeData.backgroundColor,
        foregroundColor: override.textKeyThemeData.foregroundColor,
        margin: override.textKeyThemeData.margin,
        padding: override.textKeyThemeData.padding,
        fitChild: override.textKeyThemeData.fitChild,
        borderRadius: override.textKeyThemeData.borderRadius,
        border: override.textKeyThemeData.border,
        iconSize: override.textKeyThemeData.iconSize,
        boxShadow: override.textKeyThemeData.boxShadow,
        gradient: override.textKeyThemeData.gradient,
        textStyle: override.textKeyThemeData.textStyle,
      ),
      actionKeyThemeData: base.actionKeyThemeData.copyWith(
        backgroundColor: override.actionKeyThemeData.backgroundColor,
        foregroundColor: override.actionKeyThemeData.foregroundColor,
        margin: override.actionKeyThemeData.margin,
        padding: override.actionKeyThemeData.padding,
        fitChild: override.actionKeyThemeData.fitChild,
        borderRadius: override.actionKeyThemeData.borderRadius,
        border: override.actionKeyThemeData.border,
        iconSize: override.actionKeyThemeData.iconSize,
        boxShadow: override.actionKeyThemeData.boxShadow,
        gradient: override.actionKeyThemeData.gradient,
        pressedBackgroundColor:
            override.actionKeyThemeData.pressedBackgroundColor,
        pressedForegroundColor:
            override.actionKeyThemeData.pressedForegroundColor,
      ),
    );
  }

  /// Whether to show the secondary keys.
  bool get _showSecondary =>
      _pressedActionKeys.contains(ActionKeyType.capslock) ^
      _pressedActionKeys.contains(ActionKeyType.shift);

  final _pressedActionKeys = <String>{};

  @override
  KeyboardLayout get layout => _layout;

  void _onKeyDown(EasyOnscreenKeyboardKey key) {
    switch (key) {
      case TextKey():
        _handleTexTextKeyDown(key);
      case ActionKey():
        _handleActionKeyDown(key);
    }

    for (final listener in _rawKeyDownListeners) {
      listener(key);
    }
  }

  void _onKeyUp(EasyOnscreenKeyboardKey key) {
    switch (key) {
      case TextKey():
        break;
      case ActionKey():
        _handleActionKeyUp(key);
    }
  }

  void _handleTexTextKeyDown(TextKey key) {
    if (activeTextField?.controller case final controller?
        when controller.selection.isValid) {
      final keyText = key.getText(secondary: _showSecondary);
      final currentText = controller.text;
      final selection = controller.selection;

      // Create the new text value by replacing the selected range
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        keyText,
      );

      // Calculate the new cursor position
      final newCursorPosition = selection.start + keyText.length;

      // Create a new TextEditingValue with the proposed changes
      var newValue = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newCursorPosition),
      );

      // Apply input formatters if they exist
      if (activeTextField!.inputFormatters != null) {
        final oldValue = controller.value;
        for (final formatter in activeTextField!.inputFormatters!) {
          newValue = formatter.formatEditUpdate(oldValue, newValue);
        }
      }

      // Only update if the formatters didn't reject the change
      if (newValue.text != controller.text ||
          newValue.selection != controller.selection) {
        controller.value = newValue;

        // Call the onChanged callback if the text actually changed
        if (newValue.text != currentText &&
            activeTextField!.onChanged != null) {
          activeTextField!.onChanged!(newValue.text);
        }
      }
    }
  }

  void _handleActionKeyDown(ActionKey key) {
    if (!key.canHold) {
      setState(() => _pressedActionKeys.add(key.name));
    }

    if (activeTextField?.controller case final controller?
        when controller.selection.isValid) {
      final originalText = controller.text;

      switch (key.name) {
        case ActionKeyType.backspace:
          if (controller.text.isEmpty) return;
          String? newText;
          int? offset;
          if (!controller.selection.isCollapsed) {
            newText = controller.text.replaceRange(
              controller.start,
              controller.end,
              '',
            );
            offset = controller.start;
          } else if (controller.start > 0) {
            // handling emojis
            final leftSide =
                controller.text
                    .substring(0, controller.start)
                    .characters
                    .toList();
            final rightSide = controller.text.substring(controller.start);
            offset = controller.start - leftSide.removeLast().length;
            newText = leftSide.join() + rightSide;
          }
          if (newText != null && offset != null) {
            controller.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: offset),
            );

            // Call onChanged callback if text changed
            if (newText != originalText && activeTextField!.onChanged != null) {
              activeTextField!.onChanged!(newText);
            }
          }

        case ActionKeyType.tab:
          if (!controller.selection.isValid) return;
          final newText = controller.text.replaceRange(
            controller.start,
            controller.end,
            '\t',
          );
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: controller.start + 1),
          );

          // Call onChanged callback if text changed
          if (newText != originalText && activeTextField!.onChanged != null) {
            activeTextField!.onChanged!(newText);
          }

        case ActionKeyType.enter:
          if (!controller.selection.isValid) return;
          if (activeTextField!.maxLines == 1) {
            // if a single line field
            activeTextField!.focusNode.unfocus();
            // close();
          } else {
            // if a multi line field
            final newText = controller.text.replaceRange(
              controller.start,
              controller.end,
              '\n',
            );
            controller.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: controller.start + 1),
            );

            // Call onChanged callback if text changed
            if (newText != originalText && activeTextField!.onChanged != null) {
              activeTextField!.onChanged!(newText);
            }
          }

        case ActionKeyType.capslock:
          break;
        case ActionKeyType.shift:
          break;
      }
    }
  }

  void _handleActionKeyUp(ActionKey key) {
    _safeSetState(() {
      if (key.canHold && !_pressedActionKeys.contains(key.name)) {
        _pressedActionKeys.add(key.name);
      } else {
        _pressedActionKeys.remove(key.name);
      }
    });
  }

  /// Safely call [setState] after the current frame.
  void _safeSetState(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(fn));
  }

  /// Whether the keyboard is currently visible.
  bool _visible = false;

  (double, double) _clampAlignmentToViewport((double, double) alignment) {
    return (alignment.$1.clamp(-0.8, 1.8), alignment.$2.clamp(0.0, 1.5));
  }

  @override
  void open() {
    setState(() {
      _alignListener.value = _clampAlignmentToViewport(_alignListener.value);
      _visible = true;
    });
  }

  @override
  void close() {
    final field = activeTextField;
    detachTextField(field);
    field?.focusNode.unfocus();
    setState(() => _visible = false);
  }

  @override
  void switchToSystemKeyboard() {
    activeTextField?.switchToSystemKeyboard();
  }

  @override
  void setAlignment(Alignment alignment) {
    _alignListener.value = ((alignment.x + 1) / 2, (alignment.y + 1) / 2);
  }

  @override
  void moveToTop() => setAlignment(Alignment.topCenter);

  @override
  void moveToBottom() => setAlignment(Alignment.bottomCenter);

  @override
  void attachTextField(OnscreenKeyboardFieldState state) {
    _activeTextField.value = state;
  }

  @override
  void detachTextField([OnscreenKeyboardFieldState? state]) {
    if (state == null || state == activeTextField) {
      _activeTextField.value = null;
    }
  }

  final _activeTextField = ValueNotifier<OnscreenKeyboardFieldState?>(null);

  OnscreenKeyboardFieldState? get activeTextField => _activeTextField.value;

  /// List of raw key down listeners.
  final _rawKeyDownListeners = ObserverList<OnscreenKeyboardListener>();

  @override
  void addRawKeyDownListener(OnscreenKeyboardListener listener) {
    _rawKeyDownListeners.add(listener);
  }

  @override
  void removeRawKeyDownListener(OnscreenKeyboardListener listener) {
    _rawKeyDownListeners.remove(listener);
  }

  /// Returns the default keyboard layout based on the current platform.
  KeyboardLayout _getDefaultLayout() => switch (defaultTargetPlatform) {
    TargetPlatform.android ||
    TargetPlatform.iOS ||
    TargetPlatform.fuchsia => const MobileKeyboardLayout(),
    TargetPlatform.macOS ||
    TargetPlatform.windows ||
    TargetPlatform.linux => const DesktopKeyboardLayout(),
  };

  /// The resolved layout used by the keyboard.
  late final KeyboardLayout _layout = widget.layout ?? _getDefaultLayout();

  /// The current active keyboard mode (e.g., "alphabetic", "symbols").
  ///
  /// This determines which layout mode from [KeyboardLayout.modes] is used.
  late String _mode = _layout.modes.keys.first;

  double? _resolveKeyboardWidth(BuildContext context) {
    final baseWidth = widget.width?.call(context);
    if (baseWidth == null) return null;

    final isNumberMode = _mode.startsWith('number');
    return isNumberMode ? baseWidth : baseWidth * 1.25;
  }

  @override
  void switchMode() {
    final modes = _layout.modes.keys.toList();
    final i = modes.indexOf(_mode);
    setState(() => _mode = modes[(i + 1) % modes.length]);
  }

  @override
  void setModeNamed(String modeName) {
    if (_mode == modeName) return;

    if (_layout.modes.containsKey(modeName)) {
      setState(() {
        _mode = modeName;
      });
    } else {
      debugPrint(
        "OnScreenKeyboard: Keyboard mode '$modeName' "
        'not found on the KeyboardLayout.',
      );
    }
  }

  final GlobalKey _keyboardKey = GlobalKey();

  /// Alignment of the keyboard
  final ValueNotifier<(double, double)> _alignListener = ValueNotifier((.5, 1));

  /// Whether the keyboard is currently being dragged.
  final ValueNotifier<bool> _draggingListener = ValueNotifier(false);

  @override
  void dispose() {
    _alignListener.dispose();
    _draggingListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      _layout.modes.isNotEmpty,
      'Keyboard layout must have at least one mode defined.',
    );

    return _OnscreenKeyboardProvider(
      state: this,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) {
              final resolvedTheme = _mergeKeyboardTheme(
                _resolveDefaultTheme(context),
                widget.theme,
              );

              return EasyOnscreenKeyboardTheme(
                data: resolvedTheme,
                child: Stack(
                  children: [
                    // the app widget
                    widget.child,

                    // keyboard
                    if (_visible)
                      Positioned.fill(
                        child: Builder(
                          builder: (context) {
                            final useSaveArea =
                                context.theme.useSafeArea ?? true;
                            return SafeArea(
                              top: useSaveArea,
                              right: useSaveArea,
                              bottom: useSaveArea,
                              left: useSaveArea,
                              child: Builder(
                                builder: (context) {
                                  // drag handle keyboard widget
                                  final dragHandle = GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onPanStart:
                                        (_) => _draggingListener.value = true,
                                    onPanCancel:
                                        () => _draggingListener.value = false,
                                    onPanDown:
                                        (_) => _draggingListener.value = true,
                                    onPanEnd:
                                        (_) => _draggingListener.value = false,
                                    onPanUpdate: (details) {
                                      final keyboardSize =
                                          _keyboardKey.currentContext!.size!;
                                      final dxRange =
                                          context.size!.width -
                                          keyboardSize.width;
                                      final dyRange =
                                          context.size!.height -
                                          keyboardSize.height;
                                      final dx =
                                          dxRange == 0
                                              ? 0.0
                                              : details.delta.dx / dxRange;
                                      final dy =
                                          dyRange == 0
                                              ? 0.0
                                              : details.delta.dy / dyRange;
                                      _alignListener.value = (
                                        _alignListener.value.$1 + dx,
                                        _alignListener.value.$2 + dy,
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: ValueListenableBuilder(
                                        valueListenable: _draggingListener,
                                        builder: (context, value, child) {
                                          // user defined drag handle
                                          if (child != null) return child;
                                          return IconButton(
                                            mouseCursor:
                                                value
                                                    ? SystemMouseCursors
                                                        .grabbing
                                                    : SystemMouseCursors.grab,
                                            onPressed: null,
                                            icon: Icon(
                                              Icons.drag_handle_rounded,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).iconTheme.color,
                                            ),
                                          );
                                        },
                                        child: widget.dragHandle,
                                      ),
                                    ),
                                  );

                                  // keyboard widget
                                  final keyboard = TextFieldTapRegion(
                                    // theme override for modes
                                    child: EasyOnscreenKeyboardTheme(
                                      data: _mergeKeyboardTheme(
                                        resolvedTheme,
                                        _layout.modes[_mode]!.theme?.call(
                                          context,
                                        ),
                                      ),
                                      child: Builder(
                                        key: _keyboardKey,
                                        builder: (context) {
                                          final colors =
                                              Theme.of(context).colorScheme;
                                          final theme = context.theme;
                                          final keyboardBackgroundColor =
                                              theme.color ??
                                              theme.controlBarColor ??
                                              colors.surface;
                                          final borderRadius =
                                              theme.borderRadius ??
                                              BorderRadius.circular(6);
                                          return Material(
                                            color: keyboardBackgroundColor,
                                            borderRadius: borderRadius,
                                            clipBehavior: Clip.hardEdge,
                                            child: Container(
                                              width: _resolveKeyboardWidth(
                                                context,
                                              ),
                                              margin: theme.margin,
                                              padding: theme.padding,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                color: keyboardBackgroundColor,
                                                borderRadius: borderRadius,
                                                gradient: theme.gradient,
                                                boxShadow:
                                                    theme.boxShadow ??
                                                    [
                                                      BoxShadow(
                                                        color: colors.shadow
                                                            .fade(0.05),
                                                        spreadRadius: 5,
                                                        blurRadius: 5,
                                                      ),
                                                    ],
                                              ),
                                              foregroundDecoration:
                                                  BoxDecoration(
                                                    borderRadius: borderRadius,
                                                    border:
                                                        theme.border ??
                                                        Border.all(
                                                          color:
                                                              colors.outline
                                                                  .fade(),
                                                        ),
                                                  ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (widget.showControlBar)
                                                    _ControlBar(
                                                      dragHandle: dragHandle,
                                                      actions: widget
                                                          .buildControlBarActions
                                                          ?.call(context),
                                                    ),
                                                  EasyRawOnscreenKeyboard(
                                                    aspectRatio:
                                                        widget.aspectRatio,
                                                    onKeyDown: _onKeyDown,
                                                    onKeyUp: _onKeyUp,
                                                    layout: _layout,
                                                    mode: _mode,
                                                    pressedActionKeys:
                                                        _pressedActionKeys,
                                                    showSecondary:
                                                        _showSecondary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  );

                                  return AnimatedBuilder(
                                    animation: _alignListener,
                                    builder: (context, child) {
                                      return Align(
                                        alignment: Alignment(
                                          _alignListener.value.$1 * 2 - 1,
                                          _alignListener.value.$2 * 2 - 1,
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: keyboard,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Default control bar widget used in the on-screen keyboard.
///
/// This bar typically appears at the top of the keyboard and provides:
class _ControlBar extends StatelessWidget {
  /// Creates a control bar for the on-screen keyboard.
  const _ControlBar({required this.dragHandle, this.actions});

  /// A widget used for dragging the keyboard.
  final Widget dragHandle;

  /// {@template controlBar.actions}
  /// Optional custom action widgets shown on the right side of the control bar.
  ///
  /// If not provided or is empty, default actions are shown:
  /// - Move to bottom
  /// - Move to top
  /// - Close keyboard
  /// {@endtemplate}
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final theme = context.theme;
    final l10n = EasyUiLocalizations.of(context);

    final Widget trailing;
    if (actions != null && actions!.isNotEmpty) {
      trailing = Row(mainAxisSize: MainAxisSize.min, children: actions!);
    } else {
      trailing = FittedBox(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                EasyOnscreenKeyboard.of(context).switchToSystemKeyboard();
              },
              icon: const Icon(Icons.keyboard_rounded),
              tooltip: l10n.switchToSystemKeyboard,
            ),
            IconButton(
              onPressed: () {
                EasyOnscreenKeyboard.of(context).moveToBottom();
              },
              icon: const Icon(Icons.arrow_downward_rounded),
              tooltip: l10n.moveToBottom,
            ),
            IconButton(
              onPressed: () {
                EasyOnscreenKeyboard.of(context).moveToTop();
              },
              icon: const Icon(Icons.arrow_upward_rounded),
              tooltip: l10n.moveToTop,
            ),
            IconButton(
              onPressed: () {
                EasyOnscreenKeyboard.of(context).close();
              },
              icon: const Icon(Icons.close_rounded),
              tooltip: l10n.close,
            ),
          ],
        ),
      );
    }

    return Material(
      color: theme.controlBarColor ?? colors.surfaceContainer,
      child: IconButtonTheme(
        data: IconButtonThemeData(style: IconButton.styleFrom(iconSize: 16)),
        child: Row(children: [Expanded(child: dragHandle), trailing]),
      ),
    );
  }
}

/// An [InheritedWidget] that provides [EasyOnscreenKeyboardController]
/// to its descendants.
class _OnscreenKeyboardProvider extends InheritedWidget {
  const _OnscreenKeyboardProvider({required this.state, required super.child});

  /// The state of the nearest [EasyOnscreenKeyboard] in the widget tree.
  final _OnscreenKeyboardState state;

  @override
  bool updateShouldNotify(_OnscreenKeyboardProvider oldWidget) =>
      oldWidget.state != state;
}
