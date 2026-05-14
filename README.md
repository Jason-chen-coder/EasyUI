# Easy UI

[![Deploy Example](https://github.com/Jason-chen-coder/easy_ui/actions/workflows/deploy-example.yml/badge.svg)](https://github.com/Jason-chen-coder/easy_ui/actions/workflows/deploy-example.yml)

Easy UI is a Flutter component library for building practical, product-facing applications across Web, desktop, and mobile. It provides a migrated and unified set of `Easy*` widgets, design tokens, interaction patterns, and example pages for teams that need a reusable UI layer instead of one-off screens.

## Documentation

Use the live example as the primary documentation and preview surface:

[https://jason-chen-coder.github.io/easy_ui/](https://jason-chen-coder.github.io/easy_ui/)

The example app is deployed from `example/` with GitHub Actions. It includes a standalone landing page, a component workbench, theme switching, locale switching, and Web-first loading feedback. Component-level recipes should live in the example app instead of making this README a long usage catalog.

## Highlights

- **Flutter-first components**: built as Flutter widgets and exported from a single package entrypoint.
- **Unified Easy naming**: public components follow the `Easy*` naming convention after migration.
- **Product UI coverage**: includes foundations for form-heavy, data-heavy, feedback-heavy, and content-heavy applications.
- **Theme-aware by default**: supports light/dark presentation through Easy UI and Material theme integration.
- **Internationalization ready**: ships generated localization metadata and example locale switching.
- **Web preview workflow**: the example project is automatically built and deployed to GitHub Pages.

## Installation

Add Easy UI from GitHub:

```yaml
dependencies:
  easy_ui:
    git:
      url: https://github.com/Jason-chen-coder/easy_ui.git
      ref: main
```

Then fetch dependencies:

```bash
flutter pub get
```

Import the package where you build your UI:

```dart
import 'package:easy_ui/easy_ui.dart';
```

## Requirements

This repository is currently verified with:

- Flutter `3.29.2`
- Dart `3.7.2`

The package is intended for Flutter applications targeting Web, desktop, and mobile. Some features depend on platform-specific Flutter plugins; check the example project when enabling file, notification, H5, PDF, or desktop-specific capabilities.

## Repository Structure

```text
easy_ui/
├── lib/                 # Package source and public exports
├── assets/              # Package assets used by widgets
├── fonts/               # Bundled typography assets
├── test/                # Package tests
├── example/             # Runnable Flutter example app
└── .github/workflows/   # CI and GitHub Pages deployment
```

## Development

Install dependencies for the package:

```bash
flutter pub get
```

Run static analysis and tests:

```bash
flutter analyze
flutter test
```

Run the example locally:

```bash
cd example
flutter pub get
flutter run -d chrome
```

Build the Web example:

```bash
cd example
flutter build web --release --no-web-resources-cdn --pwa-strategy=none
```

For GitHub Pages, build with the repository base path:

```bash
cd example
flutter build web --release \
  --base-href /easy_ui/ \
  --no-web-resources-cdn \
  --pwa-strategy=none
```

## Deployment

The `Deploy Example` workflow runs on pushes to `main` and `master`.

It performs:

1. Package dependency install
2. Package analysis
3. Package tests
4. Example dependency install
5. Example tests
6. Example Web build
7. GitHub Pages artifact upload
8. GitHub Pages deployment

The deployed site is published to:

[https://jason-chen-coder.github.io/easy_ui/](https://jason-chen-coder.github.io/easy_ui/)

## Contributing

Contributions should keep the library consistent with the current migration rules:

- Public widget names use the `Easy*` prefix.
- File names use the `easy_*` convention.
- Example pages should remain runnable on Web.
- Run `flutter analyze` and relevant tests before opening a pull request.
- Avoid committing generated build outputs such as `build/`, `.dart_tool/`, or local platform configuration files.

## License

License terms are tracked in [LICENSE](LICENSE). Finalize the license text before publishing a stable release.
