import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';
import '../variants/button_variants.dart';

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
