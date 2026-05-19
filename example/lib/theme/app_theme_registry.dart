import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';

const AppTokens cleanLightTokens = (
  primary: Colors.blue,
  onPrimary: Colors.white,
  danger: Colors.red,
  onDanger: Colors.white,
  radius: 8.0,
  borderWidth: 1.0,
  spaceSm: 8.0,
  spaceMd: 12.0,
  spaceLg: 18.0,
);

const AppTokens cleanDarkTokens = (
  primary: Colors.indigo,
  onPrimary: Colors.white,
  danger: Colors.redAccent,
  onDanger: Colors.black,
  radius: 8.0,
  borderWidth: 1.0,
  spaceSm: 8.0,
  spaceMd: 12.0,
  spaceLg: 18.0,
);

const AppTokens forestLightTokens = (
  primary: Colors.green,
  onPrimary: Colors.white,
  danger: Colors.deepOrange,
  onDanger: Colors.white,
  radius: 16.0,
  borderWidth: 1.5,
  spaceSm: 10.0,
  spaceMd: 14.0,
  spaceLg: 22.0,
);

const AppTokens forestDarkTokens = (
  primary: Colors.teal,
  onPrimary: Colors.black,
  danger: Colors.orangeAccent,
  onDanger: Colors.black,
  radius: 16.0,
  borderWidth: 1.5,
  spaceSm: 10.0,
  spaceMd: 14.0,
  spaceLg: 22.0,
);

const AppTokens monoTokens = (
  primary: Colors.black,
  onPrimary: Colors.white,
  danger: Colors.black87,
  onDanger: Colors.white,
  radius: 0.0,
  borderWidth: 2.0,
  spaceSm: 8.0,
  spaceMd: 12.0,
  spaceLg: 16.0,
);

final appThemeRegistry = ThemeVariantRegistry<AppTokens>(
  themes: {
    'clean': LightDarkThemeVariant(
      light: ThemeVariant(
        id: 'clean-light',
        name: 'Clean Light',
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        tokens: cleanLightTokens,
      ),
      dark: ThemeVariant(
        id: 'clean-dark',
        name: 'Clean Dark',
        themeData: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        tokens: cleanDarkTokens,
      ),
    ),
    'forest': LightDarkThemeVariant(
      light: ThemeVariant(
        id: 'forest-light',
        name: 'Forest Light',
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        tokens: forestLightTokens,
      ),
      dark: ThemeVariant(
        id: 'forest-dark',
        name: 'Forest Dark',
        themeData: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
        ),
        tokens: forestDarkTokens,
      ),
    ),
    'mono': SingleThemeVariant(
      ThemeVariant(
        id: 'mono',
        name: 'Mono',
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.black,
          useMaterial3: true,
        ),
        tokens: monoTokens,
      ),
    ),
  },
);
