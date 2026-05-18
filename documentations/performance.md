# Performance

The package is designed for normal Flutter build-time style resolution.

It is not zero-cost, and it does not need to be.

## Direct Constructors

This is the fastest style recipe form:

```dart
VariantStyle.decoration<AppTokens>(
  base: (tokens) => BoxDecoration(
    color: tokens.background,
    borderRadius: BorderRadius.circular(tokens.radius),
  ),
)
```

It constructs the final Flutter style object directly.

## Parts Constructors

This is more readable, but does slightly more work:

```dart
VariantStyle.decorationParts<AppTokens>(
  base: (tokens) => {
    DecorationPart.color(tokens.background),
    DecorationPart.radius(tokens.radius),
  },
)
```

Internally it does something like:

```dart
const BoxDecoration()
  .copyWith(color: tokens.background)
  .copyWith(borderRadius: BorderRadius.circular(tokens.radius))
```

That means:

- extra function calls
- extra short-lived style objects
- set/list allocation for the returned parts

For typical UI, this overhead is not meaningful.

## Where It Can Matter

It can matter if you resolve many styles every frame:

- thousands of list items
- animation loops
- rebuilding dense grids repeatedly
- resolving many recipes inside every item builder

If profiling shows `VariantStyle.resolve` as hot, use one of these approaches.

## Use Direct Constructors In Hot Paths

For hot recipes, prefer:

```dart
VariantStyle.decoration(...)
```

over:

```dart
VariantStyle.decorationParts(...)
```

Direct object construction avoids intermediate `copyWith` calls.

## Pre-resolve Styles

Instead of resolving inside every child:

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return Item(
      style: itemStyle.resolve(tokens, const [ItemTone.primary]),
    );
  },
)
```

resolve once above:

```dart
final primaryItemStyle = itemStyle.resolve(
  tokens,
  const [ItemTone.primary],
);

ListView.builder(
  itemBuilder: (context, index) {
    return Item(style: primaryItemStyle);
  },
)
```

## Cache Carefully

Caching can help when the same style is resolved repeatedly with the same:

```text
tokens
selected variants
recipe
```

But caching is easy to get wrong because token objects may be:

- records
- classes
- transformed objects
- mutable by convention even if they should not be

Do not add package-level caching until profiling proves it is needed.

Apps can safely cache at the call site when they control token identity and
variant inputs.

## Practical Rule

Use parts for readability first.

Switch hot recipes to direct constructors only after profiling.
