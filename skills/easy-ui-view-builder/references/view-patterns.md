# Easy UI View Patterns

Use these patterns when composing views with Easy UI.

## Operational Dashboard

Use for admin, CRM, device, lab, task, or monitoring pages.

Recommended structure:

- Header row: title, short status, primary action.
- Filter/search row: `EasySearchAnchor`, `EasySelect`, `EasyPopupSingleDateTimeFormField`.
- Main content: `EasyDataTable` or cards with `EasyPagination`.
- State handling: `EasySkeleton` while loading, `EasyEmptyView` when no records, `EasyToast` for result feedback.

Implementation notes:

- Keep density high and spacing restrained.
- Prefer real table rows over decorative cards when comparing records matters.
- Put destructive actions behind dialogs such as `EasyNotifyDialog`.

## Form or Settings Page

Use for create/edit flows, configuration, and preferences.

Recommended structure:

- Use a `Form` with Easy form fields.
- Group fields by section with stable widths.
- Use `EasyScrollSectionsLayout` for long forms.
- Use `EasyContentDialog` or `EasyInputDialog` for modal edits.

Implementation notes:

- Validate required fields.
- Include disabled/loading state for submit buttons.
- Respect existing localization patterns.

## Detail Page

Use for a record, user, device, order, or project detail.

Recommended structure:

- Summary header with `EasyStatusIndicator`.
- Key facts with `EasyInfoCard`.
- Activity or related records with `EasyTabs`.
- Actions in a right drawer or footer with `EasyDrawer`.

Implementation notes:

- Keep primary facts above the fold.
- Make status visually clear without relying only on color.

## Empty, Loading, and Error States

Every generated view that fetches data should include:

- Loading: `EasySkeleton` or `EasyListSkeleton`.
- Empty: `EasyEmptyView`.
- Offline/error: `EasyOfflineViewWidget` or an error panel with retry.
- Feedback: `EasyToastWrapper` and a toast call after actions.

## Responsive Layout

Use `LayoutBuilder` with simple breakpoints:

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final compact = constraints.maxWidth < 760;
    return compact ? const _MobileLayout() : const _DesktopLayout();
  },
)
```

Rules:

- Avoid text overlap by bounding text with `maxLines` and `overflow`.
- Keep table/card heights stable.
- Do not scale font size from viewport width.
- Collapse columns to one column on mobile.

## Verification Checklist

Before finishing:

- `dart format <touched dart files>`
- `flutter analyze`
- Run focused tests if present.
- For visual work, run the example app or web build when feasible.
- Check that every new route/page/component is rendered by a parent or registered in navigation.
