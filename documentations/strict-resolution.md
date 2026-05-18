# Strict Resolution

`VariantStyle.resolve` is strict by default.

This is intentional. Silent styling failures are hard to debug.

## What Throws

`resolve` throws when:

- a selected variant is not registered in `variants`
- a default variant is not registered in `variants`
- two default variants have the same Dart type
- two selected variants have the same Dart type
- a compound variant references an unregistered variant

## Unknown Selected Variant

This throws:

```dart
final style = VariantStyle.text<AppTokens>(
  base: (_) => const TextStyle(),
  variants: {
    ButtonSize.md: (_) => const TextStyle(fontSize: 14),
  },
);

style.resolve(tokens, const [ButtonSize.lg]);
```

`ButtonSize.lg` is not registered.

## Unknown Default Variant

This throws:

```dart
final style = VariantStyle.text<AppTokens>(
  base: (_) => const TextStyle(),
  defaultVariants: const [ButtonSize.md],
  variants: {
    ButtonSize.lg: (_) => const TextStyle(fontSize: 18),
  },
);

style.resolve(tokens);
```

`ButtonSize.md` is a default but is missing from `variants`.

## Duplicate Defaults

This throws:

```dart
defaultVariants: const [ButtonSize.sm, ButtonSize.md]
```

Both are `ButtonSize`.

Only one default value is allowed per variant group.

## Duplicate Selected Variants

This throws:

```dart
style.resolve(tokens, const [ButtonSize.sm, ButtonSize.lg]);
```

Both are `ButtonSize`.

The resolver cannot know which size you intended.

## Invalid Compound Variant

This throws:

```dart
compoundVariants: [
  CompoundVariant(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => const TextStyle(fontWeight: FontWeight.w700),
  ),
],
variants: {
  ButtonSize.lg: (_) => const TextStyle(fontSize: 18),
}
```

`ButtonTone.danger` is referenced by the compound variant but is not registered.

## Why Strict

Permissive behavior makes typos look like styling bugs:

```dart
style.resolve(tokens, const [ButtonTone.dnager])
```

If unknown variants are ignored, the UI quietly renders the wrong style.

Strict mode fails at the source of the bug.
