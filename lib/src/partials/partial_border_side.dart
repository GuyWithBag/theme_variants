import 'package:flutter/material.dart';

class PartialBorderSide extends BorderSide {
  const PartialBorderSide({
    super.color,
    super.width,
    super.style,
    super.strokeAlign,
    this.hasColor = false,
    this.hasWidth = false,
    this.hasStyle = false,
    this.hasStrokeAlign = false,
  });

  final bool hasColor;
  final bool hasWidth;
  final bool hasStyle;
  final bool hasStrokeAlign;

  factory PartialBorderSide.fromSide(
    BorderSide side, {
    bool hasColor = false,
    bool hasWidth = false,
    bool hasStyle = false,
    bool hasStrokeAlign = false,
  }) {
    if (side case final PartialBorderSide partial) {
      return partial.copyPartial(
        hasColor: hasColor,
        hasWidth: hasWidth,
        hasStyle: hasStyle,
        hasStrokeAlign: hasStrokeAlign,
      );
    }

    return PartialBorderSide(
      color: side.color,
      width: side.width,
      style: side.style,
      strokeAlign: side.strokeAlign,
      hasColor: hasColor,
      hasWidth: hasWidth,
      hasStyle: hasStyle,
      hasStrokeAlign: hasStrokeAlign,
    );
  }

  PartialBorderSide copyPartial({
    Color? color,
    double? width,
    BorderStyle? style,
    double? strokeAlign,
    bool hasColor = false,
    bool hasWidth = false,
    bool hasStyle = false,
    bool hasStrokeAlign = false,
  }) {
    return PartialBorderSide(
      color: color ?? this.color,
      width: width ?? this.width,
      style: style ?? this.style,
      strokeAlign: strokeAlign ?? this.strokeAlign,
      hasColor: this.hasColor || hasColor,
      hasWidth: this.hasWidth || hasWidth,
      hasStyle: this.hasStyle || hasStyle,
      hasStrokeAlign: this.hasStrokeAlign || hasStrokeAlign,
    );
  }
}
