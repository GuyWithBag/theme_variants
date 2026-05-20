## 0.1.2

  * renamed light and dark to lightTokens and
  darkTokens
  * removed TModeTokens and use only
  TTokens

## 0.1.1

* Added `LightDarkThemePreset.composed` for building light/dark preset pairs
  from shared and mode-specific token inputs.
* Added `ThemeTokensComposer` and `ThemeDataForTokensBuilder` typedefs to
  support reusable token merge and `ThemeData` construction flows.
* Added tests validating composed presets keep shared token values stable while
  allowing mode-specific overrides.
* Updated theme system docs with composed token usage examples.

## 0.1.0

* Breaking: replaced theme entries with preset-based theme models. Use
  `LightDarkThemePreset` and `SingleThemePreset` to group concrete
  `ThemeVariant` values under stable preset ids and names.
* Breaking: `ThemeVariant` now identifies its preset with `themePresetId` and
  `brightness` instead of a standalone variant id.
* Added registry helpers for listing all themes, light themes, dark themes,
  single themes, and resolving current presets.
* Added controller and registry import/export helpers with `ThemeImportMode`
  support for add-only, replace-and-add, and replace-only workflows.
* Added `ContentStyle` and `SurfaceStyle` for resolving paired text/icon and
  surface/content styles.
* Added the `Surface` widget for applying resolved surface styles to a subtree.
* Added `VariantStyle.content`, `VariantStyle.contentParts`,
  `VariantStyle.surface`, and `VariantStyle.surfaceParts`.
* Added `SurfaceStylePart` and `ContentStylePart` helpers, including support
  for content text layout and surface layout fields.
* Updated the example app and README to use preset-based theme registration and
  persistence-friendly import/export patterns.

## 0.0.1

* Initial release.
* Added theme registries, light/dark theme entries, controller/provider widgets,
  nested theme overrides, and typed Flutter style variants.
* Breaking: `VariantStyle.resolve` validates recipes and selected variants
  strictly. Unknown variants, duplicate variants from the same type group,
  unregistered defaults, and invalid compound variants now throw errors.
* Added `ThemeVariantRegistry.ids` and clearer unknown theme id errors.
* Added `...Parts` `VariantStyle` constructors and typed style part helpers for
  composing Flutter style objects from set-like fragments.
