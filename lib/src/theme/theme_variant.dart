import 'package:flutter/material.dart';

/// The brightness slot a [ThemeVariant] occupies inside a theme preset.
enum ThemeVariantBrightness { single, light, dark }

/// A concrete theme payload within a theme preset.
class ThemeVariant<TTokens> {
  /// Creates a concrete theme variant that belongs to a preset.
  const ThemeVariant({
    required this.themePresetId,
    required this.brightness,
    required this.themeData,
    required this.tokens,
  });

  /// The parent preset id this variant belongs to.
  final String themePresetId;

  /// The slot this variant fills inside the preset.
  final ThemeVariantBrightness brightness;

  /// Material theme data resolved for this variant.
  final ThemeData themeData;

  /// User-defined theme tokens resolved for this variant.
  final TTokens tokens;
}
