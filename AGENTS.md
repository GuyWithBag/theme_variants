# Repository Guidelines

## Project Structure & Module Organization

This repository is a Flutter package named `theme_variants`. The public package entry point is `lib/theme_variants.dart`, which exports the internal implementation under `lib/src/`.

- `lib/src/theme/`: theme models, light/dark entries, and registry lookup.
- `lib/src/controller/`: `ThemeVariantsController` state management.
- `lib/src/widgets/`: Flutter provider/context integration.
- `lib/src/variants/`: typed CVA-style variant resolver, compound variants, and style mergers.
- `test/`: package unit and widget tests.
- `example/`: runnable Flutter app demonstrating real usage.
- `example/lib/`: example app code split into `theme/`, `tokens/`, `variants/`, and `screens/`.

## Build, Test, and Development Commands

Run commands from the repository root unless noted.

```bash
dart format lib test example/lib example/test
dart analyze
flutter test
cd example && dart analyze
cd example && flutter test
cd example && flutter run
```

`dart format` applies standard Dart formatting. `dart analyze` checks lints from `flutter_lints`. `flutter test` runs package tests; the same command inside `example/` runs example widget tests. `flutter run` launches the demo app.

## Coding Style & Naming Conventions

Use Dart defaults: two-space indentation, trailing commas for multi-line widget trees and constructors, and `lower_snake_case.dart` file names. Public classes use `UpperCamelCase`; methods, variables, and fields use `lowerCamelCase`.

Keep `lib/theme_variants.dart` as a barrel file only. Add implementation files under `lib/src/` by domain instead of expanding the public entry point.

## Testing Guidelines

Tests use `flutter_test`. Add package behavior tests in `test/theme_variants_test.dart`, especially for resolver behavior, theme selection, and provider access. Add demo interaction tests in `example/test/widget_test.dart`.

Name tests by behavior, for example: `explicit variants replace defaults from the same type`. Run both root and example test suites before committing.

## Commit & Pull Request Guidelines

Use Conventional Commit style, matching current history:

```text
docs(example): add theme variants demo app
fix(variants): allow explicit variants to override defaults
refactor(lib): split package internals by domain
```

Pull requests should include a short description, the reason for the change, test results, and screenshots or recordings for visible example app changes. Keep unrelated refactors out of feature or bug-fix PRs.

## Agent-Specific Instructions

Do not change public imports without updating tests and the example. Preserve `import 'package:theme_variants/theme_variants.dart';` as the main user-facing API.
