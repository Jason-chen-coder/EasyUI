import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

/// [EasySelect]组件样式
class EasySelectStyle {
  /// 触发器内容边距
  final EdgeInsets? triggerContentPadding;

  /// 触发器边框颜色
  final Color? triggerBorderColor;

  /// 触发器占位文本样式
  final TextStyle? placeholderTextStyle;

  /// 触发器显示文本样式
  final TextStyle? displayTextStyle;

  /// 触发器大小约束
  final BoxConstraints? triggerConstraints;

  const EasySelectStyle({
    this.triggerContentPadding,
    this.triggerBorderColor,
    this.placeholderTextStyle,
    this.displayTextStyle,
    this.triggerConstraints,
  });

  EasySelectStyle merge(EasySelectStyle style) {
    return EasySelectStyle(
      triggerContentPadding:
          triggerContentPadding ?? style.triggerContentPadding,
      triggerBorderColor: triggerBorderColor ?? style.triggerBorderColor,
      placeholderTextStyle: placeholderTextStyle ?? style.placeholderTextStyle,
      displayTextStyle: displayTextStyle ?? style.displayTextStyle,
      triggerConstraints: triggerConstraints ?? style.triggerConstraints,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EasySelectStyle &&
          runtimeType == other.runtimeType &&
          triggerContentPadding == other.triggerContentPadding &&
          triggerBorderColor == other.triggerBorderColor &&
          placeholderTextStyle == other.placeholderTextStyle &&
          displayTextStyle == other.displayTextStyle &&
          triggerConstraints == other.triggerConstraints;

  @override
  int get hashCode => Object.hash(
    triggerContentPadding,
    triggerBorderColor,
    placeholderTextStyle,
    displayTextStyle,
    triggerConstraints,
  );
}
