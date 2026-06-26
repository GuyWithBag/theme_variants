import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class BoxShadowPart {
  const BoxShadowPart._();

  static StylePart<BoxShadow> color(Color color) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<BoxShadow> offset(Offset offset) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasOffset: true,
    ).copyPartial(offset: offset);
  }

  static StylePart<BoxShadow> blurRadius(double blurRadius) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasBlurRadius: true,
    ).copyPartial(blurRadius: blurRadius);
  }

  static StylePart<BoxShadow> spreadRadius(double spreadRadius) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasSpreadRadius: true,
    ).copyPartial(spreadRadius: spreadRadius);
  }

  static StylePart<BoxShadow> blurStyle(BlurStyle blurStyle) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasBlurStyle: true,
    ).copyPartial(blurStyle: blurStyle);
  }
}
