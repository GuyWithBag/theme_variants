import 'package:flutter/material.dart';

import 'theme_variant.dart';

/// Describes whether a theme preset has one theme or separate light/dark themes.
enum ThemePresetType { single, lightDark }

/// A named theme preset that can resolve to a concrete [ThemeVariant].
abstract class ThemePreset<TTokens> {
  const ThemePreset();

  String get id;

  String get name;

  ThemePresetType get presetType;

  ThemeVariant<TTokens> resolve(Brightness brightness);
}

/// A preset that uses the same theme for light and dark brightness.
class SingleThemePreset<TTokens> extends ThemePreset<TTokens> {
  const SingleThemePreset({
    required this.id,
    required this.name,
    required this.theme,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  ThemePresetType get presetType => ThemePresetType.single;

  final ThemeVariant<TTokens> theme;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) => theme;
}

/// A preset with distinct light and dark variants.
class LightDarkThemePreset<TTokens> extends ThemePreset<TTokens> {
  const LightDarkThemePreset({
    required this.id,
    required this.name,
    required this.light,
    required this.dark,
  });

  @override
  final String id;

  @override
  final String name;

  @override
  ThemePresetType get presetType => ThemePresetType.lightDark;

  final ThemeVariant<TTokens> light;
  final ThemeVariant<TTokens> dark;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

@Deprecated('Use ThemePreset instead.')
typedef ThemeVariantEntry<TTokens> = ThemePreset<TTokens>;

@Deprecated('Use SingleThemePreset instead.')
typedef SingleThemeVariant<TTokens> = SingleThemePreset<TTokens>;

@Deprecated('Use LightDarkThemePreset instead.')
typedef LightDarkThemeVariant<TTokens> = LightDarkThemePreset<TTokens>;
