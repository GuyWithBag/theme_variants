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

BoxShadow mergeBoxShadow(BoxShadow base, BoxShadow next) {
  if (next case final PartialBoxShadow partial) {
    return BoxShadow(
      color: partial.hasColor ? partial.color : base.color,
      offset: partial.hasOffset ? partial.offset : base.offset,
      blurRadius: partial.hasBlurRadius ? partial.blurRadius : base.blurRadius,
      spreadRadius: partial.hasSpreadRadius
          ? partial.spreadRadius
          : base.spreadRadius,
      blurStyle: partial.hasBlurStyle ? partial.blurStyle : base.blurStyle,
    );
  }

  return next;
}

List<BoxShadow>? mergeBoxShadows(List<BoxShadow>? base, List<BoxShadow>? next) {
  if (next == null || !next.any((shadow) => shadow is PartialBoxShadow)) {
    return next;
  }

  final baseShadows = base ?? const <BoxShadow>[];
  final length = baseShadows.length > next.length
      ? baseShadows.length
      : next.length;
  return [
    for (var index = 0; index < length; index++)
      if (index < next.length)
        mergeBoxShadow(
          index < baseShadows.length ? baseShadows[index] : const BoxShadow(),
          next[index],
        )
      else
        baseShadows[index],
  ];
}

Shadow mergeShadow(Shadow base, Shadow next) {
  if (next case final PartialShadow partial) {
    return Shadow(
      color: partial.hasColor ? partial.color : base.color,
      offset: partial.hasOffset ? partial.offset : base.offset,
      blurRadius: partial.hasBlurRadius ? partial.blurRadius : base.blurRadius,
    );
  }

  return next;
}

List<Shadow>? mergeShadows(List<Shadow>? base, List<Shadow>? next) {
  if (next == null || !next.any((shadow) => shadow is PartialShadow)) {
    return next;
  }

  final baseShadows = base ?? const <Shadow>[];
  final length = baseShadows.length > next.length
      ? baseShadows.length
      : next.length;
  return [
    for (var index = 0; index < length; index++)
      if (index < next.length)
        mergeShadow(
          index < baseShadows.length ? baseShadows[index] : const Shadow(),
          next[index],
        )
      else
        baseShadows[index],
  ];
}

BorderSide mergeBorderSide(BorderSide base, BorderSide next) {
  if (next case final PartialBorderSide partial) {
    return BorderSide(
      color: partial.hasColor ? partial.color : base.color,
      width: partial.hasWidth ? partial.width : base.width,
      style: partial.hasStyle ? partial.style : base.style,
      strokeAlign: partial.hasStrokeAlign
          ? partial.strokeAlign
          : base.strokeAlign,
    );
  }

  return next;
}

BoxBorder? mergeBoxBorder(BoxBorder? base, BoxBorder? next) {
  if (next == null) {
    return null;
  }

  if (next case final PartialBorder partial) {
    final baseBorder = base is Border ? base : const Border();
    return Border(
      top: mergeBorderSide(baseBorder.top, partial.top),
      right: mergeBorderSide(baseBorder.right, partial.right),
      bottom: mergeBorderSide(baseBorder.bottom, partial.bottom),
      left: mergeBorderSide(baseBorder.left, partial.left),
    );
  }

  return next;
}
