# Easy UI Component Catalog

Use this catalog to select components before writing code. Confirm exact constructor arguments from the source or examples before final implementation.

## Public Entry Point

Import Easy UI with:

```dart
import 'package:easy_ui/easy_ui.dart';
```

The public exports are declared in `lib/easy_ui.dart`.

## Complete Public Symbol Index

Keep this section searchable. It includes public Easy-prefixed declarations from the `lib/easy_ui.dart` export graph, including widgets, controllers, style types, builders, delegates, and helper models. When using a less common symbol, confirm constructor arguments in source or examples first.

Additional public Easy-prefixed symbols not covered by the common choices:

- Avatar: `EasyAvatarItem`.
- Buttons: `EasyButtonSize`, `EasyButtonType`.
- Carousel: `EasyCarouselAlignment`, `EasyCarouselController`, `EasyCarouselFixedConstraint`, `EasyCarouselFractionalConstraint`, `EasyCarouselTransition`.
- Data table: `EasyDataTableCalculateDelegate`, `EasyDataTableCalculateRowHeightResult`, `EasyDataTableCellBuilder`, `EasyDataTableCellWrapper`, `EasyDataTableCheckboxCell`, `EasyDataTableCheckboxHeader`, `EasyDataTableHeaderBuilder`, `EasyDataTableHeaderData`, `EasyDataTableOperationButton`, `EasyDataTableOperationsCell`, `EasyDataTableTextCell`, `EasyDataTableTextHeader`, `EasyDataTableUserCell`.
- Dialog and drawer: `EasyDialogSize`, `EasyDrawerFooterButton`, `EasyDrawerRoute`, `EasyDrawerScope`, `EasyDrawerSize`, `EasyDrawerTopBar`, `EasyNotifyDialogElevatedButton`, `EasyNotifyDialogOutlinedButton`, `EasyNotifyDialogTextButton`.
- Dropdown and legacy selection: `EasyDropDownTextField`, `EasyDropDownTextField2`, `EasyMultiSelection`, `EasyMultiSelection2`, `EasySingleSelection`.
- File drag: `EasyFileDragAreaController`, `EasyFileDragAreaFileListItem`, `EasyFileDraggedItem`.
- Flow chart internals: `EasyFlowAlgorithm`, `EasyFlowEdge`, `EasyFlowEdgePainter`, `EasyFlowNode`, `EasyRenderFlowView`.
- Forms and i18n: `EasyI18nInputModel`, `EasyTextFormFieldDecorationLayoutDelegate`.
- Layout: `EasyScrollSectionsPositionIndicatorBuilder`, `EasyScrollSectionsScrollToPositionCallback`.
- Localization and models: `EasyLocaleModel`, `EasyUiLocalizations`.
- Lottie: `EasyLottieIconExtension`, `EasyLottieIconType`.
- Menus: `EasyListPopMenuConstraintsBuilder`, `EasyListPopMenuLayoutDelegate`, `EasyListPopMenuMixin`, `EasyListPopMenuOption`, `EasyListPopMenuOptionsState`, `EasyMenuAnchorChildBuilder`, `EasyMenuAnchorMenuBuilder`, `EasyMenuAnchorTransitionBuilder`, `EasyMenuController`, `EasyMenuOverlayInfo`, `EasyMenuStyle`, `EasyMultiCheckBoxListPopMenu`, `EasySingleCheckListTilePopMenu`, `EasySingleCheckPopMenuItem`, `EasySingleCheckboxListPopMenu`.
- Pagination select: `EasyPaginationMultipleSelectController`, `EasyPaginationSelect`, `EasyPaginationSelectState`, `EasyPaginationSingleSelectController`.
- Progress: `EasyLinearProgressIndicatorPainter`, `EasyMarqueeGradientBarState`, `EasyRadialProgressIndicatorStyle`.
- Rich editor: `EasyRichEditorController`, `EasyRichEditorUploadParams`.
- Search and select: `EasySearchAnchorBuilder`, `EasySearchController`, `EasySearchSuggestionsBuilder`, `EasySelectController`, `EasySelectOptionsFetcher`, `EasySelectStyle`.
- Signature: `EasySignaturePadController`, `EasySignaturePainter`.
- Switch and tabs: `EasySwitchLabelPosition`, `EasyTabPosition`.
- Time picker: `EasyPopupRangeDateTimePicker`, `EasyPopupSingleDateTimePicker`.

