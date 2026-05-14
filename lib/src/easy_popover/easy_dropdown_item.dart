part of 'easy_dropdown.dart';

/// 下拉列表项类型
abstract class EasyDropdownItem<T> {
  const EasyDropdownItem();
}

/// 普通下拉列表项（仅文本）
class EasyDropdownListItem<T> extends EasyDropdownItem<T> {
  const EasyDropdownListItem({
    required this.value,
    required this.child,
    this.onTap,
    this.enabled = true,
  });

  /// 项的值
  final T value;

  /// 显示的子组件
  final Widget child;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否启用
  final bool enabled;
}

/// 带图标和标签的下拉列表项
class EasyDropdownIconItem<T> extends EasyDropdownItem<T> {
  const EasyDropdownIconItem({
    required this.value,
    this.icon,
    required this.label,
    this.onTap,
    this.enabled = true,
    this.spacing = 8.0,
  });

  ///使用资源图片的列表项
  factory EasyDropdownIconItem.fromPicture({
    required T value,
    required String assetName,
    String? package,
    required String label,
    VoidCallback? onTap,
    bool enabled = true,
    Color? iconColor = const Color(0xFF4F5159),
    Color? labelColor = const Color(0xFF101010),
    double iconSize = 20,
  }) {
    final icon =
        assetName.endsWith(".svg")
            ? SvgPicture.asset(
              assetName,
              height: iconSize,
              width: iconSize,
              colorFilter:
                  iconColor == null
                      ? null
                      : ColorFilter.mode(iconColor, BlendMode.srcIn),
              package: package,
            )
            : Image.asset(
              assetName,
              height: iconSize,
              width: iconSize,
              color: iconColor,
              package: package,
            );

    return EasyDropdownIconItem<T>(
      value: value,
      onTap: onTap,
      enabled: enabled,
      spacing: 0,
      icon: icon,
      label: Center(
        child: Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 14, height: 20 / 14),
        ),
      ),
    );
  }

  /// 项的值
  final T value;

  /// 图标组件
  final Widget? icon;

  /// 标签组件
  final Widget label;

  /// 点击回调
  final VoidCallback? onTap;

  /// 是否启用
  final bool enabled;

  /// 图标和标签之间的间距
  final double spacing;
}

/// 分割线项
///
/// `T` 泛型和列表的泛型保持一致即可
class EasyDropdownDivider<T> extends EasyDropdownItem<T> {
  const EasyDropdownDivider({
    this.height = 1.0,
    this.color = const Color(0xFFF8F8F8),
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  /// 分割线高度
  final double height;

  /// 分割线颜色
  final Color color;

  /// 左侧缩进
  final double indent;

  /// 右侧缩进
  final double endIndent;
}
