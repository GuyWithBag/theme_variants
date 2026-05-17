import 'compound_variant.dart';
import 'types.dart';

export 'types.dart';

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
    final selected = _resolveSelectedVariants(selectedVariants);

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

  Set<Object> _resolveSelectedVariants(Iterable<Object> selectedVariants) {
    final selected = [...defaultVariants];

    for (final variant in selectedVariants) {
      selected.removeWhere((defaultVariant) {
        return defaultVariant.runtimeType == variant.runtimeType;
      });
      selected.add(variant);
    }

    return selected.toSet();
  }
}
