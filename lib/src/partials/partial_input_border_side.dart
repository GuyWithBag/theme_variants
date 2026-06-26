import 'package:flutter/material.dart';

class PartialInputBorderSide extends InputBorder {
  const PartialInputBorderSide({
    super.borderSide,
    this.borderRadius,
    this.hasBorderSide = false,
    this.hasBorderRadius = false,
  });

  final BorderRadius? borderRadius;
  final bool hasBorderSide;
  final bool hasBorderRadius;

  PartialInputBorderSide copyPartial({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    bool hasBorderSide = false,
    bool hasBorderRadius = false,
  }) {
    return PartialInputBorderSide(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      hasBorderSide: this.hasBorderSide || hasBorderSide,
      hasBorderRadius: this.hasBorderRadius || hasBorderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  bool get isOutline => false;

  @override
  InputBorder copyWith({BorderSide? borderSide}) {
    return copyPartial(borderSide: borderSide, hasBorderSide: true);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {}

  @override
  ShapeBorder scale(double t) => this;
}
