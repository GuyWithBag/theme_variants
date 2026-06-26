import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class BorderSidePart {
  const BorderSidePart._();

  static StylePart<BorderSide> color(Color color) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<BorderSide> width(double width) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasWidth: true,
    ).copyPartial(width: width);
  }

  static StylePart<BorderSide> style(BorderStyle style) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasStyle: true,
    ).copyPartial(style: style);
  }

  static StylePart<BorderSide> strokeAlign(double strokeAlign) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasStrokeAlign: true,
    ).copyPartial(strokeAlign: strokeAlign);
  }
}
