import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class DecorationPart {
  const DecorationPart._();

  static StylePart<BoxDecoration> color(Color color) {
    return (decoration) => decoration.copyWith(color: color);
  }

  static StylePart<BoxDecoration> border(BoxBorder border) {
    return (decoration) => decoration.copyWith(border: border);
  }

  static StylePart<BoxDecoration> borderParts(
    Iterable<StylePart<Border>> parts,
  ) {
    return (decoration) {
      final border = decoration.border is Border
          ? decoration.border! as Border
          : const Border();

      return decoration.copyWith(
        border: applyStyleParts<Border>(
          PartialBorder.fromBorder(border),
          parts,
        ),
      );
    };
  }

  static StylePart<BoxDecoration> borderRadius(BorderRadiusGeometry radius) {
    return (decoration) => decoration.copyWith(borderRadius: radius);
  }

  static StylePart<BoxDecoration> radius(double radius) {
    return borderRadius(BorderRadius.circular(radius));
  }

  static StylePart<BoxDecoration> boxShadow(List<BoxShadow> boxShadow) {
    return (decoration) => decoration.copyWith(boxShadow: boxShadow);
  }

  static StylePart<BoxDecoration> boxShadowParts(
    Iterable<StylePart<BoxShadow>> parts, {
    int index = 0,
  }) {
    return (decoration) {
      final boxShadow = <BoxShadow>[
        ...?decoration.boxShadow?.map(PartialBoxShadow.fromShadow),
      ];

      while (boxShadow.length <= index) {
        boxShadow.add(const PartialBoxShadow());
      }

      boxShadow[index] = applyStyleParts<BoxShadow>(boxShadow[index], parts);

      return decoration.copyWith(boxShadow: boxShadow);
    };
  }

  static StylePart<BoxDecoration> shape(BoxShape shape) {
    return (decoration) => decoration.copyWith(shape: shape);
  }
}
