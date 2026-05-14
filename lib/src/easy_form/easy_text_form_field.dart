// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../easy_theme.dart';
import 'easy_text_form_field_decoration_layout_delegate.dart';

export 'package:flutter/services.dart' show SmartDashesType, SmartQuotesType;

/// A [FormField] that contains a [TextField].
///
/// This is a convenience widget that wraps a [TextField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] allows one to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a `GlobalKey<FormFieldState>` (see [GlobalKey]) to the constructor and use
/// [GlobalKey.currentState] to save or reset the form field.
///
/// When a [controller] is specified, its [TextEditingController.text]
/// defines the [initialValue]. If this [FormField] is part of a scrolling
/// container that lazily constructs its children, like a [ListView] or a
/// [CustomScrollView], then a [controller] should be specified.
/// The controller's lifetime should be managed by a stateful widget ancestor
/// of the scrolling container.
///
/// If a [controller] is not specified, [initialValue] can be used to give
/// the automatically generated controller an initial value.
///
/// {@macro flutter.material.textfield.wantKeepAlive}
///
/// Remember to call [TextEditingController.dispose] of the [TextEditingController]
/// when it is no longer needed. This will ensure any resources used by the object
/// are discarded.
///
/// By default, `decoration` will apply the [ThemeData.inputDecorationTheme] for
/// the current context to the [InputDecoration], see
/// [InputDecoration.applyDefaults].
///
/// For a documentation about the various parameters, see [TextField].
///
/// {@tool snippet}
///
/// Creates a [EasyTextFormField] with an [InputDecoration] and validator function.
///
/// ![If the user enters valid text, the TextField appears normally without any warnings to the user](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field.png)
///
/// ![If the user enters invalid text, the error message returned from the validator function is displayed in dark red underneath the input](https://flutter.github.io/assets-for-api-docs/assets/material/text_form_field_error.png)
///
/// ```dart
/// TextFormField(
///   decoration: const InputDecoration(
///     icon: Icon(Icons.person),
///     hintText: 'What do people call you?',
///     labelText: 'Name *',
///   ),
///   onSaved: (String? value) {
///     // This optional block of code can be used to run
///     // code when the user saves the form.
///   },
///   validator: (String? value) {
///     return (value != null && value.contains('@')) ? 'Do not use the @ char.' : null;
///   },
/// )
/// ```
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to move the focus to the next field when the user
/// presses the SPACE key.
///
/// ** See code in examples/api/lib/material/text_form_field/text_form_field.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to force an error text to the field after making
/// an asynchronous call.
///
/// ** See code in examples/api/lib/material/text_form_field/text_form_field.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/text-fields.html>
///  * [TextField], which is the underlying text field without the [Form]
///    integration.
///  * [InputDecorator], which shows the labels and other visual elements that
///    surround the actual text editing widget.
///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://docs.flutter.dev/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
class EasyTextFormField extends FormField<String> {
  /// Creates a [FormField] that contains a [TextField].
  ///
  /// When a [controller] is specified, [initialValue] must be null (the
  /// default). If [controller] is null, then a [TextEditingController]
  /// will be constructed automatically and its `text` will be initialized
  /// to [initialValue] or the empty string.
  ///
  /// For documentation about the various parameters, see the [TextField] class
  /// and [TextField.new], the constructor.
  EasyTextFormField({
    super.key,
    this.groupId = EditableText,
    this.controller,
    // AddBy: cyl.是否显示必填星号*
    bool showRequiredMark = false,
    // AddBy cyl.是否使用自定义的label,counter,helper,error布局方式
    // 值未null时使用TextField自带的布局方式
    EasyTextFormFieldDecorationLayoutDelegate? decorationLayoutDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    String? initialValue,
    FocusNode? focusNode,
    super.forceErrorText,
    InputDecoration? decoration,
    this.fillColor,
    this.placeholder,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction? textInputAction,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextAlign textAlign = TextAlign.start,
    TextAlignVertical? textAlignVertical,
    bool autofocus = false,
    bool readOnly = false,
    @Deprecated(
      'Use `contextMenuBuilder` instead. '
      'This feature was deprecated after v3.3.0-0.5.pre.',
    )
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLines = 1,
    int? minLines,
    bool expands = false,
    int? maxLength,
    this.onChanged,
    GestureTapCallback? onTap,
    bool onTapAlwaysCalled = false,
    TapRegionCallback? onTapOutside,
    TapRegionUpCallback? onTapUpOutside,
    VoidCallback? onEditingComplete,
    ValueChanged<String>? onFieldSubmitted,
    super.onSaved,
    super.validator,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    bool? ignorePointers,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Color? cursorErrorColor,
    Brightness? keyboardAppearance,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool? enableInteractiveSelection,
    TextSelectionControls? selectionControls,
    InputCounterWidgetBuilder? buildCounter,
    ScrollPhysics? scrollPhysics,
    Iterable<String>? autofillHints,
    AutovalidateMode? autovalidateMode,
    ScrollController? scrollController,
    super.restorationId,
    bool enableIMEPersonalizedLearning = true,
    MouseCursor? mouseCursor,
    EditableTextContextMenuBuilder? contextMenuBuilder =
        _defaultContextMenuBuilder,
    SpellCheckConfiguration? spellCheckConfiguration,
    TextMagnifierConfiguration? magnifierConfiguration,
    UndoHistoryController? undoController,
    AppPrivateCommandCallback? onAppPrivateCommand,
    bool? cursorOpacityAnimates,
    ui.BoxHeightStyle selectionHeightStyle = ui.BoxHeightStyle.tight,
    ui.BoxWidthStyle selectionWidthStyle = ui.BoxWidthStyle.tight,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    WidgetStatesController? statesController,
    Clip clipBehavior = Clip.hardEdge,
    @Deprecated(
      'Use `stylusHandwritingEnabled` instead. '
      'This feature was deprecated after v3.27.0-0.2.pre.',
    )
    bool scribbleEnabled = true,
    bool stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    bool canRequestFocus = true,
    double? height,
  }) : assert(initialValue == null || controller == null),
       assert(obscuringCharacter.length == 1),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         (maxLines == null) || (minLines == null) || (maxLines >= minLines),
         "minLines can't be greater than maxLines",
       ),
       assert(
         !expands || (maxLines == null && minLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(
         !obscureText || maxLines == 1,
         'Obscured fields cannot be multiline.',
       ),
       assert(
         maxLength == null ||
             maxLength == TextField.noMaxLength ||
             maxLength > 0,
       ),
       super(
         initialValue:
             controller != null ? controller.text : (initialValue ?? ''),
         enabled: enabled ?? decoration?.enabled ?? true,
         autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
         builder: (FormFieldState<String> field) {
           final _TextFormFieldState state = field as _TextFormFieldState;
           // AddBy: cyl
           // 使用自定义的InputDecoration
           final easyTheme = EasyTheme.of(field.context);
           var effectiveDecoration = (decoration ?? const InputDecoration())
               .applyDefaults(easyTheme.easyTextFormFieldInputDecorationTheme)
               .copyWith(
                 filled: true,
                 fillColor:
                     state._textFormField.fillColor ??
                     decoration?.fillColor ??
                     Colors.transparent,
                 hintText:
                     decoration?.hintText ?? state._textFormField.placeholder,
               );
           // Show a clear (X) suffix icon when enabled, not read-only, has value, and no custom suffixIcon is provided.
           final bool isEnabled = enabled ?? decoration?.enabled ?? true;
           final bool canClear =
               isEnabled &&
               !readOnly &&
               state._effectiveController.text.isNotEmpty &&
               (effectiveDecoration.suffixIcon == null &&
                   effectiveDecoration.suffix == null &&
                   effectiveDecoration.suffixText == null);
           if (canClear) {
             effectiveDecoration = effectiveDecoration.copyWith(
               suffixIcon: Padding(
                 padding: const EdgeInsets.only(right: 5),
                 child: Builder(
                   builder:
                       (context) => IconButton(
                         icon: Icon(
                           Icons.close,
                           color: Color(0xFF666666),
                           size: 18,
                         ),
                         onPressed: () {
                           state._effectiveController.clear();
                           field.didChange('');
                           onChanged?.call('');
                           // Refocus the current input after clearing
                           if (focusNode != null) {
                             focusNode.requestFocus();
                           }
                         },
                       ),
                 ),
               ),
             );
           }
           void onChangedHandler(String value) {
             field.didChange(value);
             onChanged?.call(value);
           }

           // AddBy: cyl
           // 当decorationDelegate不为null时
           // 不再使用TextField自带的error显示方式
           // 不再使用TextField自带的label显示方式
           // 不再使用TextField自带的counter显示方式
           // 不再使用TextField自带的helper显示方式
           var textFiledDecoration = effectiveDecoration;
           if (decorationLayoutDelegate != null) {
             textFiledDecoration = effectiveDecoration.replaceCopy(
               // 通过设置error不为null使输入框显示错误Border
               error:
                   (field.hasError ||
                           textFiledDecoration.errorText != null ||
                           textFiledDecoration.error != null)
                       ? const SizedBox()
                       : null,
               errorText: null,
               label: null,
               labelText: null,
               counter: const SizedBox(),
               counterText: null,
               helperText: null,
               helper: null,
             );
           }

           Widget textField = TextField(
             groupId: groupId,
             restorationId: restorationId,
             controller: state._effectiveController,
             focusNode: focusNode,
             decoration: textFiledDecoration,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             // AddBy: cyl.默认textStyle
             style:
                 style ??
                 TextStyle(
                   fontSize: 16,
                   color:
                       enabled == false
                           ? easyTheme.neutral99
                           : easyTheme.neutral66,
                 ),
             strutStyle: strutStyle,
             textAlign: textAlign,
             textAlignVertical: textAlignVertical,
             textDirection: textDirection,
             textCapitalization: textCapitalization,
             autofocus: autofocus,
             statesController: statesController,
             toolbarOptions: toolbarOptions,
             readOnly: readOnly,
             showCursor: showCursor,
             obscuringCharacter: obscuringCharacter,
             obscureText: obscureText,
             autocorrect: autocorrect,
             smartDashesType:
                 smartDashesType ??
                 (obscureText
                     ? SmartDashesType.disabled
                     : SmartDashesType.enabled),
             smartQuotesType:
                 smartQuotesType ??
                 (obscureText
                     ? SmartQuotesType.disabled
                     : SmartQuotesType.enabled),
             enableSuggestions: enableSuggestions,
             maxLengthEnforcement: maxLengthEnforcement,
             maxLines: maxLines,
             minLines: minLines,
             expands: expands,
             maxLength: maxLength,
             onChanged: onChangedHandler,
             onTap: onTap,
             onTapAlwaysCalled: onTapAlwaysCalled,
             onTapOutside: onTapOutside,
             onTapUpOutside: onTapUpOutside,
             onEditingComplete: onEditingComplete,
             onSubmitted: onFieldSubmitted,
             inputFormatters: inputFormatters,
             enabled: enabled ?? decoration?.enabled ?? true,
             ignorePointers: ignorePointers,
             cursorWidth: cursorWidth,
             cursorHeight: cursorHeight,
             cursorRadius: cursorRadius,
             cursorColor: cursorColor,
             // AddBy: cyl.默认使用warning颜色
             cursorErrorColor: cursorErrorColor ?? easyTheme.warning,
             scrollPadding: scrollPadding,
             scrollPhysics: scrollPhysics,
             keyboardAppearance: keyboardAppearance,
             enableInteractiveSelection:
                 enableInteractiveSelection ?? (!obscureText || !readOnly),
             selectionControls: selectionControls,
             buildCounter: buildCounter,
             autofillHints: autofillHints,
             scrollController: scrollController,
             enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
             mouseCursor: mouseCursor,
             contextMenuBuilder: contextMenuBuilder,
             spellCheckConfiguration: spellCheckConfiguration,
             magnifierConfiguration: magnifierConfiguration,
             undoController: undoController,
             onAppPrivateCommand: onAppPrivateCommand,
             cursorOpacityAnimates: cursorOpacityAnimates,
             selectionHeightStyle: selectionHeightStyle,
             selectionWidthStyle: selectionWidthStyle,
             dragStartBehavior: dragStartBehavior,
             contentInsertionConfiguration: contentInsertionConfiguration,
             clipBehavior: clipBehavior,
             scribbleEnabled: scribbleEnabled,
             stylusHandwritingEnabled: stylusHandwritingEnabled,
             canRequestFocus: canRequestFocus,
           );

           if (height != null) {
             textField = SizedBox(height: height, child: textField);
           }

           if (decorationLayoutDelegate != null) {
             textField = decorationLayoutDelegate.buildDecoration(
               field.context,
               decoration: effectiveDecoration,
               filedHasError: field.hasError,
               fieldErrorText: field.errorText,
               maxLength: maxLength,
               textField: textField,
               controller: state._effectiveController,
               showRequiredMark: showRequiredMark,
             );
           }

           return UnmanagedRestorationScope(
             bucket: field.bucket,
             child: textField,
           );
         },
       );

  factory EasyTextFormField.password({
    TextEditingController? controller,
    InputDecoration? decoration,
    bool showRequireMark = false,
    bool obscureText = false,
    bool enabled = true,
    List<TextInputFormatter>? inputFormatters,
    VoidCallback? onObscureTap,
  }) {
    return EasyTextFormField(
      controller: controller,
      decoration: (decoration ?? InputDecoration()).copyWith(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: obscureText ? Color(0xFF999999) : Color(0xFF666666),
            ),
            onPressed: onObscureTap,
          ),
        ),
      ),
      showRequiredMark: showRequireMark,
      obscureText: obscureText,
      enabled: enabled,
      inputFormatters: inputFormatters,
    );
  }

  factory EasyTextFormField.dropdownMenu({
    required bool menuOpen,
    required VoidCallback? onTap,
    TextStyle? style,
    double? iconSize,
    TextEditingController? controller,
    InputDecoration? decoration,
    bool showRequiredMark = false,
    bool readOnly = true,
    bool enabled = true,
    BoxConstraints? suffixIconConstraints,
    ButtonStyle? suffixIconButtonStyle,
    String? Function(String?)? validator,
    EdgeInsets suffixIconPadding = const EdgeInsets.only(right: 16),
  }) {
    return EasyTextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: style,
      enabled: enabled,
      decoration: (decoration ?? InputDecoration()).copyWith(
        suffixIconConstraints: suffixIconConstraints,
        suffixIcon: Padding(
          padding: suffixIconPadding,
          child: IconButton(
            style: suffixIconButtonStyle,
            iconSize: iconSize,
            color: Color(0xFF666666),
            icon: Icon(
              menuOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
            onPressed: onTap,
          ),
        ),
      ),
      showRequiredMark: showRequiredMark,
      validator: validator,
    );
  }

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// {@macro flutter.widgets.editableText.groupId}
  final Object groupId;

  /// Background fill color of the input. If null, falls back to decoration.fillColor,
  /// otherwise defaults to transparent.
  final Color? fillColor;

  /// Placeholder text shown when input is empty. Maps to InputDecoration.hintText.
  final String? placeholder;

  /// {@template flutter.material.TextFormField.onChanged}
  /// Called when the user initiates a change to the TextField's
  /// value: when they have inserted or deleted text or reset the form.
  /// {@endtemplate}
  final ValueChanged<String>? onChanged;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  @override
  FormFieldState<String> createState() => _TextFormFieldState();
}

