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

  static StylePart<TextFieldStyle> border(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.borderParts(parts)});
  }

  static StylePart<TextFieldStyle> enabledBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.enabledBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> focusedBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.focusedBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> disabledBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.disabledBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> errorBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.errorBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> focusedErrorBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.focusedErrorBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> outlineBorder(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return decoration({InputDecorationPart.outlineBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> activeIndicatorBorder(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return decoration({InputDecorationPart.activeIndicatorBorderParts(parts)});
  }
}
