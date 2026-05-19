import 'package:flutter/material.dart';

import 'content_style.dart';

/// A paired surface decoration and content style.
///
/// Useful for cards, panels, labels, badges, and other components where
/// container, text, and icon styling are usually selected together.
class SurfaceStyle {
  const SurfaceStyle({
    this.decoration = const BoxDecoration(),
    this.contentStyle = const ContentStyle(),
  });

  final BoxDecoration decoration;
  final ContentStyle contentStyle;

  TextStyle get textStyle => contentStyle.textStyle;

  IconThemeData get iconTheme => contentStyle.iconTheme;

  SurfaceStyle copyWith({
    BoxDecoration? decoration,
    ContentStyle? contentStyle,
  }) {
    return SurfaceStyle(
      decoration: decoration ?? this.decoration,
      contentStyle: contentStyle ?? this.contentStyle,
    );
  }
}