class _TextFormFieldState extends FormFieldState<String> {
  RestorableTextEditingController? _controller;

  TextEditingController get _effectiveController =>
      _textFormField.controller ?? _controller!.value;

  EasyTextFormField get _textFormField => super.widget as EasyTextFormField;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(oldBucket, initialRestore);
    if (_controller != null) {
      _registerController();
    }
    // Make sure to update the internal [FormFieldState] value to sync up with
    // text editing controller value.
    setValue(_effectiveController.text);
  }

  void _registerController() {
    assert(_controller != null);
    registerForRestoration(_controller!, 'controller');
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);
    _controller =
        value == null
            ? RestorableTextEditingController()
            : RestorableTextEditingController.fromValue(value);
    if (!restorePending) {
      _registerController();
    }
  }

  @override
  void initState() {
    super.initState();
    if (_textFormField.controller == null) {
      _createLocalController(
        widget.initialValue != null
            ? TextEditingValue(text: widget.initialValue!)
            : null,
      );
    } else {
      _textFormField.controller!.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(EasyTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_textFormField.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      _textFormField.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && _textFormField.controller == null) {
        _createLocalController(oldWidget.controller!.value);
      }

      if (_textFormField.controller != null) {
        setValue(_textFormField.controller!.text);
        if (oldWidget.controller == null) {
          unregisterFromRestoration(_controller!);
          _controller!.dispose();
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    _textFormField.controller?.removeListener(_handleControllerChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController.text != value) {
      _effectiveController.value = TextEditingValue(text: value ?? '');
    }
  }

  @override
  void reset() {
    // Set the controller value before calling super.reset() to let
    // _handleControllerChanged suppress the change.
    _effectiveController.value = TextEditingValue(
      text: widget.initialValue ?? '',
    );
    super.reset();
    _textFormField.onChanged?.call(_effectiveController.text);
  }

  void _handleControllerChanged() {
    // Suppress changes that originated from within this class.
    //
    // In the case where a controller has been passed in to this widget, we
    // register this change listener. In these cases, we'll also receive change
    // notifications for changes originating from within this class -- for
    // example, the reset() method. In such cases, the FormField value will
    // already have been set.
    if (_effectiveController.text != value) {
      didChange(_effectiveController.text);
    }
  }
}

extension _EasyInputDecoration on InputDecoration {
  InputDecoration replaceCopy({
    required Widget? label,
    required String? labelText,
    required Widget? error,
    required String? errorText,
    required Widget? counter,
    required String? counterText,
    required Widget? helper,
    required String? helperText,
  }) {
    return InputDecoration(
      icon: icon,
      iconColor: iconColor,
      label: label,
      labelText: labelText,
      labelStyle: labelStyle,
      floatingLabelStyle: floatingLabelStyle,
      helper: helper,
      helperText: helperText,
      helperStyle: helperStyle,
      helperMaxLines: helperMaxLines,
      hintText: hintText,
      hintStyle: hintStyle,
      hintTextDirection: hintTextDirection,
      hintMaxLines: hintMaxLines,
      hintFadeDuration: hintFadeDuration,
      maintainHintHeight: maintainHintHeight,
      error: error,
      errorText: errorText,
      errorStyle: errorStyle,
      errorMaxLines: errorMaxLines,
      floatingLabelBehavior: floatingLabelBehavior,
      floatingLabelAlignment: floatingLabelAlignment,
      isCollapsed: isCollapsed,
      isDense: isDense,
      contentPadding: contentPadding,
      prefixIcon: prefixIcon,
      prefix: prefix,
      prefixText: prefixText,
      prefixStyle: prefixStyle,
      prefixIconColor: prefixIconColor,
      prefixIconConstraints: prefixIconConstraints,
      suffixIcon: suffixIcon,
      suffix: suffix,
      suffixText: suffixText,
      suffixStyle: suffixStyle,
      suffixIconColor: suffixIconColor,
      suffixIconConstraints: suffixIconConstraints,
      counter: counter,
      counterText: counterText,
      counterStyle: counterStyle,
      filled: filled,
      fillColor: fillColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      errorBorder: errorBorder,
      focusedBorder: focusedBorder,
      focusedErrorBorder: focusedErrorBorder,
      disabledBorder: disabledBorder,
      enabledBorder: enabledBorder,
      border: border,
      enabled: enabled,
      semanticCounterText: semanticCounterText,
      alignLabelWithHint: alignLabelWithHint,
      constraints: constraints,
    );
  }
}
