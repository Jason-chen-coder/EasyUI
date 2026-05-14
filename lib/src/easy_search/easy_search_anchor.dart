import 'dart:async';

import 'package:flutter/material.dart';

typedef EasySearchAnchorBuilder =
    Widget Function(
      BuildContext context,
      EasySearchController searchController,
      Object tapRegionGroupId,
    );

typedef EasySearchSuggestionsBuilder =
    Future<Iterable<Widget>> Function(
      BuildContext context,
      EasySearchController searchController,
    );

class EasySearchAnchor extends StatefulWidget {
  const EasySearchAnchor({
    super.key,
    required this.builder,
    required this.viewBuilder,
    required this.suggestionsBuilder,
    this.viewConstraints,
  });

  final EasySearchAnchorBuilder builder;
  final Widget Function(Iterable<Widget> suggestions) viewBuilder;
  final EasySearchSuggestionsBuilder suggestionsBuilder;
  final BoxConstraints? viewConstraints;

  @override
  State<EasySearchAnchor> createState() => _EasySearchAnchorState();
}

class _EasySearchAnchorState extends State<EasySearchAnchor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;
  final _searchController = EasySearchController();
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _searchController._attach(this);
    _animationController = AnimationController(
      vsync: this,
      duration: Durations.medium2,
    );
    _sizeAnimation = Tween(begin: .0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController._detach(this);
    _overlayEntry?.remove();
    _overlayEntry = null;
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  bool get _isOpen => _overlayEntry != null;

  void _openSearchView() {
    if (_overlayEntry != null) {
      _animationController.forward();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final anchorContext = _key.currentContext!;
        final RenderBox overlay =
            Overlay.of(anchorContext).context.findRenderObject()! as RenderBox;
        final anchorBox = anchorContext.findRenderObject() as RenderBox;
        final upperLeft = anchorBox.localToGlobal(
          Offset.zero,
          ancestor: overlay,
        );
        final bottomRight = anchorBox.localToGlobal(
          anchorBox.size.bottomRight(Offset.zero),
          ancestor: overlay,
        );
        final anchorRect = Rect.fromPoints(upperLeft, bottomRight);
        final overlaySize = overlay.size;

        final leftSpace = anchorRect.left;
        final rightSpace = overlaySize.width - leftSpace - anchorRect.width;
        final topSpace = anchorRect.top - 2;
        final bottomSpace = overlaySize.height - anchorRect.bottom - 2;

        double? left;
        double? right;
        double? top;
        double maxHeight = double.infinity;
        double maxWidth = double.infinity;

        if (leftSpace > rightSpace) {
          right = overlaySize.width - anchorRect.right;
          maxWidth = overlaySize.width - right;
        } else {
          left = anchorRect.left;
          maxWidth = overlaySize.width - left;
        }

        if (bottomSpace < topSpace &&
            widget.viewConstraints != null &&
            bottomSpace < widget.viewConstraints!.minHeight) {
          top = anchorRect.top - anchorRect.height - 2;
          maxHeight = anchorRect.top - 2;
        } else {
          top = anchorRect.bottom + 2;
          maxHeight = overlaySize.height - anchorRect.bottom - 2;
        }

        var constraints = BoxConstraints(
          minWidth: anchorRect.width,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
        if (widget.viewConstraints != null) {
          constraints = widget.viewConstraints!.enforce(constraints);
        }

        return Positioned(
          left: left,
          right: right,
          top: top,
          child: TapRegion(
            groupId: _key,
            onTapOutside: (event) {
              _closeSearchView();
            },
            child: Container(
              constraints: constraints,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x401484FC),
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Material(
                color: Colors.transparent,
                child: SizeTransition(
                  sizeFactor: _sizeAnimation,
                  axisAlignment: -1.0,
                  child: _EasySearchView(
                    suggestionsBuilder: widget.suggestionsBuilder,
                    searchController: _searchController,
                    viewBuilder: widget.viewBuilder,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  void _closeSearchView() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      key: _key,
      builder: (context) => widget.builder(context, _searchController, _key),
    );
  }
}

class EasySearchController extends TextEditingController {
  _EasySearchAnchorState? _anchor;

  bool get isOpen {
    assert(_anchor != null);
    return _anchor!._isOpen;
  }

  bool get isAttached => _anchor != null;

  void open() {
    assert(isAttached);
    _anchor!._openSearchView();
  }

  void close() {
    assert(isAttached);
    _anchor!._closeSearchView();
  }

  void _attach(_EasySearchAnchorState anchor) {
    assert(_anchor == null);
    _anchor = anchor;
  }

  void _detach(_EasySearchAnchorState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}

class _EasySearchView extends StatefulWidget {
  const _EasySearchView({
    required this.suggestionsBuilder,
    required this.searchController,
    required this.viewBuilder,
  });

  final EasySearchController searchController;
  final Widget Function(Iterable<Widget> suggestions) viewBuilder;
  final EasySearchSuggestionsBuilder suggestionsBuilder;

  @override
  State<_EasySearchView> createState() => _EasySearchViewState();
}

class _EasySearchViewState extends State<_EasySearchView> {
  static const _searchDuration = Duration(milliseconds: 400);

  Iterable<Widget>? _lastSuggestions;

  Timer? _searchTimer;

  final List<Future> _searchFutures = [];

  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _lastSuggestions = [];
    widget.searchController.addListener(_onSearchTextChanged);
    _searchText = widget.searchController.text;
    _search();
  }

  void _onSearchTextChanged() {
    if (widget.searchController.text == _searchText) {
      return;
    }

    _searchText = widget.searchController.text;
    _searchTimer?.cancel();
    _searchTimer = Timer(_searchDuration, _search);
  }

  void _search() {
    final future = widget.suggestionsBuilder(context, widget.searchController);
    _searchFutures.add(future);
    future
        .then((value) {
          _searchFutures.remove(future);
          if (_searchFutures.isEmpty && context.mounted) {
            setState(() {
              _lastSuggestions = value;
            });
          }
        })
        .onError((error, stackTrace) {
          _searchFutures.remove(future);
        });
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchTextChanged);
    _searchTimer?.cancel();
    _searchTimer = null;
    _searchFutures.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.viewBuilder(_lastSuggestions ?? []);
  }
}
