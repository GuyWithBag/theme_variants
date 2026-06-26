import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class PartialBorder extends Border {
  const PartialBorder({super.top, super.right, super.bottom, super.left});

  factory PartialBorder.fromBorder(Border border) {
    return PartialBorder(
      top: PartialBorderSide.fromSide(border.top),
      right: PartialBorderSide.fromSide(border.right),
      bottom: PartialBorderSide.fromSide(border.bottom),
      left: PartialBorderSide.fromSide(border.left),
    );
  }
}
