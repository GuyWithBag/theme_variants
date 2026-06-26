import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Describes whether a theme preset has one theme or separate light/dark themes.
enum ThemePresetType { single, lightDark }

/// Codec used to serialize [ThemeVariant] payloads for persistence.
typedef ThemeVariantMapEncoder<TTokens> =
    Map<String, Object?> Function(ThemeVariant<TTokens> variant);

/// Codec used to deserialize [ThemeVariant] payloads for persistence.
typedef ThemeVariantMapDecoder<TTokens> =
    ThemeVariant<TTokens> Function(Map<String, Object?> map);

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

  /// Serializes this preset into a map using a variant encoder.
  Map<String, Object?> toMap({
    required ThemeVariantMapEncoder<TTokens> encodeVariant,
  });

  /// Deserializes a preset from a map using a variant decoder.
  static ThemePreset<TTokens> fromMap<TTokens>(
    Map<String, Object?> map, {
    required ThemeVariantMapDecoder<TTokens> decodeVariant,
  }) {
    final rawId = map['id'];
    final rawName = map['name'];
    final rawType = map['preset_type'];
    if (rawId is! String) {
      throw ArgumentError.value(rawId, 'map[id]', 'id must be a String.');
    }
    if (rawName is! String) {
      throw ArgumentError.value(rawName, 'map[name]', 'name must be a String.');
    }
    if (rawType is! String) {
      throw ArgumentError.value(
        rawType,
        'map[preset_type]',
        'preset_type must be a String.',
      );
    }

    return switch (rawType) {
      'single' => SingleThemePreset<TTokens>(
        id: rawId,
        name: rawName,
        theme: decodeVariant(_asMap(map['theme'], 'theme')),
      ),
      'light_dark' => LightDarkThemePreset<TTokens>(
        id: rawId,
        name: rawName,
        light: decodeVariant(_asMap(map['light'], 'light')),
        dark: decodeVariant(_asMap(map['dark'], 'dark')),
      ),
      _ => throw ArgumentError.value(
        rawType,
        'map[preset_type]',
        'Unsupported preset_type value.',
      ),
    };
  }
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

  @override
  Map<String, Object?> toMap({
    required ThemeVariantMapEncoder<TTokens> encodeVariant,
  }) {
    return {
      'id': id,
      'name': name,
      'preset_type': 'single',
      'theme': encodeVariant(theme),
    };
  }
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

  @override
  Map<String, Object?> toMap({
    required ThemeVariantMapEncoder<TTokens> encodeVariant,
  }) {
    return {
      'id': id,
      'name': name,
      'preset_type': 'light_dark',
      'light': encodeVariant(light),
      'dark': encodeVariant(dark),
    };
  }
}

Map<String, Object?> _asMap(Object? value, String fieldName) {
  if (value is Map<String, Object?>) return value;
  if (value is Map) {
    return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
  }
  throw ArgumentError.value(
    value,
    'map[$fieldName]',
    '$fieldName must be a map.',
  );
}
