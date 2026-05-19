import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';
import '../variants/button_variants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.themeVariantsController<AppTokens>();
    final tokens = context.themeTokens<AppTokens>();
    final activeTheme = context.activeThemeVariant<AppTokens>();
    final activePreset = context.activeThemePreset<AppTokens>();
    final themeIds = controller.registry.ids.toList(growable: false);
    final activeThemeLabel = activePreset.themeLabel(activeTheme.brightness);

    return Scaffold(
      appBar: AppBar(title: Text(activeThemeLabel)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active theme: $activeThemeLabel'),
            Text(
              'radius ${tokens.radius.toStringAsFixed(0)} / spacing ${tokens.spaceSm.toStringAsFixed(0)}-${tokens.spaceLg.toStringAsFixed(0)}',
            ),
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
            const SizedBox(height: 12),
            FilledButton(
              style: buttonStyle.resolve(tokens, const [
                ButtonSize.lg,
                ButtonTone.danger,
              ]),
              onPressed: () {},
              child: const Text('Danger large compound'),
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
              items: [
                for (final id in themeIds)
                  DropdownMenuItem(
                    value: id,
                    child: Text(
                      controller.registry
                          .getPreset(id)
                          .themeLabel(ThemeVariantBrightness.light),
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) controller.setLightTheme(value);
              },
            ),
            DropdownButton<String>(
              value: controller.darkThemeId,
              items: [
                for (final id in themeIds)
                  DropdownMenuItem(
                    value: id,
                    child: Text(
                      controller.registry
                          .getPreset(id)
                          .themeLabel(ThemeVariantBrightness.dark),
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) controller.setDarkTheme(value);
              },
            ),
            const SizedBox(height: 24),
            const FlashcardPreview(
              title: 'Overridden flashcard',
              subtitle: 'This card uses the forest theme boundary.',
              useParentTheme: false,
            ),
            const SizedBox(height: 12),
            const FlashcardPreview(
              title: 'Inherited flashcard',
              subtitle: 'This card uses the parent app theme.',
              useParentTheme: true,
            ),
          ],
        ),
      ),
    );
  }
}

class FlashcardPreview extends StatelessWidget {
  const FlashcardPreview({
    required this.title,
    required this.subtitle,
    required this.useParentTheme,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool useParentTheme;

  @override
  Widget build(BuildContext context) {
    return ThemeVariantsOverride<AppTokens>(
      enabled: !useParentTheme,
      lightThemeId: 'forest',
      darkThemeId: 'forest',
      themeMode: ThemeMode.light,
      child: _FlashcardSurface(title: title, subtitle: subtitle),
    );
  }
}

class _FlashcardSurface extends StatelessWidget {
  const _FlashcardSurface({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final activeTheme = context.activeThemeVariant<AppTokens>();
    final activePreset = context.activeThemePreset<AppTokens>();

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.primary.withValues(alpha: 0.08),
        border: Border.all(color: tokens.primary, width: tokens.borderWidth),
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 12),
            Text(
              'Card theme: ${activePreset.themeLabel(activeTheme.brightness)}',
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: buttonStyle.resolve(tokens),
              onPressed: () {},
              child: const Text('Default action'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on ThemePreset<AppTokens> {
  /// Builds a display label from preset metadata and variant brightness.
  String themeLabel(ThemeVariantBrightness brightness) {
    return switch ((presetType, brightness)) {
      (ThemePresetType.lightDark, ThemeVariantBrightness.light) =>
        '$name Light',
      (ThemePresetType.lightDark, ThemeVariantBrightness.dark) => '$name Dark',
      _ => name,
    };
  }
}
