import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ContentStylePart {
  const ContentStylePart._();

  static StylePart<ContentStyle> textAlign(TextAlign textAlign) {
    return (style) => style.copyWith(textAlign: textAlign);
  }

  static StylePart<ContentStyle> softWrap(bool softWrap) {
    return (style) => style.copyWith(softWrap: softWrap);
  }

  static StylePart<ContentStyle> overflow(TextOverflow overflow) {
    return (style) => style.copyWith(overflow: overflow);
  }

  static StylePart<ContentStyle> maxLines(int maxLines) {
    return (style) => style.copyWith(maxLines: maxLines);
  }

  static StylePart<ContentStyle> textWidthBasis(TextWidthBasis textWidthBasis) {
    return (style) => style.copyWith(textWidthBasis: textWidthBasis);
  }

  static StylePart<ContentStyle> textHeightBehavior(
    TextHeightBehavior textHeightBehavior,
  ) {
    return (style) => style.copyWith(textHeightBehavior: textHeightBehavior);
  }

  static StylePart<ContentStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return (style) => style.copyWith(
      textStyle: applyStyleParts<TextStyle>(style.textStyle, parts),
    );
  }

  static StylePart<ContentStyle> icon(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return (style) => style.copyWith(
      iconTheme: applyStyleParts<IconThemeData>(style.iconTheme, parts),
    );
  }
}
