# Architecture

`theme_variants` has two independent systems that work well together:

1. Theme selection
2. Style variant resolution

They are independent because an app may want theme selection without component
variants, or component variants without nested theme overrides.

## Public Entry Point

All public API is exported from:

```text
lib/theme_variants.dart
```

That file exports the internal modules:

```text
src/theme/
src/controller/
src/widgets/
src/variants/
```

## Theme Selection Flow

The theme system resolves this question:

```text
Given the selected light id, selected dark id, and ThemeMode,
which ThemeVariant<TTokens> is active right now?
```

Flow:

```text
ThemeVariantRegistry
  -> ThemeVariantsController
  -> ThemeVariantsProvider
  -> context.themeTokens<TTokens>()
```

`ThemeVariantRegistry` owns the known theme ids.

`ThemeVariantsController` owns the selected ids and `ThemeMode`.

`ThemeVariantsProvider` puts the controller into the widget tree.

`BuildContext` extensions read the active theme/tokens from the nearest provider.

## Variant Resolution Flow

The variant system resolves this question:

```text
Given active tokens and selected enum values,
what Flutter style object should this component use?
```

Flow:

```text
VariantStyle<TTokens, TValue>
  -> base(tokens)
  -> default variants
  -> selected variants
  -> compound variants
  -> resolved TValue
```

`TValue` is a Flutter style type such as:

```text
TextStyle
ButtonStyle
BoxDecoration
CardThemeData
ChipThemeData
```

## Why Factories Exist

`variant_style.dart` owns the public constructors:

```dart
VariantStyle.button(...)
VariantStyle.buttonParts(...)
VariantStyle.decoration(...)
VariantStyle.decorationParts(...)
```

The implementation is split into helper files:

```text
variant_style_factories.dart
variant_style_parts_adapter.dart
style_parts.dart
```

This keeps the public API in one predictable file while moving mechanical
construction details out of the main resolver.

## Core Rule

The package does not own your design tokens.

The app owns `TTokens`.

The package only knows how to:

- store a `TTokens` value next to `ThemeData`
- expose the active `TTokens`
- pass `TTokens` into style builders
