import 'package:flutter/material.dart';

/// The brightness slot a [ThemeVariant] occupies inside a theme preset.
enum ThemeVariantBrightness { single, light, dark }

/// A concrete theme payload within a theme preset.
class ThemeVariant<TTokens> {
  const ThemeVariant({
    required this.themePresetId,
    required this.brightness,
    required this.themeData,
    required this.tokens,
  });

  final String themePresetId;
  final ThemeVariantBrightness brightness;
  final ThemeData themeData;
  final TTokens tokens;
}
