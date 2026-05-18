import 'compound_variant.dart';
import 'variant_style.dart';
import 'variant_style_parts_adapter.dart';

VariantStyle<TTokens, TValue> createVariantStyle<TTokens, TValue>({
  required ThemeVariantBuilder<TTokens, TValue> base,
  required ThemeVariantMerger<TValue> merge,
  Map<Object, ThemeVariantBuilder<TTokens, TValue>> variants = const {},
  Iterable<Object> defaultVariants = const [],
  Iterable<CompoundVariant<TTokens, TValue>> compoundVariants = const [],
}) {
  return VariantStyle<TTokens, TValue>(
    base: base,
    merge: merge,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );
}

VariantStyle<TTokens, TValue> createPartsVariantStyle<TTokens, TValue>({
  required TValue seed,
  required ThemeVariantPartsBuilder<TTokens, TValue> base,
  required ThemeVariantMerger<TValue> merge,
  Map<Object, ThemeVariantPartsBuilder<TTokens, TValue>> variants = const {},
  Iterable<Object> defaultVariants = const [],
  Iterable<CompoundVariantParts<TTokens, TValue>> compoundVariants = const [],
}) {
  return partsVariantStyle(
    seed: seed,
    merge: merge,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );
}
