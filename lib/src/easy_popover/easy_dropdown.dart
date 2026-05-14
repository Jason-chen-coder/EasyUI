import 'package:easy_ui/src/easy_popover/easy_popover_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';

export 'package:easy_ui/src/easy_popover/easy_popover_direction.dart';

part 'easy_dropdown_item.dart';

/// 显示下拉列表
///
/// `context` 构建上下文，必需参数
///
/// `items` 下拉列表项，必需参数
///
/// `onSelected` 选择项时的回调
///
/// `direction` 弹出框显示方向，默认为`EasyPopoverDirection.bottom`
///
/// `width` 弹出框宽度，默认为 `200`
///
/// `maxHeight` 弹出框最大高度，超出时可滚动，默认为 `300`
///
/// `backgroundColor` 背景颜色，默认为 `Color(0xFFFFFFFF)`
///
/// `barrierColor` 遮罩层颜色，默认为 `Color(0x80000000)`
///
/// `radius` 圆角半径，默认为 `12`
///
/// `arrowWidth` 箭头宽度，默认为 `14`
///
/// `arrowHeight` 箭头高度，默认为 `6`
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
/// `itemPadding` 列表项的内边距，默认为 `EdgeInsets.symmetric(horizontal: 16, vertical: 12)`
///
/// `itemTextStyle` 列表项文本样式
///
/// `scrollPhysics` 滚动物理效果
///
/// 返回值：`Future<T?>` 选中项的值
Future<T?> showEasyDropdown<T>({
  required BuildContext context,
  required List<EasyDropdownItem<T>> items,
  ValueChanged<T>? onSelected,
  EasyPopoverDirection direction = EasyPopoverDirection.bottom,
  double? width = 160,
  double? maxHeight,
  Color backgroundColor = const Color(0xFFFFFFFF),
  Color barrierColor = const Color(0x00000000),
  double radius = 10,
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
  EdgeInsetsGeometry itemPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  ),
  TextStyle? itemTextStyle,
  ScrollPhysics? scrollPhysics,
}) {
  return showPopover<T>(
    context: context,
    bodyBuilder:
        (context) => _EasyDropdownContent<T>(
          items: items,
          onSelected: (value) {
            Navigator.of(context).pop(value);
            onSelected?.call(value);
          },
          itemPadding: itemPadding,
          itemTextStyle: itemTextStyle,
          maxHeight: maxHeight,
          scrollPhysics: scrollPhysics,
        ),
    direction: direction.toPopoverDirection,
    width: width,
    height: null, // 让内容自适应高度
    backgroundColor: backgroundColor,
    barrierColor: barrierColor,
    radius: radius,
    arrowWidth: arrowWidth,
    arrowHeight: arrowHeight,
    barrierDismissible: barrierDismissible,
    transitionDuration: transitionDuration,
    onPop: onPop,
    shadow:
        shadow ?? const [BoxShadow(color: Color(0x1F000000), blurRadius: 10)],
    arrowDxOffset: arrowDxOffset,
    arrowDyOffset: arrowDyOffset,
    contentDxOffset: contentDxOffset,
    contentDyOffset: contentDyOffset,
  );
}

/// 下拉列表内容组件
class _EasyDropdownContent<T> extends StatelessWidget {
  const _EasyDropdownContent({
    required this.items,
    required this.onSelected,
    required this.itemPadding,
    this.itemTextStyle,
    this.maxHeight,
    this.scrollPhysics,
  });

  final List<EasyDropdownItem<T>> items;
  final ValueChanged<T> onSelected;
  final EdgeInsetsGeometry itemPadding;
  final TextStyle? itemTextStyle;
  final double? maxHeight;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      final item = items[i];

      if (item is EasyDropdownListItem<T>) {
        children.add(
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  item.enabled
                      ? () {
                        item.onTap?.call();
                        onSelected(item.value);
                      }
                      : null,
              child: Container(
                width: double.infinity,
                padding: itemPadding,
                child: DefaultTextStyle(
                  style:
                      itemTextStyle ??
                      Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: item.enabled ? null : Colors.grey,
                      ) ??
                      TextStyle(
                        fontSize: 14,
                        color: item.enabled ? Color(0xFF101010) : Colors.grey,
                      ),
                  child: item.child,
                ),
              ),
            ),
          ),
        );
      } else if (item is EasyDropdownIconItem<T>) {
        children.add(
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  item.enabled
                      ? () {
                        item.onTap?.call();
                        onSelected(item.value);
                      }
                      : null,
              child: Container(
                width: double.infinity,
                padding: itemPadding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null)
                      item.enabled
                          ? item.icon!
                          : Opacity(opacity: 0.5, child: item.icon!),
                    SizedBox(width: item.spacing),
                    Expanded(
                      child:
                          item.enabled
                              ? item.label
                              : Opacity(opacity: 0.5, child: item.label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (item is EasyDropdownDivider<T>) {
        children.add(
          Container(
            height: item.height,
            margin: EdgeInsets.only(
              left: item.indent,
              right: item.endIndent,
              top: 5,
              bottom: 5,
            ),
            color: item.color,
          ),
        );
      }
    }

    Widget content = Column(mainAxisSize: MainAxisSize.min, children: children);

    // 如果设置了最大高度且需要滚动
    if (maxHeight != null) {
      content = ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: SingleChildScrollView(physics: scrollPhysics, child: content),
      );
    }

    return content;
  }
}