Non-Easy public widget/helper exports that may still be requested by name:

- Stepper and pagination: `BaseStep`, `ControlButton`, `NumberButton`, `NumberPageContainer`, `NumberPagination`.
- H5 and web: `AppBridge`, `H5WebView`, `SafeInAppWebview`, `LocalhostServerManager`.
- Markdown internals: `MarkdownWidget`, `MarkdownBlock`, `ImageViewer`, `MCheckBox`, `ProxyRichText`, `TocWidget`.
- Date picker and dropdown internals: `PopupDateTimePicker`, `I18nInputFormField`, `KeyboardVisibilityBuilder`, `MultiValueDropDownController`, `SingleValueDropDownController`.
- Flow chart internals: `DrawingArrowWidget`.

## Common Component Choices

### Layout and Navigation

- `EasyTabs`, `EasyTabItem`: tabbed views and section switching.
- `EasyStepper`, `EasyStep`, `EasyLine`: workflows, onboarding, process state.
- `EasyStepIndicator`: compact progress indicators.
- `EasyScrollSectionsLayout`, `EasySectionContent`: long settings/detail pages with section navigation.
- `EasyDrawer`, `EasyDrawerWrapper`: side panels and detail drawers.

Examples:

- `example/lib/view/navigation/tabs.dart`
- `example/lib/view/navigation/easy_stepper.dart`
- `example/lib/view/navigation/step_indicator.dart`
- `example/lib/view/layout/easy_scroll_sections_layout.dart`
- `example/lib/view/feedback/drawer.dart`

### Inputs and Forms

- `EasyTextFormField`: text input with Easy UI styling.
- `EasySelect`, `EasySelectFormField`, `EasyMultiSelectFormField`: single/multiple selection.
- `EasyPopupSingleDateTimeFormField`, `EasyPopupRangeDateTimeFormField`: date/time fields.
- `EasyModeDatePicker`: date picker mode UI.
- `EasyPaginationSingleSelectFormField`, `EasyPaginationMultipleSelectFormField`: large option sets.
- `EasyColorPicker`, `EasyColorSelector`, `EasyColorSelectorFormField`: color input.
- `EasySlider`, `EasyRangeSlider`: numeric range controls.
- `EasySwitch`: boolean settings.
- `EasySignaturePad`: signature capture.
- `EasyFileDragArea`, `EasyFileDragAreaFormField`: file upload surfaces.
- `EasyOnscreenKeyboard`: touch/embedded input.
- `EasyI18nInputFormField`, `EasyI18nButton`, `EasyI18nInputDrawer`: multilingual text input.

Examples:

- `example/lib/view/data_entry/form.dart`
- `example/lib/view/data_entry/drop_down/select.dart`
- `example/lib/view/data_entry/drop_down/pagination_select.dart`
- `example/lib/view/data_entry/mode_date_picker.dart`
- `example/lib/view/data_entry/time_picker.dart`
- `example/lib/view/data_entry/slider_demo.dart`
- `example/lib/view/base/switch.dart`
- `example/lib/view/easy_signature_pad_example.dart`
- `example/lib/view/easy_file_drag_area_demo.dart`

### Data Display

