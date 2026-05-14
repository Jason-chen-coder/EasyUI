import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../markdown_widget.dart';

///[TocController] combines [TocWidget] and [MarkdownWidget],
///you can use it to control the jump between the two,
/// and each [TocWidget] corresponds to a [MarkdownWidget].
class TocController {
  ///key is index of widgets, value is [Toc]
  final LinkedHashMap<int, Toc> _index2toc = LinkedHashMap();

  ValueCallback<int>? _jumpToIndexCallback;
  ValueCallback<int>? _onIndexChangedCallback;
  ValueCallback<List<Toc>>? _onListChanged;

  void setTocList(List<Toc> list) {
    _index2toc.clear();
    for (final toc in list) {
      _index2toc[toc.widgetIndex] = toc;
    }
    _onListChanged?.call(list);
  }

  set jumpToIndexCallback(ValueCallback<int>? value) {
    _jumpToIndexCallback = value;
  }

  List<Toc> get tocList => List.unmodifiable(_index2toc.values);

  void dispose() {
    _index2toc.clear();
    _onIndexChangedCallback = null;
    _jumpToIndexCallback = null;
    _onListChanged = null;
  }

  void jumpToIndex(int index) {
    _jumpToIndexCallback?.call(index);
  }

  void onIndexChanged(int index) {
    _onIndexChangedCallback?.call(index);
  }
}

///config for toc
class Toc {
  ///the HeadingNode
  final HeadingNode node;

  ///index of [MarkdownGenerator]'s _children
  final int widgetIndex;

  ///index of [TocController.tocList]
  final int selfIndex;

  Toc({required this.node, this.widgetIndex = 0, this.selfIndex = 0});
}

const defaultTocTextStyle = TextStyle(fontSize: 16);
const defaultCurrentTocTextStyle = TextStyle(
  fontSize: 16,
  color: Color(0xFF31DA9F),
);

class TocWidget extends StatefulWidget {
  ///[controller] must not be null
  final TocController controller;

  ///set the desired scroll physics for the markdown item list
  final ScrollPhysics? physics;

  ///set shrinkWrap to obtained [ListView] (only available when [tocController] is null)
  final bool shrinkWrap;

  /// [ListView] padding
  final EdgeInsetsGeometry? padding;

  ///use [itemBuilder] to return a custom widget
  final TocItemBuilder? itemBuilder;

  /// use [tocTextStyle] to set the style of the toc item
  final TextStyle tocTextStyle;

  /// use [currentTocTextStyle] to set the style of the current toc item
  final TextStyle currentTocTextStyle;

  const TocWidget({
    super.key,
    required this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.itemBuilder,
    TextStyle? tocTextStyle,
    TextStyle? currentTocTextStyle,
  }) : tocTextStyle = tocTextStyle ?? defaultTocTextStyle,
       currentTocTextStyle = currentTocTextStyle ?? defaultCurrentTocTextStyle;

  @override
  State<TocWidget> createState() => _TocWidgetState();
}

class _TocWidgetState extends State<TocWidget> {
  final AutoScrollController controller = AutoScrollController();
  int currentIndex = 0;
  final List<Toc> _tocList = [];
  final List<Toc> _displayList = [];
  final Set<int> _expandedH3Indices = {};
  final Set<int> _autoExpandedH3Indices = {}; // 记录自动展开的3级标题

