import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';

ThemeVariant<AppTokens> appTheme({
  required String id,
  required Brightness brightness,
  required String name,
  required Color primary,
}) {
  return ThemeVariant(
    id: id,
    themeData: ThemeData(
      brightness: brightness,
      colorSchemeSeed: primary,
      useMaterial3: true,
    ),
    tokens: AppTokens(
      name: name,
      radius: brightness == Brightness.dark ? 20 : 8,
      primary: primary,
    ),
  );
}
