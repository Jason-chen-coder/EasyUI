import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

typedef EasyScrollSectionsScrollToPositionCallback = void Function(int);

typedef EasyScrollSectionsPositionIndicatorBuilder =
    Widget Function(
      BuildContext,
      int,
      EasyScrollSectionsScrollToPositionCallback,
    );

class EasyScrollSectionsLayout extends StatefulWidget {
  const EasyScrollSectionsLayout({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemSpacing = 24,
    this.positionIndicatorBuilder,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 24),
  });

  /// Number of items the [itemBuilder] can produce.
  final int itemCount;

  /// Called to build children for the list with
  /// 0 <= index < itemCount.
  final IndexedWidgetBuilder itemBuilder;

  /// 子项间距
  final double itemSpacing;

  /// 指示器构建函数
  final EasyScrollSectionsPositionIndicatorBuilder? positionIndicatorBuilder;

  /// 列表的内边距
  final EdgeInsets listPadding;

  @override
  State<EasyScrollSectionsLayout> createState() =>
      _EasyScrollSectionsLayoutState();
}

class _EasyScrollSectionsLayoutState extends State<EasyScrollSectionsLayout> {
  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;

  bool _playingScrollAnimation = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    _itemPositionsListener.itemPositions.addListener(() {
      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isEmpty || _playingScrollAnimation) {
        return;
      }
      int? index;
      final totalInViewportItems = <ItemPosition>[];
      final leadingInViewportItems = <ItemPosition>[];
      final leadingAboveViewportItems = <ItemPosition>[];
      for (final position in positions) {
        if (position.itemLeadingEdge >= 0 && position.itemTrailingEdge <= 1) {
          totalInViewportItems.add(position);
        }
        if (position.itemLeadingEdge >= 0 && position.itemLeadingEdge < 1) {
          leadingInViewportItems.add(position);
        }
        if (position.itemLeadingEdge < 0) {
          leadingAboveViewportItems.add(position);
        }
      }
      if (totalInViewportItems.isNotEmpty) {
        index =
            totalInViewportItems
                .reduce((a, b) => a.index < b.index ? a : b)
                .index;
      } else if (leadingInViewportItems.isNotEmpty) {
        index =
            leadingInViewportItems
                .reduce((a, b) => a.index < b.index ? a : b)
                .index;
      } else if (leadingAboveViewportItems.isNotEmpty) {
        index =
            leadingAboveViewportItems
                .reduce((a, b) => a.index < b.index ? a : b)
                .index;
      }

      if (index != null && _currentIndex != index) {
        setState(() {
          _currentIndex = index!;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemList = ScrollablePositionedList.separated(
      padding: widget.listPadding,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      itemScrollController: _itemScrollController,
      itemPositionsListener: _itemPositionsListener,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: widget.itemSpacing);
      },
    );

    if (widget.positionIndicatorBuilder != null) {
      return Column(
        children: [
          widget.positionIndicatorBuilder!(context, _currentIndex, (index) {
            if (_itemScrollController.isAttached) {
              setState(() {
                _currentIndex = index;
              });
              _playingScrollAnimation = true;
              _itemScrollController
                  .scrollTo(
                    index: index,
                    duration: Durations.medium2,
                    curve: Curves.easeInOut,
                  )
                  .whenComplete(() {
                    setState(() {
                      _playingScrollAnimation = false;
                    });
                  });
            }
          }),
          Expanded(child: itemList),
        ],
      );
    } else {
      return itemList;
    }
  }
}

class EasySectionContent extends StatelessWidget {
  const EasySectionContent({
    super.key,
    required this.title,
    this.titleBuilder,
    required this.content,
  });

  final String title;
  final Widget Function(BuildContext, Widget)? titleBuilder;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    Widget titleWidget = Text(
      title,
      style: TextStyle(fontSize: 16, color: easyTheme.neutral33, height: 1.0),
    );
    if (titleBuilder != null) {
      titleWidget = titleBuilder!(context, titleWidget);
    }

    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [titleWidget, content],
    );
  }
}
