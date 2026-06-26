import 'package:flutter/material.dart';

class PartialNoInputBorder extends InputBorder {
  const PartialNoInputBorder();

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  bool get isOutline => false;

  @override
  InputBorder copyWith({BorderSide? borderSide}) => this;

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
