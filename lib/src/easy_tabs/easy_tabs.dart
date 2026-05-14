import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/material.dart';

/// Tab position relative to content
enum EasyTabPosition {
  /// Tabs at the top, content below, indicator line at bottom
  top,

  /// Tabs at the bottom, content above, indicator line at top
  bottom,

  /// Tabs on the left, content on the right, tabs arranged vertically, indicator line on the right
  left,

  /// Tabs on the right, content on the left, tabs arranged vertically, indicator line on the left
  right,
}

/// Tab item data model for EasyTabs
class EasyTabItem {
  /// Display label for the tab button
  final String label;

  /// Value that uniquely identifies this tab
  final dynamic value;

  /// Optional content widget to display below the tabs when this tab is selected
  /// If null, nothing will be displayed below the tabs
  final Widget? content;

  EasyTabItem({required this.label, required this.value, this.content});
}

/// A customizable tabs widget with default styling
class EasyTabs extends StatefulWidget {
  /// List of tab items
  final List<EasyTabItem> tabs;

  /// Current selected tab value
  final dynamic value;

  /// Callback when tab selection changes
  /// Returns the selected tab's value
  final ValueChanged<dynamic>? onChange;

  /// Optional height for the tabs container (for top/bottom position)
  /// For left/right position, this becomes the width
  final double? height;

  /// Optional border decoration
  final BoxDecoration? decoration;

  /// Position of tabs relative to content
  /// Default is [EasyTabPosition.top]
  final EasyTabPosition tabPosition;

  /// Placeholder widget to display when a tab's content is null
  final Widget? placeholder;

  const EasyTabs({
    super.key,
    required this.tabs,
    required this.value,
    this.onChange,
    this.height,
    this.decoration,
    this.tabPosition = EasyTabPosition.top,
    this.placeholder,
  });

  @override
  State<EasyTabs> createState() => _EasyTabsState();
}

