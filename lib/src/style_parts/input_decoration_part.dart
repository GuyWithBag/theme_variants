import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class InputDecorationPart {
  const InputDecorationPart._();

  static StylePart<InputDecorationThemeData> contentPadding(
    EdgeInsetsGeometry padding,
  ) {
    return (theme) => theme.copyWith(contentPadding: padding);
  }

  static StylePart<InputDecorationThemeData> fillColor(Color color) {
    return (theme) => theme.copyWith(fillColor: color);
  }

  static StylePart<InputDecorationThemeData> filled(bool filled) {
    return (theme) => theme.copyWith(filled: filled);
  }

  static StylePart<InputDecorationThemeData> border(InputBorder border) {
    return (theme) => theme.copyWith(border: border);
  }

  static StylePart<InputDecorationThemeData> borderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      border: _resolveInputBorderParts(theme.border, null, parts),
    );
  }

  static StylePart<InputDecorationThemeData> enabledBorder(InputBorder border) {
    return (theme) => theme.copyWith(enabledBorder: border);
  }

  static StylePart<InputDecorationThemeData> enabledBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      enabledBorder: _resolveInputBorderParts(
        theme.enabledBorder,
        theme.border,
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> focusedBorder(InputBorder border) {
    return (theme) => theme.copyWith(focusedBorder: border);
  }

  static StylePart<InputDecorationThemeData> focusedBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      focusedBorder: _resolveInputBorderParts(
        theme.focusedBorder,
        theme.border,
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> disabledBorder(
    InputBorder border,
  ) {
    return (theme) => theme.copyWith(disabledBorder: border);
  }

  static StylePart<InputDecorationThemeData> disabledBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      disabledBorder: _resolveInputBorderParts(
        theme.disabledBorder,
        theme.border,
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> errorBorder(InputBorder border) {
    return (theme) => theme.copyWith(errorBorder: border);
  }

  static StylePart<InputDecorationThemeData> errorBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      errorBorder: _resolveInputBorderParts(
        theme.errorBorder,
        theme.border,
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> focusedErrorBorder(
    InputBorder border,
  ) {
    return (theme) => theme.copyWith(focusedErrorBorder: border);
  }

  static StylePart<InputDecorationThemeData> focusedErrorBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      focusedErrorBorder: _resolveInputBorderParts(
        theme.focusedErrorBorder,
        theme.focusedBorder ?? theme.border,
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> outlineBorder(BorderSide border) {
    return (theme) => theme.copyWith(outlineBorder: border);
  }

  static StylePart<InputDecorationThemeData> outlineBorderParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (theme) => theme.copyWith(
      outlineBorder: applyStyleParts<BorderSide>(
        theme.outlineBorder ?? const BorderSide(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> activeIndicatorBorder(
    BorderSide border,
  ) {
    return (theme) => theme.copyWith(activeIndicatorBorder: border);
  }

  static StylePart<InputDecorationThemeData> activeIndicatorBorderParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (theme) => theme.copyWith(
      activeIndicatorBorder: applyStyleParts<BorderSide>(
        theme.activeIndicatorBorder ?? const BorderSide(),
        parts,
      ),
    );
  }
}

InputBorder _resolveInputBorderParts(
  InputBorder? base,
  InputBorder? fallback,
  Iterable<StylePart<InputBorder>> parts,
) {
  final effectiveBase = base ?? fallback;
  final seed =
      effectiveBase ?? const PartialInputBorderSide(borderSide: BorderSide());
  final resolved = applyStyleParts<InputBorder>(seed, parts);
  if (resolved is PartialNoInputBorder) {
    return InputBorder.none;
  }

  if (resolved is PartialInputBorderSide) {
    return effectiveBase == null
        ? resolved
        : mergeInputBorder(effectiveBase, resolved);
  }

  return resolved;
}