  TocController get tocController => widget.controller;

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    tocController._onListChanged = (list) {
      if (list.length < _tocList.length && currentIndex >= list.length) {
        currentIndex = list.length - 1;
      }
      _refreshList(list);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        refresh();
      });
    };
    tocController._onIndexChangedCallback = (index) {
      final selfIndex = tocController._index2toc[index]?.selfIndex;
      if (selfIndex != null && _tocList.length > selfIndex) {
        refreshIndex(selfIndex);
        controller.scrollToIndex(
          currentIndex,
          preferPosition: AutoScrollPosition.begin,
        );
      }
    };
    _refreshList(tocController.tocList);
    _buildDisplayList();
  }

  void _refreshList(List<Toc> list) {
    _tocList.clear();
    _tocList.addAll(List.unmodifiable(list));
    _buildDisplayList();
  }

  void _buildDisplayList() {
    _displayList.clear();

    for (int i = 0; i < _tocList.length; i++) {
      final toc = _tocList[i];
      final level = headingTag2Level[toc.node.headingConfig.tag] ?? 1;

      // 只显示1-4级标题，5级及以上的标题不显示
      if (level > 4) {
        continue;
      }

      // 显示1-2级标题
      if (level <= 2) {
        _displayList.add(toc);
      }
      // 3级标题：默认显示，但其4级子标题需要根据展开状态决定
      else if (level == 3) {
        _displayList.add(toc);
      }
      // 4级标题：只在其父3级标题展开时显示
      else if (level == 4) {
        // 找到这个4级标题的父3级标题
        int parentH3Index = -1;
        for (int j = i - 1; j >= 0; j--) {
          final parentLevel =
              headingTag2Level[_tocList[j].node.headingConfig.tag] ?? 1;
          if (parentLevel == 3) {
            parentH3Index = j;
            break;
          }
          // 如果遇到更高级的标题，停止查找
          if (parentLevel < 3) break;
        }

        // 如果找到父3级标题且该标题被展开，则显示这个4级标题
        if (parentH3Index != -1 && _expandedH3Indices.contains(parentH3Index)) {
          _displayList.add(toc);
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _tocList.clear();
    _displayList.clear();
    _expandedH3Indices.clear();
    _autoExpandedH3Indices.clear();
    tocController._onIndexChangedCallback = null;
    tocController._onListChanged = null;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      controller: controller,
      itemBuilder: (ctx, index) {
        final currentToc = _displayList[index];
        final originalIndex = _tocList.indexOf(currentToc);
        bool isCurrentToc = originalIndex == currentIndex;

        // 检查是否需要高亮父标题
        bool shouldHighlightParent = false;
        if (!isCurrentToc) {
          final currentSelectedToc =
              currentIndex < _tocList.length ? _tocList[currentIndex] : null;
          if (currentSelectedToc != null) {
            final currentLevel =
                headingTag2Level[currentSelectedToc.node.headingConfig.tag] ??
                1;
            final thisLevel =
                headingTag2Level[currentToc.node.headingConfig.tag] ?? 1;

            // 如果当前选中的是子标题，且这是其父标题，则高亮
            if (currentLevel > thisLevel) {
              // 查找当前选中项的所有父标题
              for (int i = currentIndex - 1; i >= 0; i--) {
                final parentLevel =
                    headingTag2Level[_tocList[i].node.headingConfig.tag] ?? 1;
                if (parentLevel < currentLevel && parentLevel == thisLevel) {
                  shouldHighlightParent = (i == originalIndex);
                  break;
                }
                // 如果遇到同级或更高级的标题，停止查找
                if (parentLevel <= thisLevel) break;
              }
            }
          }
        }

        final itemBuilder = widget.itemBuilder;
        if (itemBuilder != null) {
          final result = itemBuilder.call(
            TocItemBuilderData(index, currentToc, currentIndex, refreshIndex),
          );
          if (result != null) return result;
        }

        final shouldHighlight = isCurrentToc || shouldHighlightParent;
        final node = currentToc.node.copy(
          headingConfig: _TocHeadingConfig(
            shouldHighlight ? widget.currentTocTextStyle : widget.tocTextStyle,
            currentToc.node.headingConfig.tag,
          ),
        );

        final level = headingTag2Level[currentToc.node.headingConfig.tag] ?? 1;
        final isH3 = level == 3;
        final isH4 = level == 4;
        final isExpanded = _expandedH3Indices.contains(originalIndex);

        final child = ListTile(
          minTileHeight: 40,
          contentPadding: EdgeInsets.only(
            right: 10.0,
            left: 0,
            top: 0,
            bottom: 0,
          ),
          leading: isH3 ? null : null,
          title: Tooltip(
            message: node.build().toPlainText(),
            child: Container(
              margin: EdgeInsets.only(left: 10.0 * (level - 1)),
              child: Text(
                node.build().toPlainText(),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: widget.tocTextStyle.fontSize,
                  color:
                      shouldHighlight
                          ? widget.currentTocTextStyle.color
                          : widget.tocTextStyle.color,
                  fontWeight: widget.tocTextStyle.fontWeight,
                  fontStyle: widget.tocTextStyle.fontStyle,
                  decoration: widget.tocTextStyle.decoration,
                  decorationColor: widget.tocTextStyle.decorationColor,
                  decorationStyle: widget.tocTextStyle.decorationStyle,
                ),
                // style: node.headingConfig.style,
              ),
            ),
          ),
          onTap: () {
            final level =
                headingTag2Level[currentToc.node.headingConfig.tag] ?? 1;

            // 如果是3级标题，处理折叠/展开逻辑
            if (level == 3) {
              setState(() {
                if (_expandedH3Indices.contains(originalIndex)) {
                  _expandedH3Indices.remove(originalIndex);
                  _autoExpandedH3Indices.remove(
                    originalIndex,
                  ); // 手动收起时也要从自动展开列表中移除
                } else {
                  _expandedH3Indices.add(originalIndex);
                  // 手动展开的不加入自动展开列表，这样就不会被自动收起
                }
                _buildDisplayList();
              });
            }

            tocController.jumpToIndex(currentToc.widgetIndex);
            refreshIndex(originalIndex);
          },
        );

        // 为4级标题添加高度和透明度动画
        if (isH4) {
          return AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300),
              child: wrapByAutoScroll(index, child, controller),
            ),
          );
        }

        return wrapByAutoScroll(index, child, controller);
      },
      itemCount: _displayList.length,
      // padding: widget.padding,
    );
  }

  void refreshIndex(int index) {
    currentIndex = index;

    // 重新计算应该展开的3级标题
    _updateH3ExpansionBasedOnCurrentIndex();

    _buildDisplayList();
    refresh();
  }

  void _updateH3ExpansionBasedOnCurrentIndex() {
    // 清除所有自动展开的3级标题
    for (int autoExpandedIndex in _autoExpandedH3Indices) {
      _expandedH3Indices.remove(autoExpandedIndex);
    }
    _autoExpandedH3Indices.clear();

    // 根据当前高亮的索引决定哪个3级标题应该展开
    if (currentIndex < _tocList.length) {
      final selectedToc = _tocList[currentIndex];
      final selectedLevel =
          headingTag2Level[selectedToc.node.headingConfig.tag] ?? 1;

      if (selectedLevel == 3) {
        // 当前选中3级标题，展开它
        _expandedH3Indices.add(currentIndex);
        _autoExpandedH3Indices.add(currentIndex);
      } else if (selectedLevel == 4) {
        // 当前选中4级标题，找到并展开其父3级标题
        for (int i = currentIndex - 1; i >= 0; i--) {
          final parentLevel =
              headingTag2Level[_tocList[i].node.headingConfig.tag] ?? 1;
          if (parentLevel == 3) {
            _expandedH3Indices.add(i);
            _autoExpandedH3Indices.add(i);
            break;
          }
          if (parentLevel < 3) break;
        }
      }
      // 如果选中的是1级或2级标题，不自动展开任何3级标题
    }
  }
}

///use [TocItemBuilder] to return a custom widget
typedef TocItemBuilder = Widget? Function(TocItemBuilderData data);

///pass [TocItemBuilderData] to help build your own [TocItemBuilder]
class TocItemBuilderData {
  ///the index of item
  final int index;

  ///the toc data
  final Toc toc;

  ///current selected index of item
  final int currentIndex;

  ///use [refreshIndexCallback] to change [currentIndex]
  final ValueChanged<int> refreshIndexCallback;

  TocItemBuilderData(
    this.index,
    this.toc,
    this.currentIndex,
    this.refreshIndexCallback,
  );
}

///every heading tag has a special level
final headingTag2Level = <String, int>{
  'h1': 1,
  'h2': 2,
  'h3': 3,
  'h4': 4,
  'h5': 5,
  'h6': 6,
};

class _TocHeadingConfig extends HeadingConfig {
  @override
  final TextStyle style;
  @override
  final String tag;

  _TocHeadingConfig(this.style, this.tag);
}
