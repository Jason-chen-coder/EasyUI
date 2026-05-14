import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';


class EasyColorSelector extends StatefulWidget {
  const EasyColorSelector({
    super.key,
    this.initialValue,
    this.onChanged,
    this.placeholder,
    this.width,
    this.height = 38,
    this.clearable = false,
    this.textStyle,
    this.placeholderTextStyle,
    this.padding,
    this.borderColor,
    this.icon,
    this.enableAlpha = true,
    this.displayThumbColor = true,
  });

  final Color? initialValue;
  final ValueChanged<Color?>? onChanged;
  final String? placeholder;
  final double? width;
  final double? height;

  /// 是否显示清除按钮
  final bool clearable;
  final TextStyle? textStyle;
  final TextStyle? placeholderTextStyle;
  final EdgeInsets? padding;
  final Color? borderColor;

  /// 图标，用于展示选中的颜色
  /// 仅支持可以读取`IconTheme`颜色的图标组件
  /// 例如：`Icon`、`EasySvgIcon`等
  final Widget? icon;

  /// 是否启用透明度选择
  final bool enableAlpha;

  /// 是否在滑块上显示颜色预览
  final bool displayThumbColor;

  @override
  State<EasyColorSelector> createState() => _EasyColorSelectorState();
}

class _EasyColorSelectorState extends State<EasyColorSelector> {
  final _focusNode = FocusNode();
  Color? _selectedValue;
  bool _isHover = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant EasyColorSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void handleClear(EasyMenuController controller) {
    if (_selectedValue != null) {
      setState(() => _selectedValue = null);
      controller.close();
      widget.onChanged?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyMenuAnchor(
      menuBuilder: _buildColorSelectorPanel,
      childBuilder: _buildSelector,
      onOpen: _focusNode.requestFocus,
      onClose: _focusNode.unfocus,
    );
  }

  Widget _buildColorSelectorPanel(
    BuildContext context,
    EasyMenuController controller,
    EasyMenuOverlayInfo overlayInfo,
  ) {
    return SizedBox(
      width: overlayInfo.anchorRect.width,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: EasyColorPicker(
          enableAlpha: widget.enableAlpha,
          displayThumbColor: widget.displayThumbColor,
          pickerColor: _selectedValue ?? EasyTheme.of(context).background,
          onColorChanged: (Color value) {
            setState(() => _selectedValue = value);
            widget.onChanged?.call(value);
          },
        ),
      ),
    );
  }

  Widget _buildSelector(
    BuildContext context,
    EasyMenuController controller,
    Widget? _,
  ) {
    final theme = EasyTheme.of(context);
    return InkWell(
      focusNode: _focusNode,
      onTap: () {
        if (controller.isOpen) {
          controller.close();
        } else {
          controller.open();
        }
      },
      borderRadius: BorderRadius.all(EasyTheme.of(context).cornerSmall),
      child: StatefulBuilder(
        builder: (context, setter) {
          return MouseRegion(
            onEnter: (_) => setter(() => _isHover = true),
            onExit: (_) => setter(() => _isHover = false),
            child: Container(
              width: widget.width,
              height: widget.height,
              padding:
                  widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.background,
                borderRadius: BorderRadius.all(theme.cornerSmall),
                border: Border.all(
                  color: widget.borderColor ?? theme.neutralEE,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildDisplay(context)),
                  if (widget.clearable && _selectedValue != null && _isHover)
                    InkWell(
                      onTap: () => handleClear(controller),
                      borderRadius: BorderRadius.circular(10),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.neutral99,
                      ),
                    )
                  else
                    Icon(
                      controller.isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 16,
                      color: theme.neutral99,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDisplay(BuildContext context) {
    final theme = EasyTheme.of(context);
    final placeholder = widget.placeholder ?? '';

    bool usePlaceholder = true;
    String title = placeholder;
    if (_selectedValue != null) {
      title = _selectedValue!.toHexString(
        includeHashSign: true,
        enableAlpha: widget.enableAlpha,
      );
      usePlaceholder = false;
    }
    final textWidget = Text(
      title,
      style:
          (usePlaceholder ? widget.placeholderTextStyle : widget.textStyle) ??
          TextStyle(fontSize: 14, color: theme.neutral66),
      overflow: TextOverflow.ellipsis,
    );

    final iconWidget =
        (widget.icon != null && !usePlaceholder)
            ? IconTheme(
              data: IconTheme.of(context).copyWith(color: _selectedValue),
              child: widget.icon!,
            )
            : null;

    return iconWidget != null
        ? Row(spacing: 8, children: [iconWidget, Expanded(child: textWidget)])
        : textWidget;
  }
}
