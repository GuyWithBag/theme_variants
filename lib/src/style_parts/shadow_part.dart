import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ShadowPart {
  const ShadowPart._();

  static StylePart<Shadow> color(Color color) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<Shadow> offset(Offset offset) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasOffset: true,
    ).copyPartial(offset: offset);
  }

  static StylePart<Shadow> blurRadius(double blurRadius) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasBlurRadius: true,
    ).copyPartial(blurRadius: blurRadius);
  }
}
