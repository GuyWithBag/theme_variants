## 0.2.5

* fix(Surface): ClipRRect is a child of Container instead of the parent of
the Container

## 0.2.4

* Made `Surface` clip rounded decorations automatically.

## 0.2.3

* Added content-style helpers to `ChipPart` and `TextFieldStylePart`.

## 0.2.2

* Added `InputDecorationPart.disabledBorder`.

## 0.2.1

* Added more `ChipPart` helpers for selected colors, secondary label styling,
  checkmark visibility, icon theme, and related chip theme fields.
* Added `TextStylePart.letterSpacing` and `TextFieldStylePart.cursorColor`.
* Allowed `Surface` to be constructed without an explicit style or child.

## 0.2.0

* Added `VariantShowcaseGrid`, a public widget for automatically displaying
  available variant styles.
* Updated the example app to demonstrate the showcase grid and added tests for
  the new widget behavior.

## 0.1.2

* Added `TextFieldStyle` for resolving editable text, input decoration,
  cursor color, and text alignment styles together.
* Added `VariantStyle.textField` and `VariantStyle.textFieldParts`.
* Added `TextFieldStylePart` helpers for text style, decoration theme, and
  text alignment fragments.
* Preserved nullable patch semantics for content, surface, and text field
  variant merging so omitted fields do not reset base style values.

## 0.1.1

* Breaking: Renamed light and dark from ThemeVariant to lightTokens and darkTokens

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
