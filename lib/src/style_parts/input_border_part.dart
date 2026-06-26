import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class InputBorderPart {
  const InputBorderPart._();

  static StylePart<InputBorder> borderSide(BorderSide borderSide) {
    return (border) {
      if (border is UnderlineInputBorder) {
        return PartialUnderlineInputBorder.fromBorder(
          border,
          hasBorderSide: true,
        ).copyPartial(borderSide: borderSide);
      }
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasBorderSide: true,
        ).copyPartial(borderSide: borderSide);
      }
      return border.copyWith(borderSide: borderSide);
    };
  }

  static StylePart<InputBorder> borderSideParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (border) {
      final resolvedSide = applyStyleParts<BorderSide>(
        border.borderSide,
        parts,
      );
      return borderSide(resolvedSide)(border);
    };
  }

  static StylePart<InputBorder> borderRadius(BorderRadiusGeometry radius) {
    return (border) {
      if (border is UnderlineInputBorder) {
        return PartialUnderlineInputBorder.fromBorder(
          border,
          hasBorderRadius: true,
        ).copyPartial(borderRadius: radius.resolve(null));
      }
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasBorderRadius: true,
        ).copyPartial(borderRadius: radius.resolve(null));
      }
      return border;
    };
  }

  static StylePart<InputBorder> gapPadding(double gapPadding) {
    return (border) {
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasGapPadding: true,
        ).copyPartial(gapPadding: gapPadding);
      }
      return border;
    };
  }
}
