import 'package:flutter/material.dart';

/// A named app theme with Material [ThemeData] and user-defined tokens.
class ThemeVariant<TTokens> {
  const ThemeVariant({
    required this.id,
    required this.themeData,
    required this.tokens,
  });

  final String id;
  final ThemeData themeData;
  final TTokens tokens;
}
