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

  /// Creates a [TextTheme] variant resolver using the package's text theme merge.
  static VariantStyle<TTokens, TextTheme> textTheme<TTokens>({
    required ThemeVariantBuilder<TTokens, TextTheme> base,
    Map<Object, ThemeVariantBuilder<TTokens, TextTheme>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TextTheme>> compoundVariants = const [],
  }) {
    return VariantStyle<TTokens, TextTheme>(
      base: base,
      merge: mergeTextTheme,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates an [IconThemeData] variant resolver using the package's icon merge.
  static VariantStyle<TTokens, IconThemeData> icon<TTokens>({
    required ThemeVariantBuilder<TTokens, IconThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, IconThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, IconThemeData>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, IconThemeData>(
      base: base,
      merge: mergeIconThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates an [InputDecorationThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, InputDecorationThemeData>
  inputDecoration<TTokens>({
    required ThemeVariantBuilder<TTokens, InputDecorationThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, InputDecorationThemeData>>
        variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, InputDecorationThemeData>>
        compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, InputDecorationThemeData>(
      base: base,
      merge: mergeInputDecorationThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [ListTileThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, ListTileThemeData> listTile<TTokens>({
    required ThemeVariantBuilder<TTokens, ListTileThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, ListTileThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ListTileThemeData>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, ListTileThemeData>(
      base: base,
      merge: mergeListTileThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [CardThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, CardThemeData> card<TTokens>({
    required ThemeVariantBuilder<TTokens, CardThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, CardThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, CardThemeData>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, CardThemeData>(
      base: base,
      merge: mergeCardThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [ChipThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, ChipThemeData> chip<TTokens>({
    required ThemeVariantBuilder<TTokens, ChipThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, ChipThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ChipThemeData>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, ChipThemeData>(
      base: base,
      merge: mergeChipThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [NavigationBarThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, NavigationBarThemeData> navigationBar<TTokens>({
    required ThemeVariantBuilder<TTokens, NavigationBarThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, NavigationBarThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, NavigationBarThemeData>>
        compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, NavigationBarThemeData>(
      base: base,
      merge: mergeNavigationBarThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [TabBarThemeData] resolver using the package's merge.
  static VariantStyle<TTokens, TabBarThemeData> tabBar<TTokens>({
    required ThemeVariantBuilder<TTokens, TabBarThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, TabBarThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TabBarThemeData>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, TabBarThemeData>(
      base: base,
      merge: mergeTabBarThemeData,
      variants: variants,
      defaultVariants: defaultVariants,
      compoundVariants: compoundVariants,
    );
  }

  /// Creates a [BoxDecoration] variant resolver using the package's box merge.
  static VariantStyle<TTokens, BoxDecoration> decoration<TTokens>({
    required ThemeVariantBuilder<TTokens, BoxDecoration> base,
    Map<Object, ThemeVariantBuilder<TTokens, BoxDecoration>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, BoxDecoration>> compoundVariants =
        const [],
  }) {
    return VariantStyle<TTokens, BoxDecoration>(
      base: base,
      merge: mergeBoxDecoration,
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
