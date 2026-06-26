/// A style applied when every required variant is selected.
class CompoundVariant<TTokens, TValue> {
  const CompoundVariant({required this.when, required this.build});

  final Set<Object> when;
  final TValue Function(TTokens tokens) build;

  bool matches(Set<Object> selectedVariants) {
    return selectedVariants.containsAll(when);
  }
}
