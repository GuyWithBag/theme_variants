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
  presets: [
    LightDarkThemePreset(
      id: 'clean',
      name: 'Clean',
      light: ThemeVariant(
        themePresetId: 'clean',
        brightness: ThemeVariantBrightness.light,
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        ),
        tokens: cleanLightTokens,
      ),
      dark: ThemeVariant(
        themePresetId: 'clean',
        brightness: ThemeVariantBrightness.dark,
        themeData: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        tokens: cleanDarkTokens,
      ),
    ),
    LightDarkThemePreset(
      id: 'forest',
      name: 'Forest',
      light: ThemeVariant(
        themePresetId: 'forest',
        brightness: ThemeVariantBrightness.light,
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.green,
          useMaterial3: true,
        ),
        tokens: forestLightTokens,
      ),
      dark: ThemeVariant(
        themePresetId: 'forest',
        brightness: ThemeVariantBrightness.dark,
        themeData: ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.teal,
          useMaterial3: true,
        ),
        tokens: forestDarkTokens,
      ),
    ),
    SingleThemePreset(
      id: 'mono',
      name: 'Mono',
      theme: ThemeVariant(
        themePresetId: 'mono',
        brightness: ThemeVariantBrightness.single,
        themeData: ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.black,
          useMaterial3: true,
        ),
        tokens: monoTokens,
      ),
    ),
  ],
);
