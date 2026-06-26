import 'package:flutter/material.dart';

class PartialInputBorderSide extends InputBorder {
  const PartialInputBorderSide({super.borderSide, this.hasBorderSide = false});

  final bool hasBorderSide;

  PartialInputBorderSide copyPartial({
    BorderSide? borderSide,
    bool hasBorderSide = false,
  }) {
    return PartialInputBorderSide(
      borderSide: borderSide ?? this.borderSide,
      hasBorderSide: this.hasBorderSide || hasBorderSide,
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
