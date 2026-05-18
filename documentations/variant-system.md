# Variant System

The variant system is the CVA-inspired part of the package.

It resolves enum values into Flutter style objects.

## Core Type

File:

```text
lib/src/variants/variant_style.dart
```

The generic type is:

```dart
VariantStyle<TTokens, TValue>
```

`TTokens` is the app token type.

`TValue` is the resolved Flutter style object.

Examples:

```dart
VariantStyle<AppTokens, TextStyle>
VariantStyle<AppTokens, ButtonStyle>
VariantStyle<AppTokens, BoxDecoration>
```

## What A Recipe Contains

A recipe has:

```text
base
merge
variants
defaultVariants
compoundVariants
```

Example:

```dart
final textStyle = VariantStyle.text<AppTokens>(
  base: (_) => const TextStyle(fontSize: 14),
  defaultVariants: const [ButtonTone.primary],
  variants: {
    ButtonTone.primary: (tokens) => TextStyle(color: tokens.primary),
    ButtonTone.danger: (tokens) => TextStyle(color: tokens.danger),
  },
);
```

## Base

`base` always runs first.

It defines the default foundation of the style:

```dart
base: (_) => const TextStyle(fontSize: 14)
```

## Variants

`variants` maps enum values to style builders:

```dart
variants: {
  ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
  ButtonSize.lg: (_) => const TextStyle(fontSize: 18),
  ButtonTone.primary: (tokens) => TextStyle(color: tokens.primary),
}
```

The keys are `Object` because a recipe can combine different enum types:

```dart
ButtonSize.lg
ButtonTone.primary
ButtonState.disabled
```

## Default Variants

Defaults apply unless an explicit selected variant from the same enum/type group
replaces them.

```dart
defaultVariants: const [ButtonSize.md, ButtonTone.primary]
```

If this is resolved:

```dart
style.resolve(tokens, const [ButtonSize.lg])
```

the selected variants become:

```text
ButtonSize.lg
ButtonTone.primary
```

`ButtonSize.lg` replaces `ButtonSize.md` because they have the same
`runtimeType`.

## Variant Groups

A variant group is the Dart type of a variant value.

For enums:

```dart
ButtonSize.sm.runtimeType == ButtonSize
ButtonTone.primary.runtimeType == ButtonTone
```

So the intended pattern is:

```text
one enum per visual axis
```

Good:

```dart
enum ButtonSize { sm, md, lg }
enum ButtonTone { primary, danger }
```

Avoid mixing unrelated values into one enum:

```dart
enum ButtonVariant { sm, md, primary, danger }
```

That would make size and tone collide because all values share the same type.

## Compound Variants

Compound variants apply when all required variants are selected:

```dart
compoundVariants: [
  CompoundVariant<AppTokens, TextStyle>(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => const TextStyle(fontWeight: FontWeight.w700),
  ),
],
```

This is useful when a style depends on a combination, not a single axis.

## Merge

`merge` combines the current resolved style with the next style fragment.

For text:

```dart
TextStyle mergeTextStyle(TextStyle base, TextStyle next) => base.merge(next);
```

For decorations:

```dart
BoxDecoration mergeBoxDecoration(BoxDecoration base, BoxDecoration next) {
  return base.copyWith(
    color: next.color,
    border: next.border,
    borderRadius: next.borderRadius,
    boxShadow: next.boxShadow,
  );
}
```

The shortcut constructors choose the right merge function for you:

```dart
VariantStyle.text(...)
VariantStyle.button(...)
VariantStyle.decoration(...)
```

## Resolution Order

`resolve` does this:

1. Validate the recipe.
2. Validate selected variants.
3. Start with `base(tokens)`.
4. Apply default variants.
5. Replace defaults with explicit variants from the same type group.
6. Apply selected variant builders.
7. Apply matching compound variants.
8. Return the final Flutter style object.
