import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';

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
