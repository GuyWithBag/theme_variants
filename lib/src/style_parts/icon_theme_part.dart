import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class IconThemePart {
  const IconThemePart._();

  static StylePart<IconThemeData> size(double size) {
    return (theme) => theme.copyWith(size: size);
  }

  static StylePart<IconThemeData> fill(double fill) {
    return (theme) => theme.copyWith(fill: fill);
  }

  static StylePart<IconThemeData> weight(double weight) {
    return (theme) => theme.copyWith(weight: weight);
  }

  static StylePart<IconThemeData> grade(double grade) {
    return (theme) => theme.copyWith(grade: grade);
  }

  static StylePart<IconThemeData> opticalSize(double opticalSize) {
    return (theme) => theme.copyWith(opticalSize: opticalSize);
  }

  static StylePart<IconThemeData> color(Color color) {
    return (theme) => theme.copyWith(color: color);
  }

  static StylePart<IconThemeData> opacity(double opacity) {
    return (theme) => theme.copyWith(opacity: opacity);
  }

  static StylePart<IconThemeData> shadows(List<Shadow> shadows) {
    return (theme) => theme.copyWith(shadows: shadows);
  }

  static StylePart<IconThemeData> shadowParts(
    Iterable<StylePart<Shadow>> parts, {
    int index = 0,
  }) {
    return (theme) {
      final shadows = <Shadow>[
        ...?theme.shadows?.map(PartialShadow.fromShadow),
      ];

      while (shadows.length <= index) {
        shadows.add(const PartialShadow());
      }

      shadows[index] = applyStyleParts<Shadow>(shadows[index], parts);

      return theme.copyWith(shadows: shadows);
    };
  }

  static StylePart<IconThemeData> applyTextScaling(bool applyTextScaling) {
    return (theme) => theme.copyWith(applyTextScaling: applyTextScaling);
  }
}
