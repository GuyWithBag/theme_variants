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

  /// Active registry used to resolve preset ids into concrete themes.
  ThemeVariantRegistry<TTokens> get registry => _registry;

  /// Selected preset id for light mode.
  String get lightThemeId => _lightThemeId;

  /// Selected preset id for dark mode.
  String get darkThemeId => _darkThemeId;

  /// Current theme mode policy.
  ThemeMode get themeMode => _themeMode;

  /// Optional transform applied to resolved variants.
  ThemeVariantTransformer<TTokens>? get transform => _transform;

  /// Replaces the registry and validates selected preset ids.
  set registry(ThemeVariantRegistry<TTokens> value) {
    if (identical(value, _registry)) return;

    _registry = value;
    _assertRegistered(_lightThemeId);
    _assertRegistered(_darkThemeId);
    notifyListeners();
  }

  /// Selects the preset id used for light mode.
  void setLightTheme(String id) {
    _assertRegistered(id);
    if (id == _lightThemeId) return;

    _lightThemeId = id;
    notifyListeners();
  }

  /// Selects the preset id used for dark mode.
  void setDarkTheme(String id) {
    _assertRegistered(id);
    if (id == _darkThemeId) return;

    _darkThemeId = id;
    notifyListeners();
  }

  /// Updates the active [ThemeMode].
  void setThemeMode(ThemeMode mode) {
    if (mode == _themeMode) return;

    _themeMode = mode;
    notifyListeners();
  }

  /// Updates the optional variant transform.
  void setTransform(ThemeVariantTransformer<TTokens>? transform) {
    if (identical(transform, _transform)) return;

    _transform = transform;
    notifyListeners();
  }

  /// Resolves the current light-mode variant.
  ThemeVariant<TTokens> getCurrentLightTheme() {
    return _applyTransform(
      _registry.resolve(id: _lightThemeId, brightness: Brightness.light),
    );
  }

  /// Resolves the current light-mode variant.
  ThemeVariant<TTokens> lightTheme() => getCurrentLightTheme();

  /// Resolves the current dark-mode variant.
  ThemeVariant<TTokens> getCurrentDarkTheme() {
    return _applyTransform(
      _registry.resolve(id: _darkThemeId, brightness: Brightness.dark),
    );
  }

  /// Resolves the current dark-mode variant.
  ThemeVariant<TTokens> darkTheme() => getCurrentDarkTheme();

  /// Resolves the active variant based on [platformBrightness] and [themeMode].
  ThemeVariant<TTokens> getCurrentTheme(Brightness platformBrightness) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };

    return brightness == Brightness.dark
        ? getCurrentDarkTheme()
        : getCurrentLightTheme();
  }

  /// Resolves the active variant based on [platformBrightness] and [themeMode].
  ThemeVariant<TTokens> activeTheme(Brightness platformBrightness) {
    return getCurrentTheme(platformBrightness);
  }

  /// Returns the selected light-mode preset definition.
  ThemePreset<TTokens> getCurrentLightThemePreset() {
    return _registry.getPreset(_lightThemeId);
  }

  /// Returns the selected dark-mode preset definition.
  ThemePreset<TTokens> getCurrentDarkThemePreset() {
    return _registry.getPreset(_darkThemeId);
  }

  /// Returns the active preset definition for [platformBrightness].
  ThemePreset<TTokens> getCurrentThemePreset(Brightness platformBrightness) {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };

    return brightness == Brightness.dark
        ? getCurrentDarkThemePreset()
        : getCurrentLightThemePreset();
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
