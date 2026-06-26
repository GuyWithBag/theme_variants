import 'package:flutter/material.dart';

class PartialBoxShadow extends BoxShadow {
  const PartialBoxShadow({
    super.color,
    super.offset,
    super.blurRadius,
    super.spreadRadius,
    super.blurStyle,
    this.hasColor = false,
    this.hasOffset = false,
    this.hasBlurRadius = false,
    this.hasSpreadRadius = false,
    this.hasBlurStyle = false,
  });

  final bool hasColor;
  final bool hasOffset;
  final bool hasBlurRadius;
  final bool hasSpreadRadius;
  final bool hasBlurStyle;

  factory PartialBoxShadow.fromShadow(
    BoxShadow shadow, {
    bool hasColor = false,
    bool hasOffset = false,
    bool hasBlurRadius = false,
    bool hasSpreadRadius = false,
    bool hasBlurStyle = false,
  }) {
    if (shadow case final PartialBoxShadow partial) {
      return partial.copyPartial(
        hasColor: hasColor,
        hasOffset: hasOffset,
        hasBlurRadius: hasBlurRadius,
        hasSpreadRadius: hasSpreadRadius,
        hasBlurStyle: hasBlurStyle,
      );
    }

    return PartialBoxShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: shadow.spreadRadius,
      blurStyle: shadow.blurStyle,
      hasColor: hasColor,
      hasOffset: hasOffset,
      hasBlurRadius: hasBlurRadius,
      hasSpreadRadius: hasSpreadRadius,
      hasBlurStyle: hasBlurStyle,
    );
  }

  PartialBoxShadow copyPartial({
    Color? color,
    Offset? offset,
    double? blurRadius,
    double? spreadRadius,
    BlurStyle? blurStyle,
    bool hasColor = false,
    bool hasOffset = false,
    bool hasBlurRadius = false,
    bool hasSpreadRadius = false,
    bool hasBlurStyle = false,
  }) {
    return PartialBoxShadow(
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurRadius: blurRadius ?? this.blurRadius,
      spreadRadius: spreadRadius ?? this.spreadRadius,
      blurStyle: blurStyle ?? this.blurStyle,
      hasColor: this.hasColor || hasColor,
      hasOffset: this.hasOffset || hasOffset,
      hasBlurRadius: this.hasBlurRadius || hasBlurRadius,
      hasSpreadRadius: this.hasSpreadRadius || hasSpreadRadius,
      hasBlurStyle: this.hasBlurStyle || hasBlurStyle,
    );
  }
}
