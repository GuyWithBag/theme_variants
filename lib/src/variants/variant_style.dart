import 'package:flutter/material.dart';

import 'compound_variant.dart';
import 'mergers.dart';
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

  /// Creates a [ButtonStyle] variant resolver using the package's button merge.
  static VariantStyle<TTokens, ButtonStyle> button<TTokens>({
    required ThemeVariantBuilder<TTokens, ButtonStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, ButtonStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ButtonStyle>> compoundVariants = const [],
  }) {
    return VariantStyle<TTokens, ButtonStyle>(
      base: base,
      merge: mergeButtonStyle,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [TextStyle] variant resolver using the package's text merge.
  static VariantStyle<TTokens, TextStyle> text<TTokens>({
    required ThemeVariantBuilder<TTokens, TextStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, TextStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TextStyle>> compoundVariants = const [],
  }) {
    return VariantStyle<TTokens, TextStyle>(
      base: base,
      merge: mergeTextStyle,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

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
