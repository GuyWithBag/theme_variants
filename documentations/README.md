# theme_variants Documentation

This folder explains the internal structure of `theme_variants`.

Read these in order:

1. [Architecture](architecture.md)
2. [Theme System](theme-system.md)
3. [Variant System](variant-system.md)
4. [Style Parts](style-parts.md)
5. [Strict Resolution](strict-resolution.md)
6. [Performance](performance.md)
7. [Maintainer Guide](maintainer-guide.md)

The short version:

- `ThemeVariant<TTokens>` pairs Flutter `ThemeData` with app-owned typed tokens.
- `ThemeVariantRegistry` stores named theme entries.
- `ThemeVariantsController` chooses light/dark theme ids and a `ThemeMode`.
- `ThemeVariantsProvider` exposes the controller to widgets.
- `VariantStyle<TTokens, TValue>` resolves reusable component styles.
- `...Parts` constructors let style recipes return small typed fragments instead
  of full Flutter style objects.
