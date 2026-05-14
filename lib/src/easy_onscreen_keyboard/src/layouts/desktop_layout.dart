import 'package:flutter/material.dart';
import '../../easy_onscreen_keyboard.dart';
import '../constants/action_key_type.dart';

/// A complete QWERTY desktop keyboard layout excluding the number pad.
///
/// This layout includes rows of alphabetic keys, number keys, symbols,
/// and common action keys like backspace, capslock, enter, and shift.
///
/// Use this layout with [EasyOnscreenKeyboard] for a desktop-style experience.
class DesktopKeyboardLayout extends KeyboardLayout {
  /// Creates a [DesktopKeyboardLayout] instance.
  const DesktopKeyboardLayout();

  @override
  double get aspectRatio => 5 / 2;

  @override
  Map<String, KeyboardMode> get modes => {
    'default': KeyboardMode(rows: _defaultMode),
    'number': KeyboardMode(rows: _buildNumberMode()),
    'number_decimal': KeyboardMode(rows: _buildNumberMode(decimal: true)),
    'number_signed': KeyboardMode(rows: _buildNumberMode(signed: true)),
    'number_signed_decimal': KeyboardMode(
      rows: _buildNumberMode(signed: true, decimal: true),
    ),
  };

  List<KeyboardRow> get _defaultMode => [
    const KeyboardRow(
      keys: [
        EasyOnscreenKeyboardKey.text(primary: '`', secondary: '~'),
        EasyOnscreenKeyboardKey.text(primary: '1', secondary: '!'),
        EasyOnscreenKeyboardKey.text(primary: '2', secondary: '@'),
        EasyOnscreenKeyboardKey.text(primary: '3', secondary: '#'),
        EasyOnscreenKeyboardKey.text(primary: '4', secondary: r'$'),
        EasyOnscreenKeyboardKey.text(primary: '5', secondary: '%'),
        EasyOnscreenKeyboardKey.text(primary: '6', secondary: '^'),
        EasyOnscreenKeyboardKey.text(primary: '7', secondary: '&'),
        EasyOnscreenKeyboardKey.text(primary: '8', secondary: '*'),
        EasyOnscreenKeyboardKey.text(primary: '9', secondary: '('),
        EasyOnscreenKeyboardKey.text(primary: '0', secondary: ')'),
        EasyOnscreenKeyboardKey.text(primary: '-', secondary: '_'),
        EasyOnscreenKeyboardKey.text(primary: '=', secondary: '+'),
        EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.backspace,
          child: Icon(Icons.backspace_outlined),
          flex: 25,
        ),
      ],
    ),
    KeyboardRow(
      keys: [
        const EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.placeholder,
          child: SizedBox.shrink(),
          flex: 25,
        ),
        for (final c in ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'])
          EasyOnscreenKeyboardKey.text(primary: c),
        const EasyOnscreenKeyboardKey.text(primary: '[', secondary: '{'),
        const EasyOnscreenKeyboardKey.text(primary: ']', secondary: '}'),
        const EasyOnscreenKeyboardKey.text(primary: r'\', secondary: '|'),
      ],
    ),
    KeyboardRow(
      keys: [
        const EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.capslock,
          child: Icon(Icons.keyboard_capslock_rounded),
          flex: 30,
          canHold: true,
        ),
        for (final c in ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'])
          EasyOnscreenKeyboardKey.text(primary: c),
        const EasyOnscreenKeyboardKey.text(primary: ';', secondary: ':'),
        const EasyOnscreenKeyboardKey.text(primary: "'", secondary: '"'),
        const EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.enter,
          child: Icon(Icons.keyboard_return_rounded),
          flex: 30,
        ),
      ],
    ),
    KeyboardRow(
      keys: [
        const EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.shift,
          child: Icon(Icons.arrow_upward_rounded),
          flex: 35,
          canHold: true,
        ),
        for (final c in ['z', 'x', 'c', 'v', 'b', 'n', 'm'])
          EasyOnscreenKeyboardKey.text(primary: c),
        const EasyOnscreenKeyboardKey.text(primary: ',', secondary: '<'),
        const EasyOnscreenKeyboardKey.text(primary: '.', secondary: '>'),
        const EasyOnscreenKeyboardKey.text(primary: '/', secondary: '?'),
        const EasyOnscreenKeyboardKey.action(
          name: ActionKeyType.shift,
          child: Icon(Icons.arrow_upward_rounded),
          flex: 35,
          canHold: true,
        ),
      ],
    ),
    const KeyboardRow(
      keys: [
        EasyOnscreenKeyboardKey.text(
          primary: ' ',
          child: Icon(Icons.space_bar_rounded),
        ),
      ],
    ),
  ];

  List<KeyboardRow> _buildNumberMode({
    bool signed = false,
    bool decimal = false,
  }) {
    final row2LastKey =
        signed
            ? const EasyOnscreenKeyboardKey.text(primary: '-')
            : const EasyOnscreenKeyboardKey.action(
              name: ActionKeyType.placeholder,
              child: SizedBox.shrink(),
            );

    final row4ZeroFlex = decimal ? 40 : 60;
    final row4Keys = <EasyOnscreenKeyboardKey>[
      EasyOnscreenKeyboardKey.text(primary: '0', flex: row4ZeroFlex),
      if (decimal) const EasyOnscreenKeyboardKey.text(primary: '.'),
      const EasyOnscreenKeyboardKey.action(
        name: ActionKeyType.enter,
        child: Icon(Icons.keyboard_return_rounded),
      ),
    ];

    return [
      const KeyboardRow(
        keys: [
          EasyOnscreenKeyboardKey.text(primary: '7'),
          EasyOnscreenKeyboardKey.text(primary: '8'),
          EasyOnscreenKeyboardKey.text(primary: '9'),
          EasyOnscreenKeyboardKey.action(
            name: ActionKeyType.backspace,
            child: Icon(Icons.backspace_outlined),
          ),
        ],
      ),
      KeyboardRow(
        keys: [
          const EasyOnscreenKeyboardKey.text(primary: '4'),
          const EasyOnscreenKeyboardKey.text(primary: '5'),
          const EasyOnscreenKeyboardKey.text(primary: '6'),
          row2LastKey,
        ],
      ),
      const KeyboardRow(
        keys: [
          EasyOnscreenKeyboardKey.text(primary: '1'),
          EasyOnscreenKeyboardKey.text(primary: '2'),
          EasyOnscreenKeyboardKey.text(primary: '3'),
          EasyOnscreenKeyboardKey.action(
            name: ActionKeyType.placeholder,
            child: SizedBox.shrink(),
          ),
        ],
      ),
      KeyboardRow(keys: row4Keys),
    ];
  }
}
