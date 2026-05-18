---
name: easy-ui-view-builder
description: Build Flutter views, pages, dashboards, forms, data displays, and component demos with the Easy UI component library. Use when Codex needs to design or implement a Flutter screen using package:easy_ui/easy_ui.dart, choose Easy UI components, wire examples, or convert rough UI requirements into production-ready Easy UI code.
---

# Easy UI View Builder

Use this skill to turn a product or UI requirement into a Flutter view built with Easy UI. Prefer Easy UI components over raw Material widgets when an Easy equivalent exists.

## Workflow

1. Inspect the target Flutter project.
   - Read `pubspec.yaml` and confirm `easy_ui` is available.
   - Read nearby screens before creating a new visual style.
   - If working inside this repository, use `lib/easy_ui.dart` as the public API surface and `example/lib/view/**` as implementation references.

2. Load references only as needed.
   - For component selection, read `references/component-catalog.md`.
   - For page composition patterns, read `references/view-patterns.md`.

3. Map the user's intent to Easy UI building blocks.
   - Forms: `EasyTextFormField`, `EasySelectFormField`, date/time fields, color selectors, pagination selects.
   - Data-heavy views: `EasyDataTable`, `EasyPagination`, `EasySearchAnchor`, `EasyEmptyView`, `EasySkeleton`.
   - Operational pages: `EasyStatusIndicator`, `EasyInfoCard`, `EasyRecordCard`, `EasyTabs`, `EasyStepper`.
   - Feedback: `EasyToastWrapper`, `EasyNotifyDialog`, `EasyContentDialog`, `EasyDrawer`, `EasyPopover`.
   - Rich content and media: `EasyMarkdown`, `EasyImage`, `EasyCarousel`, `EasyPdfViewer`, `EasyRichEditor`.

4. Build the actual usable view.
   - Import `package:easy_ui/easy_ui.dart`.
   - Keep the first screen functional, not a landing-page explanation.
   - Use stable responsive constraints: `LayoutBuilder`, `ConstrainedBox`, fixed row heights, and bounded cards.
   - Keep cards at 8px radius or less unless existing code uses another radius.
   - Avoid oversized marketing hero sections for operational tools.

5. Verify.
   - Run `dart format` on touched Dart files.
   - Run `flutter analyze` in the target package.
   - Run focused widget tests when existing tests cover the touched area.
   - For web/example changes, run a web build or local preview when feasible.

## Code Rules

- Do not invent component names. Confirm exports in `lib/easy_ui.dart` or usage in `example/lib/view/**`.
- Do not copy large demo files wholesale. Extract the smallest useful pattern.
- Do not introduce new dependencies if Easy UI or Flutter already covers the need.
- Preserve the host app's navigation, state management, theme, and localization patterns.
- Use real loading, empty, disabled, error, and overflow states when the view handles data.
- For text in production UI, follow the app's localization approach if one exists.

## Starter Prompt Pattern

When a user gives a rough UI request, internally translate it into:

```text
Build a Flutter view using Easy UI.
Purpose: <what the user wants to accomplish>
Primary users: <operator/admin/customer/etc.>
Data model: <fields and states>
Main regions: <toolbar/content/detail/footer/etc.>
Easy UI components: <selected components>
Verification: <format/analyze/tests/preview>
```

Then implement the view directly unless the requirement is ambiguous enough that one short clarification is necessary.
