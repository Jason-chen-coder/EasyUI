part of 'easy_onscreen_keyboard.dart';

/// 用于创建文本表单字段小部件的构建器函数签名。
///
/// [controller]、[focusNode]、[keyboardType]、[maxLines]、[onChanged]
/// 和 [inputFormatters] 参数为方便起见而提供，应传递给构造的 [TextFormField]。
typedef OnscreenKeyboardTextFormFieldBuilderCallback =
    Widget Function(
      TextEditingController controller,
      FocusNode focusNode,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      int? maxLines,
      ValueChanged<String>? onChanged,
    );

/// A specialized [TextFormField] widget that integrates with
/// an [EasyOnscreenKeyboard].
///
/// This widget behaves like a regular Flutter [TextFormField], but
/// includes additional features to automatically attach and
/// interact with an onscreen keyboard widget.
///
/// ### Additional Features:
/// - Automatically opens the [EasyOnscreenKeyboard] when this field gains focus,
///   and closes it when it loses focus (if [enableOnscreenKeyboard] is true).
/// - Registers itself with the [EasyOnscreenKeyboardController] so key presses
///   are directly applied to this input.
/// - Provides optional [TextEditingController] and [FocusNode] management
///   if none are supplied.
/// - Visually highlights the field when it is the active
///   onscreen keyboard target.
///
/// ### Usage
/// ```dart
/// const EasyOnscreenKeyboardTextFormFieldBuilder(
///   decoration: InputDecoration(labelText: 'Enter Name'),
/// );
/// ```
///
/// ### Onscreen Keyboard Specific Options
///
/// - [enableOnscreenKeyboard]: If set to false, this widget
///   will function as a regular [TextFormField].
/// - [onscreenKeyboardMode]: Initial keyboard mode.
class EasyOnscreenKeyboardTextFormFieldBuilder extends StatefulWidget {
  /// Creates a new [EasyOnscreenKeyboardTextFormFieldBuilder] widget.
  const EasyOnscreenKeyboardTextFormFieldBuilder({
    super.key,
    this.enableOnscreenKeyboard = true,
    this.onscreenKeyboardMode,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.selectAllOnFocus,
    required this.builder,
  }) : assert(
         initialValue == null || controller == null,
         'Should not provide both an initialValue and a controller',
       );

  /// Enables or disables the automatic onscreen keyboard behavior.
  ///
  /// When true, focusing this field will attach it to the
  /// onscreen keyboard and open it.
  ///
  /// When true, the [keyboardType] will be ignored.
  ///
  /// If set to false, this widget will function as a regular [TextFormField].
  /// Defaults to `true`.
  final bool enableOnscreenKeyboard;

  /// Changes the [KeyboardMode] to the one specified on [onscreenKeyboardMode]
  /// when the [EasyOnscreenKeyboardTextFormFieldBuilder] is selected.
  ///
  /// If none is specified the keyboard will use the first mode
  /// specified on the layout mode list.
  final String? onscreenKeyboardMode;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// An optional value to initialize the form field to, or null otherwise.
  ///
  /// The `initialValue` affects the form field's state in two cases:
  /// 1. When the form field is first built, `initialValue` determines
  /// the field's initial state.
  /// 2. When [FormFieldState.reset] is called (either directly or by calling
  /// [FormFieldState.reset]), the form field is reset to this `initialValue`.
  final String? initialValue;

  /// Defines the keyboard focus for this widget.
  ///
  /// The [focusNode] is a long-lived object that's typically managed by a
  /// [StatefulWidget] parent. See [FocusNode] for more information.
  ///
  /// To give the keyboard focus to this widget, provide a [focusNode] and then
  /// use the current [FocusScope] to request the focus:
  ///
  /// ```dart
  /// FocusScope.of(context).requestFocus(myFocusNode);
  /// ```
  ///
  /// This happens automatically when the widget is tapped.
  ///
  /// To be notified when the widget gains or loses the focus, add a listener
  /// to the [focusNode]:
  ///
  /// ```dart
  /// myFocusNode.addListener(() { print(myFocusNode.hasFocus); });
  /// ```
  ///
  /// If null, this widget will create its own [FocusNode].
  ///
  /// ## Keyboard
  ///
  /// Requesting the focus will typically cause the keyboard to be shown
  /// if it's not showing already.
  ///
  /// On Android, the user can hide the keyboard - without changing the focus -
  /// with the system back button. They can restore the keyboard's visibility
  /// by tapping on a text field. The user might hide the keyboard and
  /// switch to a physical keyboard, or they might just need to get it
  /// out of the way for a moment, to expose something it's
  /// obscuring. In this case requesting the focus again will not
  /// cause the focus to change, and will not make the keyboard visible.
  ///
  /// This widget builds an [EditableText] and will ensure that the
  /// keyboard is showing when it is tapped by calling
  /// [EditableTextState.requestKeyboard()].
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.keyboardType}
  ///
  /// IMPORTANT: This will be ignored if [enableOnscreenKeyboard] is true.
  final TextInputType? keyboardType;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// Called when the user initiates a change to the TextField's
  /// value: when they have inserted or deleted text or reset the form.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// {@macro flutter.widgets.editableText.selectAllOnFocus}
  final bool? selectAllOnFocus;

  final OnscreenKeyboardTextFormFieldBuilderCallback builder;

  @override
  State<EasyOnscreenKeyboardTextFormFieldBuilder> createState() =>
      _OnscreenKeyboardTextFormFieldBuilderState();
}

