import 'package:flutter/material.dart';

/// Builds a style value from the active theme tokens.
typedef ThemeVariantBuilder<TTokens, TValue> = TValue Function(TTokens tokens);

/// Merges two style values of the same type.
typedef ThemeVariantMerger<TValue> = TValue Function(TValue base, TValue next);

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

/// A theme entry that can resolve to light and dark variants.
abstract class ThemeVariantEntry<TTokens> {
  const ThemeVariantEntry();

  ThemeVariant<TTokens> resolve(Brightness brightness);
}

/// A theme entry that uses the same theme for light and dark brightness.
class SingleThemeVariant<TTokens> extends ThemeVariantEntry<TTokens> {
  const SingleThemeVariant(this.theme);

  final ThemeVariant<TTokens> theme;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) => theme;
}

/// A theme entry with distinct light and dark variants.
class LightDarkThemeVariant<TTokens> extends ThemeVariantEntry<TTokens> {
  const LightDarkThemeVariant({required this.light, required this.dark});

  final ThemeVariant<TTokens> light;
  final ThemeVariant<TTokens> dark;

  @override
  ThemeVariant<TTokens> resolve(Brightness brightness) {
    return brightness == Brightness.dark ? dark : light;
  }
}

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

/// Exposes a [ThemeVariantsController] to the widget tree.
class ThemeVariantsProvider<TTokens>
    extends InheritedNotifier<ThemeVariantsController<TTokens>> {
  const ThemeVariantsProvider({
    required ThemeVariantsController<TTokens> controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  static ThemeVariantsController<TTokens> controllerOf<TTokens>(
    BuildContext context, {
    bool listen = true,
  }) {
    if (listen) {
      final provider = context
          .dependOnInheritedWidgetOfExactType<ThemeVariantsProvider<TTokens>>();
      if (provider == null) {
        throw FlutterError(
          'No ThemeVariantsProvider<$TTokens> found in the widget tree.',
        );
      }
      return provider.notifier!;
    }

    final element = context
        .getElementForInheritedWidgetOfExactType<
          ThemeVariantsProvider<TTokens>
        >();
    final provider = element?.widget as ThemeVariantsProvider<TTokens>?;
    if (provider == null) {
      throw FlutterError(
        'No ThemeVariantsProvider<$TTokens> found in the widget tree.',
      );
    }
    return provider.notifier!;
  }

  static ThemeVariant<TTokens> activeThemeOf<TTokens>(
    BuildContext context, {
    bool listen = true,
  }) {
    final controller = controllerOf<TTokens>(context, listen: listen);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    return controller.activeTheme(platformBrightness);
  }

  static TTokens tokensOf<TTokens>(BuildContext context, {bool listen = true}) {
    return activeThemeOf<TTokens>(context, listen: listen).tokens;
  }
}

/// A typed, CVA-like style resolver.
class VariantStyle<TTokens, TValue> {
  const VariantStyle({
    required this.base,
    required this.merge,
    this.variants = const {},
    this.defaultVariants = const [],
    this.compoundVariants = const [],
  });

  final ThemeVariantBuilder<TTokens, TValue> base;
  final ThemeVariantMerger<TValue> merge;
  final Map<Object, ThemeVariantBuilder<TTokens, TValue>> variants;
  final Iterable<Object> defaultVariants;
  final Iterable<CompoundVariant<TTokens, TValue>> compoundVariants;

  TValue resolve(
    TTokens tokens, [
    Iterable<Object> selectedVariants = const [],
  ]) {
    final selected = {...defaultVariants, ...selectedVariants};

    var result = base(tokens);

    for (final variant in selected) {
      final builder = variants[variant];
      if (builder != null) {
        result = merge(result, builder(tokens));
      }
    }

    for (final compound in compoundVariants) {
      if (compound.matches(selected)) {
        result = merge(result, compound.build(tokens));
      }
    }

    return result;
  }
}

/// A style applied when every required variant is selected.
class CompoundVariant<TTokens, TValue> {
  const CompoundVariant({required this.when, required this.build});

  final Set<Object> when;
  final ThemeVariantBuilder<TTokens, TValue> build;

  bool matches(Set<Object> selectedVariants) {
    return selectedVariants.containsAll(when);
  }
}

/// Convenience merger for [TextStyle].
TextStyle mergeTextStyle(TextStyle base, TextStyle next) => base.merge(next);

/// Convenience merger for [ButtonStyle].
ButtonStyle mergeButtonStyle(ButtonStyle base, ButtonStyle next) {
  return base.merge(next);
}
