import 'package:easy_ui/src/easy_popover/easy_popover_direction.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../easy_theme.dart';

export 'package:easy_ui/src/easy_popover/easy_popover_direction.dart';

/// 显示弹出框
///
/// `context` 构建上下文，必需参数
///
/// `contentBuilder` 弹出框内容构建器，必需参数
///
/// `direction` 弹出框显示方向，默认为`EasyPopoverDirection.bottom`
///
/// `width` 弹出框宽度，默认为 `200`
///
/// `height` 弹出框高度，默认为 `200`
///
/// `backgroundColor` 背景颜色，默认为 `Color(0xFFFFFFFF)`
///
/// `barrierColor` 遮罩层颜色，默认为 `Color(0x80000000)`
///
/// `radius` 圆角半径，默认为 `12`
///
/// `arrowWidth` 箭头宽度，默认为 `30`
///
/// `arrowHeight` 箭头高度，默认为 `15`
///
/// `barrierDismissible` 是否可以通过点击遮罩层关闭，默认为 `true`
///
/// `transitionDuration` 动画持续时间。默认为 `300 毫秒`
///
/// `onPop` 弹出框关闭时的回调
///
/// `arrowDxOffset` 箭头在 X 轴上的偏移量。可以是正数或负数。 默认为 `0`。
///
/// `arrowDyOffset` 箭头在 Y 轴上的偏移量。可以是正数或负数。 默认为 `0`。
///
/// `contentDyOffset` 弹出框内容在 Y 轴上的偏移量。可以是正数或负数。 默认为 `0`。
///
/// `contentDxOffset` 弹出框内容在 X 轴上的偏移量。可以是正数或负数。 默认为 `0`。
///
/// 返回值：`Future<T?>` 弹出框的返回结果
Future<T?> showEasyPopover<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) contentBuilder,
  EasyPopoverDirection direction = EasyPopoverDirection.left,
  double? width = 200,
  double? height,
  Color? backgroundColor,
  Color barrierColor = const Color(0x80000000),
  double radius = 12,
  double arrowWidth = 14,
  double arrowHeight = 6,
  bool barrierDismissible = true,
  Duration transitionDuration = const Duration(milliseconds: 300),
  VoidCallback? onPop,
  List<BoxShadow>? shadow,
  double arrowDxOffset = 0,
  double arrowDyOffset = 0,
  double contentDxOffset = 0,
  double contentDyOffset = 0,
}) {
  return showPopover<T>(
    context: context,
    bodyBuilder: contentBuilder,
    direction: direction.toPopoverDirection,
    width: width,
    height: height,
    backgroundColor: backgroundColor ?? EasyTheme.of(context).background,
    barrierColor: barrierColor,
    radius: radius,
    arrowWidth: arrowWidth,
    arrowHeight: arrowHeight,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    onPop: onPop,
    shadow:
        shadow ??
        [
          BoxShadow(
            color: EasyTheme.of(context).onBackground.withAlpha(0x1F),
            blurRadius: 5,
          ),
        ],
    arrowDxOffset: arrowDxOffset,
    arrowDyOffset: arrowDyOffset,
    contentDxOffset: contentDxOffset,
    contentDyOffset: contentDyOffset,
  );
}
