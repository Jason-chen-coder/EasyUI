import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../easy_theme.dart';
import '../easy_menu/easy_list_pop_menu.dart';
import '../easy_menu/easy_menu_style.dart';
import '../easy_menu/easy_menu_anchor.dart';
import 'easy_select_style.dart';

typedef EasySelectOptionsFetcher<T> =
    FutureOr<List<EasyListPopMenuOption<T>>> Function();

class EasySelect<T> extends StatefulWidget {
  const EasySelect({
    super.key,
    required this.optionsFetcher,
    this.multiple = false,
    this.initialValue,
    this.initialValues,
    this.onChanged,
    this.onChangedMultiple,
    this.placeholder,
    this.style,
    this.menuConstraintsBuilder,
    this.clearable = false,
    this.filterable = false,
    this.controller,
    this.searchHintText,
    this.easySelectStyle,
  });

  /// 只会在initState的时候触发一次
  /// 后续可以在错误界面点击重新加载按钮或者通过controller手动触发
  final EasySelectOptionsFetcher<T> optionsFetcher;
  final bool multiple;
  final T? initialValue;
  final Iterable<T>? initialValues;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<Iterable<T>>? onChangedMultiple;
  final String? placeholder;
  final EasyMenuStyle? style;
  final EasyListPopMenuConstraintsBuilder? menuConstraintsBuilder;
  final bool clearable;
  final bool filterable;
  final EasySelectController? controller;
  final String? searchHintText;
  final EasySelectStyle? easySelectStyle;

  @override
  State<EasySelect<T>> createState() => _EasySelectState<T>();
}

