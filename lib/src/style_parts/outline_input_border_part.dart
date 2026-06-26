import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';

class OutlineInputBorderPart {
  const OutlineInputBorderPart._();

  static StylePart<InputBorder> borderSide(BorderSide borderSide) {
    return (border) => _outlineBorderFrom(
      border,
    ).copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  static StylePart<InputBorder> borderSideParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (border) {
      final outline = _outlineBorderFrom(border);
      final resolvedSide = applyStyleParts<BorderSide>(
        outline.borderSide,
        parts,
      );
      return outline.copyPartial(borderSide: resolvedSide, hasBorderSide: true);
    };
  }

  static StylePart<InputBorder> borderRadius(BorderRadiusGeometry radius) {
    return (border) => _outlineBorderFrom(
      border,
    ).copyPartial(borderRadius: radius.resolve(null), hasBorderRadius: true);
  }

  static StylePart<InputBorder> gapPadding(double gapPadding) {
    return (border) => _outlineBorderFrom(
      border,
    ).copyPartial(gapPadding: gapPadding, hasGapPadding: true);
  }
}

PartialOutlineInputBorder _outlineBorderFrom(InputBorder border) {
  if (border is PartialUnderlineInputBorder || border is PartialNoInputBorder) {
    throw StateError(conflictingInputBorderPartsMessage);
  }

  if (border is OutlineInputBorder) {
    return PartialOutlineInputBorder.fromBorder(border);
  }

  if (border is PartialInputBorderSide) {
    return PartialOutlineInputBorder(
      borderSide: border.borderSide,
      hasBorderSide: border.hasBorderSide,
    );
  }

  if (border is UnderlineInputBorder) {
    return PartialOutlineInputBorder(
      borderSide: border.borderSide,
      borderRadius: border.borderRadius,
    );
  }

  return PartialOutlineInputBorder(borderSide: border.borderSide);
}
