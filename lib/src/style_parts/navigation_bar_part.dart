import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class NavigationBarPart {
  const NavigationBarPart._();

  static StylePart<NavigationBarThemeData> height(double height) {
    return (theme) => theme.copyWith(height: height);
  }

  static StylePart<NavigationBarThemeData> backgroundColor(Color color) {
    return (theme) => theme.copyWith(backgroundColor: color);
  }

  static StylePart<NavigationBarThemeData> elevation(double elevation) {
    return (theme) => theme.copyWith(elevation: elevation);
  }

  static StylePart<NavigationBarThemeData> indicatorColor(Color color) {
    return (theme) => theme.copyWith(indicatorColor: color);
  }

  static StylePart<NavigationBarThemeData> indicatorShape(ShapeBorder shape) {
    return (theme) => theme.copyWith(indicatorShape: shape);
  }

  static StylePart<NavigationBarThemeData> labelTextStyle(
    WidgetStateProperty<TextStyle?> labelTextStyle,
  ) {
    return (theme) => theme.copyWith(labelTextStyle: labelTextStyle);
  }

  static StylePart<NavigationBarThemeData> iconTheme(
    WidgetStateProperty<IconThemeData?> iconTheme,
  ) {
    return (theme) => theme.copyWith(iconTheme: iconTheme);
  }
}
