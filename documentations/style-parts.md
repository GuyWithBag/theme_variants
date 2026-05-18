# Style Parts

Style parts are the readability layer.

They let recipe builders return small typed fragments instead of full Flutter
style objects.

## The Problem

Without parts, a decoration recipe looks like this:

```dart
final decoration = VariantStyle.decoration<AppTokens>(
  base: (tokens) => BoxDecoration(
    color: tokens.background,
    borderRadius: BorderRadius.circular(tokens.radius),
    border: Border.all(color: tokens.border),
  ),
  variants: {
    ButtonTone.primary: (tokens) => BoxDecoration(
      color: tokens.primary,
      border: Border.all(color: tokens.primary),
    ),
  },
);
```

This is correct, but repetitive. Every variant has to construct a
`BoxDecoration`.

## The Parts API

With parts:

```dart
final decoration = VariantStyle.decorationParts<AppTokens>(
  base: (tokens) => {
    DecorationPart.color(tokens.background),
    DecorationPart.radius(tokens.radius),
    DecorationPart.border(Border.all(color: tokens.border)),
  },
  variants: {
    ButtonTone.primary: (tokens) => {
      DecorationPart.color(tokens.primary),
      DecorationPart.border(Border.all(color: tokens.primary)),
    },
  },
);
```

The recipe still resolves to `BoxDecoration`.

The widget code does not change:

```dart
Container(
  decoration: decoration.resolve(tokens, const [ButtonTone.primary]),
)
```

## What A StylePart Is

File:

```text
lib/src/variants/types.dart
```

The type is:

```dart
typedef StylePart<TValue> = TValue Function(TValue value);
```

A style part receives the current style object and returns an updated copy.

This:

```dart
DecorationPart.color(Colors.red)
```

is effectively:

```dart
(decoration) => decoration.copyWith(color: Colors.red)
```

## How Parts Become Styles

File:

```text
lib/src/variants/variant_style_parts_adapter.dart
```

The adapter starts with an empty seed object:

```dart
const BoxDecoration()
```

Then it applies every part in order:

```dart
TValue applyStyleParts<TValue>(
  TValue base,
  Iterable<StylePart<TValue>> parts,
) {
  return parts.fold(base, (value, part) => part(value));
}
```

So:

```dart
{
  DecorationPart.color(Colors.red),
  DecorationPart.radius(12),
}
```

becomes:

```dart
const BoxDecoration()
  .copyWith(color: Colors.red)
  .copyWith(borderRadius: BorderRadius.circular(12))
```

## Parts Constructors

Every existing shortcut has a parts version:

```text
buttonParts
textParts
textThemeParts
iconParts
inputDecorationParts
listTileParts
cardParts
chipParts
navigationBarParts
tabBarParts
decorationParts
```

## CompoundVariantParts

Object-style recipes use:

```dart
CompoundVariant<AppTokens, TextStyle>
```

Parts-style recipes use:

```dart
CompoundVariantParts<AppTokens, TextStyle>
```

Example:

```dart
compoundVariants: [
  CompoundVariantParts<AppTokens, TextStyle>(
    when: const {ButtonSize.lg, ButtonTone.danger},
    build: (_) => {
      TextStylePart.fontWeight(FontWeight.w700),
    },
  ),
],
```

## When To Use Parts

Use parts when:

- the style object is verbose
- variants only change a few fields
- readability matters more than micro-performance

Use direct constructors when:

- the style is tiny
- this is a hot path
- the variant needs to construct a complete object anyway

Both APIs resolve through the same `VariantStyle` engine.
