/// @docImport '../easy_theme.dart';
library;

import 'package:flutter/material.dart';

import '../easy_theme.dart';
import 'easy_drawer_wrapper.dart';

/// 抽屉尺寸
enum EasyDrawerSize {
  /// 宽度456
  small,

  /// 宽度714
  medium,

  /// 宽度914
  large,

  /// 全屏
  full;

  double get width => switch (this) {
    EasyDrawerSize.small => 456,
    EasyDrawerSize.medium => 714,
    EasyDrawerSize.large => 914,
    EasyDrawerSize.full => double.infinity,
  };
}

/// 抽屉
class EasyDrawer extends StatelessWidget {
  const EasyDrawer({
    super.key,
    required this.body,
    this.size = EasyDrawerSize.small,
    this.bodyPadding,
    this.backgroundColor,
    this.needNavigatorWrapper = false,
    this.header,
    this.footer,
    this.footerPadding = const EdgeInsets.only(
      top: 16,
      left: 24,
      right: 24,
      bottom: 24,
    ),
    this.bodyScrollable = false,
    this.resizeToAvoidBottomInset = true,
  });

  final bool needNavigatorWrapper;

  /// 抽屉尺寸
  final EasyDrawerSize size;

  /// 抽屉内边距, 默认为EdgeInsets.all(24).
  /// 存在footer时默认为EdgeInsets.only(left: 24, right: 24, top: 24)
  final EdgeInsets? bodyPadding;

  /// 抽屉背景色
  final Color? backgroundColor;

  /// 抽屉头部
  final Widget? header;

  /// 抽屉内容
  final Widget body;

  /// 抽屉底部
  final Widget? footer;

  /// 抽屉底部内边距
  final EdgeInsets footerPadding;

  /// 为true时默认使用[SingleChildScrollView]包裹[body]
  final bool bodyScrollable;

  /// 为true时，使用[MediaQuery.viewInsetsOf]在底部插入padding，防止界面被键盘被遮挡。
  ///
  /// 默认为true
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final bodyPadding =
        this.bodyPadding ??
        (footer == null
            ? EdgeInsets.all(24)
            : EdgeInsets.only(left: 24, right: 24, top: 24));

    Widget body = this.body;
    if (bodyScrollable) {
      body = SingleChildScrollView(padding: bodyPadding, child: body);
    } else {
      body = Padding(padding: bodyPadding, child: body);
    }
    Widget content;
    if (needNavigatorWrapper) {
      content = Navigator(
        onGenerateRoute: (settings) {
          return PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    header != null || footer != null
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (header != null) header!,
                            Expanded(child: body),
                            if (footer != null)
                              Padding(padding: footerPadding, child: footer!),
                          ],
                        )
                        : body,
          );
        },
      );
    } else {
      content =
          header != null || footer != null
              ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (header != null) header!,
                  Expanded(child: body),
                  if (footer != null)
                    Padding(padding: footerPadding, child: footer!),
                ],
              )
              : body;
    }

    if (resizeToAvoidBottomInset) {
      content = Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: content,
      );
    }

    return Drawer(
      backgroundColor: backgroundColor ?? EasyTheme.of(context).background,
      shape: const RoundedRectangleBorder(),
      width: size.width,
      child: content,
    );
  }
}

/// 抽屉顶部栏
class EasyDrawerTopBar extends StatelessWidget {
  const EasyDrawerTopBar({
    super.key,
    this.onBackButtonTap,
    this.title = '',
    this.titleStyle,
    this.titleWidget,
    this.actions,
    this.backgroundColor,
  });

  static const height = 60.0;

  /// 返回按钮点击事件
  final VoidCallback? onBackButtonTap;

  /// 标题
  final String title;

  /// 标题样式
  final TextStyle? titleStyle;

  /// 标题组件，不为null时，[title]和[titleStyle]不生效
  final Widget? titleWidget;

  /// 顶部栏右侧按钮
  final List<Widget>? actions;

  /// 抽屉顶部栏背景色
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    final backButton = Container(
      color: backgroundColor ?? EasyTheme.of(context).background,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 11),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_outlined,
          size: 14,
          color: Color(0xff666666),
        ),
        onPressed:
            onBackButtonTap ??
            () async {
              // 优先尝试通过 EasyDrawerScope 关闭当前由 Wrapper 打开的抽屉
              final closed = await EasyDrawerScope.tryCloseAsync(context);
              if (!closed) {
                // 退化到路由返回，兼容直接放入 Scaffold drawer 的场景
                Navigator.of(context).maybePop();
              }
            },
      ),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.neutralEE)),
      ),
      child: Stack(
        children: [
          backButton,
          Center(
            child:
                titleWidget ??
                Text(
                  title,
                  style:
                      titleStyle ??
                      TextStyle(fontSize: 16, color: theme.neutral33),
                ),
          ),
          if (actions != null)
            Align(
              alignment: Alignment.centerRight,
              child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ),
        ],
      ),
    );
  }
}

/// 抽屉底部按钮
class EasyDrawerFooterButton extends StatelessWidget {
  const EasyDrawerFooterButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    this.minimumSize = const Size.fromHeight(46),
    this.fixedSize = const Size.fromHeight(46),
    this.maximumSize = Size.infinite,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.icon,
    this.elevation,
    this.side,
    this.textColor = Colors.white,
    this.shadowColor,
  });

  final String text;

  /// 默认为[EasyThemeData.primaryGreen]
  final Color? backgroundColor;
  final OutlinedBorder shape;
  final Size minimumSize;
  final Size fixedSize;
  final Size maximumSize;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? elevation;
  final BorderSide? side;
  final Color? textColor;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.primaryGreen,
        shape: shape,
        minimumSize: minimumSize,
        fixedSize: fixedSize,
        maximumSize: maximumSize,
        padding: padding,
        side: side,
        elevation: elevation,
        shadowColor: shadowColor,
      ),
      onPressed: onPressed,
      icon: icon,
      label: Text(text, style: TextStyle(fontSize: 14, color: textColor)),
    );
  }
}
