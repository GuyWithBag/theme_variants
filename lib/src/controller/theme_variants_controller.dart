import 'package:flutter/material.dart';

import '../theme/theme_variant.dart';
import '../theme/theme_preset.dart';
import '../theme/theme_variant_registry.dart';

/// Transforms a resolved theme before it is returned by the controller.
typedef ThemeVariantTransformer<TTokens> =
    ThemeVariant<TTokens> Function(ThemeVariant<TTokens> theme);

/// Codec used to serialize [ThemeData] values.
typedef ThemeDataMapEncoder = Object? Function(ThemeData themeData);

/// Codec used to deserialize [ThemeData] values.
typedef ThemeDataMapDecoder = ThemeData Function(Object? rawThemeData);

/// Codec used to serialize token payloads.
typedef ThemeTokensMapEncoder<TTokens> = Object? Function(TTokens tokens);

/// Codec used to deserialize token payloads.
typedef ThemeTokensMapDecoder<TTokens> = TTokens Function(Object? rawTokens);

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

  /// Adds one preset to the registry.
  void addTheme(ThemePreset<TTokens> preset) {
    registry = _registry.addTheme(preset);
  }

  /// Adds multiple presets to the registry.
  void addThemes(Iterable<ThemePreset<TTokens>> presets) {
    registry = _registry.addThemes(presets);
  }

  /// Removes one preset by id.
  void removeTheme(String id) {
    final next = _registry.removeTheme(id);
    if (identical(next, _registry)) return;
    _registry = next;
    _repairSelectedIdsAfterRegistryChange();
    notifyListeners();
  }

  /// Removes multiple presets by id.
  void removeThemes(Iterable<String> ids) {
    final next = _registry.removeThemes(ids);
    if (identical(next, _registry)) return;
    _registry = next;
    _repairSelectedIdsAfterRegistryChange();
    notifyListeners();
  }

  /// Clears all presets from the registry.
  void clearThemes() {
    _registry = _registry.clear();
    _lightThemeId = '';
    _darkThemeId = '';
    notifyListeners();
  }

  /// Exports controller state and preset definitions to a map.
  Map<String, Object?> toMap({
    required ThemeDataMapEncoder encodeThemeData,
    required ThemeTokensMapEncoder<TTokens> encodeTokens,
  }) {
    return {
      'light_theme_id': _lightThemeId,
      'dark_theme_id': _darkThemeId,
      'theme_mode': _themeMode.name,
      'presets': [
        for (final preset in _registry.getThemes())
          preset.toMap(
            encodeVariant: (variant) => variant.toMap(
              encodeThemeData: encodeThemeData,
              encodeTokens: encodeTokens,
            ),
          ),
      ],
    };
  }

  /// Exports only theme presets.
  List<Map<String, Object?>> exportThemes({
    required ThemeDataMapEncoder encodeThemeData,
    required ThemeTokensMapEncoder<TTokens> encodeTokens,
  }) {
    return _registry.exportThemes(
      encodeVariant: (variant) => variant.toMap(
        encodeThemeData: encodeThemeData,
        encodeTokens: encodeTokens,
      ),
    );
  }

  /// Imports controller state and preset definitions from a map.
  void fromMap(
    Map<String, Object?> map, {
    required ThemeDataMapDecoder decodeThemeData,
    required ThemeTokensMapDecoder<TTokens> decodeTokens,
    bool replaceExisting = true,
  }) {
    final presets = _parsePresetsFromMap(
      map,
      decodeThemeData: decodeThemeData,
      decodeTokens: decodeTokens,
    );
    _registry = replaceExisting
        ? ThemeVariantRegistry<TTokens>(presets: presets)
        : _registry.addThemes(presets);

    final importedLightId = map['light_theme_id'];
    final importedDarkId = map['dark_theme_id'];
    if (importedLightId is String) {
      _lightThemeId = importedLightId;
    }
    if (importedDarkId is String) {
      _darkThemeId = importedDarkId;
    }

    final importedMode = map['theme_mode'];
    if (importedMode is String) {
      _themeMode = switch (importedMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => _themeMode,
      };
    }

    _repairSelectedIdsAfterRegistryChange();
    notifyListeners();
  }

  /// Imports only theme presets using [mode].
  void importThemes(
    Iterable<Map<String, Object?>> themes, {
    required ThemeDataMapDecoder decodeThemeData,
    required ThemeTokensMapDecoder<TTokens> decodeTokens,
    ThemeImportMode mode = ThemeImportMode.replaceAndAdd,
  }) {
    _registry = _registry.importThemes(
      themes,
      decodeVariant: (variantMap) => ThemeVariant.fromMap<TTokens>(
        variantMap,
        decodeThemeData: decodeThemeData,
        decodeTokens: decodeTokens,
      ),
      mode: mode,
    );
    _repairSelectedIdsAfterRegistryChange();
    notifyListeners();
  }

  void _assertRegistered(String id) {
    if (!_registry.contains(id)) {
      throw ArgumentError.value(id, 'id', 'No theme preset is registered.');
    }
  }

  void _repairSelectedIdsAfterRegistryChange() {
    final fallbackId = _firstPresetId();
    if (_lightThemeId.isEmpty || !_registry.contains(_lightThemeId)) {
      _lightThemeId = fallbackId ?? '';
    }
    if (_darkThemeId.isEmpty || !_registry.contains(_darkThemeId)) {
      _darkThemeId = fallbackId ?? '';
    }
  }

  String? _firstPresetId() {
    final iterator = _registry.ids.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }

  List<ThemePreset<TTokens>> _parsePresetsFromMap(
    Map<String, Object?> map, {
    required ThemeDataMapDecoder decodeThemeData,
    required ThemeTokensMapDecoder<TTokens> decodeTokens,
  }) {
    final rawPresets = map['presets'];
    if (rawPresets is! Iterable) {
      throw ArgumentError.value(
        rawPresets,
        'map[presets]',
        'presets must be an iterable.',
      );
    }

    return [
      for (final item in rawPresets)
        ThemePreset.fromMap<TTokens>(
          _toStringObjectMap(item, 'presets[]'),
          decodeVariant: (variantMap) => ThemeVariant.fromMap<TTokens>(
            variantMap,
            decodeThemeData: decodeThemeData,
            decodeTokens: decodeTokens,
          ),
        ),
    ];
  }

  static Map<String, Object?> _toStringObjectMap(Object? value, String field) {
    if (value is Map<String, Object?>) return value;
    if (value is Map) {
      return value.map((key, mapValue) => MapEntry(key.toString(), mapValue));
    }
    throw ArgumentError.value(value, field, 'Must be a map.');
  }
}
