import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import '../tokens/app_tokens.dart';

enum ButtonSize { sm, md, lg }

enum ButtonTone { primary, danger }

/// CVA-style button recipe.
///
/// In Tailwind/CVA terms, [ButtonSize] and [ButtonTone] are variant options.
/// Calling [resolve] returns a Flutter [ButtonStyle] instead of a class string.
final buttonStyle = VariantStyle.buttonParts<AppTokens>(
  base: (tokens) => {
    ButtonStylePart.side(
      BorderSide(color: tokens.primary, width: tokens.borderWidth),
    ),
    ButtonStylePart.shape(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.radius),
      ),
    ),
  },
  defaultVariants: const [ButtonSize.md, ButtonTone.primary],
  variants: {
    ButtonSize.sm: (tokens) => {
      ButtonStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceMd,
          vertical: tokens.spaceSm,
        ),
      ),
    },
    ButtonSize.md: (tokens) => {
      ButtonStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceLg,
          vertical: tokens.spaceMd,
        ),
      ),
    },
    ButtonSize.lg: (tokens) => {
      ButtonStylePart.padding(
        EdgeInsets.symmetric(
          horizontal: tokens.spaceLg * 1.35,
          vertical: tokens.spaceMd * 1.25,
        ),
      ),
    },
    ButtonTone.primary: (tokens) => {
      ButtonStylePart.backgroundColor(tokens.primary),
      ButtonStylePart.foregroundColor(tokens.onPrimary),
      ButtonStylePart.side(
        BorderSide(color: tokens.primary, width: tokens.borderWidth),
      ),
    },
    ButtonTone.danger: (tokens) => {
      ButtonStylePart.backgroundColor(tokens.danger),
      ButtonStylePart.foregroundColor(tokens.onDanger),
      ButtonStylePart.side(
        BorderSide(color: tokens.danger, width: tokens.borderWidth),
      ),
    },
  },
  compoundVariants: [
    CompoundVariantParts(
      when: const {ButtonSize.lg, ButtonTone.danger},
      build: (tokens) => {
        ButtonStylePart.elevation(6),
        ButtonStylePart.shadowColor(tokens.danger.withValues(alpha: 0.4)),
        ButtonStylePart.textStyle(const TextStyle(fontWeight: FontWeight.w700)),
      },
    ),
  ],
);
