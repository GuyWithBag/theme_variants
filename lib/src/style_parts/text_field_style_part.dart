import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class TextFieldStylePart {
  const TextFieldStylePart._();

  static StylePart<TextFieldStyle> textAlign(TextAlign textAlign) {
    return (style) => style.copyWith(textAlign: textAlign);
  }

  static StylePart<TextFieldStyle> cursorColor(Color cursorColor) {
    return (style) => style.copyWith(cursorColor: cursorColor);
  }

  static StylePart<TextFieldStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return content({ContentStylePart.text(parts)});
  }

  static StylePart<TextFieldStyle> content(
    Iterable<StylePart<ContentStyle>> parts,
  ) {
    return (style) {
      final resolvedContent = applyStyleParts<ContentStyle>(
        ContentStyle(textStyle: style.textStyle, textAlign: style.textAlign),
        parts,
      );

      return style.copyWith(
        textStyle: resolvedContent.textStyle,
        textAlign: resolvedContent.textAlign,
      );
    };
  }

  static StylePart<TextFieldStyle> decoration(
    Iterable<StylePart<InputDecorationThemeData>> parts,
  ) {
    return (style) => style.copyWith(
      decorationTheme: applyStyleParts<InputDecorationThemeData>(
        style.decorationTheme,
        parts,
      ),
    );
  }
}
