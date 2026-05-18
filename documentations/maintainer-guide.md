# Maintainer Guide

This guide explains where to make changes.

## Add A New Style Shortcut

Example goal:

```dart
VariantStyle.tooltip(...)
VariantStyle.tooltipParts(...)
TooltipPart.someField(...)
```

Steps:

1. Add a merger in `lib/src/variants/mergers.dart`.
2. Add the object constructor in `VariantStyle`.
3. Add the parts constructor in `VariantStyle`.
4. Add part helpers in `style_parts.dart`.
5. Add tests in `test/theme_variants_test.dart`.
6. Update README and changelog.

## Add A New Part Helper

File:

```text
lib/src/variants/style_parts.dart
```

Pattern:

```dart
class TextStylePart {
  static StylePart<TextStyle> color(Color color) {
    return (style) => style.copyWith(color: color);
  }
}
```

Rules:

- Return `StylePart<TValue>`.
- Do not mutate anything.
- Use `copyWith`.
- Keep helper names close to Flutter field names.

## Change Resolution Behavior

File:

```text
lib/src/variants/variant_style.dart
```

The important methods:

```dart
resolve
_resolveSelectedVariants
_validateRecipe
_validateSelectedVariants
```

Any behavior change here needs tests for:

- defaults
- explicit selected variants
- compound variants
- invalid selected variants
- duplicate variant groups

## Change Theme Selection Behavior

Files:

```text
lib/src/theme/
lib/src/controller/
lib/src/widgets/
```

Add widget tests when changing:

- `ThemeVariantsProvider`
- `ThemeVariantsOverride`
- context extensions
- controller notification behavior

## Keep Compatibility In Mind

This package is early-stage, but breaking changes should still be explicit.

When breaking behavior changes:

- use `!` in the commit message
- update `CHANGELOG.md`
- update README usage notes
- add tests showing the new behavior

## Run Checks

From the package root:

```bash
dart format lib test example/lib example/test
dart analyze
flutter test
```

From the example:

```bash
cd example
dart analyze
flutter test
```

## Mental Model

Do not think of `VariantStyle` as a widget system.

It is just a resolver:

```text
tokens + selected variants -> Flutter style object
```

Do not think of `ThemeVariantRegistry` as app state.

It is just a lookup table:

```text
theme id + brightness -> ThemeVariant<TTokens>
```

The controller is the app state:

```text
selected light id
selected dark id
theme mode
optional transform
```
