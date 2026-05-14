import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ToastAnimatedListItemBuilder =
    Widget Function(
      BuildContext context,
      int index,
      Animation<double> animation,
    );

typedef ToastAnimatedListRemovedItemBuilder =
    Widget Function(BuildContext context, Animation<double> animation);

class _ToastAnimatedItem implements Comparable<_ToastAnimatedItem> {
  final AnimationController? controller;
  final ToastAnimatedListRemovedItemBuilder? removedItemBuilder;
  int itemIndex;

  _ToastAnimatedItem(this.itemIndex, this.controller, this.removedItemBuilder);

  @override
  int compareTo(_ToastAnimatedItem other) {
    return itemIndex - other.itemIndex;
  }
}

class ToastAnimatedList extends StatefulWidget {
  const ToastAnimatedList({
    super.key,
    required this.itemBuilder,
    required this.initialItemCount,
    this.clipBehavior = Clip.hardEdge,
    this.reverse = false,
    this.primary,
  });

  final ToastAnimatedListItemBuilder itemBuilder;
  final int initialItemCount;
  final Clip clipBehavior;
  final bool reverse;
  final bool? primary;

  @override
  State<ToastAnimatedList> createState() => ToastAnimatedListState();
}

class ToastAnimatedListState extends State<ToastAnimatedList>
    with TickerProviderStateMixin {
  final List<_ToastAnimatedItem> _items = [];
  final List<_ToastAnimatedItem> _outcomingItems = [];
  late int _itemsCount;

  @override
  void initState() {
    super.initState();
    _itemsCount = widget.initialItemCount;
    for (var i = 0; i < widget.initialItemCount; ++i) {
      final item = _ToastAnimatedItem(
        i,
        AnimationController(vsync: this, duration: Durations.medium2),
        null,
      );
      item.controller!.value = 1.0;
      _items.add(item);
    }
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.controller?.dispose();
    }
    for (final item in _outcomingItems) {
      item.controller?.dispose();
    }
    super.dispose();
  }

  _ToastAnimatedItem? _removeAnimatedItemAt(
    List<_ToastAnimatedItem> items,
    int itemIndex,
  ) {
    final int i = binarySearch(
      items,
      _ToastAnimatedItem(itemIndex, null, null),
    );
    return i == -1 ? null : items.removeAt(i);
  }

  _ToastAnimatedItem? _animatedItemAt(
    List<_ToastAnimatedItem> items,
    int itemIndex,
  ) {
    final int i = binarySearch(
      items,
      _ToastAnimatedItem(itemIndex, null, null),
    );
    return i == -1 ? null : items[i];
  }

  int _itemIndexToIndex(int itemIndex) {
    int index = itemIndex;
    for (final item in _outcomingItems) {
      assert(item.itemIndex != itemIndex);
      if (item.itemIndex < itemIndex) {
        index -= 1;
      } else {
        break;
      }
    }
    return index;
  }

  int _indexToItemIndex(int index) {
    int itemIndex = index;
    for (final item in _outcomingItems) {
      if (item.itemIndex <= itemIndex) {
        itemIndex += 1;
      } else {
        break;
      }
    }
    return itemIndex;
  }

  void insertItem(int index, {Duration duration = Durations.medium2}) {
    assert(index >= 0);

    final itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex <= _itemsCount);

    for (final item in _items) {
      if (item.itemIndex >= itemIndex) {
        item.itemIndex += 1;
      }
    }
    for (final item in _outcomingItems) {
      if (item.itemIndex >= itemIndex) {
        item.itemIndex += 1;
      }
    }

    final controller = AnimationController(vsync: this, duration: duration);
    final item = _ToastAnimatedItem(itemIndex, controller, null);

    setState(() {
      _items
        ..add(item)
        ..sort();
      _itemsCount += 1;
    });

    controller.forward();
  }

  void removeItem(
    int index,
    ToastAnimatedListRemovedItemBuilder removedItemBuilder, {
    Duration duration = Durations.medium2,
  }) {
    assert(index >= 0);

    final itemIndex = _indexToItemIndex(index);
    assert(itemIndex >= 0 && itemIndex < _itemsCount);
    assert(_animatedItemAt(_outcomingItems, itemIndex) == null);

    final item = _removeAnimatedItemAt(_items, itemIndex);
    final AnimationController controller =
        item?.controller ??
        AnimationController(vsync: this, duration: duration, value: 1.0);
    final outcomingItem = _ToastAnimatedItem(
      itemIndex,
      controller,
      removedItemBuilder,
    );
    setState(() {
      _outcomingItems
        ..add(outcomingItem)
        ..sort();
    });

    if (controller.status != AnimationStatus.reverse) {
      controller.reverse().then<void>((void value) {
        final removedItem = _removeAnimatedItemAt(_outcomingItems, itemIndex);
        if (removedItem != null) {
          removedItem.controller?.dispose();
          for (final item in _outcomingItems) {
            if (item.itemIndex > itemIndex) {
              item.itemIndex -= 1;
            }
          }
          for (final item in _items) {
            if (item.itemIndex > itemIndex) {
              item.itemIndex -= 1;
            }
          }

          setState(() {
            _itemsCount -= 1;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_itemsCount == 0) {
      return const SizedBox();
    }
    return SingleChildScrollView(
      clipBehavior: widget.clipBehavior,
      reverse: widget.reverse,
      primary: widget.primary,
      child: Column(
        children: List.generate(_itemsCount, (itemIndex) {
          final outgoingItem = _animatedItemAt(_outcomingItems, itemIndex);
          if (outgoingItem != null) {
            return outgoingItem.removedItemBuilder?.call(
                  context,
                  CurvedAnimation(
                    parent: outgoingItem.controller!,
                    curve: Curves.easeInOut,
                  ),
                ) ??
                SizedBox.shrink();
          }

          final item = _animatedItemAt(_items, itemIndex)!;
          return widget.itemBuilder(
            context,
            _itemIndexToIndex(itemIndex),
            CurvedAnimation(parent: item.controller!, curve: Curves.easeInOut),
          );
        }),
      ),
    );
  }
}
