import 'package:flutter/material.dart';

/// A paired surface decoration and text style.
///
/// Useful for cards, panels, labels, badges, and other components where
/// container styling and text styling are usually selected together.
class SurfaceStyle {
  const SurfaceStyle({
    this.decoration = const BoxDecoration(),
    this.textStyle = const TextStyle(),
  });

  final BoxDecoration decoration;
  final TextStyle textStyle;

  SurfaceStyle copyWith({BoxDecoration? decoration, TextStyle? textStyle}) {
    return SurfaceStyle(
      decoration: decoration ?? this.decoration,
      textStyle: textStyle ?? this.textStyle,
    );
  }
}
