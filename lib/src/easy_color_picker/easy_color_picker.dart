library;

import 'package:flutter/material.dart';

import '../../easy_ui.dart';
import 'easy_color_indicator.dart';
import 'easy_color_picker_area.dart';
import 'easy_color_picker_input.dart';
import 'easy_color_picker_slider.dart';

class EasyColorPicker extends StatefulWidget {
  const EasyColorPicker({
    super.key,
    required this.pickerColor,
    required this.onColorChanged,
    this.pickerHsvColor,
    this.onHsvColorChanged,
    this.enableAlpha = true,
    this.displayThumbColor = true,
  });

  /// 初始颜色
  final Color pickerColor;

  /// 颜色变化回调
  final ValueChanged<Color> onColorChanged;

  /// 初始颜色`HSVColor`格式
  /// 优先级高于[`pickerColor`]
  final HSVColor? pickerHsvColor;

  /// 颜色变化回调`HSVColor`格式
  final ValueChanged<HSVColor>? onHsvColorChanged;

  /// 是否启用透明度选择
  final bool enableAlpha;

  /// 是否在滑块上显示颜色预览
  final bool displayThumbColor;

  @override
  State<EasyColorPicker> createState() => _EasyColorPickerState();
}

class _EasyColorPickerState extends State<EasyColorPicker> {
  HSVColor currentHsvColor = const HSVColor.fromAHSV(0.0, 0.0, 0.0, 0.0);
  List<Color> colorHistory = [];

  @override
  void initState() {
    currentHsvColor =
        (widget.pickerHsvColor != null)
            ? widget.pickerHsvColor as HSVColor
            : HSVColor.fromColor(widget.pickerColor);
    super.initState();
  }

  // @override
  // void didUpdateWidget(EasyColorPicker oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   currentHsvColor =
  //       (widget.pickerHsvColor != null)
  //           ? widget.pickerHsvColor as HSVColor
  //           : HSVColor.fromColor(widget.pickerColor);
  // }

  Widget colorPickerSlider(TrackType trackType) {
    return EasyColorPickerSlider(trackType, currentHsvColor, (HSVColor color) {
      setState(() => currentHsvColor = color);
      widget.onColorChanged(currentHsvColor.toColor());
      widget.onHsvColorChanged?.call(currentHsvColor);
    }, displayThumbColor: true);
  }

  void onColorChanging(HSVColor color) {
    setState(() => currentHsvColor = color);
    widget.onColorChanged(currentHsvColor.toColor());
    widget.onHsvColorChanged?.call(currentHsvColor);
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return Container(
      constraints: BoxConstraints(minWidth: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.all(easyTheme.cornerMedium),
              child: EasyColorPickerArea(currentHsvColor, onColorChanging),
            ),
          ),
          SizedBox(height: 16.0, child: colorPickerSlider(TrackType.hue)),
          if (widget.enableAlpha)
            SizedBox(height: 16.0, child: colorPickerSlider(TrackType.alpha)),
          Row(
            spacing: 24,
            children: [
              EasyColorIndicator(height: 38, width: 38, color: currentHsvColor),
              Text(
                'HEX',
                style: TextStyle(
                  color: easyTheme.neutral33,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  fontFamily: 'HarmonyOS_SansSC',
                ),
              ),
              Expanded(
                child: EasyColorPickerInput(currentHsvColor.toColor(), (
                  Color color,
                ) {
                  setState(() => currentHsvColor = HSVColor.fromColor(color));
                  widget.onColorChanged(currentHsvColor.toColor());
                  widget.onHsvColorChanged?.call(currentHsvColor);
                }, enableAlpha: widget.enableAlpha),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
