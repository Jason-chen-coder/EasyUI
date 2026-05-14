import 'package:popover/popover.dart';

/// 展示方向
enum EasyPopoverDirection {
  top,
  bottom,
  left,
  right;

  PopoverDirection get toPopoverDirection {
    return switch (this) {
      EasyPopoverDirection.top => PopoverDirection.top,
      EasyPopoverDirection.bottom => PopoverDirection.bottom,
      EasyPopoverDirection.left => PopoverDirection.left,
      EasyPopoverDirection.right => PopoverDirection.right,
    };
  }
}
