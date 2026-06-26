import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';

class UnderlineInputBorderPart {
  const UnderlineInputBorderPart._();

  static StylePart<InputBorder> borderSide(BorderSide borderSide) {
    return (border) => _underlineBorderFrom(
      border,
    ).copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  static StylePart<InputBorder> borderSideParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (border) {
      final underline = _underlineBorderFrom(border);
      final resolvedSide = applyStyleParts<BorderSide>(
        underline.borderSide,
        parts,
      );
      return underline.copyPartial(
        borderSide: resolvedSide,
        hasBorderSide: true,
      );
    };
  }

  static StylePart<InputBorder> borderRadius(BorderRadiusGeometry radius) {
    return (border) => _underlineBorderFrom(
      border,
    ).copyPartial(borderRadius: radius.resolve(null), hasBorderRadius: true);
  }
}

PartialUnderlineInputBorder _underlineBorderFrom(InputBorder border) {
  if (border is PartialOutlineInputBorder || border is PartialNoInputBorder) {
    throw StateError(conflictingInputBorderPartsMessage);
  }

  if (border is UnderlineInputBorder) {
    return PartialUnderlineInputBorder.fromBorder(border);
  }

  if (border is OutlineInputBorder) {
    return PartialUnderlineInputBorder(
      borderSide: border.borderSide,
      borderRadius: border.borderRadius,
    );
  }

  return PartialUnderlineInputBorder(borderSide: border.borderSide);
}
