import 'package:flutter/material.dart';

/// A paired text style and icon theme.
///
/// Useful for list rows, menu items, chips, tabs, labels, and other components
/// where text and icon styling are selected together.
class ContentStyle {
  const ContentStyle({
    this.textStyle = const TextStyle(),
    this.iconTheme = const IconThemeData(),
  });

  final TextStyle textStyle;
  final IconThemeData iconTheme;

  ContentStyle copyWith({TextStyle? textStyle, IconThemeData? iconTheme}) {
    return ContentStyle(
      textStyle: textStyle ?? this.textStyle,
      iconTheme: iconTheme ?? this.iconTheme,
    );
  }
}
