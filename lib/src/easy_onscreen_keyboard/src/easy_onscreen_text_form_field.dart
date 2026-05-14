import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:easy_ui/easy_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


/// 用法同[EasyTextFormField]，
/// 增加了[enableOnscreenKeyboard]和[onscreenKeyboardMode]两个属性来控制是否启用自动弹出键盘和指定键盘模式。
class EasyOnscreenTextFormField extends StatelessWidget {
  const EasyOnscreenTextFormField({
    super.key,
    this.enableOnscreenKeyboard = true,
    this.onscreenKeyboardMode,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.inputFormatters,
    this.selectAllOnFocus,
    this.groupId = EditableText,
    this.fillColor,
    this.placeholder,
    this.showRequiredMark = false,
    this.decorationLayoutDelegate =
        const VerticalEasyTextFormFieldDecorationLayoutDelegate(),
    this.initialValue,
    this.forceErrorText,
    this.decoration,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.autofocus = false,
    this.readOnly = false,
    this.showCursor,
    this.obscuringCharacter = '•',
    this.obscureText = false,
    this.autocorrect = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.enableSuggestions = true,
    this.maxLengthEnforcement,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.onTap,
    this.onTapAlwaysCalled = false,
    this.onTapOutside,
    this.onTapUpOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.enabled,
    this.ignorePointers,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.cursorErrorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection,
    this.selectionControls,
    this.buildCounter,
    this.scrollPhysics,
    this.autofillHints,
    this.autovalidateMode,
    this.scrollController,
    this.restorationId,
    this.enableIMEPersonalizedLearning = true,
    this.mouseCursor,
    this.contextMenuBuilder,
    this.spellCheckConfiguration,
    this.magnifierConfiguration,
    this.undoController,
    this.onAppPrivateCommand,
    this.cursorOpacityAnimates,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
    this.contentInsertionConfiguration,
    this.statesController,
    this.clipBehavior = Clip.hardEdge,
    this.stylusHandwritingEnabled =
        EditableText.defaultStylusHandwritingEnabled,
    this.canRequestFocus = true,
    this.height,
  });

  /// Enables or disables the automatic onscreen keyboard behavior.
  ///
  /// When true, focusing this field will attach it to the
  /// onscreen keyboard and open it.
  ///
  /// When true, the [keyboardType] will be ignored.
  ///
  /// If set to false, this widget will function as a regular [TextField].
  /// Defaults to `true`.
  final bool enableOnscreenKeyboard;

  /// Changes the [KeyboardMode] to the one specified on [onscreenKeyboardMode]
  /// when the [EasyOnscreenKeyboardTextFormField] is selected.
  ///
  /// If none is specified the keyboard will use the first mode
  /// specified on the layout mode list.
  final String? onscreenKeyboardMode;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController? controller;

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
  /// This widget builds an [EditableText] and will ensure that the keyboard is
  /// showing when it is tapped by calling
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

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// {@macro flutter.widgets.editableText.onChanged}
  ///
  /// See also:
  ///
  ///  * [inputFormatters], which are called before [onChanged]
  ///    runs and can validate and change ("format") the input value.
  ///  * [onEditingComplete], [onSubmitted]:
  ///    which are more specialized input change notifications.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// {@macro flutter.widgets.editableText.selectAllOnFocus}
  final bool? selectAllOnFocus;

  /// {@macro flutter.widgets.editableText.groupId}
  final Object groupId;

  /// Controls the text being edited.
  ///

  /// Background fill color of the input. If null, falls back to decoration.fillColor,
  /// otherwise defaults to transparent.
  final Color? fillColor;

  /// Placeholder text shown when input is empty. Maps to InputDecoration.hintText.
  final String? placeholder;

  // AddBy: cyl.是否显示必填星号*
  final bool showRequiredMark;
  // AddBy cyl.是否使用自定义的label,counter,helper,error布局方式
  // 值未null时使用TextField自带的布局方式
  final EasyTextFormFieldDecorationLayoutDelegate? decorationLayoutDelegate;
  final String? initialValue;

  /// An optional property that forces the [FormFieldState] into an error state
  /// by directly setting the [FormFieldState.errorText] property without
  /// running the validator function.
  ///
  /// When the [forceErrorText] property is provided, the [FormFieldState.errorText]
  /// will be set to the provided value, causing the form field to be considered
  /// invalid and to display the error message specified.
  ///
  /// When [validator] is provided, [forceErrorText] will override any error that it
  /// returns. [validator] will not be called unless [forceErrorText] is null.
  ///
  /// See also:
  ///
  /// * [InputDecoration.errorText], which is used to display error messages in the text
  /// field's decoration without effecting the field's state. When [forceErrorText] is
  /// not null, it will override [InputDecoration.errorText] value.
  final String? forceErrorText;
  final InputDecoration? decoration;

  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool autofocus;
  final bool readOnly;
  final bool? showCursor;
  final String obscuringCharacter;
  final bool obscureText;
  final bool autocorrect;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final bool enableSuggestions;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? minLines;
  final bool expands;
  final int? maxLength;

