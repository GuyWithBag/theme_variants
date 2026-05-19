import 'package:flutter/material.dart';

import 'theme_variant.dart';

/// Describes whether a theme preset has one theme or separate light/dark themes.
enum ThemePresetType { single, lightDark }

/// A named theme preset that can resolve to a concrete [ThemeVariant].
abstract class ThemePreset<TTokens> {
  const ThemePreset();

  /// Stable identifier for the preset.
  String get id;

  /// User-facing preset name.
  String get name;

  /// Preset shape: single theme or light/dark pair.
  ThemePresetType get presetType;

  /// Resolves the concrete variant for a requested [brightness].
  ThemeVariant<TTokens> resolve(Brightness brightness);
}

/// A preset that uses the same theme for light and dark brightness.
class SingleThemePreset<TTokens> extends ThemePreset<TTokens> {
  /// Creates a preset that serves one variant for all brightness modes.
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

  /// The only variant produced by this preset.
  final ThemeVariant<TTokens> theme;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) => theme;
}

/// A preset with distinct light and dark variants.
class LightDarkThemePreset<TTokens> extends ThemePreset<TTokens> {
  /// Creates a preset with separate light and dark variants.
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

  /// Variant used when resolving [Brightness.light].
  final ThemeVariant<TTokens> light;

  /// Variant used when resolving [Brightness.dark].
  final ThemeVariant<TTokens> dark;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}
