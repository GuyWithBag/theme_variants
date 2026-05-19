import 'package:flutter/material.dart';

import '../theme/theme_variant.dart';
import '../theme/theme_variant_entry.dart';
import '../theme/theme_variant_registry.dart';

/// Transforms a resolved theme before it is returned by the controller.
typedef ThemeVariantTransformer<TTokens> =
    ThemeVariant<TTokens> Function(ThemeVariant<TTokens> theme);

/// Controls the selected light and dark themes independently.
class ThemeVariantsController<TTokens> extends ChangeNotifier {
  ThemeVariantsController({
    required ThemeVariantRegistry<TTokens> registry,
    required String lightThemeId,
    required String darkThemeId,
    ThemeMode themeMode = ThemeMode.system,
    ThemeVariantTransformer<TTokens>? transform,
  }) : _registry = registry,
       _lightThemeId = lightThemeId,
       _darkThemeId = darkThemeId,
       _themeMode = themeMode,
       _transform = transform {
    _assertRegistered(lightThemeId);
    _assertRegistered(darkThemeId);
  }

  ThemeVariantRegistry<TTokens> _registry;
  String _lightThemeId;
  String _darkThemeId;
  ThemeMode _themeMode;
  ThemeVariantTransformer<TTokens>? _transform;

  ThemeVariantRegistry<TTokens> get registry => _registry;

  String get lightThemeId => _lightThemeId;

  String get darkThemeId => _darkThemeId;

  ThemeMode get themeMode => _themeMode;

  ThemeVariantTransformer<TTokens>? get transform => _transform;

  set registry(ThemeVariantRegistry<TTokens> value) {
    if (identical(value, _registry)) return;

    _registry = value;
    _assertRegistered(_lightThemeId);
    _assertRegistered(_darkThemeId);
    notifyListeners();
  }

  void setLightTheme(String id) {
    _assertRegistered(id);
    if (id == _lightThemeId) return;

    _lightThemeId = id;
    notifyListeners();
  }

  void setDarkTheme(String id) {
    _assertRegistered(id);
    if (id == _darkThemeId) return;

    _darkThemeId = id;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();
  }

  void setTransform(ThemeVariantTransformer<TTokens>? transform) {
    if (identical(transform, _transform)) return;

    _transform = transform;
    notifyListeners();
  }

  ThemeVariant<TTokens> lightTheme() {
    return _applyTransform(
      _registry.resolve(id: _lightThemeId, brightness: Brightness.light),
    );
  }

  ThemeVariant<TTokens> getCurrentLightTheme() => lightTheme();

  ThemeVariant<TTokens> darkTheme() {
    return _applyTransform(
      _registry.resolve(id: _darkThemeId, brightness: Brightness.dark),
    );
  }

  ThemeVariant<TTokens> getCurrentDarkTheme() => darkTheme();

  ThemeVariant<TTokens> activeTheme(Brightness platformBrightness) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };

    return brightness == Brightness.dark ? darkTheme() : lightTheme();
  }

  ThemeVariant<TTokens> getCurrentTheme(Brightness platformBrightness) {
    return activeTheme(platformBrightness);
  }

  ThemePreset<TTokens> lightThemePreset() {
    return _registry.preset(_lightThemeId);
  }

  ThemePreset<TTokens> getCurrentLightThemePreset() => lightThemePreset();

  ThemePreset<TTokens> darkThemePreset() {
    return _registry.preset(_darkThemeId);
  }

  ThemePreset<TTokens> getCurrentDarkThemePreset() => darkThemePreset();

  ThemePreset<TTokens> activeThemePreset(Brightness platformBrightness) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };

    return brightness == Brightness.dark
        ? darkThemePreset()
        : lightThemePreset();
  }

  ThemePreset<TTokens> getCurrentThemePreset(Brightness platformBrightness) {
    return activeThemePreset(platformBrightness);
  }

  ThemeVariant<TTokens> _applyTransform(ThemeVariant<TTokens> theme) {
    final transform = _transform;
    return transform == null ? theme : transform(theme);
  }

  void _assertRegistered(String id) {
    if (!_registry.contains(id)) {
      throw ArgumentError.value(id, 'id', 'No theme preset is registered.');
    }
  }
}
