# Theme System

The theme system is intentionally small.

It has four core types:

```text
ThemeVariant<TTokens>
ThemeVariantEntry<TTokens>
ThemeVariantRegistry<TTokens>
ThemeVariantsController<TTokens>
```

## ThemeVariant

File:

```text
lib/src/theme/theme_variant.dart
```

`ThemeVariant<TTokens>` is just a named pair:

```dart
class ThemeVariant<TTokens> {
  final String id;
  final ThemeData themeData;
  final TTokens tokens;
}
```

`ThemeData` is Flutter's native theme object.

`tokens` is whatever the app wants:

```dart
typedef AppTokens = ({
  Color primary,
  double radius,
});
```

or:

```dart
class AppTokens {
  const AppTokens({required this.primary, required this.radius});

  final Color primary;
  final double radius;
}
```

## ThemeVariantEntry

File:

```text
lib/src/theme/theme_variant_entry.dart
```

`ThemeVariantEntry<TTokens>` is an abstract thing that can resolve to a concrete
`ThemeVariant<TTokens>` for a brightness.

There are two implementations:

```dart
SingleThemeVariant(theme)
```

Use this when one theme works for both light and dark.

```dart
LightDarkThemeVariant(light: lightTheme, dark: darkTheme)
```

Use this when a named theme has separate light/dark variants.

## ThemeVariantRegistry

File:

```text
lib/src/theme/theme_variant_registry.dart
```

The registry maps ids to entries:

```dart
final registry = ThemeVariantRegistry<AppTokens>(
  themes: {
    'clean': LightDarkThemeVariant(
      light: cleanLight,
      dark: cleanDark,
    ),
    'mono': SingleThemeVariant(monoTheme),
  },
);
```

It exposes:

```dart
registry.contains('clean');
registry.ids;
registry.resolve(id: 'clean', brightness: Brightness.light);
```

If an id is missing, it throws an `ArgumentError` with available ids.

## ThemeVariantsController

File:

```text
lib/src/controller/theme_variants_controller.dart
```

The controller is a `ChangeNotifier`.

It owns:

```text
registry
lightThemeId
darkThemeId
themeMode
transform
```

The important methods:

```dart
controller.lightTheme();
controller.darkTheme();
controller.activeTheme(platformBrightness);
controller.setLightTheme('clean');
controller.setDarkTheme('mono');
controller.setThemeMode(ThemeMode.system);
controller.setTransform(transform);
```

## Transform

`transform` lets an app customize a resolved theme without mutating the
registered theme.

Use cases:

- user-selected primary color
- custom font
- accessibility mode
- reduced contrast mode

The registry remains immutable. The controller resolves a theme, then applies
the transform before returning it.

## Provider And Context

Files:

```text
lib/src/widgets/theme_variants_provider.dart
lib/src/widgets/theme_variants_context.dart
```

Use `ThemeVariantsProvider` near the app root:

```dart
ThemeVariantsProvider<AppTokens>(
  controller: controller,
  child: MaterialApp(...),
)
```

Inside widgets:

```dart
final controller = context.themeVariantsController<AppTokens>();
final activeTheme = context.activeThemeVariant<AppTokens>();
final tokens = context.themeTokens<AppTokens>();
```

## Override

File:

```text
lib/src/widgets/theme_variants_override.dart
```

`ThemeVariantsOverride` creates a nested controller for a subtree.

Use it for previews, cards, editors, and embedded surfaces:

```dart
ThemeVariantsOverride<AppTokens>(
  lightThemeId: 'forest',
  darkThemeId: 'mono',
  themeMode: ThemeMode.light,
  child: const PreviewCard(),
)
```

If an id is omitted, it follows the parent controller.

If `enabled` is false, it returns `child` directly and inherits the nearest
parent provider.
