import 'package:flutter/material.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';
import 'package:theme_variants/theme_variants.dart';

class InputBorderPart {
  const InputBorderPart._();

  static StylePart<InputBorder> outline() {
    return (border) => _outlineBorderFrom(border);
  }

  static StylePart<InputBorder> underline() {
    return (border) => _underlineBorderFrom(border);
  }

  static StylePart<InputBorder> none() {
    return (border) {
      if (border is PartialOutlineInputBorder ||
          border is PartialUnderlineInputBorder ||
          (border is PartialInputBorderSide &&
              (border.hasBorderSide || border.hasBorderRadius))) {
        throw StateError(conflictingInputBorderPartsMessage);
      }

      return const PartialNoInputBorder();
    };
  }

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

  static StylePart<InputBorder> borderRadius(BorderRadiusGeometry radius) {
    return (border) => _inputBorderWithRadius(border, radius.resolve(null));
  }

  static StylePart<InputBorder> gapPadding(double gapPadding) {
    return (border) => _outlineBorderFrom(
      border,
    ).copyPartial(gapPadding: gapPadding, hasGapPadding: true);
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

InputBorder _inputBorderWithRadius(InputBorder border, BorderRadius radius) {
  if (border is PartialNoInputBorder) {
    throw StateError(conflictingInputBorderPartsMessage);
  }

  if (border is PartialOutlineInputBorder) {
    return border.copyPartial(borderRadius: radius, hasBorderRadius: true);
  }

  if (border is PartialUnderlineInputBorder) {
    return border.copyPartial(borderRadius: radius, hasBorderRadius: true);
  }

  if (border is PartialInputBorderSide) {
    return border.copyPartial(borderRadius: radius, hasBorderRadius: true);
  }

  if (border is OutlineInputBorder) {
    return PartialOutlineInputBorder.fromBorder(
      border,
      hasBorderRadius: true,
    ).copyPartial(borderRadius: radius);
  }

  if (border is UnderlineInputBorder) {
    return PartialUnderlineInputBorder.fromBorder(
      border,
      hasBorderRadius: true,
    ).copyPartial(borderRadius: radius);
  }

  return PartialInputBorderSide(borderRadius: radius, hasBorderRadius: true);
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
      borderRadius:
          border.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
      hasBorderSide: border.hasBorderSide,
      hasBorderRadius: border.hasBorderRadius,
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

PartialUnderlineInputBorder _underlineBorderFrom(InputBorder border) {
  if (border is PartialOutlineInputBorder || border is PartialNoInputBorder) {
    throw StateError(conflictingInputBorderPartsMessage);
  }

  if (border is UnderlineInputBorder) {
    return PartialUnderlineInputBorder.fromBorder(border);
  }

  if (border is PartialInputBorderSide) {
    return PartialUnderlineInputBorder(
      borderSide: border.borderSide,
      borderRadius:
          border.borderRadius ??
          const BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
      hasBorderSide: border.hasBorderSide,
      hasBorderRadius: border.hasBorderRadius,
    );
  }

  if (border is OutlineInputBorder) {
    return PartialUnderlineInputBorder(
      borderSide: border.borderSide,
      borderRadius: border.borderRadius,
    );
  }

  return PartialUnderlineInputBorder(borderSide: border.borderSide);
}
