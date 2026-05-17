import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';
import 'app_theme.dart';

final appThemeRegistry = ThemeVariantRegistry<AppTokens>(
  themes: {
    'clean': LightDarkThemeVariant(
      light: appTheme(
        id: 'clean-light',
        brightness: Brightness.light,
        name: 'Clean Light',
        primary: Colors.blue,
      ),
      dark: appTheme(
        id: 'clean-dark',
        brightness: Brightness.dark,
        name: 'Clean Dark',
        primary: Colors.indigo,
      ),
    ),
    'forest': LightDarkThemeVariant(
      light: appTheme(
        id: 'forest-light',
        brightness: Brightness.light,
        name: 'Forest Light',
        primary: Colors.green,
      ),
      dark: appTheme(
        id: 'forest-dark',
        brightness: Brightness.dark,
        name: 'Forest Dark',
        primary: Colors.teal,
      ),
    ),
    'mono': SingleThemeVariant(
      appTheme(
        id: 'mono',
        brightness: Brightness.light,
        name: 'Mono',
        primary: Colors.black,
      ),
    ),
  },
);
