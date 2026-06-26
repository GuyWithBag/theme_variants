import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Convenience merger for [InputDecorationThemeData].
InputDecorationThemeData mergeInputDecorationThemeData(
  InputDecorationThemeData base,
  InputDecorationThemeData next,
) {
  final merged = next.merge(base);
  return merged.copyWith(
    border: _mergeInputBorderThemeSlot(base: base.border, next: merged.border),
    enabledBorder: _mergeInputBorderThemeSlot(
      base: base.enabledBorder,
      fallback: base.border,
      next: merged.enabledBorder,
    ),
    focusedBorder: _mergeInputBorderThemeSlot(
      base: base.focusedBorder,
      fallback: base.border,
      next: merged.focusedBorder,
    ),
    disabledBorder: _mergeInputBorderThemeSlot(
      base: base.disabledBorder,
      fallback: base.border,
      next: merged.disabledBorder,
    ),
    errorBorder: _mergeInputBorderThemeSlot(
      base: base.errorBorder,
      fallback: base.border,
      next: merged.errorBorder,
    ),
    focusedErrorBorder: _mergeInputBorderThemeSlot(
      base: base.focusedErrorBorder,
      fallback: base.focusedBorder ?? base.border,
      next: merged.focusedErrorBorder,
    ),
    outlineBorder: switch ((base.outlineBorder, merged.outlineBorder)) {
      (final baseBorder?, final mergedBorder?) => mergeBorderSide(
        baseBorder,
        mergedBorder,
      ),
      (_, final mergedBorder?) => mergedBorder,
      (final baseBorder?, _) => baseBorder,
      _ => null,
    },
    activeIndicatorBorder: switch ((
      base.activeIndicatorBorder,
      merged.activeIndicatorBorder,
    )) {
      (final baseBorder?, final mergedBorder?) => mergeBorderSide(
        baseBorder,
        mergedBorder,
      ),
      (_, final mergedBorder?) => mergedBorder,
      (final baseBorder?, _) => baseBorder,
      _ => null,
    },
  );
}

InputBorder? _mergeInputBorderThemeSlot({
  required InputBorder? base,
  required InputBorder? next,
  InputBorder? fallback,
}) {
  if (next == null) {
    return base;
  }

  final effectiveBase = base ?? (_isPartialInputBorder(next) ? fallback : null);
  if (effectiveBase == null) {
    return next;
  }

  return mergeInputBorder(effectiveBase, next);
}

bool _isPartialInputBorder(InputBorder border) {
  return border is PartialNoInputBorder ||
      border is PartialUnderlineInputBorder ||
      border is PartialOutlineInputBorder;
}
