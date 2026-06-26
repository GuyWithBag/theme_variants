import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class CardPart {
  const CardPart._();

  static StylePart<CardThemeData> color(Color color) {
    return (theme) => theme.copyWith(color: color);
  }

  static StylePart<CardThemeData> margin(EdgeInsetsGeometry margin) {
    return (theme) => theme.copyWith(margin: margin);
  }

  static StylePart<CardThemeData> elevation(double elevation) {
    return (theme) => theme.copyWith(elevation: elevation);
  }

  static StylePart<CardThemeData> shape(ShapeBorder shape) {
    return (theme) => theme.copyWith(shape: shape);
  }

  static StylePart<CardThemeData> clipBehavior(Clip clipBehavior) {
    return (theme) => theme.copyWith(clipBehavior: clipBehavior);
  }
}
