import 'package:flutter/material.dart';

import '../controller/theme_variants_controller.dart';
import 'theme_variants_provider.dart';

/// Creates an optional nested theme boundary for a subtree.
///
/// When [enabled] is false, [child] is returned directly and reads the nearest
/// parent [ThemeVariantsProvider]. When [enabled] is true, this widget creates a
/// nested controller from the parent registry and selected theme ids.
class ThemeVariantsOverride<TTokens> extends StatefulWidget {
  const ThemeVariantsOverride({
    required this.child,
    this.enabled = true,
    this.lightThemeId,
    this.darkThemeId,
    this.themeMode,
    super.key,
  });

  final Widget child;
  final bool enabled;
  final String? lightThemeId;
  final String? darkThemeId;
  final ThemeMode? themeMode;

  @override
  State<ThemeVariantsOverride<TTokens>> createState() =>
      _ThemeVariantsOverrideState<TTokens>();
}

class _ThemeVariantsOverrideState<TTokens>
    extends State<ThemeVariantsOverride<TTokens>> {
  ThemeVariantsController<TTokens>? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncController(listen: true);
  }

  @override
  void didUpdateWidget(ThemeVariantsOverride<TTokens> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncController(listen: false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return ThemeVariantsProvider<TTokens>(
      controller: _controller!,
      child: widget.child,
    );
  }

  void _syncController({required bool listen}) {
    if (!widget.enabled) {
      _controller?.dispose();
      _controller = null;
      return;
    }

    final parent = ThemeVariantsProvider.controllerOf<TTokens>(
      context,
      listen: listen,
    );
    final lightThemeId = widget.lightThemeId ?? parent.lightThemeId;
    final darkThemeId = widget.darkThemeId ?? parent.darkThemeId;
    final themeMode = widget.themeMode ?? parent.themeMode;

    final controller = _controller;
    if (controller == null) {
      _controller = ThemeVariantsController<TTokens>(
        registry: parent.registry,
        lightThemeId: lightThemeId,
        darkThemeId: darkThemeId,
        themeMode: themeMode,
        transform: parent.transform,
      );
      return;
    }

    controller
      ..registry = parent.registry
      ..setLightTheme(lightThemeId)
      ..setDarkTheme(darkThemeId)
      ..setThemeMode(themeMode)
      ..setTransform(parent.transform);
  }
}
