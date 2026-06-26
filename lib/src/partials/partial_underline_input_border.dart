import 'package:flutter/material.dart';

class PartialUnderlineInputBorder extends UnderlineInputBorder {
  const PartialUnderlineInputBorder({
    super.borderSide,
    super.borderRadius,
    this.hasBorderSide = false,
    this.hasBorderRadius = false,
  });

  final bool hasBorderSide;
  final bool hasBorderRadius;

  factory PartialUnderlineInputBorder.fromBorder(
    UnderlineInputBorder border, {
    bool hasBorderSide = false,
    bool hasBorderRadius = false,
  }) {
    if (border case final PartialUnderlineInputBorder partial) {
      return partial.copyPartial(
        hasBorderSide: hasBorderSide,
        hasBorderRadius: hasBorderRadius,
      );
    }

    return PartialUnderlineInputBorder(
      borderSide: border.borderSide,
      borderRadius: border.borderRadius,
      hasBorderSide: hasBorderSide,
      hasBorderRadius: hasBorderRadius,
    );
  }

  PartialUnderlineInputBorder copyPartial({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    bool hasBorderSide = false,
    bool hasBorderRadius = false,
  }) {
    return PartialUnderlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      hasBorderSide: this.hasBorderSide || hasBorderSide,
      hasBorderRadius: this.hasBorderRadius || hasBorderRadius,
    );
  }
}
