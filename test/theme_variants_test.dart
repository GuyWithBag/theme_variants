import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

enum CardTone { neutral, highlighted }

class TestTokens {
  const TestTokens({
    required this.name,
    required this.radius,
    required this.primary,
  });

  final String name;
  final double radius;
  final Color primary;
}

ThemeVariant<TestTokens> theme(
  String id,
  Brightness brightness,
  String tokenName,
) {
  return ThemeVariant<TestTokens>(
    id: id,
    themeData: ThemeData(brightness: brightness),
    tokens: TestTokens(
      name: tokenName,
      radius: brightness == Brightness.dark ? 16 : 8,
      primary: brightness == Brightness.dark ? Colors.indigo : Colors.blue,
    ),
  );
}

void main() {
  group('ThemeVariantRegistry', () {
    test('resolves single themes for both brightnesses', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'minimal': SingleThemeVariant(
            theme('minimal', Brightness.light, 'minimal'),
          ),
        },
      );

      expect(
        registry
            .resolve(id: 'minimal', brightness: Brightness.light)
            .tokens
            .name,
        'minimal',
      );
      expect(
        registry
            .resolve(id: 'minimal', brightness: Brightness.dark)
            .tokens
            .name,
        'minimal',
      );
    });

    test('resolves light and dark theme pairs', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'brand': LightDarkThemeVariant(
            light: theme('brand-light', Brightness.light, 'brand light'),
            dark: theme('brand-dark', Brightness.dark, 'brand dark'),
          ),
        },
      );

      expect(
        registry.resolve(id: 'brand', brightness: Brightness.light).tokens.name,
        'brand light',
      );
      expect(
        registry.resolve(id: 'brand', brightness: Brightness.dark).tokens.name,
        'brand dark',
      );
    });
  });

  group('ThemeVariantsController', () {
    test('uses independently selected light and dark themes', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': LightDarkThemeVariant(
            light: theme('clean-light', Brightness.light, 'clean light'),
            dark: theme('clean-dark', Brightness.dark, 'clean dark'),
          ),
          'midnight': SingleThemeVariant(
            theme('midnight', Brightness.dark, 'midnight'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'midnight',
      );

      expect(controller.lightTheme().tokens.name, 'clean light');
      expect(controller.darkTheme().tokens.name, 'midnight');
    });

    test('resolves active theme from ThemeMode', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': LightDarkThemeVariant(
            light: theme('clean-light', Brightness.light, 'clean light'),
            dark: theme('clean-dark', Brightness.dark, 'clean dark'),
          ),
          'midnight': SingleThemeVariant(
            theme('midnight', Brightness.dark, 'midnight'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'midnight',
      );

      expect(controller.activeTheme(Brightness.dark).tokens.name, 'midnight');

      controller.setThemeMode(ThemeMode.light);

      expect(
        controller.activeTheme(Brightness.dark).tokens.name,
        'clean light',
      );
    });

    test('applies theme transforms to resolved themes', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        transform: (theme) {
          return ThemeVariant<TestTokens>(
            id: theme.id,
            themeData: theme.themeData.copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
            ),
            tokens: TestTokens(
              name: '${theme.tokens.name} customized',
              radius: 24,
              primary: Colors.purple,
            ),
          );
        },
      );

      final resolved = controller.lightTheme();

      expect(resolved.tokens.name, 'clean customized');
      expect(resolved.tokens.radius, 24);
      expect(resolved.tokens.primary, Colors.purple);
    });
  });

  group('ThemeVariantsProvider', () {
    testWidgets('exposes active tokens from context', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: Builder(
            builder: (context) {
              final tokens = ThemeVariantsProvider.tokensOf<TestTokens>(
                context,
              );
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text(tokens.name),
              );
            },
          ),
        ),
      );

      expect(find.text('clean'), findsOneWidget);
    });

    testWidgets('exposes active tokens through context extension', (
      tester,
    ) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: Builder(
            builder: (context) {
              final tokens = context.themeTokens<TestTokens>();
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text(tokens.name),
              );
            },
          ),
        ),
      );

      expect(find.text('clean'), findsOneWidget);
    });

    testWidgets('override can provide a separate subtree theme', (
      tester,
    ) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
          'card': SingleThemeVariant(theme('card', Brightness.light, 'card')),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: ThemeVariantsOverride<TestTokens>(
            lightThemeId: 'card',
            darkThemeId: 'card',
            child: Builder(
              builder: (context) {
                final tokens = context.themeTokens<TestTokens>();
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(tokens.name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('card'), findsOneWidget);
    });

    testWidgets('disabled override inherits the parent theme', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
          'card': SingleThemeVariant(theme('card', Brightness.light, 'card')),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: ThemeVariantsOverride<TestTokens>(
            enabled: false,
            lightThemeId: 'card',
            darkThemeId: 'card',
            child: Builder(
              builder: (context) {
                final tokens = context.themeTokens<TestTokens>();
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(tokens.name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('clean'), findsOneWidget);
    });

    testWidgets('override can fix its own brightness mode', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': LightDarkThemeVariant(
            light: theme('clean-light', Brightness.light, 'clean light'),
            dark: theme('clean-dark', Brightness.dark, 'clean dark'),
          ),
          'card': LightDarkThemeVariant(
            light: theme('card-light', Brightness.light, 'card light'),
            dark: theme('card-dark', Brightness.dark, 'card dark'),
          ),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        themeMode: ThemeMode.dark,
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.dark),
            child: ThemeVariantsOverride<TestTokens>(
              lightThemeId: 'card',
              darkThemeId: 'card',
              themeMode: ThemeMode.light,
              child: Builder(
                builder: (context) {
                  final tokens = context.themeTokens<TestTokens>();
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(tokens.name),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('card light'), findsOneWidget);
    });

    testWidgets('override inherits the parent theme transform', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        themes: {
          'clean': SingleThemeVariant(
            theme('clean', Brightness.light, 'clean'),
          ),
          'card': SingleThemeVariant(theme('card', Brightness.light, 'card')),
        },
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        transform: (theme) {
          return ThemeVariant<TestTokens>(
            id: theme.id,
            themeData: theme.themeData,
            tokens: TestTokens(
              name: '${theme.tokens.name} transformed',
              radius: theme.tokens.radius,
              primary: theme.tokens.primary,
            ),
          );
        },
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: ThemeVariantsOverride<TestTokens>(
            lightThemeId: 'card',
            darkThemeId: 'card',
            child: Builder(
              builder: (context) {
                final tokens = context.themeTokens<TestTokens>();
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(tokens.name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('card transformed'), findsOneWidget);
    });
  });

  group('VariantStyle', () {
    test('resolves typed variants and defaults', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle<TestTokens, TextStyle>(
        base: (_) => const TextStyle(fontSize: 14),
        merge: mergeTextStyle,
        defaultVariants: const [ButtonSize.md, ButtonTone.primary],
        variants: {
          ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
          ButtonSize.md: (_) => const TextStyle(fontSize: 14),
          ButtonSize.lg: (_) => const TextStyle(fontSize: 18),
          ButtonTone.primary: (tokens) => TextStyle(color: tokens.primary),
          ButtonTone.danger: (_) => const TextStyle(color: Colors.red),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonSize.lg]);

      expect(resolved.fontSize, 18);
      expect(resolved.color, Colors.blue);
    });

    test('explicit variants replace defaults from the same type', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle<TestTokens, TextStyle>(
        base: (_) => const TextStyle(),
        merge: mergeTextStyle,
        defaultVariants: const [ButtonTone.primary],
        variants: {
          ButtonTone.primary: (tokens) => TextStyle(color: tokens.primary),
          ButtonTone.danger: (_) => const TextStyle(color: Colors.red),
        },
        compoundVariants: [
          CompoundVariant(
            when: const {ButtonTone.primary, ButtonTone.danger},
            build: (_) => const TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      );

      final resolved = style.resolve(tokens, const [ButtonTone.danger]);

      expect(resolved.color, Colors.red);
      expect(resolved.decoration, isNull);
    });

    test('button style variants override earlier button style values', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.button<TestTokens>(
        base: (_) => const ButtonStyle(),
        defaultVariants: const [ButtonTone.primary],
        variants: {
          ButtonTone.primary: (tokens) => ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(tokens.primary),
          ),
          ButtonTone.danger: (_) => const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.danger]);

      expect(resolved.backgroundColor?.resolve({}), Colors.red);
    });

    test('text style constructor uses the text style merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.text<TestTokens>(
        base: (_) => const TextStyle(fontSize: 14),
        defaultVariants: const [ButtonTone.primary],
        variants: {
          ButtonTone.primary: (tokens) => TextStyle(color: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens);

      expect(resolved.fontSize, 14);
      expect(resolved.color, Colors.blue);
    });

    test('text theme constructor uses the text theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.textTheme<TestTokens>(
        base: (_) => const TextTheme(titleMedium: TextStyle(fontSize: 18)),
        variants: {
          ButtonTone.primary: (tokens) =>
              TextTheme(titleMedium: TextStyle(color: tokens.primary)),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.titleMedium?.fontSize, 18);
      expect(resolved.titleMedium?.color, Colors.blue);
    });

    test('icon constructor uses the icon theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.icon<TestTokens>(
        base: (_) => const IconThemeData(size: 20),
        variants: {
          ButtonTone.primary: (tokens) => IconThemeData(color: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.size, 20);
      expect(resolved.color, Colors.blue);
    });

    test('decoration constructor uses the box decoration merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.decoration<TestTokens>(
        base: (tokens) =>
            BoxDecoration(borderRadius: BorderRadius.circular(tokens.radius)),
        defaultVariants: const [CardTone.neutral],
        variants: {
          CardTone.neutral: (_) => const BoxDecoration(color: Colors.white),
          CardTone.highlighted: (tokens) =>
              BoxDecoration(color: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.color, Colors.blue);
      expect(resolved.borderRadius, BorderRadius.circular(12));
    });

    test('input decoration constructor uses the input theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.inputDecoration<TestTokens>(
        base: (_) =>
            const InputDecorationThemeData(contentPadding: EdgeInsets.all(12)),
        variants: {
          ButtonTone.primary: (tokens) =>
              InputDecorationThemeData(fillColor: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.contentPadding, const EdgeInsets.all(12));
      expect(resolved.fillColor, Colors.blue);
    });

    test('list tile constructor uses the list tile theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.listTile<TestTokens>(
        base: (_) =>
            const ListTileThemeData(contentPadding: EdgeInsets.all(12)),
        variants: {
          ButtonTone.primary: (tokens) =>
              ListTileThemeData(tileColor: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.contentPadding, const EdgeInsets.all(12));
      expect(resolved.tileColor, Colors.blue);
    });

    test('card constructor uses the card theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.card<TestTokens>(
        base: (_) => const CardThemeData(margin: EdgeInsets.all(12)),
        variants: {
          ButtonTone.primary: (tokens) => CardThemeData(color: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.margin, const EdgeInsets.all(12));
      expect(resolved.color, Colors.blue);
    });

    test('chip constructor uses the chip theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.chip<TestTokens>(
        base: (_) => const ChipThemeData(padding: EdgeInsets.all(12)),
        variants: {
          ButtonTone.primary: (tokens) =>
              ChipThemeData(backgroundColor: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.padding, const EdgeInsets.all(12));
      expect(resolved.backgroundColor, Colors.blue);
    });

    test('navigation bar constructor uses the navigation theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.navigationBar<TestTokens>(
        base: (_) => const NavigationBarThemeData(height: 72),
        variants: {
          ButtonTone.primary: (tokens) =>
              NavigationBarThemeData(backgroundColor: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.height, 72);
      expect(resolved.backgroundColor, Colors.blue);
    });

    test('tab bar constructor uses the tab bar theme merger', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle.tabBar<TestTokens>(
        base: (_) => const TabBarThemeData(labelPadding: EdgeInsets.all(12)),
        variants: {
          ButtonTone.primary: (tokens) =>
              TabBarThemeData(labelColor: tokens.primary),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.labelPadding, const EdgeInsets.all(12));
      expect(resolved.labelColor, Colors.blue);
    });

    test('applies compound variants when all required variants match', () {
      const tokens = TestTokens(name: 'test', radius: 12, primary: Colors.blue);
      final style = VariantStyle<TestTokens, TextStyle>(
        base: (_) => const TextStyle(fontSize: 14),
        merge: mergeTextStyle,
        variants: {
          ButtonSize.lg: (_) => const TextStyle(fontSize: 18),
          ButtonTone.danger: (_) => const TextStyle(color: Colors.red),
        },
        compoundVariants: [
          CompoundVariant(
            when: const {ButtonSize.lg, ButtonTone.danger},
            build: (_) => const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      );

      final resolved = style.resolve(tokens, const [
        ButtonSize.lg,
        ButtonTone.danger,
      ]);

      expect(resolved.fontSize, 18);
      expect(resolved.color, Colors.red);
      expect(resolved.fontWeight, FontWeight.w700);
    });
  });
}
