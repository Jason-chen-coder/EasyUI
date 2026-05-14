import 'package:easy_ui/src/easy_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'easy_avatar.dart';

/// EasyAvatar item 数据模型
class EasyAvatarItem {
  final String? initials;
  final String? src;
  final Color? backgroundColor;
  final Color? initialsColor;
  EasyAvatarItem({
    this.initials,
    this.src,
    this.backgroundColor,
    this.initialsColor = Colors.white,
  });

  /// 根据 initials 第一个字符生成背景颜色
  static Color colorFromInitial(String? initials) {
    if (initials == null || initials.isEmpty) return CupertinoColors.systemGrey;

    final code = initials.codeUnitAt(0); // 拿第一个字符的 Unicode
    final colors = [
      Color(0xff31DA9F),
      Color(0xff907FF0),
      Color(0xff6E8EFF),
      Color(0xff2BC8E4),
      Color(0xff7EDA99),
      Color(0xffF4BE59),
      Color(0xffFF943D),
    ];
    return colors[code % colors.length]; // 按字符哈希到一个颜色
  }

  /// 根据索引循环选择主题色作为背景颜色
  static Color colorFromIndex(BuildContext context, int index) {
    final easyTheme = EasyTheme.of(context);
    final colors = [easyTheme.primaryGreen, ...easyTheme.secondaryColors];
    return colors[index % colors.length];
  }
}

enum AvatarGroupDirection { left, right, top, bottom }

class EasyAvatarGroup extends StatelessWidget {
  final double avatarGap; // 头像之间的间距（传给 AvatarGroup.gap；负值可重叠）
  final AvatarGroupDirection direction;
  final List<EasyAvatarItem> items;
  final double? avatarSize;
  final double avatarOffset;
  final int? count; // 限制显示的头像数量
  final bool showBorder;
  const EasyAvatarGroup({
    super.key,
    this.avatarGap = 2,
    this.direction = AvatarGroupDirection.left,
    this.avatarSize,
    this.avatarOffset = 0.5,
    this.count, // 可选参数，不传则显示所有头像
    this.showBorder = false,
    required this.items,
  });

  /// 处理头像数据，根据 count 限制数量并添加 "+数量" 头像
  List<EasyAvatarItem> _processItems() {
    if (count == null || items.length <= count!) {
      // 如果没有设置 count 或者 items 数量不超过 count，直接返回原数据
      return items;
    }

    // 取前 count 个真实头像
    final visibleItems = items.take(count!).toList();
    // 计算剩余未显示的数量
    final remainingCount = items.length - count!;

    // 添加显示剩余数量的头像
    return [
      ...visibleItems,
      EasyAvatarItem(
        initials: '+$remainingCount',
        src: null,
        backgroundColor: Colors.white,
        initialsColor: Color(0xFF666666),
      ),
    ];
  }

  List<Widget> _buildAvatars(BuildContext context) {
    // 获取要处理的items（已经考虑了count限制）
    final itemsToProcess =
        (count == null || items.length <= count!) ? items : _processItems();
    final avatars = <Widget>[];
    var colorIndex = 0;

    for (var item in itemsToProcess) {
      var color =
          item.backgroundColor ??
          EasyAvatarItem.colorFromInitial(item.initials);
      if (item.backgroundColor == null) {
        colorIndex++;
      }

      avatars.add(
        EasyAvatar(
          initials: item.initials,
          size: avatarSize,
          src: item.src,
          backgroundColor: color,
          initialsColor: item.initialsColor,
          showBorder: true,
        ),
      );
    }

    return avatars;
  }

  double _effectiveSize() => avatarSize ?? 32.0;

  double _step() {
    final double size = _effectiveSize();
    final double spacingFactor = avatarOffset < 0 ? 0.0 : avatarOffset;
    return (size * spacingFactor + avatarGap).toDouble();
  }

  Widget _buildHorizontal(BuildContext context, {required bool leftToRight}) {
    final children = _buildAvatars(context);
    final avatars = leftToRight ? children : children.reversed.toList();
    final double size = _effectiveSize();
    final double step = _step();
    final int count = avatars.length;
    final double width = count > 0 ? size + (count - 1) * step : 0.0;

    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: List.generate(avatars.length, (index) {
          return Positioned(
            left: (index * step).toDouble(),
            width: size,
            height: size,
            child: avatars[index],
          );
        }),
      ),
    );
  }

  Widget _buildVertical(BuildContext context, {required bool topToBottom}) {
    final children = _buildAvatars(context);
    final avatars = topToBottom ? children : children.reversed.toList();
    final double size = _effectiveSize();
    final double step = _step();
    final int count = avatars.length;
    final double height = count > 0 ? size + (count - 1) * step : 0.0;

    return SizedBox(
      width: size,
      height: height,
      child: Stack(
        children: List.generate(avatars.length, (index) {
          return Positioned(
            top: (index * step).toDouble(),
            width: size,
            height: size,
            child: avatars[index],
          );
        }),
      ),
    );
  }

  Widget _buildGroup(BuildContext context) {
    switch (direction) {
      case AvatarGroupDirection.left:
        return _buildHorizontal(context, leftToRight: true);
      case AvatarGroupDirection.right:
        return _buildHorizontal(context, leftToRight: false);
      case AvatarGroupDirection.top:
        return _buildVertical(context, topToBottom: true);
      case AvatarGroupDirection.bottom:
        return _buildVertical(context, topToBottom: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildGroup(context);
  }
}
