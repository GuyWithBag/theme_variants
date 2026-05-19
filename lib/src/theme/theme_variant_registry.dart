import 'package:flutter/material.dart';

import 'theme_variant.dart';
import 'theme_variant_entry.dart';

/// Stores all named themes an app can choose from.
class ThemeVariantRegistry<TTokens> {
  /// Creates a registry from preset definitions, indexed by preset id.
  ThemeVariantRegistry({required Iterable<ThemePreset<TTokens>> presets})
    : presets = Map.unmodifiable(_indexPresets(presets));

  /// Presets indexed by id.
  final Map<String, ThemePreset<TTokens>> presets;

  /// All registered preset ids.
  Iterable<String> get ids => presets.keys;

  /// Whether a preset id exists in this registry.
  bool contains(String id) => presets.containsKey(id);

  /// Returns a preset by id or throws when missing.
  ThemePreset<TTokens> getPreset(String id) {
    final preset = presets[id];
    if (preset == null) {
      final available = ids.isEmpty ? 'none' : ids.join(', ');
      throw ArgumentError.value(
        id,
        'id',
        'No theme preset is registered. Available ids: $available.',
      );
    }

    return preset;
  }

  /// Returns all registered presets.
  Iterable<ThemePreset<TTokens>> getThemes() => presets.values;

  /// Returns variants resolved in light mode for all presets.
  Iterable<ThemeVariant<TTokens>> getLightThemes() {
    return presets.values.map((preset) => preset.resolve(Brightness.light));
  }

  /// Returns variants resolved in dark mode for all presets.
  Iterable<ThemeVariant<TTokens>> getDarkThemes() {
    return presets.values.map((preset) => preset.resolve(Brightness.dark));
  }

  /// Returns only presets with a single shared theme.
  Iterable<SingleThemePreset<TTokens>> getSingleThemes() {
    return presets.values.whereType<SingleThemePreset<TTokens>>();
  }

  /// Resolves a concrete variant by preset id and requested brightness.
  ThemeVariant<TTokens> resolve({
    required String id,
    required Brightness brightness,
  }) {
    return getPreset(id).resolve(brightness);
  }

  static Map<String, ThemePreset<TTokens>> _indexPresets<TTokens>(
    Iterable<ThemePreset<TTokens>> presets,
  ) {
    final indexed = <String, ThemePreset<TTokens>>{};

    for (final preset in presets) {
      final previous = indexed[preset.id];
      if (previous != null) {
        throw ArgumentError.value(
          preset.id,
          'presets',
          'Duplicate theme preset id used by ${previous.name} and '
              '${preset.name}.',
        );
      }
      indexed[preset.id] = preset;
    }

    return indexed;
  }
}
