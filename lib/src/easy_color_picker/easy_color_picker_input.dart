import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../easy_theme.dart';
import 'easy_color_picker_utils.dart';

class EasyColorPickerInput extends StatefulWidget {
  const EasyColorPickerInput(
    this.color,
    this.onColorChanged, {
    super.key,
    this.enableAlpha = true,
    this.disable = false,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;
  final bool enableAlpha;
  final bool disable;

  @override
  State<EasyColorPickerInput> createState() => _EasyColorPickerInputState();
}

class _EasyColorPickerInputState extends State<EasyColorPickerInput> {
  TextEditingController hexController = TextEditingController();
  TextEditingController alphaController = TextEditingController();
  int inputColor = 0;

  @override
  void dispose() {
    hexController.dispose();
    alphaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (inputColor != widget.color.toARGB32()) {
      hexController.text =
          (widget.color.r * 255)
              .round()
              .toRadixString(16)
              .toUpperCase()
              .padLeft(2, '0') +
          (widget.color.g * 255)
              .round()
              .toRadixString(16)
              .toUpperCase()
              .padLeft(2, '0') +
          (widget.color.b * 255)
              .round()
              .toRadixString(16)
              .toUpperCase()
              .padLeft(2, '0');
      alphaController.text = '${(widget.color.a * 100).round()}';
      inputColor = widget.color.toARGB32();
    }
    final easyTheme = EasyTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: !widget.disable ? Border.all(color: easyTheme.neutralEE) : null,
        borderRadius: BorderRadius.all(easyTheme.cornerSmall),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: CupertinoTextField(
              enabled: !widget.disable,
              controller: hexController,
              inputFormatters: [
                _UpperCaseTextFormatter(),
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(6),
              ],
              style: TextStyle(
                fontSize: 14,
                color: easyTheme.neutral66,
                fontWeight: FontWeight.w400,
                fontFamily: 'HarmonyOS_SansSC',
              ),
              decoration: const BoxDecoration(),
              prefix: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  '#',
                  style: TextStyle(
                    fontSize: 14,
                    color: easyTheme.neutral66,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'HarmonyOS_SansSC',
                  ),
                ),
              ),
              onChanged: (String value) {
                if (value.length == 6) {
                  final String hexWithAlpha =
                      widget.enableAlpha ? alphaController.text : '100';
                  final int alpha =
                      ((int.tryParse(hexWithAlpha) ?? 100) * 255 / 100).round();
                  final Color? color = colorFromHex(
                    value + alpha.toRadixString(16).padLeft(2, '0'),
                  );
                  if (color != null) {
                    widget.onColorChanged(color);
                    inputColor = color.toARGB32();
                  }
                }
              },
            ),
          ),
          if (widget.enableAlpha) ...[
            Container(
              width: 1,
              height: 14,
              color: easyTheme.neutralEE,
              margin: const EdgeInsets.symmetric(horizontal: 8),
            ),
            Expanded(
              flex: 2,
              child: CupertinoTextField(
                enabled: !widget.disable,
                controller: alphaController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _RangeTextInputFormatter(min: 0, max: 100),
                ],
                decoration: const BoxDecoration(),
                style: TextStyle(
                  fontSize: 14,
                  color: easyTheme.neutral66,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'HarmonyOS_SansSC',
                ),
                suffix: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(
                    '%',
                    style: TextStyle(
                      fontSize: 14,
                      color: easyTheme.neutral66,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'HarmonyOS_SansSC',
                    ),
                  ),
                ),
                onChanged: (String value) {
                  final int? alphaPercent = int.tryParse(value);
                  if (alphaPercent != null &&
                      alphaPercent >= 0 &&
                      alphaPercent <= 100 &&
                      hexController.text.length == 6) {
                    final int alpha = (alphaPercent * 255 / 100).round();
                    final Color? color = colorFromHex(
                      hexController.text +
                          alpha.toRadixString(16).padLeft(2, '0'),
                    );
                    if (color != null) {
                      widget.onColorChanged(color);
                      inputColor = color.toARGB32();
                    }
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Uppercase text formater
class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(oldValue, TextEditingValue newValue) =>
      TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
      );
}

/// Range text formatter for limiting input values
class _RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  _RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final int? value = int.tryParse(newValue.text);
    if (value == null) {
      return oldValue;
    }

    if (value < min || value > max) {
      return oldValue;
    }

    return newValue;
  }
}
