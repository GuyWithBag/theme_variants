import 'package:flutter/material.dart';

import 'content_style.dart';

/// A paired surface decoration and content style.
///
/// Useful for cards, panels, labels, badges, and other components where
/// container, text, and icon styling are usually selected together.
class SurfaceStyle {
  const SurfaceStyle({
    this.decoration = const BoxDecoration(),
    this.foregroundDecoration,
    this.contentStyle = const ContentStyle(),
    this.alignment,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.constraints,
    this.transform,
    this.transformAlignment,
    this.clipBehavior,
    this.opacity,
  });

  final BoxDecoration decoration;
  final BoxDecoration? foregroundDecoration;
  final ContentStyle contentStyle;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip? clipBehavior;
  final double? opacity;

  TextStyle get textStyle => contentStyle.textStyle;

  IconThemeData get iconTheme => contentStyle.iconTheme;

  double get effectiveOpacity => opacity ?? 1;

  Clip get effectiveClipBehavior => clipBehavior ?? Clip.none;

  SurfaceStyle copyWith({
    BoxDecoration? decoration,
    BoxDecoration? foregroundDecoration,
    ContentStyle? contentStyle,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Clip? clipBehavior,
    double? opacity,
  }) {
    return SurfaceStyle(
      decoration: decoration ?? this.decoration,
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      contentStyle: contentStyle ?? this.contentStyle,
      alignment: alignment ?? this.alignment,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      width: width ?? this.width,
      height: height ?? this.height,
      constraints: constraints ?? this.constraints,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      opacity: opacity ?? this.opacity,
    );
  }
}
