import 'package:flutter/material.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';
import 'package:theme_variants/theme_variants.dart';

class InputBorderSidePart {
  const InputBorderSidePart._();

  static StylePart<InputBorder> borderSide(BorderSide borderSide) {
    return (border) => _inputBorderWithSide(border, borderSide);
  }

  static StylePart<InputBorder> borderSideParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (border) {
      final resolvedSide = applyStyleParts<BorderSide>(
        border.borderSide,
        parts,
      );
      return _inputBorderWithSide(border, resolvedSide);
    };
  }

  static StylePart<InputBorder> color(Color color) {
    return borderSideParts({BorderSidePart.color(color)});
  }

  static StylePart<InputBorder> width(double width) {
    return borderSideParts({BorderSidePart.width(width)});
  }

  static StylePart<InputBorder> style(BorderStyle style) {
    return borderSideParts({BorderSidePart.style(style)});
  }

  static StylePart<InputBorder> strokeAlign(double strokeAlign) {
    return borderSideParts({BorderSidePart.strokeAlign(strokeAlign)});
  }
}

InputBorder _inputBorderWithSide(InputBorder border, BorderSide borderSide) {
  if (border is PartialNoInputBorder) {
    throw StateError(conflictingInputBorderPartsMessage);
  }

  if (border is PartialOutlineInputBorder) {
    return border.copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  if (border is PartialUnderlineInputBorder) {
    return border.copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  if (border is PartialInputBorderSide) {
    return border.copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  if (border is OutlineInputBorder) {
    return PartialOutlineInputBorder.fromBorder(
      border,
      hasBorderSide: true,
    ).copyPartial(borderSide: borderSide);
  }

  if (border is UnderlineInputBorder) {
    return PartialUnderlineInputBorder.fromBorder(
      border,
      hasBorderSide: true,
    ).copyPartial(borderSide: borderSide);
  }

  return PartialInputBorderSide(borderSide: borderSide, hasBorderSide: true);
}
