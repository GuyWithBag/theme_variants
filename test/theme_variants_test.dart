import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

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
      final style = VariantStyle<TestTokens, ButtonStyle>(
        base: (_) => const ButtonStyle(),
        merge: mergeButtonStyle,
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
