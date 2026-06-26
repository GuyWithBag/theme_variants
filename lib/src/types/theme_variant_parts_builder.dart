import 'package:theme_variants/theme_variants.dart';

/// Builds style parts from the active theme tokens.
typedef ThemeVariantPartsBuilder<TTokens, TValue> =
    Iterable<StylePart<TValue>> Function(TTokens tokens);
