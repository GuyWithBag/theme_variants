import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:theme_variants/theme_variants.dart';

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

enum CardTone { neutral, highlighted }

enum ButtonDensity { compact }

class TestTokens {
  const TestTokens({required this.radius, required this.primary});

  final double radius;
  final Color primary;
}

ThemeVariant<TestTokens> theme(
  String themePresetId,
  ThemeVariantBrightness brightness,
) {
  final themeBrightness = brightness == ThemeVariantBrightness.dark
      ? Brightness.dark
      : Brightness.light;

  return ThemeVariant<TestTokens>(
    themePresetId: themePresetId,
    brightness: brightness,
    themeData: ThemeData(brightness: themeBrightness),
    tokens: TestTokens(
      radius: themeBrightness == Brightness.dark ? 16 : 8,
      primary: themeBrightness == Brightness.dark ? Colors.indigo : Colors.blue,
    ),
  );
}

SingleThemePreset<TestTokens> singlePreset(String id, String name) {
  return SingleThemePreset<TestTokens>(
    id: id,
    name: name,
    theme: theme(id, ThemeVariantBrightness.single),
  );
}

LightDarkThemePreset<TestTokens> lightDarkPreset(String id, String name) {
  return LightDarkThemePreset<TestTokens>(
    id: id,
    name: name,
    light: theme(id, ThemeVariantBrightness.light),
    dark: theme(id, ThemeVariantBrightness.dark),
  );
}

Widget surfaceTestProbe(BuildContext context) {
  final textStyle = DefaultTextStyle.of(context).style;
  final iconTheme = IconTheme.of(context);

  return Text(
    'text:${textStyle.color == Colors.white && textStyle.fontSize == 16} '
    'icon:${iconTheme.color == Colors.white && iconTheme.size == 20}',
  );
}

