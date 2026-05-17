import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'screens/home_page.dart';
import 'theme/app_theme_registry.dart';
import 'tokens/app_tokens.dart';

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
      registry: appThemeRegistry,
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
