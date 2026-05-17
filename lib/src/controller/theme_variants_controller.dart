import 'package:flutter/material.dart';

import '../theme/theme_variant.dart';
import '../theme/theme_variant_registry.dart';

/// Controls the selected light and dark themes independently.
class ThemeVariantsController<TTokens> extends ChangeNotifier {
  ThemeVariantsController({
    required ThemeVariantRegistry<TTokens> registry,
    required String lightThemeId,
    required String darkThemeId,
    ThemeMode themeMode = ThemeMode.system,
  }) : _registry = registry,
       _lightThemeId = lightThemeId,
       _darkThemeId = darkThemeId,
       _themeMode = themeMode {
    _assertRegistered(lightThemeId);
    _assertRegistered(darkThemeId);
  }

  ThemeVariantRegistry<TTokens> _registry;
  String _lightThemeId;
  String _darkThemeId;
  ThemeMode _themeMode;

  ThemeVariantRegistry<TTokens> get registry => _registry;

  String get lightThemeId => _lightThemeId;

  String get darkThemeId => _darkThemeId;

  ThemeMode get themeMode => _themeMode;

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

  ThemeVariant<TTokens> lightTheme() {
    return _registry.resolve(id: _lightThemeId, brightness: Brightness.light);
  }

  ThemeVariant<TTokens> darkTheme() {
    return _registry.resolve(id: _darkThemeId, brightness: Brightness.dark);
  }

  ThemeVariant<TTokens> activeTheme(Brightness platformBrightness) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };

    return brightness == Brightness.dark ? darkTheme() : lightTheme();
  }

  void _assertRegistered(String id) {
    if (!_registry.contains(id)) {
      throw ArgumentError.value(id, 'id', 'No theme variant is registered.');
    }
  }
}
