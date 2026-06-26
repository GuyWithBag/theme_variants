import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class BorderPart {
  const BorderPart._();

  static StylePart<Border> side(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: applyStyleParts<BorderSide>(border.top, parts),
      right: applyStyleParts<BorderSide>(border.right, parts),
      bottom: applyStyleParts<BorderSide>(border.bottom, parts),
      left: applyStyleParts<BorderSide>(border.left, parts),
    );
  }

  static StylePart<Border> color(Color color) {
    return side({BorderSidePart.color(color)});
  }

  static StylePart<Border> width(double width) {
    return side({BorderSidePart.width(width)});
  }

  static StylePart<Border> style(BorderStyle style) {
    return side({BorderSidePart.style(style)});
  }

  static StylePart<Border> strokeAlign(double strokeAlign) {
    return side({BorderSidePart.strokeAlign(strokeAlign)});
  }

  static StylePart<Border> top(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: applyStyleParts<BorderSide>(border.top, parts),
      right: border.right,
      bottom: border.bottom,
      left: border.left,
    );
  }

  static StylePart<Border> right(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: applyStyleParts<BorderSide>(border.right, parts),
      bottom: border.bottom,
      left: border.left,
    );
  }

  static StylePart<Border> bottom(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: border.right,
      bottom: applyStyleParts<BorderSide>(border.bottom, parts),
      left: border.left,
    );
  }

  static StylePart<Border> left(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: border.right,
      bottom: border.bottom,
      left: applyStyleParts<BorderSide>(border.left, parts),
    );
  }
}
