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

  static ThemePreset<TTokens> activeThemePresetOf<TTokens>(
    BuildContext context, {
    bool listen = true,
  }) {
    final controller = controllerOf<TTokens>(context, listen: listen);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    return controller.activeThemePreset(platformBrightness);
  }

  static TTokens tokensOf<TTokens>(BuildContext context, {bool listen = true}) {
    return activeThemeOf<TTokens>(context, listen: listen).tokens;
  }
}
