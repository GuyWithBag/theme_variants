import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ButtonStylePart {
  const ButtonStylePart._();

  static StylePart<ButtonStyle> backgroundColor(Color color) {
    return (style) =>
        style.copyWith(backgroundColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> foregroundColor(Color color) {
    return (style) =>
        style.copyWith(foregroundColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> padding(EdgeInsetsGeometry padding) {
    return (style) => style.copyWith(padding: WidgetStatePropertyAll(padding));
  }

  static StylePart<ButtonStyle> side(BorderSide side) {
    return (style) => style.copyWith(side: WidgetStatePropertyAll(side));
  }

  static StylePart<ButtonStyle> shape(OutlinedBorder shape) {
    return (style) => style.copyWith(shape: WidgetStatePropertyAll(shape));
  }

  static StylePart<ButtonStyle> elevation(double elevation) {
    return (style) =>
        style.copyWith(elevation: WidgetStatePropertyAll(elevation));
  }

  static StylePart<ButtonStyle> shadowColor(Color color) {
    return (style) =>
        style.copyWith(shadowColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> textStyle(TextStyle textStyle) {
    return (style) =>
        style.copyWith(textStyle: WidgetStatePropertyAll(textStyle));
  }
}
