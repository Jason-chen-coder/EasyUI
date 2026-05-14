import 'package:flutter/material.dart';

/// 菜单项
class EasySingleCheckPopMenuItem<T> {
  /// 菜单项标签
  final String label;

  /// 菜单项值
  final T value;

  EasySingleCheckPopMenuItem({required this.label, required this.value});
}

class EasySingleCheckPopMenu<T> extends StatefulWidget {
  const EasySingleCheckPopMenu({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.anchorBuilder,
    this.anchorChild,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.alignmentOffset,
    this.alignment,
    this.layerLink,
    this.elevation,
  });

  /// 当前选中项的值
  final T value;

  /// 所有可选项
  final List<EasySingleCheckPopMenuItem<T>> items;

  /// 选项改变回调
  final ValueChanged<T>? onChanged;

  /// 构建菜单锚点
  final MenuAnchorChildBuilder? anchorBuilder;

  /// 菜单锚点Widget，同[MenuAnchor]的child属性
  final Widget? anchorChild;

  /// 弹出菜单最小尺寸
  final WidgetStateProperty<Size>? minimumSize;

  /// 弹出菜单固定尺寸
  final WidgetStateProperty<Size>? fixedSize;

  /// 弹出菜单最大尺寸
  final WidgetStateProperty<Size>? maximumSize;

  /// 同[MenuAnchor]的alignOffset属性
  final Offset? alignmentOffset;

  /// 同[MenuStyle]的align属性
  final AlignmentGeometry? alignment;

  /// 同[MenuAnchor]的layerLink属性
  final LayerLink? layerLink;

  /// 同[MenuStyle]的elevation属性
  final WidgetStateProperty<double>? elevation;

  @override
  State<EasySingleCheckPopMenu<T>> createState() =>
      _EasySingleCheckPopMenuState<T>();
}

class _EasySingleCheckPopMenuState<T> extends State<EasySingleCheckPopMenu<T>> {
  final _controller = MenuController();

  @override
  Widget build(BuildContext context) {
    final menuChildren =
        widget.items.map((e) {
          final checked = e.value == widget.value;
          return CheckboxListTile(
            value: checked,
            controlAffinity: ListTileControlAffinity.leading,
            side: checked ? null : const BorderSide(color: Color(0xffeeeeee)),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xffffd9d9d9);
              }
              if (states.contains(WidgetState.selected)) {
                return const Color(0xff31DA9F);
              }
              return Colors.white;
            }),
            checkColor: Colors.white,
            title: Text(
              e.label,
              style: const TextStyle(fontSize: 14, color: Color(0xff666666)),
            ),
            onChanged: (check) {
              if (check == true) {
                if (_controller.isOpen) {
                  _controller.close();
                }
                widget.onChanged?.call(e.value);
              }
            },
          );
        }).toList();

    return MenuAnchor(
      controller: _controller,
      menuChildren: menuChildren,
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        shadowColor: WidgetStatePropertyAll(Color(0x401484FC)),
        side: WidgetStatePropertyAll(BorderSide(color: Color(0xFFEEEEEE))),
        minimumSize: widget.minimumSize,
        fixedSize: widget.fixedSize,
        maximumSize: widget.maximumSize,
        alignment: widget.alignment,
        elevation: widget.elevation,
      ),
      crossAxisUnconstrained: false,
      alignmentOffset: widget.alignmentOffset,
      layerLink: widget.layerLink,
      builder: widget.anchorBuilder,
      child: widget.anchorChild,
    );
  }
}