class _OnscreenKeyboardTextFormFieldBuilderState
    extends State<EasyOnscreenKeyboardTextFormFieldBuilder>
    implements OnscreenKeyboardFieldState {
  /// The [TextEditingController] for the text field.
  TextEditingController get _effectiveController =>
      widget.controller ??
      (_controller ??= TextEditingController(text: widget.initialValue));
  TextEditingController? _controller;

  /// The [FocusNode] for the text field.
  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());
  FocusNode? _focusNode;

  /// The [EasyOnscreenKeyboardController] for the text field.
  late final EasyOnscreenKeyboardController _keyboard;
  bool _useSystemKeyboard = false;
  bool _switchingToSystemKeyboard = false;

  @override
  void initState() {
    super.initState();
    _keyboard = EasyOnscreenKeyboard.of(context);
    _effectiveFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _keyboard.detachTextField(this);
    _effectiveFocusNode.removeListener(_onFocusChanged);
    _focusNode?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    if (!widget.enableOnscreenKeyboard) return;
    if (_effectiveFocusNode.hasPrimaryFocus) {
      if (_useSystemKeyboard) {
        _keyboard.detachTextField(this);
        _keyboard.close();
        return;
      }

      final mode = _resolveKeyboardMode();

      _keyboard
        ..attachTextField(this)
        ..setModeNamed(mode)
        ..open();
    } else {
      if (_switchingToSystemKeyboard) return;
      if (_useSystemKeyboard) {
        setState(() => _useSystemKeyboard = false);
      }
      _keyboard.close();
    }
  }

  String _resolveKeyboardMode() {
    if (widget.onscreenKeyboardMode case final mode?) {
      return mode;
    }

    if (_isNumberKeyboardType(widget.keyboardType)) {
      return _resolveNumberModeName(widget.keyboardType);
    }

    return _keyboard.layout.modes.entries.first.key;
  }

  String _resolveNumberModeName(TextInputType? type) {
    final signed = type?.signed == true;
    final decimal = type?.decimal == true;

    final candidate = switch ((signed, decimal)) {
      (true, true) => 'number_signed_decimal',
      (true, false) => 'number_signed',
      (false, true) => 'number_decimal',
      (false, false) => 'number',
    };

    if (_keyboard.layout.modes.containsKey(candidate)) {
      return candidate;
    }

    return _keyboard.layout.modes.containsKey('number')
        ? 'number'
        : _keyboard.layout.modes.entries.first.key;
  }

  bool _isNumberKeyboardType(TextInputType? type) {
    if (type == null) return false;

    return type.index == TextInputType.number.index ||
        type == TextInputType.number ||
        type == const TextInputType.numberWithOptions() ||
        type == const TextInputType.numberWithOptions(decimal: true) ||
        type == const TextInputType.numberWithOptions(signed: true) ||
        type ==
            const TextInputType.numberWithOptions(decimal: true, signed: true);
  }

  @override
  void switchToSystemKeyboard() {
    if (!widget.enableOnscreenKeyboard || !mounted) return;

    final previousSelection = _effectiveController.selection;
    _switchingToSystemKeyboard = true;
    setState(() => _useSystemKeyboard = true);
    _keyboard.detachTextField(this);
    _keyboard.close();
    _effectiveFocusNode.unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _effectiveFocusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _switchingToSystemKeyboard = false;
        if (!mounted) return;
        if (_effectiveFocusNode.hasFocus) {
          SystemChannels.textInput.invokeMethod<void>('TextInput.show');
          if (widget.selectAllOnFocus == false) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted || !_effectiveFocusNode.hasFocus) return;
              _effectiveController.selection = _selectionForSystemKeyboard(
                previousSelection,
              );
            });
          }
        }
      });
    });
  }

  TextSelection _selectionForSystemKeyboard(TextSelection selection) {
    if (!selection.isValid) {
      return TextSelection.collapsed(offset: _effectiveController.text.length);
    }

    final textLength = _effectiveController.text.length;
    return TextSelection(
      baseOffset: selection.baseOffset.clamp(0, textLength),
      extentOffset: selection.extentOffset.clamp(0, textLength),
      affinity: selection.affinity,
      isDirectional: selection.isDirectional,
    );
  }

  @override
  TextEditingController get controller => _effectiveController;

  @override
  FocusNode get focusNode => _effectiveFocusNode;

  @override
  int? get maxLines => widget.maxLines;

  @override
  List<TextInputFormatter>? get inputFormatters => widget.inputFormatters;

  @override
  ValueChanged<String>? get onChanged => widget.onChanged;

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      _effectiveController,
      _effectiveFocusNode,
      // prevent the keyboard from opening
      widget.inputFormatters,
      widget.enableOnscreenKeyboard && !_useSystemKeyboard
          ? TextInputType.none
          : widget.keyboardType,
      widget.maxLines,
      widget.onChanged,
      // selectAllOnFocus: widget.selectAllOnFocus,
      // hintLocales: widget.hintLocales,
    );
  }
}
