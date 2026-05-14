import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'easy_theme.dart';

class EasySegmentsItem {
  final String label;

  /// 是否未读（未读状态右上角会展示一个小红点）
  final bool unread;

  const EasySegmentsItem(this.label, {this.unread = false});
}

class EasySegments extends StatelessWidget {
  /// The list of segments to display.
  final List<EasySegmentsItem> segments;

  /// The index of the selected segment.
  final int selectedIndex;

  /// The callback function to be called when the segment is changed.
  final void Function(int segment)? onSegmentChange;

  /// The padding of the segments.
  final EdgeInsets padding;

  /// The width of the segments.
  final double width;

  final double height;

  /// The background color of the segments.
  final Color? background;

  /// The border radius of the segments.
  final BorderRadius? borderRadius;

  /// The spacing between the segments.
  final double segmentSpacing;

  /// The height of the segment.
  final double segmentHeight;

  /// The border radius of the selected segment.
  final BorderRadius? segmentBorderRadius;

  /// The background color of the selected segment.
  final Color? selectedSegmentBackground;

  /// The text style of the selected segment.
  final TextStyle? selectedSegmentTextStyle;

  /// The text style of the segment.
  final TextStyle? segmentTextStyle;

  /// 是否支持滚动
  final bool scrollable;

  /// 仅支持滚动时生效，每个segment的最小宽度
  final double segmentMinWidth;

  /// 仅支持滚动时生效，每个segment的padding
  final EdgeInsets segmentPadding;

