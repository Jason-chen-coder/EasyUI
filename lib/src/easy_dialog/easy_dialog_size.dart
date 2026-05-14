/// 弹窗大小
enum EasyDialogSize {
  /// 小尺寸。宽度：占屏幕30%，在1124*834的设计稿中约等于358px
  small,

  /// 中尺寸。宽度：占屏幕50%，在1124*834的设计稿中约等于586px
  medium,

  /// 大尺寸。宽度：占屏幕70%，在1124*834的设计稿中约等于836px
  large;

  double get width => switch (this) {
    EasyDialogSize.small => 358,
    EasyDialogSize.medium => 586,
    EasyDialogSize.large => 836,
  };
}