- `EasyDataTable`, `EasyDataTableColumnConfig`, table cell/header helpers: dense data tables.
- `EasyPagination`, `EasyPaginationState`, `EasyPaginationDataProvider`: paged data.
- `EasySearchAnchor`: searchable command/search surfaces.
- `EasyInfoCard`, `EasyInfoItem`: key-value information cards.
- `EasyRecordCard`, `EasyCardButton`: record summaries and action cards.
- `EasyStatusIndicator`: status pills.
- `EasyEmptyView`, `EasyOfflineViewWidget`: empty/offline states.
- `EasySkeleton`, `EasyListSkeleton`: loading states.
- `EasyCarousel`, `EasyCarouselDotIndicator`: carousel content.
- `EasyFlowChart`, `EasyFlowView`, `EasyFlowGraph`: flow/process visualization.

Examples:

- `example/lib/view/data_display/data_table.dart`
- `example/lib/view/pagination/easy_pagination_example.dart`
- `example/lib/view/data_display/info_card.dart`
- `example/lib/view/data_display/record_card.dart`
- `example/lib/view/data_display/status_indicator.dart`
- `example/lib/view/data_display/empty_view.dart`
- `example/lib/view/data_display/skeleton.dart`
- `example/lib/view/data_display/carousel_demo.dart`
- `example/lib/view/data_display/flow.dart`

### Feedback and Overlays

- `EasyToastWrapper`, `EasyToast`: transient feedback.
- `EasyNotifyDialog`, `EasyContentDialog`, `EasyInputDialog`: modal decisions and input.
- `EasyPopover`, `EasyDropdown`, dropdown items: anchored overlays.
- `EasyMenuAnchor`, `EasySingleCheckPopMenu`, list pop menus: menus.
- `EasyToolTipWidget`: tooltip behavior.
- `EasyLocalNotifications`: local notification integration.

Examples:

- `example/lib/view/feedback/toast.dart`
- `example/lib/view/feedback/dialog.dart`
- `example/lib/view/feedback/popover.dart`
- `example/lib/view/data_entry/tool_tip.dart`
- `example/lib/view/feedback/local_notification.dart`

### Media and Rich Content

- `EasyImage`, `EasyImagePreviewWrapper`: images and preview behavior.
- `EasySvgIcon`: SVG icons.
- `EasyImageCropperDialog`: crop workflow.
- `EasyMarkdown`, `MarkdownWidget`: markdown/rich text rendering.
- `EasyRichEditor`: H5 rich editor.
- `EasySimpleH5Page`, `H5WebView`, `SafeInAppWebview`: H5/web content.
- `EasyPdfViewer`: PDF preview.
- `EasyLottieIcon`: lightweight animated status icons.
- `EasyTypographyParagraph`: long readable text.
- `EasyLongPressCopyable`: copyable text/code.

Examples:

- `example/lib/view/base/image.dart`
- `example/lib/view/base/svg_icon.dart`
- `example/lib/view/other/easy_markdown_demo.dart`
- `example/lib/view/other/easy_rich_editor_demo.dart`
- `example/lib/view/h5/h5_proxy_demo.dart`
- `example/lib/view/other/easy_pdf_viewer_demo.dart`
- `example/lib/view/base/easy_lottie_icon.dart`
- `example/lib/view/base/typography_paragraph.dart`
- `example/lib/view/other/long_press_copyable.dart`

### Theme and Utility

- `EasyTheme`, `EasyThemeData`: Easy UI theme integration.
- `EasyButton2`, `EasySearchButton`, `EasyResetSearchButton`, `EasyButtonStyle`: buttons.
- `EasyAvatar`, `EasyAvatarGroup`, `EasyUserListTile`: people/user UI.
- `EasyLinearProgressIndicator`, `EasyRadialProgressIndicator`, `EasyMarqueeGradientBar`: progress and activity.
- `EasySegments`, `EasySegmentsItem`: segmented controls.

Examples:

- `example/lib/view/base/theme.dart`
- `example/lib/view/button/easy_button_example.dart`
- `example/lib/view/base/button.dart`
- `example/lib/view/base/avatar.dart`
- `example/lib/view/other/linear_progress_indicator.dart`
- `example/lib/view/other/easy_radial_progress_indicator_demo.dart`
- `example/lib/view/other/marquee_gradient_bar.dart`
- `example/lib/view/base/segments.dart`
