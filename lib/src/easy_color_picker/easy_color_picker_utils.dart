// Common function lib

import 'dart:math';
import 'package:flutter/painting.dart';

/// Check if is good condition to use white foreground color by passing
/// the background color, and optional bias.
///
/// Reference:
///
/// Old: https://www.w3.org/TR/WCAG20-TECHS/G18.html
///
/// New: https://github.com/mchome/flutter_statusbarcolor/issues/40
bool useWhiteForeground(Color backgroundColor, {double bias = 0.0}) {
  // Old:
  // return 1.05 / (color.computeLuminance() + 0.05) > 4.5;

  // New:
  int v =
      sqrt(
        pow(backgroundColor.r, 2) * 0.299 +
            pow(backgroundColor.g, 2) * 0.587 +
            pow(backgroundColor.b, 2) * 0.114,
      ).round();
  return v < 130 + bias ? true : false;
}

/// [RegExp] pattern for validation complete HEX color [String], allows only:
///
/// * exactly 6 or 8 digits in HEX format,
/// * only Latin A-F characters, case insensitive,
/// * and integer numbers 0,1,2,3,4,5,6,7,8,9,
/// * with optional hash (`#`) symbol at the beginning (not calculated in length).
///
/// ```dart
/// final RegExp hexCompleteValidator = RegExp(kCompleteValidHexPattern);
/// if (hexCompleteValidator.hasMatch(hex)) print('$hex is valid HEX color');
/// ```
/// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
const String kCompleteValidHexPattern =
    r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})$';

/// Try to convert text input or any [String] to valid [Color].
/// The [String] must be provided in one of those formats:
///
/// * RGB
/// * #RGB
/// * RRGGBB
/// * #RRGGBB
/// * RRGGBBAA
/// * #RRGGBBAA
///
/// Where: R for Red, G for Green, B for Blue, and A stands for Alpha color.
/// It will only accept 3/6/8 long HEXs with an optional hash (`#`) at the beginning.
/// Allowed characters are Latin A-F case insensitive and numbers 0-9.
/// Optional [enableAlpha] can be provided (it's `true` by default). If it's set
/// to `false` transparency information (alpha channel) will be removed.
/// ```dart
/// /// // Valid 3 digit HEXs:
/// colorFromHex('abc') == Color(0xffaabbcc)
/// colorFromHex('ABc') == Color(0xffaabbcc)
/// colorFromHex('ABC') == Color(0xffaabbcc)
/// colorFromHex('#Abc') == Color(0xffaabbcc)
/// colorFromHex('#abc') == Color(0xffaabbcc)
/// colorFromHex('#ABC') == Color(0xffaabbcc)
/// // Valid 6 digit HEXs:
/// colorFromHex('aabbcc') == Color(0xffaabbcc)
/// colorFromHex('AABbcc') == Color(0xffaabbcc)
/// colorFromHex('AABBCC') == Color(0xffaabbcc)
/// colorFromHex('#AABbcc') == Color(0xffaabbcc)
/// colorFromHex('#aabbcc') == Color(0xffaabbcc)
/// colorFromHex('#AABBCC') == Color(0xffaabbcc)
/// // Valid 8 digit HEXs (RGBA format):
/// colorFromHex('aabbccff') == Color(0xffaabbcc)
/// colorFromHex('aabbccFF') == Color(0xffaabbcc)
/// colorFromHex('aabbccff', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('AABBccff', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('aabbccFF', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('AABBccFF', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('#aabbccff') == Color(0xffaabbcc)
/// colorFromHex('#aabbccFF') == Color(0xffaabbcc)
/// colorFromHex('#AABBCCFF') == Color(0xffaabbcc)
/// colorFromHex('#aabbccff', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('#AABBccff', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('#aabbccFF', enableAlpha: true) == Color(0xffaabbcc)
/// colorFromHex('#AABBccFF', enableAlpha: true) == Color(0xffaabbcc)
/// // Invalid HEXs:
/// colorFromHex('bc') == null // length 2
/// colorFromHex('aabbc') == null // length 5
/// colorFromHex('#aabbccdde') == null // length 9 (+#)
/// colorFromHex('aabbccx') == null // x character
/// colorFromHex('#aabbвв') == null // в non-latin character
/// colorFromHex('') == null // empty
/// ```
/// Reference: https://en.wikipedia.org/wiki/Web_colors#Hex_triplet
Color? colorFromHex(String inputString, {bool enableAlpha = true}) {
  // Registers validator for exactly 6 or 8 digits long HEX (with optional #).
  final RegExp hexValidator = RegExp(kCompleteValidHexPattern);
  // Validating input, if it does not match — it's not proper HEX.
  if (!hexValidator.hasMatch(inputString)) return null;
  // Remove optional hash if exists and convert HEX to UPPER CASE.
  String hexToParse = inputString.replaceFirst('#', '').toUpperCase();
  // It may allow HEXs with transparency information even if alpha is disabled,
  if (!enableAlpha && hexToParse.length == 8) {
    // but it will replace this info with 100% non-transparent value (FF).
    hexToParse = '${hexToParse.substring(0, 6)}FF';
  }
  // HEX may be provided in 3-digits format, let's just duplicate each letter.
  if (hexToParse.length == 3) {
    hexToParse = hexToParse.split('').map((ch) => '$ch$ch').join();
  }
  // We will need 8 digits to parse the color, let's add missing digits.
  if (hexToParse.length == 6) hexToParse = '${hexToParse}FF';
  // Convert RGBA format to ARGB format for Color constructor
  // RGBA: RRGGBBAA -> ARGB: AARRGGBB
  String argbHex = hexToParse.substring(6, 8) + hexToParse.substring(0, 6);
  // HEX must be valid now, but as a precaution, it will just "try" to parse it.
  final intColorValue = int.tryParse(argbHex, radix: 16);
  // If for some reason HEX is not valid — abort the operation, return nothing.
  if (intColorValue == null) return null;
  // Register output color for the last step.
  final color = Color(intColorValue);
  // Decide to return color with transparency information or not.
  return enableAlpha ? color : color.withAlpha(255);
}

/// Converts `dart:ui` [Color] to the 6/8 digits HEX [String].
///
/// Prefixes a hash (`#`) sign if [includeHashSign] is set to `true`.
/// The result will be provided as UPPER CASE, it can be changed via [toUpperCase]
/// flag set to `false` (default is `true`). Hex can be returned without alpha
/// channel information (transparency), with the [enableAlpha] flag set to `false`.
/// Format is RGBA (Red, Green, Blue, Alpha).
extension ColorToHexExtension on Color {
  String toHexString({
    bool includeHashSign = false,
    bool enableAlpha = true,
    bool toUpperCase = true,
  }) {
    final String hex =
        (includeHashSign ? '#' : '') +
        _padRadix((r * 255).round()) +
        _padRadix((g * 255).round()) +
        _padRadix((b * 255).round()) +
        (enableAlpha ? _padRadix((a * 255).round()) : '');
    return toUpperCase ? hex.toUpperCase() : hex;
  }
}

// Shorthand for padLeft of RadixString, DRY.
String _padRadix(int value) => value.toRadixString(16).padLeft(2, '0');
