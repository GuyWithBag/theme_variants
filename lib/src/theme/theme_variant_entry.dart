import 'package:flutter/material.dart';

import 'theme_variant.dart';

/// A theme entry that can resolve to light and dark variants.
abstract class ThemeVariantEntry<TTokens> {
  const ThemeVariantEntry();

  ThemeVariant<TTokens> resolve(Brightness brightness);
}

/// A theme entry that uses the same theme for light and dark brightness.
class SingleThemeVariant<TTokens> extends ThemeVariantEntry<TTokens> {
  const SingleThemeVariant(this.theme);

  final ThemeVariant<TTokens> theme;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) => theme;
}

/// A theme entry with distinct light and dark variants.
class LightDarkThemeVariant<TTokens> extends ThemeVariantEntry<TTokens> {
  const LightDarkThemeVariant({required this.light, required this.dark});

  final ThemeVariant<TTokens> light;
  final ThemeVariant<TTokens> dark;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}
