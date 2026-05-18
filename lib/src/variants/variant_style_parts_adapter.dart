import 'compound_variant.dart';
import 'variant_style.dart';

VariantStyle<TTokens, TValue> partsVariantStyle<TTokens, TValue>({
  required TValue seed,
  required ThemeVariantMerger<TValue> merge,
  required ThemeVariantPartsBuilder<TTokens, TValue> base,
  required Map<Object, ThemeVariantPartsBuilder<TTokens, TValue>> variants,
  required Iterable<Object> defaultVariants,
  required Iterable<CompoundVariantParts<TTokens, TValue>> compoundVariants,
}) {
  return VariantStyle<TTokens, TValue>(
    base: partsBuilder(seed, base),
    merge: merge,
    variants: partsVariants(seed, variants),
    defaultVariants: defaultVariants,
    compoundVariants: partsCompounds(seed, compoundVariants),
  );
}

ThemeVariantBuilder<TTokens, TValue> partsBuilder<TTokens, TValue>(
  TValue seed,
  ThemeVariantPartsBuilder<TTokens, TValue> build,
) {
  return (tokens) => applyStyleParts(seed, build(tokens));
}

Map<Object, ThemeVariantBuilder<TTokens, TValue>>
partsVariants<TTokens, TValue>(
  TValue seed,
  Map<Object, ThemeVariantPartsBuilder<TTokens, TValue>> variants,
) {
  return variants.map(
    (variant, build) => MapEntry(variant, partsBuilder(seed, build)),
  );
}

List<CompoundVariant<TTokens, TValue>> partsCompounds<TTokens, TValue>(
  TValue seed,
  Iterable<CompoundVariantParts<TTokens, TValue>> compoundVariants,
) {
  return [
    for (final compound in compoundVariants)
      CompoundVariant<TTokens, TValue>(
        when: compound.when,
        build: (tokens) => applyStyleParts(seed, compound.build(tokens)),
      ),
  ];
}
