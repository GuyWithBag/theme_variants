import 'package:flutter/material.dart';

import '../controller/theme_variants_controller.dart';
import '../theme/theme_variant.dart';
import 'theme_variants_provider.dart';

/// Convenience accessors for theme variants from a [BuildContext].
extension ThemeVariantsContext on BuildContext {
  ThemeVariantsController<TTokens> themeVariantsController<TTokens>({
    bool listen = true,
  }) {
    return ThemeVariantsProvider.controllerOf<TTokens>(this, listen: listen);
  }

  ThemeVariant<TTokens> activeThemeVariant<TTokens>({bool listen = true}) {
    return ThemeVariantsProvider.activeThemeOf<TTokens>(this, listen: listen);
  }

  TTokens themeTokens<TTokens>({bool listen = true}) {
    return ThemeVariantsProvider.tokensOf<TTokens>(this, listen: listen);
  }
}
