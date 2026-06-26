import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TabBarPart {
  const TabBarPart._();

  static StylePart<TabBarThemeData> labelColor(Color color) {
    return (theme) => theme.copyWith(labelColor: color);
  }

  static StylePart<TabBarThemeData> labelStyle(TextStyle style) {
    return (theme) => theme.copyWith(labelStyle: style);
  }

  static StylePart<TabBarThemeData> unselectedLabelColor(Color color) {
    return (theme) => theme.copyWith(unselectedLabelColor: color);
  }

  static StylePart<TabBarThemeData> unselectedLabelStyle(TextStyle style) {
    return (theme) => theme.copyWith(unselectedLabelStyle: style);
  }

  static StylePart<TabBarThemeData> indicator(Decoration indicator) {
    return (theme) => theme.copyWith(indicator: indicator);
  }

  static StylePart<TabBarThemeData> indicatorColor(Color color) {
    return (theme) => theme.copyWith(indicatorColor: color);
  }

  static StylePart<TabBarThemeData> labelPadding(EdgeInsetsGeometry padding) {
    return (theme) => theme.copyWith(labelPadding: padding);
  }
}
