import 'package:theme_variants/theme_variants.dart';

class CompoundVariantParts<TTokens, TValue> {
  const CompoundVariantParts({required this.when, required this.build});

  final Set<Object> when;
  final ThemeVariantPartsBuilder<TTokens, TValue> build;
}

TValue applyStyleParts<TValue>(TValue base, Iterable<StylePart<TValue>> parts) {
  return parts.fold(base, (value, part) => part(value));
}
