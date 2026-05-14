import 'package:flutter/material.dart';

/// 菜单样式
class EasyMenuStyle {
  const EasyMenuStyle({
    this.backgroundColor,
    this.borderRadius,
    this.boxShadows,
    this.boxBorder,
  });

  /// 背景色
  final Color? backgroundColor;

  /// 圆角
  final BorderRadiusGeometry? borderRadius;

  /// 阴影
  final List<BoxShadow>? boxShadows;

  final BoxBorder? boxBorder;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is EasyMenuStyle &&
        runtimeType == other.runtimeType &&
        backgroundColor == other.backgroundColor &&
        borderRadius == other.borderRadius &&
        boxShadows == other.boxShadows &&
        boxBorder == other.boxBorder;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      backgroundColor,
      borderRadius,
      boxShadows,
      boxBorder,
    ]);
  }

  EasyMenuStyle copyWith({
    Color? backgroundColor,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadows,
    BoxBorder? boxBorder,
  }) {
    return EasyMenuStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      boxShadows: boxShadows ?? this.boxShadows,
      boxBorder: boxBorder ?? this.boxBorder,
    );
  }

  EasyMenuStyle merge(EasyMenuStyle? style) {
    if (style == null) {
      return this;
    }
    return copyWith(
      backgroundColor: backgroundColor ?? style.backgroundColor,
      borderRadius: borderRadius ?? style.borderRadius,
      boxShadows: boxShadows ?? style.boxShadows,
      boxBorder: boxBorder ?? style.boxBorder,
    );
  }
}