  const EasySegments({
    super.key,
    required this.segments,
    this.selectedIndex = 0,
    this.onSegmentChange,
    this.padding = const EdgeInsets.all(4.0),
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius,
    this.background,
    this.segmentSpacing = 8.0,
    this.segmentHeight = 32.0,
    this.segmentBorderRadius,
    this.selectedSegmentBackground,
    this.selectedSegmentTextStyle,
    this.segmentTextStyle,
    this.scrollable = false,
    this.segmentMinWidth = 136.0,
    this.segmentPadding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
  });

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);

    final background = this.background ?? easyTheme.neutralF8;
    final borderRadius =
        this.borderRadius ?? BorderRadius.all(easyTheme.cornerSmall);
    final segmentBorderRadius =
        this.segmentBorderRadius ?? BorderRadius.all(easyTheme.cornerSmall);
    final selectedSegmentTextStyle =
        this.selectedSegmentTextStyle ??
        TextStyle(fontSize: 14, color: easyTheme.primaryGreen);
    final segmentTextStyle =
        this.segmentTextStyle ??
        TextStyle(fontSize: 14, color: easyTheme.neutral66);

    if (scrollable) {
      return _EasySegments2(
        items: segments,
        selectedItemIndex: selectedIndex,
        onSegmentChanged: onSegmentChange,
        segmentSpacing: segmentSpacing,
        backgroundColor: background,
        borderRadius: borderRadius,
        padding: padding,
        segmentPadding: segmentPadding,
        segmentMinWidth: segmentMinWidth,
        segmentBorderRadius: segmentBorderRadius,
        segmentTextStyle: segmentTextStyle.copyWith(height: 1),
        selectedSegmentBg: selectedSegmentBackground ?? easyTheme.background,
        selectedSegmentTextStyle: selectedSegmentTextStyle.copyWith(height: 1),
      );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(color: background, borderRadius: borderRadius),
      width: width,
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final segmentWidth =
              (constraints.maxWidth - (segments.length - 1) * segmentSpacing) /
              segments.length;

          return Stack(
            children: [
              AnimatedPositioned(
                left: selectedIndex * (segmentWidth + segmentSpacing),
                curve: Curves.ease,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: segmentWidth,
                  height: segmentHeight,
                  decoration: BoxDecoration(
                    borderRadius: segmentBorderRadius,
                    color: selectedSegmentBackground ?? easyTheme.background,
                  ),
                ),
              ),
              Row(
                spacing: segmentSpacing,
                children:
                    segments
                        .asMap()
                        .map((key, item) {
                          return MapEntry(
                            key,
                            Expanded(
                              child: Tooltip(
                                message: item.label,
                                child: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 3,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: segmentBorderRadius,
                                    ),
                                    height: segmentHeight,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Text(
                                          item.label,
                                          style:
                                              key == selectedIndex
                                                  ? selectedSegmentTextStyle
                                                  : segmentTextStyle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (item.unread) ...[
                                          Positioned(
                                            top: 0,
                                            right: -7,
                                            child: Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: easyTheme.warning,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    if (onSegmentChange != null) {
                                      onSegmentChange!(key);
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        })
                        .values
                        .toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EasySegments2 extends StatefulWidget {
  const _EasySegments2({
    required this.items,
    required this.selectedItemIndex,
    required this.onSegmentChanged,
    required this.segmentSpacing,
    this.padding = const EdgeInsets.all(4.0),
    this.segmentMinWidth = 136.0,
    this.segmentBorderRadius,
    this.segmentPadding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    this.segmentTextStyle,
    this.selectedSegmentBg = Colors.white,
    this.selectedSegmentTextStyle,
    this.backgroundColor,
    this.borderRadius,
  });

  static const defaultSelectedSegmentTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF31DA9F),
    height: 1,
  );

  static const defaultSegmentTextStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF666666),
    height: 1,
  );

  final List<EasySegmentsItem> items;
  final int selectedItemIndex;
  final ValueChanged<int>? onSegmentChanged;
  final BorderRadius? borderRadius;
  final double segmentMinWidth;
  final BorderRadius? segmentBorderRadius;
  final EdgeInsets padding;
  final EdgeInsets segmentPadding;
  final TextStyle? segmentTextStyle;
  final Color selectedSegmentBg;
  final TextStyle? selectedSegmentTextStyle;
  final Color? backgroundColor;
  final double segmentSpacing;

  @override
  State<_EasySegments2> createState() => _EasySegments2State();
}

class _EasySegments2State extends State<_EasySegments2>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  double _scrollOffset = 0;
  double _preIndicatorLeftSpace = .0;
  double _indicatorLeftSpace = .0;
  Size? _preIndicatorSize;
  Size? _indicatorSize;

  TextStyle get selectedTextStyle {
    return widget.selectedSegmentTextStyle ??
        _EasySegments2.defaultSelectedSegmentTextStyle;
  }

  TextStyle get unselectedTextStyle {
    return widget.segmentTextStyle ?? _EasySegments2.defaultSegmentTextStyle;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.short4,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(_EasySegments2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItemIndex != widget.selectedItemIndex) {
      final oldLeftUnselectedItems = widget.items.take(
        oldWidget.selectedItemIndex,
      );

      _preIndicatorLeftSpace =
          oldLeftUnselectedItems.isEmpty
              ? 0
              : (oldLeftUnselectedItems
                      .map(
                        (e) => max(
                          (TextPainter(
                                text: TextSpan(
                                  text: e.label,
                                  style:
                                      oldWidget.segmentTextStyle ??
                                      _EasySegments2.defaultSegmentTextStyle,
                                ),
                                textDirection: TextDirection.ltr,
                              )..layout()).width +
                              widget.segmentPadding.horizontal,
                          widget.segmentMinWidth,
                        ),
                      )
                      .reduce((a, b) => a + b)) +
                  oldWidget.segmentSpacing * oldWidget.selectedItemIndex;

      final leftUnselectedItems = widget.items.take(widget.selectedItemIndex);

      _indicatorLeftSpace =
          leftUnselectedItems.isEmpty
              ? 0
              : (leftUnselectedItems
                      .map(
                        (e) => max(
                          (TextPainter(
                                text: TextSpan(
                                  text: e.label,
                                  style: unselectedTextStyle,
                                ),
                                textDirection: TextDirection.ltr,
                              )..layout()).width +
                              widget.segmentPadding.horizontal,
                          widget.segmentMinWidth,
                        ),
                      )
                      .reduce((a, b) => a + b)) +
                  widget.segmentSpacing * widget.selectedItemIndex;

      _preIndicatorSize = _calculateItemSize(
        oldWidget.items[oldWidget.selectedItemIndex].label,
        oldWidget.selectedSegmentTextStyle ??
            _EasySegments2.defaultSelectedSegmentTextStyle,
      );

      _indicatorSize = _calculateItemSize(
        widget.items[widget.selectedItemIndex].label,
        selectedTextStyle,
      );

      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Size _calculateItemSize(String label, TextStyle textStyle) {
    final selectedTextPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: DefaultTextStyle.of(context).style.merge(textStyle),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return Size(
      max(
        widget.segmentMinWidth,
        selectedTextPainter.width + widget.segmentPadding.horizontal,
      ),
      selectedTextPainter.height + widget.segmentPadding.vertical,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);

    return Material(
      color: widget.backgroundColor ?? theme.neutralF8,
      borderRadius: widget.borderRadius ?? BorderRadius.all(theme.cornerSmall),
      child: Padding(
        padding: widget.padding,
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                final left = Tween<double>(
                  begin: _preIndicatorLeftSpace - _scrollOffset,
                  end: _indicatorLeftSpace - _scrollOffset,
                ).evaluate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.ease,
                  ),
                );

                final size =
                    _indicatorSize ??
                    _calculateItemSize(
                      widget.items[widget.selectedItemIndex].label,
                      selectedTextStyle,
                    );
                final preSize = _preIndicatorSize ?? size;
                final width = Tween<double>(
                  begin: preSize.width,
                  end: size.width,
                ).evaluate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.ease,
                  ),
                );
                return Positioned(
                  left: left,
                  child: Container(
                    width: width,
                    height: size.height,
                    decoration: BoxDecoration(
                      color:
                          _animationController.isAnimating
                              ? widget.selectedSegmentBg
                              : null,
                      borderRadius: widget.segmentBorderRadius,
                    ),
                  ),
                );
              },
            ),
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _scrollOffset = notification.metrics.extentBefore;
                return false;
              },
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics:
                      _animationController.isAnimating
                          ? const NeverScrollableScrollPhysics()
                          : null,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: widget.segmentSpacing,
                      children:
                          widget.items.indexed.map((e) {
                            final (index, item) = e;
                            final selected = widget.selectedItemIndex == index;
                            return KeyedSubtree(
                              key: ValueKey(Object.hashAll([index, item])),
                              child: _EasySegments2ItemWidget(
                                item: item,
                                selected: selected,
                                onTap:
                                    (_animationController.isAnimating ||
                                            selected ||
                                            widget.onSegmentChanged == null)
                                        ? null
                                        : () {
                                          widget.onSegmentChanged!.call(index);
                                        },
                                padding: widget.segmentPadding,
                                minWidth: widget.segmentMinWidth,
                                textStyle:
                                    selected
                                        ? selectedTextStyle
                                        : unselectedTextStyle,
                                backgroundColor:
                                    (_animationController.isAnimating ||
                                            !selected)
                                        ? null
                                        : widget.selectedSegmentBg,
                                borderRadius: widget.segmentBorderRadius,
                                unread: item.unread,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EasySegments2ItemWidget extends StatelessWidget {
  const _EasySegments2ItemWidget({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.padding,
    required this.minWidth,
    required this.textStyle,
    required this.backgroundColor,
    required this.borderRadius,
    required this.unread,
  });

  final EasySegmentsItem item;
  final bool selected;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final double minWidth;
  final TextStyle textStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool unread;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    Widget text = Text(item.label, style: textStyle);

    if (unread) {
      text = Stack(
        clipBehavior: Clip.none,
        children: [
          text,
          Positioned(
            top: -3,
            right: -7,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: easyTheme.warning,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: padding,
        constraints: BoxConstraints(minWidth: minWidth),
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: text,
      ),
    );
  }
}
