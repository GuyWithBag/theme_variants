import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

void main() {
  runApp(const App());
}

class AppTokens {
  const AppTokens({
    required this.name,
    required this.radius,
    required this.primary,
  });

  final String name;
  final double radius;
  final Color primary;
}

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

final buttonStyle = VariantStyle<AppTokens, ButtonStyle>(
  base: (tokens) => ButtonStyle(
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
    ),
  ),
  merge: mergeButtonStyle,
  defaultVariants: const [ButtonSize.md, ButtonTone.primary],
  variants: {
    ButtonSize.sm: (_) => const ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    ),
    ButtonSize.md: (_) => const ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    ButtonSize.lg: (_) => const ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    ButtonTone.primary: (tokens) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(tokens.primary),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
    ),
    ButtonTone.danger: (_) => const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.red),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
    ),
  },
);

ThemeVariant<AppTokens> appTheme({
  required String id,
  required Brightness brightness,
  required String name,
  required Color primary,
}) {
  return ThemeVariant(
    id: id,
    themeData: ThemeData(
      brightness: brightness,
      colorSchemeSeed: primary,
      useMaterial3: true,
    ),
    tokens: AppTokens(
      name: name,
      radius: brightness == Brightness.dark ? 20 : 8,
      primary: primary,
    ),
  );
}

final registry = ThemeVariantRegistry<AppTokens>(
  themes: {
    'clean': LightDarkThemeVariant(
      light: appTheme(
        id: 'clean-light',
        brightness: Brightness.light,
        name: 'Clean Light',
        primary: Colors.blue,
      ),
      dark: appTheme(
        id: 'clean-dark',
        brightness: Brightness.dark,
        name: 'Clean Dark',
        primary: Colors.indigo,
      ),
    ),
    'forest': LightDarkThemeVariant(
      light: appTheme(
        id: 'forest-light',
        brightness: Brightness.light,
        name: 'Forest Light',
        primary: Colors.green,
      ),
      dark: appTheme(
        id: 'forest-dark',
        brightness: Brightness.dark,
        name: 'Forest Dark',
        primary: Colors.teal,
      ),
    ),
    'mono': SingleThemeVariant(
      appTheme(
        id: 'mono',
        brightness: Brightness.light,
        name: 'Mono',
        primary: Colors.black,
      ),
    ),
  },
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final ThemeVariantsController<AppTokens> controller;

  @override
  void initState() {
    super.initState();
    controller = ThemeVariantsController<AppTokens>(
      registry: registry,
      lightThemeId: 'clean',
      darkThemeId: 'forest',
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeVariantsProvider<AppTokens>(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return MaterialApp(
            title: 'Theme Variants Example',
            theme: controller.lightTheme().themeData,
            darkTheme: controller.darkTheme().themeData,
            themeMode: controller.themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeVariantsProvider.controllerOf<AppTokens>(context);
    final tokens = ThemeVariantsProvider.tokensOf<AppTokens>(context);

    return Scaffold(
      appBar: AppBar(title: Text(tokens.name)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active tokens: ${tokens.name}'),
            const SizedBox(height: 16),
            FilledButton(
              style: buttonStyle.resolve(tokens, const [
                ButtonSize.lg,
                ButtonTone.primary,
              ]),
              onPressed: () {},
              child: const Text('Primary large'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: buttonStyle.resolve(tokens, const [
                ButtonSize.sm,
                ButtonTone.danger,
              ]),
              onPressed: () {},
              child: const Text('Danger small'),
            ),
            const SizedBox(height: 24),
            SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(value: ThemeMode.system, label: Text('System')),
                ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
              ],
              selected: {controller.themeMode},
              onSelectionChanged: (value) {
                controller.setThemeMode(value.single);
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: controller.lightThemeId,
              items: const [
                DropdownMenuItem(value: 'clean', child: Text('Clean light')),
                DropdownMenuItem(value: 'forest', child: Text('Forest light')),
                DropdownMenuItem(value: 'mono', child: Text('Mono')),
              ],
              onChanged: (value) {
                if (value != null) controller.setLightTheme(value);
              },
            ),
            DropdownButton<String>(
              value: controller.darkThemeId,
              items: const [
                DropdownMenuItem(value: 'clean', child: Text('Clean dark')),
                DropdownMenuItem(value: 'forest', child: Text('Forest dark')),
                DropdownMenuItem(value: 'mono', child: Text('Mono')),
              ],
              onChanged: (value) {
                if (value != null) controller.setDarkTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
