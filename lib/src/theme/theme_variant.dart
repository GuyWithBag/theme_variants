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

  /// Serializes this variant into a map using caller-provided codecs.
  Map<String, Object?> toMap({
    required Object? Function(ThemeData themeData) encodeThemeData,
    required Object? Function(TTokens tokens) encodeTokens,
  }) {
    return {
      'theme_preset_id': themePresetId,
      'brightness': brightness.name,
      'theme_data': encodeThemeData(themeData),
      'tokens': encodeTokens(tokens),
    };
  }

  /// Deserializes a variant from a map using caller-provided codecs.
  static ThemeVariant<TTokens> fromMap<TTokens>(
    Map<String, Object?> map, {
    required ThemeData Function(Object? rawThemeData) decodeThemeData,
    required TTokens Function(Object? rawTokens) decodeTokens,
  }) {
    final rawPresetId = map['theme_preset_id'];
    final rawBrightness = map['brightness'];
    if (rawPresetId is! String) {
      throw ArgumentError.value(
        rawPresetId,
        'map[theme_preset_id]',
        'theme_preset_id must be a String.',
      );
    }
    if (rawBrightness is! String) {
      throw ArgumentError.value(
        rawBrightness,
        'map[brightness]',
        'brightness must be a String.',
      );
    }

    return ThemeVariant<TTokens>(
      themePresetId: rawPresetId,
      brightness: parseThemeVariantBrightness(rawBrightness),
      themeData: decodeThemeData(map['theme_data']),
      tokens: decodeTokens(map['tokens']),
    );
  }
}

/// Parses a persisted brightness token into [ThemeVariantBrightness].
ThemeVariantBrightness parseThemeVariantBrightness(String value) {
  return switch (value) {
    'single' => ThemeVariantBrightness.single,
    'light' => ThemeVariantBrightness.light,
    'dark' => ThemeVariantBrightness.dark,
    _ => throw ArgumentError.value(
      value,
      'value',
      'Unsupported ThemeVariantBrightness value.',
    ),
  };
}
