import 'package:flutter/material.dart';

/// A paired text style and icon theme.
///
/// Useful for list rows, menu items, chips, tabs, labels, and other components
/// where text and icon styling are selected together.
class ContentStyle {
  const ContentStyle({
    this.textStyle = const TextStyle(),
    this.iconTheme = const IconThemeData(),
    this.textAlign,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.textWidthBasis,
    this.textHeightBehavior,
  });

  final TextStyle textStyle;
  final IconThemeData iconTheme;
  final TextAlign? textAlign;
  final bool? softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  bool get effectiveSoftWrap => softWrap ?? true;

  TextOverflow get effectiveOverflow => overflow ?? TextOverflow.clip;

  TextWidthBasis get effectiveTextWidthBasis {
    return textWidthBasis ?? TextWidthBasis.parent;
  }

  ContentStyle copyWith({
    TextStyle? textStyle,
    IconThemeData? iconTheme,
    TextAlign? textAlign,
    bool? softWrap,
    TextOverflow? overflow,
    int? maxLines,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return ContentStyle(
      textStyle: textStyle ?? this.textStyle,
      iconTheme: iconTheme ?? this.iconTheme,
      textAlign: textAlign ?? this.textAlign,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      maxLines: maxLines ?? this.maxLines,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
    );
  }
}
