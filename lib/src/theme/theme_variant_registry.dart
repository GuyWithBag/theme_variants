import 'package:flutter/material.dart';

import 'theme_variant.dart';
import 'theme_preset.dart';

/// Determines how imported presets are applied to an existing registry.
enum ThemeImportMode { addOnly, replaceAndAdd, replaceOnly }

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

  /// Returns a new registry with one preset added or replaced by id.
  ThemeVariantRegistry<TTokens> addTheme(ThemePreset<TTokens> preset) {
    final next = Map<String, ThemePreset<TTokens>>.from(presets);
    next[preset.id] = preset;
    return ThemeVariantRegistry<TTokens>(presets: next.values);
  }

  /// Returns a new registry with all provided presets added or replaced by id.
  ThemeVariantRegistry<TTokens> addThemes(
    Iterable<ThemePreset<TTokens>> values,
  ) {
    final next = Map<String, ThemePreset<TTokens>>.from(presets);
    for (final preset in values) {
      next[preset.id] = preset;
    }
    return ThemeVariantRegistry<TTokens>(presets: next.values);
  }

  /// Returns a new registry with one preset removed by id.
  ThemeVariantRegistry<TTokens> removeTheme(String id) {
    if (!presets.containsKey(id)) return this;
    final next = Map<String, ThemePreset<TTokens>>.from(presets)..remove(id);
    return ThemeVariantRegistry<TTokens>(presets: next.values);
  }

  /// Returns a new registry with all provided ids removed.
  ThemeVariantRegistry<TTokens> removeThemes(Iterable<String> ids) {
    final next = Map<String, ThemePreset<TTokens>>.from(presets);
    var changed = false;
    for (final id in ids) {
      changed = next.remove(id) != null || changed;
    }
    if (!changed) return this;
    return ThemeVariantRegistry<TTokens>(presets: next.values);
  }

  /// Returns an empty registry.
  ThemeVariantRegistry<TTokens> clear() {
    return ThemeVariantRegistry<TTokens>(presets: const []);
  }

  /// Exports all presets to serializable maps.
  List<Map<String, Object?>> exportThemes({
    required ThemeVariantMapEncoder<TTokens> encodeVariant,
  }) {
    return [
      for (final preset in getThemes())
        preset.toMap(encodeVariant: encodeVariant),
    ];
  }

  /// Imports presets from maps and returns a new registry based on [mode].
  ThemeVariantRegistry<TTokens> importThemes(
    Iterable<Map<String, Object?>> maps, {
    required ThemeVariantMapDecoder<TTokens> decodeVariant,
    ThemeImportMode mode = ThemeImportMode.replaceAndAdd,
  }) {
    final imported = [
      for (final map in maps)
        ThemePreset.fromMap<TTokens>(map, decodeVariant: decodeVariant),
    ];

    final next = switch (mode) {
      ThemeImportMode.addOnly => _applyAddOnly(imported),
      ThemeImportMode.replaceAndAdd => _applyReplaceAndAdd(imported),
      ThemeImportMode.replaceOnly => _applyReplaceOnly(imported),
    };

    return ThemeVariantRegistry<TTokens>(presets: next.values);
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

  Map<String, ThemePreset<TTokens>> _applyAddOnly(
    Iterable<ThemePreset<TTokens>> imported,
  ) {
    final next = Map<String, ThemePreset<TTokens>>.from(presets);
    for (final preset in imported) {
      next.putIfAbsent(preset.id, () => preset);
    }
    return next;
  }

  Map<String, ThemePreset<TTokens>> _applyReplaceAndAdd(
    Iterable<ThemePreset<TTokens>> imported,
  ) {
    final next = Map<String, ThemePreset<TTokens>>.from(presets);
    for (final preset in imported) {
      next[preset.id] = preset;
    }
    return next;
  }

  Map<String, ThemePreset<TTokens>> _applyReplaceOnly(
    Iterable<ThemePreset<TTokens>> imported,
  ) {
    return {for (final preset in imported) preset.id: preset};
  }
}
