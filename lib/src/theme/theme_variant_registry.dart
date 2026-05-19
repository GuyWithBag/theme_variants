import 'package:flutter/material.dart';

import 'theme_variant.dart';
import 'theme_variant_entry.dart';

/// Stores all named themes an app can choose from.
class ThemeVariantRegistry<TTokens> {
  ThemeVariantRegistry({required Iterable<ThemePreset<TTokens>> presets})
    : presets = Map.unmodifiable(_indexPresets(presets));

  final Map<String, ThemePreset<TTokens>> presets;

  Iterable<String> get ids => presets.keys;

  bool contains(String id) => presets.containsKey(id);

  ThemePreset<TTokens> preset(String id) {
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

  Iterable<ThemePreset<TTokens>> getThemes() => presets.values;

  Iterable<ThemeVariant<TTokens>> getLightThemes() {
    return presets.values.map((preset) => preset.resolve(Brightness.light));
  }

  Iterable<ThemeVariant<TTokens>> getDarkThemes() {
    return presets.values.map((preset) => preset.resolve(Brightness.dark));
  }

  Iterable<SingleThemePreset<TTokens>> getSingleThemes() {
    return presets.values.whereType<SingleThemePreset<TTokens>>();
  }

  ThemeVariant<TTokens> resolve({
    required String id,
    required Brightness brightness,
  }) {
    return preset(id).resolve(brightness);
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
