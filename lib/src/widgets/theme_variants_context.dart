import 'package:flutter/material.dart';

import '../controller/theme_variants_controller.dart';
import '../theme/theme_variant.dart';
import '../theme/theme_preset.dart';
import 'theme_variants_provider.dart';

/// Convenience accessors for theme variants from a [BuildContext].
extension ThemeVariantsContext on BuildContext {
  /// Returns the nearest theme variants controller.
  ThemeVariantsController<TTokens> themeVariantsController<TTokens>({
    bool listen = true,
  }) {
    return ThemeVariantsProvider.controllerOf<TTokens>(this, listen: listen);
  }

  /// Resolves the currently active concrete theme variant.
  ThemeVariant<TTokens> activeThemeVariant<TTokens>({bool listen = true}) {
    return ThemeVariantsProvider.themeOf<TTokens>(this, listen: listen);
  }

  /// Resolves the currently active preset definition.
  ThemePreset<TTokens> activeThemePreset<TTokens>({bool listen = true}) {
    return ThemeVariantsProvider.themePresetOf<TTokens>(this, listen: listen);
  }

  /// Returns active theme tokens.
  TTokens themeTokens<TTokens>({bool listen = true}) {
    return ThemeVariantsProvider.tokensOf<TTokens>(this, listen: listen);
  }
}
