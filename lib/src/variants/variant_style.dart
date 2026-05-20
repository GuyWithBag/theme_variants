import 'package:flutter/material.dart';
import 'variant_style_factories.dart';

export 'style_parts.dart';
import 'package:theme_variants/theme_variants.dart';

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

  static VariantStyle<TTokens, ButtonStyle> button<TTokens>({
    required ThemeVariantBuilder<TTokens, ButtonStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, ButtonStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ButtonStyle>> compoundVariants = const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeButtonStyle,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ButtonStyle> buttonParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, ButtonStyle> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, ButtonStyle>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, ButtonStyle>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const ButtonStyle(),
    merge: mergeButtonStyle,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TextStyle> text<TTokens>({
    required ThemeVariantBuilder<TTokens, TextStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, TextStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TextStyle>> compoundVariants = const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeTextStyle,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TextStyle> textParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, TextStyle> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, TextStyle>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, TextStyle>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const TextStyle(),
    merge: mergeTextStyle,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TextTheme> textTheme<TTokens>({
    required ThemeVariantBuilder<TTokens, TextTheme> base,
    Map<Object, ThemeVariantBuilder<TTokens, TextTheme>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TextTheme>> compoundVariants = const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeTextTheme,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TextTheme> textThemeParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, TextTheme> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, TextTheme>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, TextTheme>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const TextTheme(),
    merge: mergeTextTheme,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, IconThemeData> icon<TTokens>({
    required ThemeVariantBuilder<TTokens, IconThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, IconThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, IconThemeData>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeIconThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, IconThemeData> iconParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, IconThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, IconThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, IconThemeData>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const IconThemeData(),
    merge: mergeIconThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

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
  }) => createVariantStyle(
    base: base,
    merge: mergeInputDecorationThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, InputDecorationThemeData>
  inputDecorationParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, InputDecorationThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, InputDecorationThemeData>>
        variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, InputDecorationThemeData>>
        compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const InputDecorationThemeData(),
    merge: mergeInputDecorationThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ListTileThemeData> listTile<TTokens>({
    required ThemeVariantBuilder<TTokens, ListTileThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, ListTileThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ListTileThemeData>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeListTileThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ListTileThemeData> listTileParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, ListTileThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, ListTileThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, ListTileThemeData>>
        compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const ListTileThemeData(),
    merge: mergeListTileThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, CardThemeData> card<TTokens>({
    required ThemeVariantBuilder<TTokens, CardThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, CardThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, CardThemeData>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeCardThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, CardThemeData> cardParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, CardThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, CardThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, CardThemeData>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const CardThemeData(),
    merge: mergeCardThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ChipThemeData> chip<TTokens>({
    required ThemeVariantBuilder<TTokens, ChipThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, ChipThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ChipThemeData>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeChipThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ChipThemeData> chipParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, ChipThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, ChipThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, ChipThemeData>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const ChipThemeData(),
    merge: mergeChipThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, NavigationBarThemeData> navigationBar<TTokens>({
    required ThemeVariantBuilder<TTokens, NavigationBarThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, NavigationBarThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, NavigationBarThemeData>>
        compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeNavigationBarThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, NavigationBarThemeData>
  navigationBarParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, NavigationBarThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, NavigationBarThemeData>>
        variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, NavigationBarThemeData>>
        compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const NavigationBarThemeData(),
    merge: mergeNavigationBarThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TabBarThemeData> tabBar<TTokens>({
    required ThemeVariantBuilder<TTokens, TabBarThemeData> base,
    Map<Object, ThemeVariantBuilder<TTokens, TabBarThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, TabBarThemeData>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeTabBarThemeData,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, TabBarThemeData> tabBarParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, TabBarThemeData> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, TabBarThemeData>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, TabBarThemeData>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const TabBarThemeData(),
    merge: mergeTabBarThemeData,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, BoxDecoration> decoration<TTokens>({
    required ThemeVariantBuilder<TTokens, BoxDecoration> base,
    Map<Object, ThemeVariantBuilder<TTokens, BoxDecoration>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, BoxDecoration>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeBoxDecoration,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, BoxDecoration> decorationParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, BoxDecoration> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, BoxDecoration>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, BoxDecoration>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const BoxDecoration(),
    merge: mergeBoxDecoration,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, SurfaceStyle> surface<TTokens>({
    required ThemeVariantBuilder<TTokens, SurfaceStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, SurfaceStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, SurfaceStyle>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeSurfaceStyle,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, SurfaceStyle> surfaceParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, SurfaceStyle> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, SurfaceStyle>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, SurfaceStyle>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const SurfaceStyle(),
    merge: mergeSurfaceStyle,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ContentStyle> content<TTokens>({
    required ThemeVariantBuilder<TTokens, ContentStyle> base,
    Map<Object, ThemeVariantBuilder<TTokens, ContentStyle>> variants = const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariant<TTokens, ContentStyle>> compoundVariants =
        const [],
  }) => createVariantStyle(
    base: base,
    merge: mergeContentStyle,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  static VariantStyle<TTokens, ContentStyle> contentParts<TTokens>({
    required ThemeVariantPartsBuilder<TTokens, ContentStyle> base,
    Map<Object, ThemeVariantPartsBuilder<TTokens, ContentStyle>> variants =
        const {},
    Iterable<Object> defaultVariants = const [],
    Iterable<CompoundVariantParts<TTokens, ContentStyle>> compoundVariants =
        const [],
  }) => createPartsVariantStyle(
    seed: const ContentStyle(),
    merge: mergeContentStyle,
    base: base,
    variants: variants,
    defaultVariants: defaultVariants,
    compoundVariants: compoundVariants,
  );

  TValue resolve(
    TTokens tokens, [
    Iterable<Object> selectedVariants = const [],
  ]) {
    _validateRecipe();
    _validateSelectedVariants(selectedVariants);
    final selected = _resolveSelectedVariants(selectedVariants);

    var result = base(tokens);

    for (final variant in selected) {
      result = merge(result, variants[variant]!(tokens));
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

  void _validateRecipe() {
    final knownVariants = variants.keys.toSet();

    for (final variant in defaultVariants) {
      if (!knownVariants.contains(variant)) {
        throw StateError(
          'Default variant $variant is not registered in variants.',
        );
      }
    }

    final defaultGroups = <Type, Object>{};
    for (final variant in defaultVariants) {
      final previous = defaultGroups[variant.runtimeType];
      if (previous != null) {
        throw StateError(
          'Default variants $previous and $variant have the same type '
          '${variant.runtimeType}. Use only one default variant per type.',
        );
      }
      defaultGroups[variant.runtimeType] = variant;
    }

    for (final compound in compoundVariants) {
      for (final variant in compound.when) {
        if (!knownVariants.contains(variant)) {
          throw StateError(
            'Compound variant references $variant, but it is not registered '
            'in variants.',
          );
        }
      }
    }
  }

  void _validateSelectedVariants(Iterable<Object> selectedVariants) {
    final selectedGroups = <Type, Object>{};

    for (final variant in selectedVariants) {
      if (!variants.containsKey(variant)) {
        throw ArgumentError.value(
          variant,
          'selectedVariants',
          'Variant is not registered.',
        );
      }

      final previous = selectedGroups[variant.runtimeType];
      if (previous != null) {
        throw ArgumentError.value(
          variant,
          'selectedVariants',
          'Variant has the same type as $previous. Use only one selected '
              'variant per type.',
        );
      }
      selectedGroups[variant.runtimeType] = variant;
    }
  }
}
