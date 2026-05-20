import 'package:flutter/material.dart';

/// A text field style value that groups editable text and decoration styling.
///
/// Useful when a text field variant needs to select both the field's
/// [TextStyle] and its [InputDecorationThemeData] together.
class TextFieldStyle {
  const TextFieldStyle({
    this.textStyle = const TextStyle(),
    this.decorationTheme = const InputDecorationThemeData(),
    this.textAlign,
    this.cursorColor,
  });

  final TextStyle textStyle;
  final InputDecorationThemeData decorationTheme;
  final TextAlign? textAlign;
  final Color? cursorColor;

  TextFieldStyle copyWith({
    TextStyle? textStyle,
    InputDecorationThemeData? decorationTheme,
    TextAlign? textAlign,
    Color? cursorColor,
  }) {
    return TextFieldStyle(
      textStyle: textStyle ?? this.textStyle,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      textAlign: textAlign ?? this.textAlign,
      cursorColor: cursorColor ?? this.cursorColor,
    );
  }
}
