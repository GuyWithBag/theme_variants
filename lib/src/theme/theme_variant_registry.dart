import 'package:flutter/material.dart';

import 'theme_variant.dart';
import 'theme_variant_entry.dart';

/// Stores all named themes an app can choose from.
class ThemeVariantRegistry<TTokens> {
  const ThemeVariantRegistry({required this.themes});

  final Map<String, ThemeVariantEntry<TTokens>> themes;

  Iterable<String> get ids => themes.keys;

  bool contains(String id) => themes.containsKey(id);

  ThemeVariant<TTokens> resolve({
    required String id,
    required Brightness brightness,
  }) {
    final entry = themes[id];
    if (entry == null) {
      final available = ids.isEmpty ? 'none' : ids.join(', ');
      throw ArgumentError.value(
        id,
        'id',
        'No theme variant is registered. Available ids: $available.',
      );
    }

    return entry.resolve(brightness);
  }
}
