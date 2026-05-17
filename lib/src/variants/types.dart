/// Builds a style value from the active theme tokens.
typedef ThemeVariantBuilder<TTokens, TValue> = TValue Function(TTokens tokens);

/// Merges two style values of the same type.
typedef ThemeVariantMerger<TValue> = TValue Function(TValue base, TValue next);
