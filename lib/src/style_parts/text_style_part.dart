import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TextStylePart {
  const TextStylePart._();

  static StylePart<TextStyle> color(Color color) {
    return (style) => style.copyWith(color: color);
  }

  static StylePart<TextStyle> fontSize(double fontSize) {
    return (style) => style.copyWith(fontSize: fontSize);
  }

  static StylePart<TextStyle> fontWeight(FontWeight fontWeight) {
    return (style) => style.copyWith(fontWeight: fontWeight);
  }

  static StylePart<TextStyle> height(double height) {
    return (style) => style.copyWith(height: height);
  }

  static StylePart<TextStyle> letterSpacing(double letterSpacing) {
    return (style) => style.copyWith(letterSpacing: letterSpacing);
  }

  static StylePart<TextStyle> decoration(TextDecoration decoration) {
    return (style) => style.copyWith(decoration: decoration);
  }
}
