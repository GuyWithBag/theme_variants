import 'package:flutter/material.dart';

class PartialShadow extends Shadow {
  const PartialShadow({
    super.color,
    super.offset,
    super.blurRadius,
    this.hasColor = false,
    this.hasOffset = false,
    this.hasBlurRadius = false,
  });

  final bool hasColor;
  final bool hasOffset;
  final bool hasBlurRadius;

  factory PartialShadow.fromShadow(
    Shadow shadow, {
    bool hasColor = false,
    bool hasOffset = false,
    bool hasBlurRadius = false,
  }) {
    if (shadow case final PartialShadow partial) {
      return partial.copyPartial(
        hasColor: hasColor,
        hasOffset: hasOffset,
        hasBlurRadius: hasBlurRadius,
      );
    }

    return PartialShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      hasColor: hasColor,
      hasOffset: hasOffset,
      hasBlurRadius: hasBlurRadius,
    );
  }

  PartialShadow copyPartial({
    Color? color,
    Offset? offset,
    double? blurRadius,
    bool hasColor = false,
    bool hasOffset = false,
    bool hasBlurRadius = false,
  }) {
    return PartialShadow(
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurRadius: blurRadius ?? this.blurRadius,
      hasColor: this.hasColor || hasColor,
      hasOffset: this.hasOffset || hasOffset,
      hasBlurRadius: this.hasBlurRadius || hasBlurRadius,
    );
  }
}
