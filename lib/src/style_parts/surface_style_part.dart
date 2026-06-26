import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class SurfaceStylePart {
  const SurfaceStylePart._();

  static StylePart<SurfaceStyle> alignment(AlignmentGeometry alignment) {
    return (style) => style.copyWith(alignment: alignment);
  }

  static StylePart<SurfaceStyle> padding(EdgeInsetsGeometry padding) {
    return (style) => style.copyWith(padding: padding);
  }

  static StylePart<SurfaceStyle> margin(EdgeInsetsGeometry margin) {
    return (style) => style.copyWith(margin: margin);
  }

  static StylePart<SurfaceStyle> width(double width) {
    return (style) => style.copyWith(width: width);
  }

  static StylePart<SurfaceStyle> height(double height) {
    return (style) => style.copyWith(height: height);
  }

  static StylePart<SurfaceStyle> constraints(BoxConstraints constraints) {
    return (style) => style.copyWith(constraints: constraints);
  }

  static StylePart<SurfaceStyle> transform(Matrix4 transform) {
    return (style) => style.copyWith(transform: transform);
  }

  static StylePart<SurfaceStyle> transformAlignment(
    AlignmentGeometry alignment,
  ) {
    return (style) => style.copyWith(transformAlignment: alignment);
  }

  static StylePart<SurfaceStyle> clipBehavior(Clip clipBehavior) {
    return (style) => style.copyWith(clipBehavior: clipBehavior);
  }

  static StylePart<SurfaceStyle> opacity(double opacity) {
    return (style) => style.copyWith(opacity: opacity);
  }

  static StylePart<SurfaceStyle> decoration(
    Iterable<StylePart<BoxDecoration>> parts,
  ) {
    return (style) => style.copyWith(
      decoration: applyStyleParts<BoxDecoration>(style.decoration, parts),
    );
  }

  static StylePart<SurfaceStyle> foregroundDecoration(
    Iterable<StylePart<BoxDecoration>> parts,
  ) {
    return (style) => style.copyWith(
      foregroundDecoration: applyStyleParts<BoxDecoration>(
        style.foregroundDecoration ?? const BoxDecoration(),
        parts,
      ),
    );
  }

  static StylePart<SurfaceStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return content({ContentStylePart.text(parts)});
  }

  static StylePart<SurfaceStyle> icon(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return content({ContentStylePart.icon(parts)});
  }

  static StylePart<SurfaceStyle> content(
    Iterable<StylePart<ContentStyle>> parts,
  ) {
    return (style) => style.copyWith(
      contentStyle: applyStyleParts<ContentStyle>(style.contentStyle, parts),
    );
  }
}
