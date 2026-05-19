import 'package:flutter/material.dart';

import '../controller/theme_variants_controller.dart';
import '../theme/theme_variant.dart';
import '../theme/theme_variant_entry.dart';

/// Exposes a [ThemeVariantsController] to the widget tree.
class ThemeVariantsProvider<TTokens>
    extends InheritedNotifier<ThemeVariantsController<TTokens>> {
  const ThemeVariantsProvider({
    required ThemeVariantsController<TTokens> controller,
    required super.child,
    super.key,
  }) : super(notifier: controller);

  /// Reads the nearest [ThemeVariantsController] from context.
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

  /// Resolves the currently active concrete theme variant from context.
  static ThemeVariant<TTokens> themeOf<TTokens>(
    BuildContext context, {
    bool listen = true,
  }) {
    final controller = controllerOf<TTokens>(context, listen: listen);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    return controller.getCurrentTheme(platformBrightness);
  }

  /// Resolves the currently active preset definition from context.
  static ThemePreset<TTokens> themePresetOf<TTokens>(
    BuildContext context, {
    bool listen = true,
  }) {
    final controller = controllerOf<TTokens>(context, listen: listen);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    return controller.getCurrentThemePreset(platformBrightness);
  }

  /// Reads active theme tokens from context.
  static TTokens tokensOf<TTokens>(BuildContext context, {bool listen = true}) {
    return themeOf<TTokens>(context, listen: listen).tokens;
  }
}