  final GestureTapCallback? onTap;
  final bool onTapAlwaysCalled;
  final TapRegionCallback? onTapOutside;
  final TapRegionUpCallback? onTapUpOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;

  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<String>? onSaved;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  ///
  /// The returned value is exposed by the [FormFieldState.errorText] property.
  /// The [TextFormField] uses this to override the [InputDecoration.errorText]
  /// value.
  ///
  /// Alternating between error and normal state can cause the height of the
  /// [TextFormField] to change if no other subtext decoration is set on the
  /// field. To create a field whose height is fixed regardless of whether or
  /// not an error is displayed, either wrap the  [TextFormField] in a fixed
  /// height parent like [SizedBox], or set the [InputDecoration.helperText]
  /// parameter to a space.
  final FormFieldValidator<String>? validator;
  final bool? enabled;
  final bool? ignorePointers;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Color? cursorErrorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool? enableInteractiveSelection;
  final TextSelectionControls? selectionControls;
  final InputCounterWidgetBuilder? buildCounter;
  final ScrollPhysics? scrollPhysics;
  final Iterable<String>? autofillHints;
  final AutovalidateMode? autovalidateMode;
  final ScrollController? scrollController;

  /// Restoration ID to save and restore the state of the form field.
  ///
  /// Setting the restoration ID to a non-null value results in whether or not
  /// the form field validation persists.
  ///
  /// The state of this widget is persisted in a [RestorationBucket] claimed
  /// from the surrounding [RestorationScope] using the provided restoration ID.
  ///
  /// See also:
  ///
  ///  * [RestorationManager], which explains how state restoration works in
  ///    Flutter.
  final String? restorationId;
  final bool enableIMEPersonalizedLearning;
  final MouseCursor? mouseCursor;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final SpellCheckConfiguration? spellCheckConfiguration;
  final TextMagnifierConfiguration? magnifierConfiguration;
  final UndoHistoryController? undoController;
  final AppPrivateCommandCallback? onAppPrivateCommand;
  final bool? cursorOpacityAnimates;
  final ui.BoxHeightStyle selectionHeightStyle;
  final ui.BoxWidthStyle selectionWidthStyle;
  final DragStartBehavior dragStartBehavior;
  final ContentInsertionConfiguration? contentInsertionConfiguration;
  final WidgetStatesController? statesController;
  final Clip clipBehavior;
  final bool stylusHandwritingEnabled;
  final bool canRequestFocus;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return EasyOnscreenKeyboardTextFieldBuilder(
      enableOnscreenKeyboard: enableOnscreenKeyboard,
      onscreenKeyboardMode: onscreenKeyboardMode,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      selectAllOnFocus: selectAllOnFocus,
      builder: (
        TextEditingController controller,
        FocusNode focusNode,
        List<TextInputFormatter>? inputFormatters,
        TextInputType? keyboardType,
        int? maxLines,
        ValueChanged<String>? onChanged,
      ) {
        return EasyTextFormField(
          controller: controller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          groupId: groupId,
          fillColor: fillColor,
          placeholder: placeholder,
          showRequiredMark: showRequiredMark,
          decorationLayoutDelegate: decorationLayoutDelegate,
          initialValue: initialValue,
          forceErrorText: forceErrorText,
          decoration: decoration,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          style: style,
          strutStyle: strutStyle,
          textDirection: textDirection,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          autofocus: autofocus,
          readOnly: readOnly,
          showCursor: showCursor,
          obscuringCharacter: obscuringCharacter,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLengthEnforcement: maxLengthEnforcement,
          minLines: minLines,
          expands: expands,
          maxLength: maxLength,
          onTap: onTap,
          onTapAlwaysCalled: onTapAlwaysCalled,
          onTapOutside: onTapOutside,
          onTapUpOutside: onTapUpOutside,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          onSaved: onSaved,
          validator: validator,
          enabled: enabled,
          ignorePointers: ignorePointers,
          cursorWidth: cursorWidth,
          cursorHeight: cursorHeight,
          cursorRadius: cursorRadius,
          cursorColor: cursorColor,
          cursorErrorColor: cursorErrorColor,
          keyboardAppearance: keyboardAppearance,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          selectionControls: selectionControls,
          buildCounter: buildCounter,
          scrollPhysics: scrollPhysics,
          autofillHints: autofillHints,
          autovalidateMode: autovalidateMode,
          scrollController: scrollController,
          restorationId: restorationId,
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
          statesController: statesController,
          clipBehavior: clipBehavior,
          stylusHandwritingEnabled: stylusHandwritingEnabled,
          canRequestFocus: canRequestFocus,
          height: height,
        );
      },
    );
  }
}
