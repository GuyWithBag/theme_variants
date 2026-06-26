import 'package:flutter/material.dart';

class PartialOutlineInputBorder extends OutlineInputBorder {
  const PartialOutlineInputBorder({
    super.borderSide,
    super.borderRadius,
    super.gapPadding,
    this.hasBorderSide = false,
    this.hasBorderRadius = false,
    this.hasGapPadding = false,
  });

  final bool hasBorderSide;
  final bool hasBorderRadius;
  final bool hasGapPadding;

  factory PartialOutlineInputBorder.fromBorder(
    OutlineInputBorder border, {
    bool hasBorderSide = false,
    bool hasBorderRadius = false,
    bool hasGapPadding = false,
  }) {
    if (border case final PartialOutlineInputBorder partial) {
      return partial.copyPartial(
        hasBorderSide: hasBorderSide,
        hasBorderRadius: hasBorderRadius,
        hasGapPadding: hasGapPadding,
      );
    }

    return PartialOutlineInputBorder(
      borderSide: border.borderSide,
      borderRadius: border.borderRadius,
      gapPadding: border.gapPadding,
      hasBorderSide: hasBorderSide,
      hasBorderRadius: hasBorderRadius,
      hasGapPadding: hasGapPadding,
    );
  }

  PartialOutlineInputBorder copyPartial({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    double? gapPadding,
    bool hasBorderSide = false,
    bool hasBorderRadius = false,
    bool hasGapPadding = false,
  }) {
    return PartialOutlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gapPadding: gapPadding ?? this.gapPadding,
      hasBorderSide: this.hasBorderSide || hasBorderSide,
      hasBorderRadius: this.hasBorderRadius || hasBorderRadius,
      hasGapPadding: this.hasGapPadding || hasGapPadding,
    );
  }
}
