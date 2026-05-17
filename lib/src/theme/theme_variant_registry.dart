import 'package:flutter/material.dart';

import 'theme_variant.dart';
import 'theme_variant_entry.dart';

/// Stores all named themes an app can choose from.
class ThemeVariantRegistry<TTokens> {
  const ThemeVariantRegistry({required this.themes});

  final Map<String, ThemeVariantEntry<TTokens>> themes;

  bool contains(String id) => themes.containsKey(id);

  ThemeVariant<TTokens> resolve({
    required String id,
    required Brightness brightness,
  }) {
    final entry = themes[id];
    if (entry == null) {
      throw ArgumentError.value(id, 'id', 'No theme variant is registered.');
    }

    return entry.resolve(brightness);
  }
}
