import 'dart:ui';

import 'package:flutter/material.dart';

class TableWrapper extends StatelessWidget {
  final ScrollController scrollController;
  final Widget table;
  const TableWrapper(this.scrollController, {super.key, required this.table});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          cursor: SystemMouseCursors.basic,
          child: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: true,
                dragDevices: {PointerDeviceKind.touch},
              ),
              child: _AutoPaddingHorizontalScroll(
                controller: scrollController,
                child: table,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 根据内容宽度是否可滚动，动态决定是否添加padding
class _AutoPaddingHorizontalScroll extends StatefulWidget {
  final ScrollController controller;
  final Widget child;
  const _AutoPaddingHorizontalScroll({
    required this.controller,
    required this.child,
  });

  @override
  State<_AutoPaddingHorizontalScroll> createState() =>
      _AutoPaddingHorizontalScrollState();
}

class _AutoPaddingHorizontalScrollState
    extends State<_AutoPaddingHorizontalScroll> {
  bool _showScrollbar = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateScrollbar);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollbar());
  }

  void _updateScrollbar() {
    final needScrollbar =
        widget.controller.hasClients &&
        widget.controller.position.maxScrollExtent > 0;
    if (_showScrollbar != needScrollbar) {
      setState(() {
        _showScrollbar = needScrollbar;
      });
    }
  }

  @override
  void didUpdateWidget(_AutoPaddingHorizontalScroll oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollbar());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateScrollbar);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      padding:
          _showScrollbar ? const EdgeInsets.only(bottom: 16) : EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      child: widget.child,
    );
  }
}
