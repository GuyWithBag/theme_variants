import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

/// CVA-style button recipe.
///
/// In Tailwind/CVA terms, [ButtonSize] and [ButtonTone] are variant options.
/// Calling [resolve] returns a Flutter [ButtonStyle] instead of a class string.
final buttonStyle = VariantStyle.button<AppTokens>(
  base: (tokens) => ButtonStyle(
    side: WidgetStatePropertyAll(
      BorderSide(color: tokens.primary, width: tokens.borderWidth),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
    ),
  ),
  defaultVariants: const [ButtonSize.md, ButtonTone.primary],
  variants: {
    ButtonSize.sm: (tokens) => ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceSm,
        ),
      ),
    ),
    ButtonSize.md: (tokens) => ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceLg,
          vertical: tokens.spaceMd,
        ),
      ),
    ),
    ButtonSize.lg: (tokens) => ButtonStyle(
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceLg * 1.35,
          vertical: tokens.spaceMd * 1.25,
        ),
      ),
    ),
    ButtonTone.primary: (tokens) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(tokens.primary),
      foregroundColor: WidgetStatePropertyAll(tokens.onPrimary),
      side: WidgetStatePropertyAll(
        BorderSide(color: tokens.primary, width: tokens.borderWidth),
      ),
    ),
    ButtonTone.danger: (tokens) => ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(tokens.danger),
      foregroundColor: WidgetStatePropertyAll(tokens.onDanger),
      side: WidgetStatePropertyAll(
        BorderSide(color: tokens.danger, width: tokens.borderWidth),
      ),
    ),
  },
  compoundVariants: [
    CompoundVariant(
      when: const {ButtonSize.lg, ButtonTone.danger},
      build: (tokens) => ButtonStyle(
        elevation: const WidgetStatePropertyAll(6),
        shadowColor: WidgetStatePropertyAll(
          tokens.danger.withValues(alpha: 0.4),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    ),
  ],
);
