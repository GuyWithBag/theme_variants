/// Builds a style value from the active theme tokens.
typedef ThemeVariantBuilder<TTokens, TValue> = TValue Function(TTokens tokens);

/// Applies one immutable style change to a resolved style value.
typedef StylePart<TValue> = TValue Function(TValue value);

/// Builds style parts from the active theme tokens.
typedef ThemeVariantPartsBuilder<TTokens, TValue> =
    Iterable<StylePart<TValue>> Function(TTokens tokens);

/// Merges two style values of the same type.
typedef ThemeVariantMerger<TValue> = TValue Function(TValue base, TValue next);
