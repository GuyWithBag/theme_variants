import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TextThemePart {
  const TextThemePart._();

  static StylePart<TextTheme> displayLarge(TextStyle? style) {
    return (theme) => theme.copyWith(displayLarge: style);
  }

  static StylePart<TextTheme> headlineMedium(TextStyle? style) {
    return (theme) => theme.copyWith(headlineMedium: style);
  }

  static StylePart<TextTheme> titleMedium(TextStyle? style) {
    return (theme) => theme.copyWith(titleMedium: style);
  }

  static StylePart<TextTheme> bodyMedium(TextStyle? style) {
    return (theme) => theme.copyWith(bodyMedium: style);
  }
}