void main() {
  group('ThemeVariantRegistry', () {
    test('resolves single themes for both brightnesses', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('minimal', 'minimal')],
      );

      expect(
        registry
            .resolve(id: 'minimal', brightness: Brightness.light)
            .themePresetId,
        'minimal',
      );
      expect(
        registry.resolve(id: 'minimal', brightness: Brightness.dark).brightness,
        ThemeVariantBrightness.single,
      );
    });

    test('resolves light and dark theme pairs', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [lightDarkPreset('brand', 'Brand')],
      );

      expect(
        registry.resolve(id: 'brand', brightness: Brightness.light).brightness,
        ThemeVariantBrightness.light,
      );
      expect(
        registry.resolve(id: 'brand', brightness: Brightness.dark).brightness,
        ThemeVariantBrightness.dark,
      );
    });

    test('exposes registered ids', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean'), singlePreset('mono', 'mono')],
      );

      expect(registry.ids, containsAll(['clean', 'mono']));
    });

    test('unknown id errors include available ids', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean')],
      );

      expect(
        () => registry.resolve(id: 'missing', brightness: Brightness.light),
        throwsA(
          isA<ArgumentError>().having(
            (error) => error.message,
            'message',
            contains('Available ids: clean'),
          ),
        ),
      );
    });
  });

  group('ThemeVariantsController', () {
    test('uses independently selected light and dark themes', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [
          lightDarkPreset('clean', 'clean'),
          singlePreset('midnight', 'midnight'),
        ],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'midnight',
      );

      expect(controller.lightTheme().themePresetId, 'clean');
      expect(controller.darkTheme().themePresetId, 'midnight');
    });

    test('resolves active theme from ThemeMode', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [
          lightDarkPreset('clean', 'clean'),
          singlePreset('midnight', 'midnight'),
        ],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'midnight',
      );

      expect(controller.activeTheme(Brightness.dark).themePresetId, 'midnight');

      controller.setThemeMode(ThemeMode.light);

      expect(controller.activeTheme(Brightness.dark).themePresetId, 'clean');
    });

    test('applies theme transforms to resolved themes', () {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean')],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        transform: (theme) {
          return ThemeVariant<TestTokens>(
            themePresetId: theme.themePresetId,
            brightness: theme.brightness,
            themeData: theme.themeData.copyWith(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
            ),
            tokens: TestTokens(radius: 24, primary: Colors.purple),
          );
        },
      );

      final resolved = controller.lightTheme();

      expect(resolved.themePresetId, 'clean');
      expect(resolved.tokens.radius, 24);
      expect(resolved.tokens.primary, Colors.purple);
    });
  });

  group('ThemeVariantsProvider', () {
    testWidgets('exposes active tokens from context', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean')],
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
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text(context.activeThemePreset<TestTokens>().name),
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
        presets: [singlePreset('clean', 'clean')],
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
              return Directionality(
                textDirection: TextDirection.ltr,
                child: Text(context.activeThemePreset<TestTokens>().name),
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
        presets: [singlePreset('clean', 'clean'), singlePreset('card', 'card')],
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
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(context.activeThemePreset<TestTokens>().name),
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
        presets: [singlePreset('clean', 'clean'), singlePreset('card', 'card')],
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
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(context.activeThemePreset<TestTokens>().name),
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
        presets: [
          lightDarkPreset('clean', 'clean'),
          lightDarkPreset('card', 'card'),
        ],
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
                  return Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(context.activeThemePreset<TestTokens>().name),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('card'), findsOneWidget);
    });

    testWidgets('override inherits the parent theme transform', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean'), singlePreset('card', 'card')],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        transform: (theme) {
          return ThemeVariant<TestTokens>(
            themePresetId: theme.themePresetId,
            brightness: theme.brightness,
            themeData: theme.themeData,
            tokens: TestTokens(radius: 24, primary: theme.tokens.primary),
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
                  child: Text(tokens.radius.toStringAsFixed(0)),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('24'), findsOneWidget);
    });

    testWidgets('override follows parent theme changes when ids are omitted', (
      tester,
    ) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [
          singlePreset('clean', 'clean'),
          singlePreset('forest', 'forest'),
        ],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
        themeMode: ThemeMode.light,
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: ThemeVariantsOverride<TestTokens>(
            child: Builder(
              builder: (context) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(context.activeThemePreset<TestTokens>().name),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('clean'), findsOneWidget);

      controller.setLightTheme('forest');
      await tester.pump();

      expect(find.text('forest'), findsOneWidget);
    });

    testWidgets('override updates when enabled toggles', (tester) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean'), singlePreset('card', 'card')],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );

      Widget build({required bool enabled}) {
        return ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: ThemeVariantsOverride<TestTokens>(
            enabled: enabled,
            lightThemeId: 'card',
            darkThemeId: 'card',
            child: Builder(
              builder: (context) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(context.activeThemePreset<TestTokens>().name),
                );
              },
            ),
          ),
        );
      }

      await tester.pumpWidget(build(enabled: true));
      expect(find.text('card'), findsOneWidget);

      await tester.pumpWidget(build(enabled: false));
      expect(find.text('clean'), findsOneWidget);

      await tester.pumpWidget(build(enabled: true));
      expect(find.text('card'), findsOneWidget);
    });
  });

  group('VariantStyle', () {
    test('resolves typed variants and defaults', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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

    test('throws when a selected variant is not registered', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.text<TestTokens>(
        base: (_) => const TextStyle(),
        variants: {ButtonSize.md: (_) => const TextStyle(fontSize: 14)},
      );

      expect(
        () => style.resolve(tokens, const [ButtonSize.lg]),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws when a default variant is not registered', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.text<TestTokens>(
        base: (_) => const TextStyle(),
        defaultVariants: const [ButtonSize.md],
        variants: {ButtonSize.lg: (_) => const TextStyle(fontSize: 18)},
      );

      expect(() => style.resolve(tokens), throwsA(isA<StateError>()));
    });

    test('throws when defaults contain duplicate variant types', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.text<TestTokens>(
        base: (_) => const TextStyle(),
        defaultVariants: const [ButtonSize.sm, ButtonSize.md],
        variants: {
          ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
          ButtonSize.md: (_) => const TextStyle(fontSize: 14),
        },
      );

      expect(() => style.resolve(tokens), throwsA(isA<StateError>()));
    });

    test('throws when selected variants contain duplicate variant types', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.text<TestTokens>(
        base: (_) => const TextStyle(),
        variants: {
          ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
          ButtonSize.md: (_) => const TextStyle(fontSize: 14),
        },
      );

      expect(
        () => style.resolve(tokens, const [ButtonSize.sm, ButtonSize.md]),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
      'throws when a compound variant references an unregistered variant',
      () {
        const tokens = TestTokens(radius: 12, primary: Colors.blue);
        final style = VariantStyle.text<TestTokens>(
          base: (_) => const TextStyle(),
          variants: {ButtonSize.lg: (_) => const TextStyle(fontSize: 18)},
          compoundVariants: [
            CompoundVariant(
              when: const {ButtonSize.lg, ButtonTone.danger},
              build: (_) => const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        );

        expect(() => style.resolve(tokens), throwsA(isA<StateError>()));
      },
    );

    test('button style variants override earlier button style values', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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

    test('text field constructor merges text and decoration styles', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.textField<TestTokens>(
        base: (_) => const TextFieldStyle(
          textStyle: TextStyle(fontSize: 14),
          decorationTheme: InputDecorationThemeData(
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        variants: {
          ButtonTone.primary: (tokens) => TextFieldStyle(
            textStyle: TextStyle(color: tokens.primary),
            decorationTheme: InputDecorationThemeData(
              fillColor: tokens.primary,
            ),
            textAlign: TextAlign.center,
            cursorColor: tokens.primary,
          ),
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.textStyle.fontSize, 14);
      expect(resolved.textStyle.color, Colors.blue);
      expect(resolved.decorationTheme.contentPadding, const EdgeInsets.all(12));
      expect(resolved.decorationTheme.fillColor, Colors.blue);
      expect(resolved.textAlign, TextAlign.center);
      expect(resolved.cursorColor, Colors.blue);

      const defaultStyle = TextFieldStyle();
      expect(defaultStyle.textAlign, isNull);
    });

    test('list tile constructor uses the list tile theme merger', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
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

    test('decoration parts resolve set-like style fragments', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.decorationParts<TestTokens>(
        base: (tokens) => {
          DecorationPart.radius(tokens.radius),
          DecorationPart.color(Colors.white),
        },
        defaultVariants: const [CardTone.neutral],
        variants: {
          CardTone.neutral: (_) => const <StylePart<BoxDecoration>>{},
          CardTone.highlighted: (tokens) => {
            DecorationPart.color(tokens.primary),
            DecorationPart.border(Border.all(color: tokens.primary)),
          },
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.color, Colors.blue);
      expect(resolved.borderRadius, BorderRadius.circular(12));
      expect(resolved.border, Border.all(color: Colors.blue));
    });

    test('surface constructor merges decoration and text style values', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.surface<TestTokens>(
        base: (tokens) => SurfaceStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(tokens.radius),
          ),
          contentStyle: const ContentStyle(
            textStyle: TextStyle(fontSize: 14),
            iconTheme: IconThemeData(size: 18),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          width: 80,
          constraints: const BoxConstraints(minWidth: 40),
          clipBehavior: Clip.antiAlias,
        ),
        variants: {
          CardTone.highlighted: (tokens) => SurfaceStyle(
            decoration: BoxDecoration(color: tokens.primary),
            foregroundDecoration: BoxDecoration(
              border: Border.all(color: tokens.primary),
            ),
            contentStyle: ContentStyle(
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              iconTheme: IconThemeData(color: tokens.primary),
              overflow: TextOverflow.ellipsis,
            ),
            margin: const EdgeInsets.all(4),
            height: 44,
            opacity: 0.5,
          ),
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.decoration.color, Colors.blue);
      expect(resolved.decoration.borderRadius, BorderRadius.circular(12));
      expect(
        resolved.foregroundDecoration?.borderRadius,
        BorderRadius.circular(12),
      );
      expect(
        resolved.foregroundDecoration?.border,
        Border.all(color: Colors.blue),
      );
      expect(resolved.textStyle.fontSize, 14);
      expect(resolved.textStyle.fontWeight, FontWeight.w700);
      expect(resolved.iconTheme.color, Colors.blue);
      expect(resolved.iconTheme.size, 18);
      expect(resolved.contentStyle.textAlign, TextAlign.center);
      expect(resolved.contentStyle.overflow, TextOverflow.ellipsis);
      expect(resolved.contentStyle.maxLines, 1);
      expect(resolved.alignment, Alignment.center);
      expect(resolved.padding, const EdgeInsets.all(8));
      expect(resolved.margin, const EdgeInsets.all(4));
      expect(resolved.width, 80);
      expect(resolved.height, 44);
      expect(resolved.constraints, const BoxConstraints(minWidth: 40));
      expect(resolved.clipBehavior, Clip.antiAlias);
      expect(resolved.opacity, 0.5);
    });

    test('surface parts resolve decoration, text, and icon fragments', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.surfaceParts<TestTokens>(
        base: (tokens) => {
          SurfaceStylePart.padding(const EdgeInsets.all(8)),
          SurfaceStylePart.decoration({
            DecorationPart.radius(tokens.radius),
            DecorationPart.color(Colors.white),
          }),
          SurfaceStylePart.foregroundDecoration({
            DecorationPart.radius(tokens.radius),
          }),
          SurfaceStylePart.text({TextStylePart.fontSize(14)}),
          SurfaceStylePart.content({
            ContentStylePart.maxLines(1),
            ContentStylePart.textAlign(TextAlign.center),
          }),
          SurfaceStylePart.icon({IconThemePart.size(18)}),
        },
        variants: {
          CardTone.highlighted: (tokens) => {
            SurfaceStylePart.alignment(Alignment.center),
            SurfaceStylePart.margin(const EdgeInsets.all(4)),
            SurfaceStylePart.width(80),
            SurfaceStylePart.height(44),
            SurfaceStylePart.constraints(const BoxConstraints(minHeight: 44)),
            SurfaceStylePart.clipBehavior(Clip.antiAlias),
            SurfaceStylePart.opacity(0.75),
            SurfaceStylePart.decoration({
              DecorationPart.color(tokens.primary),
              DecorationPart.border(Border.all(color: tokens.primary)),
            }),
            SurfaceStylePart.foregroundDecoration({
              DecorationPart.border(Border.all(color: Colors.white)),
            }),
            SurfaceStylePart.text({
              TextStylePart.color(Colors.white),
              TextStylePart.fontWeight(FontWeight.w700),
            }),
            SurfaceStylePart.icon({
              IconThemePart.color(Colors.white),
              IconThemePart.size(24),
            }),
          },
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.decoration.color, Colors.blue);
      expect(resolved.decoration.borderRadius, BorderRadius.circular(12));
      expect(resolved.decoration.border, Border.all(color: Colors.blue));
      expect(
        resolved.foregroundDecoration?.borderRadius,
        BorderRadius.circular(12),
      );
      expect(
        resolved.foregroundDecoration?.border,
        Border.all(color: Colors.white),
      );
      expect(resolved.textStyle.color, Colors.white);
      expect(resolved.textStyle.fontSize, 14);
      expect(resolved.textStyle.fontWeight, FontWeight.w700);
      expect(resolved.contentStyle.textAlign, TextAlign.center);
      expect(resolved.contentStyle.maxLines, 1);
      expect(resolved.iconTheme.color, Colors.white);
      expect(resolved.iconTheme.size, 24);
      expect(resolved.alignment, Alignment.center);
      expect(resolved.padding, const EdgeInsets.all(8));
      expect(resolved.margin, const EdgeInsets.all(4));
      expect(resolved.width, 80);
      expect(resolved.height, 44);
      expect(resolved.constraints, const BoxConstraints(minHeight: 44));
      expect(resolved.clipBehavior, Clip.antiAlias);
      expect(resolved.opacity, 0.75);
    });

    test('surface decoration parts preserve unchanged decoration fields', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.surfaceParts<TestTokens>(
        base: (tokens) => {
          SurfaceStylePart.decoration({
            DecorationPart.color(Colors.white),
            DecorationPart.shape(BoxShape.circle),
            DecorationPart.boxShadow(const [
              BoxShadow(color: Colors.black26, blurRadius: 8),
            ]),
          }),
        },
        variants: {
          CardTone.highlighted: (tokens) => {
            SurfaceStylePart.decoration({DecorationPart.color(tokens.primary)}),
          },
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.decoration.color, Colors.blue);
      expect(resolved.decoration.shape, BoxShape.circle);
      expect(resolved.decoration.boxShadow, const [
        BoxShadow(color: Colors.black26, blurRadius: 8),
      ]);
    });

    test('surface shadow parts preserve unchanged shadows', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.surfaceParts<TestTokens>(
        base: (_) => {
          SurfaceStylePart.decoration({
            DecorationPart.boxShadow(const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 8,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 6),
                blurRadius: 16,
              ),
            ]),
          }),
        },
        variants: {
          CardTone.highlighted: (tokens) => {
            SurfaceStylePart.decoration({
              DecorationPart.boxShadowParts({
                BoxShadowPart.color(tokens.primary),
              }),
            }),
          },
        },
      );

      final resolved = style.resolve(tokens, const [CardTone.highlighted]);

      expect(resolved.decoration.boxShadow, const [
        BoxShadow(
          color: Colors.blue,
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 1,
        ),
        BoxShadow(color: Colors.black12, offset: Offset(0, 6), blurRadius: 16),
      ]);
    });

    test('surface border parts preserve unchanged border side fields', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final colorStyle = VariantStyle.surfaceParts<TestTokens>(
        base: (_) => {
          SurfaceStylePart.decoration({
            DecorationPart.border(Border.all(color: Colors.red, width: 3)),
          }),
        },
        variants: {
          CardTone.highlighted: (tokens) => {
            SurfaceStylePart.decoration({
              DecorationPart.borderParts({BorderPart.color(tokens.primary)}),
            }),
          },
        },
      );
      final widthStyle = VariantStyle.surfaceParts<TestTokens>(
        base: (_) => {
          SurfaceStylePart.decoration({
            DecorationPart.border(Border.all(color: Colors.red, width: 3)),
          }),
        },
        variants: {
          CardTone.highlighted: (_) => {
            SurfaceStylePart.decoration({
              DecorationPart.borderParts({BorderPart.width(6)}),
            }),
          },
        },
      );

      final colorResolved = colorStyle.resolve(tokens, const [
        CardTone.highlighted,
      ]);
      final widthResolved = widthStyle.resolve(tokens, const [
        CardTone.highlighted,
      ]);
      final colorBorder = colorResolved.decoration.border! as Border;
      final widthBorder = widthResolved.decoration.border! as Border;

      expect(colorBorder.top.color, Colors.blue);
      expect(colorBorder.top.width, 3);
      expect(widthBorder.top.color, Colors.red);
      expect(widthBorder.top.width, 6);
    });

    testWidgets('Surface applies box, text, icon, and opacity style', (
      tester,
    ) async {
      const style = SurfaceStyle(
        decoration: BoxDecoration(color: Colors.blue),
        foregroundDecoration: BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.white)),
        ),
        contentStyle: ContentStyle(
          textStyle: TextStyle(color: Colors.white, fontSize: 16),
          iconTheme: IconThemeData(color: Colors.white, size: 20),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        width: 80,
        height: 44,
        constraints: BoxConstraints(minWidth: 40, minHeight: 44),
        clipBehavior: Clip.antiAlias,
        opacity: 0.5,
      );

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Surface(
            style: style,
            child: Builder(builder: surfaceTestProbe),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      final opacity = tester.widget<Opacity>(find.byType(Opacity));

      expect(container.padding, const EdgeInsets.all(8));
      expect(container.margin, const EdgeInsets.all(4));
      expect(container.alignment, Alignment.center);
      expect(
        container.constraints,
        const BoxConstraints.tightFor(width: 80, height: 44),
      );
      expect(container.decoration, const BoxDecoration(color: Colors.blue));
      expect(
        container.foregroundDecoration,
        const BoxDecoration(
          border: Border.fromBorderSide(BorderSide(color: Colors.white)),
        ),
      );
      expect(container.clipBehavior, Clip.antiAlias);
      expect(opacity.opacity, 0.5);
      expect(find.text('text:true icon:true'), findsOneWidget);
    });

    testWidgets('Surface clips rounded decorations', (tester) async {
      const style = SurfaceStyle(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );

      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: Surface(
            style: style,
            hasClipRRect: true,
            child: Text('rounded'),
          ),
        ),
      );

      final clip = tester.widget<ClipRRect>(find.byType(ClipRRect));

      expect(clip.borderRadius, BorderRadius.circular(12));
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('rounded'), findsOneWidget);
    });

    test('content constructor merges text and icon style values', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.content<TestTokens>(
        base: (_) => const ContentStyle(
          textStyle: TextStyle(fontSize: 14),
          iconTheme: IconThemeData(size: 18),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        variants: {
          ButtonTone.primary: (tokens) => ContentStyle(
            textStyle: TextStyle(color: tokens.primary),
            iconTheme: IconThemeData(color: tokens.primary),
            overflow: TextOverflow.ellipsis,
          ),
          ButtonSize.lg: (_) => const ContentStyle(
            textStyle: TextStyle(fontWeight: FontWeight.w700),
            iconTheme: IconThemeData(size: 24),
          ),
        },
      );

      final resolved = style.resolve(tokens, const [
        ButtonTone.primary,
        ButtonSize.lg,
      ]);

      expect(resolved.textStyle.color, Colors.blue);
      expect(resolved.textStyle.fontSize, 14);
      expect(resolved.textStyle.fontWeight, FontWeight.w700);
      expect(resolved.iconTheme.color, Colors.blue);
      expect(resolved.iconTheme.size, 24);
      expect(resolved.textAlign, TextAlign.center);
      expect(resolved.overflow, TextOverflow.ellipsis);
      expect(resolved.maxLines, 1);

      const defaultContent = ContentStyle();
      expect(defaultContent.textAlign, isNull);
      expect(defaultContent.softWrap, isNull);
      expect(defaultContent.overflow, isNull);
      expect(defaultContent.textWidthBasis, isNull);
      expect(defaultContent.effectiveSoftWrap, isTrue);
      expect(defaultContent.effectiveOverflow, TextOverflow.clip);
      expect(defaultContent.effectiveTextWidthBasis, TextWidthBasis.parent);

      const defaultSurface = SurfaceStyle();
      expect(defaultSurface.clipBehavior, isNull);
      expect(defaultSurface.opacity, isNull);
      expect(defaultSurface.effectiveClipBehavior, Clip.none);
      expect(defaultSurface.effectiveOpacity, 1);
    });

    test('content parts resolve text and icon style fragments', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.contentParts<TestTokens>(
        base: (_) => {
          ContentStylePart.text({TextStylePart.fontSize(14)}),
          ContentStylePart.icon({IconThemePart.size(18)}),
          ContentStylePart.textAlign(TextAlign.center),
          ContentStylePart.maxLines(1),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            ContentStylePart.text({TextStylePart.color(tokens.primary)}),
            ContentStylePart.icon({IconThemePart.color(tokens.primary)}),
            ContentStylePart.overflow(TextOverflow.ellipsis),
          },
          ButtonSize.lg: (_) => {
            ContentStylePart.text({TextStylePart.fontWeight(FontWeight.w700)}),
            ContentStylePart.icon({IconThemePart.size(24)}),
          },
        },
      );

      final resolved = style.resolve(tokens, const [
        ButtonTone.primary,
        ButtonSize.lg,
      ]);

      expect(resolved.textStyle.color, Colors.blue);
      expect(resolved.textStyle.fontSize, 14);
      expect(resolved.textStyle.fontWeight, FontWeight.w700);
      expect(resolved.iconTheme.color, Colors.blue);
      expect(resolved.iconTheme.size, 24);
      expect(resolved.textAlign, TextAlign.center);
      expect(resolved.overflow, TextOverflow.ellipsis);
      expect(resolved.maxLines, 1);
    });

    test(
      'content style merge preserves base values and applies next values',
      () {
        const base = ContentStyle(
          textStyle: TextStyle(fontSize: 14),
          iconTheme: IconThemeData(size: 18),
          textAlign: TextAlign.center,
          maxLines: 1,
        );
        const next = ContentStyle(
          textStyle: TextStyle(color: Colors.blue),
          iconTheme: IconThemeData(color: Colors.blue),
          overflow: TextOverflow.ellipsis,
        );

        final resolved = base.merge(next);

        expect(resolved.textStyle.fontSize, 14);
        expect(resolved.textStyle.color, Colors.blue);
        expect(resolved.iconTheme.size, 18);
        expect(resolved.iconTheme.color, Colors.blue);
        expect(resolved.textAlign, TextAlign.center);
        expect(resolved.overflow, TextOverflow.ellipsis);
        expect(resolved.maxLines, 1);
      },
    );

    test(
      'surface style merge preserves base values and applies next values',
      () {
        const base = SurfaceStyle(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          contentStyle: ContentStyle(textStyle: TextStyle(fontSize: 14)),
          padding: EdgeInsets.all(8),
          width: 80,
        );
        const next = SurfaceStyle(
          decoration: BoxDecoration(color: Colors.blue),
          foregroundDecoration: BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: Colors.blue)),
          ),
          contentStyle: ContentStyle(textStyle: TextStyle(color: Colors.white)),
          margin: EdgeInsets.all(4),
          height: 44,
        );

        final resolved = base.merge(next);

        expect(resolved.decoration.color, Colors.blue);
        expect(
          resolved.decoration.borderRadius,
          const BorderRadius.all(Radius.circular(12)),
        );
        expect(
          resolved.foregroundDecoration?.borderRadius,
          const BorderRadius.all(Radius.circular(12)),
        );
        expect(
          resolved.foregroundDecoration?.border,
          const Border.fromBorderSide(BorderSide(color: Colors.blue)),
        );
        expect(resolved.textStyle.fontSize, 14);
        expect(resolved.textStyle.color, Colors.white);
        expect(resolved.padding, const EdgeInsets.all(8));
        expect(resolved.margin, const EdgeInsets.all(4));
        expect(resolved.width, 80);
        expect(resolved.height, 44);
      },
    );

    test(
      'text field style merge preserves base values and applies next values',
      () {
        const base = TextFieldStyle(
          textStyle: TextStyle(fontSize: 14),
          decorationTheme: InputDecorationThemeData(
            contentPadding: EdgeInsets.all(12),
          ),
          textAlign: TextAlign.start,
        );
        const next = TextFieldStyle(
          textStyle: TextStyle(color: Colors.blue),
          decorationTheme: InputDecorationThemeData(fillColor: Colors.blue),
          cursorColor: Colors.blue,
        );

        final resolved = base.merge(next);

        expect(resolved.textStyle.fontSize, 14);
        expect(resolved.textStyle.color, Colors.blue);
        expect(
          resolved.decorationTheme.contentPadding,
          const EdgeInsets.all(12),
        );
        expect(resolved.decorationTheme.fillColor, Colors.blue);
        expect(resolved.textAlign, TextAlign.start);
        expect(resolved.cursorColor, Colors.blue);
      },
    );

    test('text field border parts preserve existing border fields', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.textFieldParts<TestTokens>(
        base: (_) => {
          TextFieldStylePart.decoration({
            InputDecorationPart.border(
              const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 3),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                gapPadding: 8,
              ),
            ),
          }),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            TextFieldStylePart.decoration({
              InputDecorationPart.borderParts({
                OutlineInputBorderPart.borderSideParts({
                  BorderSidePart.color(tokens.primary),
                }),
              }),
            }),
          },
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);
      final border = resolved.decorationTheme.border as OutlineInputBorder;

      expect(border.borderSide.color, Colors.blue);
      expect(border.borderSide.width, 3);
      expect(border.borderRadius, BorderRadius.circular(12));
      expect(border.gapPadding, 8);
    });

    test('text field state border parts fall back to the base border', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final cases = [
        (
          name: 'enabledBorder',
          part: InputDecorationPart.enabledBorderParts,
          select: (InputDecorationThemeData theme) => theme.enabledBorder,
        ),
        (
          name: 'focusedBorder',
          part: InputDecorationPart.focusedBorderParts,
          select: (InputDecorationThemeData theme) => theme.focusedBorder,
        ),
        (
          name: 'disabledBorder',
          part: InputDecorationPart.disabledBorderParts,
          select: (InputDecorationThemeData theme) => theme.disabledBorder,
        ),
        (
          name: 'errorBorder',
          part: InputDecorationPart.errorBorderParts,
          select: (InputDecorationThemeData theme) => theme.errorBorder,
        ),
        (
          name: 'focusedErrorBorder',
          part: InputDecorationPart.focusedErrorBorderParts,
          select: (InputDecorationThemeData theme) => theme.focusedErrorBorder,
        ),
      ];

      for (final testCase in cases) {
        final style = VariantStyle.textFieldParts<TestTokens>(
          base: (_) => {
            TextFieldStylePart.decoration({
              InputDecorationPart.border(
                const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gapPadding: 8,
                ),
              ),
            }),
          },
          variants: {
            ButtonTone.primary: (tokens) => {
              TextFieldStylePart.decoration({
                testCase.part({
                  OutlineInputBorderPart.borderSideParts({
                    BorderSidePart.color(tokens.primary),
                  }),
                }),
              }),
            },
          },
        );

        final resolved = style.resolve(tokens, const [ButtonTone.primary]);
        final border =
            testCase.select(resolved.decorationTheme) as OutlineInputBorder;

        expect(border.borderSide.color, Colors.blue, reason: testCase.name);
        expect(border.borderSide.width, 3, reason: testCase.name);
        expect(
          border.borderRadius,
          BorderRadius.circular(12),
          reason: testCase.name,
        );
        expect(border.gapPadding, 8, reason: testCase.name);
      }
    });

    test('concrete input border parts choose the border family', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.inputDecorationParts<TestTokens>(
        base: (_) => const <StylePart<InputDecorationThemeData>>{},
        variants: {
          ButtonTone.primary: (tokens) => {
            InputDecorationPart.borderParts({
              OutlineInputBorderPart.borderRadius(
                BorderRadius.circular(tokens.radius),
              ),
              OutlineInputBorderPart.borderSideParts({
                BorderSidePart.color(tokens.primary),
                BorderSidePart.width(2),
              }),
              OutlineInputBorderPart.gapPadding(8),
            }),
          },
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);
      final border = resolved.border as OutlineInputBorder;

      expect(border.borderRadius, BorderRadius.circular(12));
      expect(border.borderSide.color, Colors.blue);
      expect(border.borderSide.width, 2);
      expect(border.gapPadding, 8);
    });

    test('no input border part chooses InputBorder.none', () {
      final style = VariantStyle.inputDecorationParts<TestTokens>(
        base: (_) => const <StylePart<InputDecorationThemeData>>{},
        variants: {
          ButtonTone.primary: (_) => {
            InputDecorationPart.borderParts({NoInputBorderPart.none()}),
          },
        },
      );

      final resolved = style.resolve(
        const TestTokens(radius: 12, primary: Colors.blue),
        const [ButtonTone.primary],
      );

      expect(resolved.border, InputBorder.none);
    });

    test('mixed concrete input border families throw', () {
      final style = VariantStyle.inputDecorationParts<TestTokens>(
        base: (_) => const <StylePart<InputDecorationThemeData>>{},
        variants: {
          ButtonTone.primary: (_) => {
            InputDecorationPart.borderParts({
              OutlineInputBorderPart.borderSideParts({BorderSidePart.width(2)}),
              UnderlineInputBorderPart.borderSideParts({
                BorderSidePart.width(3),
              }),
            }),
          },
        },
      );

      expect(
        () => style.resolve(
          const TestTokens(radius: 12, primary: Colors.blue),
          const [ButtonTone.primary],
        ),
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('cannot resolve as both OutlineInputBorder'),
          ),
        ),
      );
    });

    test('no input border part conflicts with concrete border families', () {
      final cases = [
        {
          NoInputBorderPart.none(),
          OutlineInputBorderPart.borderSideParts({BorderSidePart.width(2)}),
        },
        {
          UnderlineInputBorderPart.borderSideParts({BorderSidePart.width(2)}),
          NoInputBorderPart.none(),
        },
      ];

      for (final parts in cases) {
        final style = VariantStyle.inputDecorationParts<TestTokens>(
          base: (_) => const <StylePart<InputDecorationThemeData>>{},
          variants: {
            ButtonTone.primary: (_) => {InputDecorationPart.borderParts(parts)},
          },
        );

        expect(
          () => style.resolve(
            const TestTokens(radius: 12, primary: Colors.blue),
            const [ButtonTone.primary],
          ),
          throwsA(
            isA<StateError>().having(
              (error) => error.message,
              'message',
              contains('InputBorder.none'),
            ),
          ),
        );
      }
    });

    test('button parts resolve ButtonStyle fragments', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.buttonParts<TestTokens>(
        base: (tokens) => {
          ButtonStylePart.shape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tokens.radius),
            ),
          ),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            ButtonStylePart.backgroundColor(tokens.primary),
            ButtonStylePart.foregroundColor(Colors.white),
          },
        },
      );

      final resolved = style.resolve(tokens, const [ButtonTone.primary]);

      expect(resolved.backgroundColor?.resolve({}), Colors.blue);
      expect(resolved.foregroundColor?.resolve({}), Colors.white);
    });

    test('parts constructors resolve supported Flutter style types', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);

      final text = VariantStyle.textParts<TestTokens>(
        base: (_) => {
          TextStylePart.fontSize(14),
          TextStylePart.color(Colors.black),
          TextStylePart.letterSpacing(1.2),
        },
        variants: {
          ButtonTone.primary: (tokens) => {TextStylePart.color(tokens.primary)},
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(text.color, Colors.blue);
      expect(text.fontSize, 14);
      expect(text.letterSpacing, 1.2);

      final textTheme = VariantStyle.textThemeParts<TestTokens>(
        base: (_) => {TextThemePart.titleMedium(const TextStyle(fontSize: 18))},
        variants: {
          ButtonTone.primary: (tokens) => {
            TextThemePart.titleMedium(TextStyle(color: tokens.primary)),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(textTheme.titleMedium?.color, Colors.blue);

      final icon = VariantStyle.iconParts<TestTokens>(
        base: (_) => {
          IconThemePart.size(20),
          IconThemePart.fill(0.1),
          IconThemePart.grade(50),
          IconThemePart.opticalSize(24),
          IconThemePart.shadows(const [
            Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 8),
            Shadow(color: Colors.black12, offset: Offset(0, 6), blurRadius: 16),
          ]),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            IconThemePart.color(tokens.primary),
            IconThemePart.weight(500),
            IconThemePart.opacity(0.8),
            IconThemePart.applyTextScaling(true),
            IconThemePart.shadowParts({ShadowPart.color(tokens.primary)}),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(icon.color, Colors.blue);
      expect(icon.size, 20);
      expect(icon.fill, 0.1);
      expect(icon.weight, 500);
      expect(icon.grade, 50);
      expect(icon.opticalSize, 24);
      expect(icon.opacity, 0.8);
      expect(icon.applyTextScaling, isTrue);
      expect(icon.shadows, const [
        Shadow(color: Colors.blue, offset: Offset(0, 2), blurRadius: 8),
        Shadow(color: Colors.black12, offset: Offset(0, 6), blurRadius: 16),
      ]);

      final inputDecoration = VariantStyle.inputDecorationParts<TestTokens>(
        base: (_) => {
          InputDecorationPart.contentPadding(const EdgeInsets.all(12)),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            InputDecorationPart.fillColor(tokens.primary),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(inputDecoration.contentPadding, const EdgeInsets.all(12));
      expect(inputDecoration.fillColor, Colors.blue);

      final borderDecoration = VariantStyle.inputDecorationParts<TestTokens>(
        base: (_) => {
          InputDecorationPart.border(
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            InputDecorationPart.borderParts({
              OutlineInputBorderPart.borderSideParts({
                BorderSidePart.color(tokens.primary),
              }),
            }),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);

      final resolvedBorder = borderDecoration.border as OutlineInputBorder;

      expect(resolvedBorder.borderSide.color, Colors.blue);
      expect(resolvedBorder.borderSide.width, 3);
      expect(resolvedBorder.borderRadius, BorderRadius.circular(12));

      final textField = VariantStyle.textFieldParts<TestTokens>(
        base: (_) => {
          TextFieldStylePart.text({TextStylePart.fontSize(14)}),
          TextFieldStylePart.decoration({
            InputDecorationPart.contentPadding(const EdgeInsets.all(12)),
          }),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            TextFieldStylePart.text({TextStylePart.color(tokens.primary)}),
            TextFieldStylePart.decoration({
              InputDecorationPart.fillColor(tokens.primary),
              InputDecorationPart.disabledBorder(
                UnderlineInputBorder(
                  borderSide: BorderSide(color: tokens.primary),
                ),
              ),
              InputDecorationPart.focusedBorderParts({
                UnderlineInputBorderPart.borderSideParts({
                  BorderSidePart.width(2),
                }),
              }),
            }),
            TextFieldStylePart.content({
              ContentStylePart.textAlign(TextAlign.center),
            }),
            TextFieldStylePart.cursorColor(tokens.primary),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(textField.textStyle.fontSize, 14);
      expect(textField.textStyle.color, Colors.blue);
      expect(
        textField.decorationTheme.contentPadding,
        const EdgeInsets.all(12),
      );
      expect(textField.decorationTheme.fillColor, Colors.blue);
      expect(
        textField.decorationTheme.disabledBorder,
        isA<UnderlineInputBorder>().having(
          (border) => border.borderSide.color,
          'border color',
          Colors.blue,
        ),
      );
      expect(
        (textField.decorationTheme.focusedBorder as UnderlineInputBorder)
            .borderSide
            .width,
        2,
      );
      expect(textField.textAlign, TextAlign.center);
      expect(textField.cursorColor, Colors.blue);

      final listTile = VariantStyle.listTileParts<TestTokens>(
        base: (_) => {ListTilePart.contentPadding(const EdgeInsets.all(12))},
        variants: {
          ButtonTone.primary: (tokens) => {
            ListTilePart.tileColor(tokens.primary),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(listTile.contentPadding, const EdgeInsets.all(12));
      expect(listTile.tileColor, Colors.blue);

      final card = VariantStyle.cardParts<TestTokens>(
        base: (_) => {CardPart.margin(const EdgeInsets.all(12))},
        variants: {
          ButtonTone.primary: (tokens) => {CardPart.color(tokens.primary)},
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(card.margin, const EdgeInsets.all(12));
      expect(card.color, Colors.blue);

      final chip = VariantStyle.chipParts<TestTokens>(
        base: (_) => {
          ChipPart.padding(const EdgeInsets.all(12)),
          ChipPart.showCheckmark(false),
        },
        variants: {
          ButtonTone.primary: (tokens) => {
            ChipPart.backgroundColor(tokens.primary),
            ChipPart.selectedColor(tokens.primary),
            ChipPart.content({
              ContentStylePart.text({TextStylePart.color(Colors.white)}),
              ContentStylePart.icon({IconThemePart.color(Colors.white)}),
            }),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(chip.padding, const EdgeInsets.all(12));
      expect(chip.backgroundColor, Colors.blue);
      expect(chip.selectedColor, Colors.blue);
      expect(chip.secondaryLabelStyle?.color, Colors.white);
      expect(chip.iconTheme?.color, Colors.white);
      expect(chip.showCheckmark, isFalse);

      final navigationBar = VariantStyle.navigationBarParts<TestTokens>(
        base: (_) => {NavigationBarPart.height(72)},
        variants: {
          ButtonTone.primary: (tokens) => {
            NavigationBarPart.backgroundColor(tokens.primary),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(navigationBar.height, 72);
      expect(navigationBar.backgroundColor, Colors.blue);

      final tabBar = VariantStyle.tabBarParts<TestTokens>(
        base: (_) => {TabBarPart.labelPadding(const EdgeInsets.all(12))},
        variants: {
          ButtonTone.primary: (tokens) => {
            TabBarPart.labelColor(tokens.primary),
          },
        },
      ).resolve(tokens, const [ButtonTone.primary]);
      expect(tabBar.labelPadding, const EdgeInsets.all(12));
      expect(tabBar.labelColor, Colors.blue);
    });

    test('parts compound variants use set-like style fragments', () {
      const tokens = TestTokens(radius: 12, primary: Colors.blue);
      final style = VariantStyle.textParts<TestTokens>(
        base: (_) => {TextStylePart.fontSize(14)},
        variants: {
          ButtonSize.lg: (_) => {TextStylePart.fontSize(18)},
          ButtonTone.danger: (_) => {TextStylePart.color(Colors.red)},
        },
        compoundVariants: [
          CompoundVariantParts(
            when: const {ButtonSize.lg, ButtonTone.danger},
            build: (_) => {TextStylePart.fontWeight(FontWeight.w700)},
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

  group('VariantShowcaseGrid', () {
    testWidgets('renders every combination from the supplied axes', (
      tester,
    ) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean')],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );
      final style = VariantStyle<TestTokens, TextStyle>(
        base: (_) => const TextStyle(fontSize: 14),
        merge: mergeTextStyle,
        variants: {
          ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
          ButtonSize.md: (_) => const TextStyle(fontSize: 14),
          ButtonTone.primary: (_) => const TextStyle(color: Colors.blue),
          ButtonTone.danger: (_) => const TextStyle(color: Colors.red),
        },
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: MaterialApp(
            home: Scaffold(
              body: VariantShowcaseGrid<TestTokens>(
                title: const Text('Text variants'),
                style: style,
                axes: const [
                  VariantShowcaseAxis(
                    label: 'Size',
                    variants: [ButtonSize.sm, ButtonSize.md],
                    labels: {ButtonSize.sm: 'Small', ButtonSize.md: 'Medium'},
                  ),
                  VariantShowcaseAxis(
                    label: 'Tone',
                    variants: [ButtonTone.primary, ButtonTone.danger],
                    labels: {
                      ButtonTone.primary: 'Primary',
                      ButtonTone.danger: 'Danger',
                    },
                  ),
                ],
                builder: (context, textStyle, selectedVariants) {
                  return Text(selectedVariants.join('|'), style: textStyle);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('Text variants'), findsOneWidget);
      expect(find.text('SIZE'), findsNWidgets(4));
      expect(find.text('TONE'), findsNWidgets(4));
      expect(find.text('Small'), findsNWidgets(2));
      expect(find.text('Medium'), findsNWidgets(2));
      expect(find.text('Primary'), findsNWidgets(2));
      expect(find.text('Danger'), findsNWidgets(2));
      expect(find.text('ButtonSize.sm|ButtonTone.primary'), findsOneWidget);
      expect(find.text('ButtonSize.sm|ButtonTone.danger'), findsOneWidget);
      expect(find.text('ButtonSize.md|ButtonTone.primary'), findsOneWidget);
      expect(find.text('ButtonSize.md|ButtonTone.danger'), findsOneWidget);
    });

    testWidgets('can infer axes, preview text styles, and mark compounds', (
      tester,
    ) async {
      final registry = ThemeVariantRegistry<TestTokens>(
        presets: [singlePreset('clean', 'clean')],
      );
      final controller = ThemeVariantsController<TestTokens>(
        registry: registry,
        lightThemeId: 'clean',
        darkThemeId: 'clean',
      );
      final style = VariantStyle<TestTokens, TextStyle>(
        base: (_) => const TextStyle(fontSize: 14),
        merge: mergeTextStyle,
        variants: {
          ButtonSize.sm: (_) => const TextStyle(fontSize: 12),
          ButtonSize.md: (_) => const TextStyle(fontSize: 14),
          ButtonTone.primary: (_) => const TextStyle(color: Colors.blue),
          ButtonTone.danger: (_) => const TextStyle(color: Colors.red),
        },
        compoundVariants: [
          CompoundVariant(
            when: const {ButtonSize.md, ButtonTone.danger},
            build: (_) => const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      );

      await tester.pumpWidget(
        ThemeVariantsProvider<TestTokens>(
          controller: controller,
          child: MaterialApp(
            home: Scaffold(body: VariantShowcaseGrid<TestTokens>(style: style)),
          ),
        ),
      );

      expect(find.text('Preview'), findsNWidgets(4));
      expect(find.text('sm'), findsNWidgets(2));
      expect(find.text('md'), findsNWidgets(2));
      expect(find.text('primary'), findsNWidgets(2));
      expect(find.text('danger'), findsNWidgets(2));
      expect(find.text('Compound'), findsOneWidget);
    });
  });
}