class _EasyTabsState extends State<EasyTabs>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    // Only create TabController for horizontal layouts (top/bottom)
    if (_isHorizontalLayout) {
      final currentIndex = widget.tabs.indexWhere(
        (tab) => tab.value == widget.value,
      );
      final initialIndex = currentIndex >= 0 ? currentIndex : 0;
      _tabController = TabController(
        length: widget.tabs.length,
        initialIndex: initialIndex,
        vsync: this,
      );
    }

    // Create PageController for vertical layouts (left/right) when all tabs have content
    if (_isVerticalLayout && _allTabsHaveContent) {
      final currentIndex = widget.tabs.indexWhere(
        (tab) => tab.value == widget.value,
      );
      final initialIndex = currentIndex >= 0 ? currentIndex : 0;
      _pageController = PageController(initialPage: initialIndex);
    }
  }

  bool get _isHorizontalLayout {
    return widget.tabPosition == EasyTabPosition.top ||
        widget.tabPosition == EasyTabPosition.bottom;
  }

  bool get _isVerticalLayout {
    return widget.tabPosition == EasyTabPosition.left ||
        widget.tabPosition == EasyTabPosition.right;
  }

  bool get _allTabsHaveContent {
    return widget.tabs.every((tab) => tab.content != null);
  }

  @override
  void didUpdateWidget(EasyTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isHorizontalLayout && _tabController != null) {
      if (oldWidget.value != widget.value) {
        final currentIndex = widget.tabs.indexWhere(
          (tab) => tab.value == widget.value,
        );
        if (currentIndex >= 0 && currentIndex != _tabController!.index) {
          _tabController!.animateTo(currentIndex);
        }
      }
    }

    // Update PageController for vertical layouts
    if (_isVerticalLayout && _pageController != null && _allTabsHaveContent) {
      if (oldWidget.value != widget.value) {
        final currentIndex = widget.tabs.indexWhere(
          (tab) => tab.value == widget.value,
        );
        if (currentIndex >= 0 &&
            currentIndex != _pageController!.page?.round()) {
          _pageController!.animateToPage(
            currentIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.tabPosition) {
      case EasyTabPosition.top:
        return _buildTopLayout(context);
      case EasyTabPosition.bottom:
        return _buildBottomLayout(context);
      case EasyTabPosition.left:
        return _buildLeftLayout(context);
      case EasyTabPosition.right:
        return _buildRightLayout(context);
    }
  }

  Widget _buildTopLayout(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Check if all tabs have content
    final allTabsHaveContent = widget.tabs.every((tab) => tab.content != null);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Build content widget
        Widget contentWidget;
        if (allTabsHaveContent) {
          // All tabs have content, render TabBarView
          // Check if height constraints are bounded
          if (constraints.maxHeight.isFinite) {
            // Use Expanded when height is bounded
            contentWidget = Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    widget.tabs
                        .map(
                          (tab) => KeyedSubtree(
                            key: ValueKey(tab.value),
                            child:
                                tab.content ??
                                widget.placeholder ??
                                EasyEmptyView(),
                          ),
                        )
                        .toList(),
              ),
            );
          } else {
            // Use SizedBox with a default height when height is unbounded
            contentWidget = SizedBox(
              height: 400, // Default height when unbounded
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children:
                    widget.tabs
                        .map(
                          (tab) => KeyedSubtree(
                            key: ValueKey(tab.value),
                            child:
                                tab.content ??
                                widget.placeholder ??
                                EasyEmptyView(),
                          ),
                        )
                        .toList(),
              ),
            );
          }
        } else {
          // Some tabs don't have content, render placeholder or current tab's content
          final currentTabIndex = widget.tabs.indexWhere(
            (tab) => tab.value == widget.value,
          );
          final currentTab =
              currentTabIndex >= 0 ? widget.tabs[currentTabIndex] : null;

          if (currentTab?.content != null) {
            // Wrap content in SizedBox to provide bounded width constraints
            contentWidget = SizedBox(
              width: double.infinity,
              child: currentTab!.content!,
            );
          } else {
            contentWidget = widget.placeholder ?? Container();
          }
        }

        return Column(
          mainAxisSize:
              allTabsHaveContent && constraints.maxHeight.isFinite
                  ? MainAxisSize.max
                  : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: widget.height ?? 50,
              decoration:
                  widget.decoration ??
                  BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                opaque: false,
                child: Material(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    labelColor: primaryColor,
                    unselectedLabelColor: EasyTheme.of(
                      context,
                    ).onBackground.withAlpha(0x8A),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2.0, color: primaryColor),
                    ),
                    tabs:
                        widget.tabs
                            .map(
                              (item) => Tab(
                                key: ValueKey(item.value),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(item.label),
                                ),
                              ),
                            )
                            .toList(),
                    onTap: (index) {
                      if (widget.onChange != null) {
                        final selectedTab = widget.tabs[index];
                        widget.onChange!(selectedTab.value);
                      }
                    },
                  ),
                ),
              ),
            ),
            contentWidget,
          ],
        );
      },
    );
  }

  Widget _buildBottomLayout(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // Check if all tabs have content
    final allTabsHaveContent = widget.tabs.every((tab) => tab.content != null);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Build content widget
        Widget contentWidget;
        if (allTabsHaveContent) {
          // All tabs have content, render TabBarView
          // Check if height constraints are bounded
          if (constraints.maxHeight.isFinite) {
            // Use Expanded when height is bounded
            contentWidget = Expanded(
              child: TabBarView(
                controller: _tabController,
                children:
                    widget.tabs
                        .map(
                          (tab) => KeyedSubtree(
                            key: ValueKey(tab.value),
                            child:
                                tab.content ??
                                widget.placeholder ??
                                Container(),
                          ),
                        )
                        .toList(),
              ),
            );
          } else {
            // Use SizedBox with a default height when height is unbounded
            contentWidget = SizedBox(
              height: 400, // Default height when unbounded
              width: double.infinity,
              child: TabBarView(
                controller: _tabController,
                children:
                    widget.tabs
                        .map(
                          (tab) => KeyedSubtree(
                            key: ValueKey(tab.value),
                            child:
                                tab.content ??
                                widget.placeholder ??
                                Container(),
                          ),
                        )
                        .toList(),
              ),
            );
          }
        } else {
          // Some tabs don't have content, render placeholder or current tab's content
          final currentTabIndex = widget.tabs.indexWhere(
            (tab) => tab.value == widget.value,
          );
          final currentTab =
              currentTabIndex >= 0 ? widget.tabs[currentTabIndex] : null;

          if (currentTab?.content != null) {
            // Wrap content in SizedBox to provide bounded width constraints
            contentWidget = SizedBox(
              width: double.infinity,
              child: currentTab!.content!,
            );
          } else {
            contentWidget = widget.placeholder ?? Container();
          }
        }

        return Column(
          mainAxisSize:
              allTabsHaveContent && constraints.maxHeight.isFinite
                  ? MainAxisSize.max
                  : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contentWidget,
            Container(
              height: widget.height ?? 50,
              decoration:
                  widget.decoration ??
                  BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                opaque: false,
                child: Material(
                  color: Colors.transparent,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    labelColor: primaryColor,
                    unselectedLabelColor: EasyTheme.of(
                      context,
                    ).onBackground.withAlpha(0x8A),
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    indicator: _TopLineTabIndicator(
                      borderSide: BorderSide(width: 2.0, color: primaryColor),
                    ),
                    tabs:
                        widget.tabs
                            .map(
                              (item) => Tab(
                                key: ValueKey(item.value),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(item.label),
                                ),
                              ),
                            )
                            .toList(),
                    onTap: (index) {
                      if (widget.onChange != null) {
                        final selectedTab = widget.tabs[index];
                        widget.onChange!(selectedTab.value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftLayout(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final currentTabIndex = widget.tabs.indexWhere(
      (tab) => tab.value == widget.value,
    );
    final selectedIndex = currentTabIndex >= 0 ? currentTabIndex : 0;

    // Calculate tab height (padding vertical 12*2 + text height ~20)
    const double tabHeight = 44.0;

    // Build content widget
    Widget contentWidget;
    if (_allTabsHaveContent && _pageController != null) {
      // All tabs have content, use PageView for smooth transitions
      contentWidget = Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (widget.onChange != null && index < widget.tabs.length) {
              widget.onChange!(widget.tabs[index].value);
            }
          },
          children:
              widget.tabs
                  .map(
                    (tab) => KeyedSubtree(
                      key: ValueKey(tab.value),
                      child:
                          tab.content ?? widget.placeholder ?? EasyEmptyView(),
                    ),
                  )
                  .toList(),
        ),
      );
    } else {
      // Some tabs don't have content, show current tab's content or placeholder
      final currentTab =
          currentTabIndex >= 0 ? widget.tabs[currentTabIndex] : null;
      if (currentTab?.content != null) {
        contentWidget = Expanded(child: currentTab!.content!);
      } else {
        contentWidget = Expanded(child: widget.placeholder ?? EasyEmptyView());
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: widget.height ?? 120,
          decoration:
              widget.decoration ??
              BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.tabs.map((item) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (widget.onChange != null) {
                                widget.onChange!(item.value);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: tabHeight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        item.value == widget.value
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                    color:
                                        item.value == widget.value
                                            ? primaryColor
                                            : EasyTheme.of(
                                              context,
                                            ).onBackground.withAlpha(0x8A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              // Animated indicator line
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                right: 0,
                top: selectedIndex * tabHeight,
                child: Container(
                  width: 2.0,
                  height: tabHeight,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
        contentWidget,
      ],
    );
  }

  Widget _buildRightLayout(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final currentTabIndex = widget.tabs.indexWhere(
      (tab) => tab.value == widget.value,
    );
    final selectedIndex = currentTabIndex >= 0 ? currentTabIndex : 0;

    // Calculate tab height (padding vertical 12*2 + text height ~20)
    const double tabHeight = 44.0;

    // Build content widget
    Widget contentWidget;
    if (_allTabsHaveContent && _pageController != null) {
      // All tabs have content, use PageView for smooth transitions
      contentWidget = Expanded(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            if (widget.onChange != null && index < widget.tabs.length) {
              widget.onChange!(widget.tabs[index].value);
            }
          },
          children:
              widget.tabs
                  .map(
                    (tab) => KeyedSubtree(
                      key: ValueKey(tab.value),
                      child:
                          tab.content ?? widget.placeholder ?? EasyEmptyView(),
                    ),
                  )
                  .toList(),
        ),
      );
    } else {
      // Some tabs don't have content, show current tab's content or placeholder
      final currentTab =
          currentTabIndex >= 0 ? widget.tabs[currentTabIndex] : null;
      if (currentTab?.content != null) {
        contentWidget = Expanded(child: currentTab!.content!);
      } else {
        contentWidget = Expanded(child: widget.placeholder ?? EasyEmptyView());
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        contentWidget,
        Container(
          width: widget.height ?? 120,
          decoration:
              widget.decoration ??
              BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    widget.tabs.map((item) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (widget.onChange != null) {
                                widget.onChange!(item.value);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              height: tabHeight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        item.value == widget.value
                                            ? FontWeight.w500
                                            : FontWeight.normal,
                                    color:
                                        item.value == widget.value
                                            ? primaryColor
                                            : EasyTheme.of(
                                              context,
                                            ).onBackground.withAlpha(0x8A),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              // Animated indicator line
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                left: 0,
                top: selectedIndex * tabHeight,
                child: Container(
                  width: 2.0,
                  height: tabHeight,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Custom tab indicator that draws a line at the top instead of bottom
class _TopLineTabIndicator extends Decoration {
  final BorderSide borderSide;

  const _TopLineTabIndicator({required this.borderSide});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TopLineTabIndicatorPainter(borderSide, onChanged);
  }
}

class _TopLineTabIndicatorPainter extends BoxPainter {
  final BorderSide borderSide;

  _TopLineTabIndicatorPainter(this.borderSide, [VoidCallback? onChanged])
    : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    final Paint paint = borderSide.toPaint();
    canvas.drawLine(rect.topLeft, rect.topRight, paint);
  }
}
