import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ListTilePart {
  const ListTilePart._();

  static StylePart<ListTileThemeData> contentPadding(
    EdgeInsetsGeometry padding,
  ) {
    return (theme) => theme.copyWith(contentPadding: padding);
  }

  static StylePart<ListTileThemeData> tileColor(Color color) {
    return (theme) => theme.copyWith(tileColor: color);
  }

  static StylePart<ListTileThemeData> selectedTileColor(Color color) {
    return (theme) => theme.copyWith(selectedTileColor: color);
  }

  static StylePart<ListTileThemeData> iconColor(Color color) {
    return (theme) => theme.copyWith(iconColor: color);
  }

  static StylePart<ListTileThemeData> textColor(Color color) {
    return (theme) => theme.copyWith(textColor: color);
  }

  static StylePart<ListTileThemeData> titleTextStyle(TextStyle style) {
    return (theme) => theme.copyWith(titleTextStyle: style);
  }
}