class _EasySelectState<T> extends State<EasySelect<T>> {
  T? _selectedValue;
  late Set<T> _selectedValues;
  bool _isHover = false;
  bool _willDispose = false;
  EasyListPopMenuOptionsState<T> _originOptionsState =
      EasyListPopMenuOptionsState<T>(loading: false, error: false, options: []);
  EasyListPopMenuOptionsState<T> _optionsState = EasyListPopMenuOptionsState<T>(
    loading: false,
    error: false,
    options: [],
  );
  final _focusNode = FocusNode();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _selectedValues = Set.of(widget.initialValues ?? const {});
    widget.controller?._attach(this);
    _loadOptions();
  }

  @override
  void didUpdateWidget(covariant EasySelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
    if (oldWidget.initialValues != widget.initialValues) {
      _selectedValues = Set.of(widget.initialValues ?? const {});
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(this);
      widget.controller?._attach(this);
    }
  }

  @override
  void dispose() {
    _willDispose = true;
    widget.controller?._detach(this);
    _focusNode.dispose();
    super.dispose();
  }

  List<EasyListPopMenuOption<T>> _filter(
    List<EasyListPopMenuOption<T>> options,
  ) {
    final upperCase = _searchKeyword.toUpperCase();
    final lowerCase = _searchKeyword.toLowerCase();
    return options.where((e) {
      switch (e) {
        case SimpleEasyListPopMenuOption<T>():
          return e.title.contains(upperCase) ||
              e.title.contains(lowerCase) ||
              e.title.contains(_searchKeyword);
        case UserEasyListPopMenuOption<T>():
          return e.title.contains(upperCase) ||
              e.title.contains(lowerCase) ||
              e.title.contains(_searchKeyword) ||
              e.email.contains(upperCase) ||
              e.email.contains(lowerCase) ||
              e.email.contains(_searchKeyword);
      }
    }).toList();
  }

  FutureOr<void> _loadOptions() {
    if (_optionsState.loading) {
      return null;
    }

    // 如果原本就有选项，不转到loading状态，fetcher拿到数据直接刷新选项列表
    if (_originOptionsState.options.isEmpty) {
      _originOptionsState = EasyListPopMenuOptionsState(
        loading: true,
        error: false,
        options: [],
      );
      _optionsState = _originOptionsState.copyWith();
      if (!_willDispose && context.mounted) {
        setState(() {});
      }
    }
    final result = widget.optionsFetcher.call();
    if (result is Future) {
      return (result as Future<List<EasyListPopMenuOption<T>>>)
          .then((options) {
            _originOptionsState = EasyListPopMenuOptionsState(
              loading: false,
              error: false,
              options: options,
            );
            _optionsState = EasyListPopMenuOptionsState(
              loading: false,
              error: false,
              options: _filter(options),
            );
          })
          .catchError((_) {
            _originOptionsState = EasyListPopMenuOptionsState(
              loading: false,
              error: true,
              options: [],
            );
            _optionsState = _originOptionsState.copyWith();
          })
          .whenComplete(() {
            if (!_willDispose && context.mounted) {
              setState(() {});
            }
          });
    } else {
      _originOptionsState = EasyListPopMenuOptionsState(
        loading: false,
        error: false,
        options: result,
      );
      _optionsState = EasyListPopMenuOptionsState(
        loading: false,
        error: false,
        options: _filter(result),
      );
      if (!_willDispose && context.mounted) {
        setState(() {});
      }
    }
  }

  void _onSearchKeywordChanged(String keyword) {
    if (_optionsState.loading) {
      return;
    }
    _searchKeyword = keyword;
    setState(() {
      _optionsState = _optionsState.copyWith(
        options: _filter(_originOptionsState.options),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    final easySelectStyle = (widget.easySelectStyle ?? EasySelectStyle()).merge(
      theme.easySelectStyle,
    );

    trigger(EasyMenuController controller) {
      return InkWell(
        focusNode: _focusNode,
        onTap: () {
          if (controller.isOpen) {
            controller.close();
          } else {
            if (!_optionsState.loading) {
              setState(() {
                _optionsState = _originOptionsState.copyWith();
              });
            }
            controller.open();
          }
        },
        borderRadius: BorderRadius.all(EasyTheme.of(context).cornerSmall),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHover = true),
          onExit: (_) => setState(() => _isHover = false),
          child: Container(
            constraints: easySelectStyle.triggerConstraints,
            padding: easySelectStyle.triggerContentPadding,
            decoration: BoxDecoration(
              color: theme.background,
              borderRadius: BorderRadius.all(theme.cornerSmall),
              border: Border.all(
                color: easySelectStyle.triggerBorderColor ?? Colors.transparent,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 当 filterable 为 true 时，根据状态切换输入框/展示UI
                Expanded(
                  child: _buildDisplay(
                    context,
                    controller.isOpen,
                    easySelectStyle,
                  ),
                ),
                if (widget.clearable && _hasSelection && _isHover)
                  InkWell(
                    onTap: () => handelClear(),
                    borderRadius: BorderRadius.circular(10),
                    child: Icon(Icons.close, size: 16, color: theme.neutral99),
                  )
                else
                  Icon(
                    controller.isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 16,
                    color: theme.neutral99,
                  ),
              ],
            ),
          ),
        ),
      );
    }

    if (!widget.multiple) {
      return EasySingleCheckListTilePopMenu<T>(
        style: widget.style,
        optionsState: _optionsState,
        reloadOptions: _loadOptions,
        initialSelected: _selectedValue,
        onValueChanged: (val) {
          setState(() {
            _selectedValue = val;
          });
          widget.onChanged?.call(val);
        },
        builder: (context, controller, child) {
          return trigger(controller);
        },
        menuConstraintsBuilder: widget.menuConstraintsBuilder,
        searchWidget:
            widget.filterable
                ? _EasySelectSearchBar(
                  onSearchWordChanged: _onSearchKeywordChanged,
                  hintText: widget.searchHintText,
                )
                : null,
        onOpen: _focusNode.requestFocus,
        onClose: _focusNode.unfocus,
      );
    }

    return EasyMultiCheckBoxListPopMenu<T>(
      style:
          widget.style ??
          EasyMenuStyle(
            boxShadows: [],
            boxBorder: Border.all(color: theme.neutralEE),
          ),
      optionsState: _optionsState,
      reloadOptions: _loadOptions,
      initialSelected: _selectedValues,
      onValueChanged: (vals) {
        setState(() {
          _selectedValues = Set.of(vals);
        });
        widget.onChangedMultiple?.call(_selectedValues);
      },
      builder: (context, controller, child) {
        return trigger(controller);
      },
      menuConstraintsBuilder: widget.menuConstraintsBuilder,
      searchWidget:
          widget.filterable
              ? _EasySelectSearchBar(
                onSearchWordChanged: _onSearchKeywordChanged,
                hintText: widget.searchHintText,
              )
              : null,
      onOpen: _focusNode.requestFocus,
      onClose: _focusNode.unfocus,
    );
  }

  void handelClear() {
    if (_selectedValue != null) {
      setState(() => _selectedValue = null);
      widget.onChanged?.call(null);
    }
    if (_selectedValues.isNotEmpty) {
      setState(() => _selectedValues = {});
      widget.onChangedMultiple?.call([]);
    }
  }

  Widget _buildDisplay(
    BuildContext context,
    bool menuIsOpen,
    EasySelectStyle easySelectStyle,
  ) {
    final theme = EasyTheme.of(context);
    final placeholder = widget.placeholder ?? '';

    if (!widget.multiple) {
      bool usePlaceholder = true;
      String title = placeholder;
      for (var o in _originOptionsState.options) {
        if (o.value == _selectedValue) {
          title = o.title;
          usePlaceholder = false;
          break;
        }
      }

      return Text(
        title,
        style:
            usePlaceholder
                ? easySelectStyle.placeholderTextStyle
                : easySelectStyle.displayTextStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    if (_selectedValues.isEmpty) {
      return Text(
        placeholder,
        style: easySelectStyle.placeholderTextStyle,
        overflow: TextOverflow.ellipsis,
      );
    }

    final selectedOptions = <EasyListPopMenuOption<T>>[];
    for (var value in _selectedValues) {
      final index = _originOptionsState.options.indexWhere(
        (e) => e.value == value,
      );
      if (!index.isNegative) {
        final option = _originOptionsState.options.elementAtOrNull(index);
        if (option != null) {
          selectedOptions.add(option);
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                selectedOptions.map((e) {
                  return _Tag(
                    label: e.title,
                    onDeleteTap:
                        menuIsOpen
                            ? () {
                              final preValues = Set.of(_selectedValues);
                              setState(() {
                                _selectedValues = preValues..remove(e.value);
                              });
                              widget.onChangedMultiple?.call(_selectedValues);
                            }
                            : null,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  bool get _hasSelection {
    if (!widget.multiple) {
      return _selectedValue != null;
    }
    return _selectedValues.isNotEmpty;
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.onDeleteTap});

  final String label;
  final VoidCallback? onDeleteTap;

  @override
  Widget build(BuildContext context) {
    final theme = EasyTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.neutralEE,
        borderRadius: BorderRadius.all(theme.cornerSmall),
        border: Border.all(color: theme.neutralEE),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: theme.neutral66, height: 1),
          ),
          if (onDeleteTap != null)
            InkWell(
              onTap: onDeleteTap,
              child: Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.close, size: 12, color: theme.neutral66),
              ),
            ),
        ],
      ),
    );
  }
}

class EasySelectController {
  _EasySelectState? _state;

  bool get isAttached => _state != null;

  void _attach(_EasySelectState state) {
    assert(_state == null);
    _state = state;
  }

  void _detach(_EasySelectState state) {
    assert(_state == state);
    _state = null;
  }

  /// 刷新选项
  FutureOr<void> refreshOptions() async {
    assert(_state != null);
    return _state!._loadOptions();
  }

  void clearSelect() {
    assert(_state != null);
    _state!.handelClear();
  }
}

class _EasySelectSearchBar extends StatefulWidget {
  const _EasySelectSearchBar({
    required this.onSearchWordChanged,
    this.hintText,
  });

  final ValueChanged<String> onSearchWordChanged;
  final String? hintText;

  @override
  State<_EasySelectSearchBar> createState() => _EasySelectSearchBarState();
}

class _EasySelectSearchBarState extends State<_EasySelectSearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final easyTheme = EasyTheme.of(context);
    return TextField(
      controller: _controller,
      onChanged: widget.onSearchWordChanged,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: easyTheme.neutralEE),
        ),
        isDense: true,
        prefixIcon: Container(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: SvgPicture.asset(
            'assets/svgs/ic_search.svg',
            package: 'easy_ui',
            colorFilter: ColorFilter.mode(easyTheme.neutral99, BlendMode.srcIn),
            width: 16,
            height: 16,
          ),
        ),
        prefixIconConstraints: BoxConstraints.tightFor(width: 56),
        suffixIcon: ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, value, _) {
            if (value.text.isEmpty) {
              return const SizedBox();
            }
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: InkWell(
                onTap: () {
                  _controller.clear();
                  widget.onSearchWordChanged('');
                },
                customBorder: CircleBorder(),
                child: Icon(Icons.close, size: 16, color: easyTheme.neutral99),
              ),
            );
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: EdgeInsets.symmetric(vertical: 16),
        hintText: widget.hintText,
        hintStyle: TextStyle(fontSize: 16, color: easyTheme.neutral99),
      ),
    );
  }
}
