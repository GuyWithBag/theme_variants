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
