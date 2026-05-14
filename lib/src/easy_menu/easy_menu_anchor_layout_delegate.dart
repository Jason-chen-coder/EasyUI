import 'dart:math';

import 'package:easy_ui/src/easy_menu/easy_menu_anchor.dart';
import 'package:flutter/material.dart';

/// [EasyMenuAnchor]定位和约束代理
class EasyMenuAnchorLayoutDelegate {
  const EasyMenuAnchorLayoutDelegate();

  /// 测量菜单大小后决定菜单位置
  /// targetAnchor、followerAnchor、offset作用同[CompositedTransformFollower]的同名参数
  ({Alignment targetAnchor, Alignment followerAnchor, Offset offset})
  getAlignmentsAndOffset(
    Size? menuSize,
    Rect anchorRect,
    Size overlaySize,
    Offset originOffset,
  ) {
    // anchor左侧到overlay右侧的距离
    final leftSpace = overlaySize.width - anchorRect.left - originOffset.dx;

    // anchor下侧到overlay下侧的距离
    final bottomSpace =
        overlaySize.height - anchorRect.bottom - originOffset.dy;

    var targetAnchor = Alignment.bottomLeft;
    var followerAnchor = Alignment.topLeft;

    if (menuSize != null) {
      if (menuSize.width > leftSpace) {
        targetAnchor = Alignment(1.0, targetAnchor.y);
        followerAnchor = Alignment(1.0, followerAnchor.y);
        originOffset = Offset(-originOffset.dx, originOffset.dy);
      }
      if (menuSize.height > bottomSpace) {
        targetAnchor = Alignment(targetAnchor.x, -1.0);
        followerAnchor = Alignment(targetAnchor.x, 1.0);
        originOffset = Offset(originOffset.dx, -originOffset.dy);
      }
    }

    return (
      targetAnchor: targetAnchor,
      followerAnchor: followerAnchor,
      offset: originOffset,
    );
  }

  /// 菜单约束
  BoxConstraints getMenuConstraints(
    Rect anchorRect,
    Size overlaySize,
    Offset originOffset,
  ) {
    // anchor左侧到overlay右侧的距离
    final leftSpace = overlaySize.width - anchorRect.left - originOffset.dx;

    // anchor右侧到overlay左侧的距离
    final rightSpace = anchorRect.right - originOffset.dx;

    // anchor上侧到overlay上侧的距离
    final topSpace = anchorRect.top - originOffset.dy;

    // anchor下侧到overlay下侧的距离
    final bottomSpace =
        overlaySize.height - anchorRect.bottom - originOffset.dy;

    return BoxConstraints(
      maxWidth: max(leftSpace, rightSpace),
      maxHeight: max(topSpace, bottomSpace),
    );
  }
}
