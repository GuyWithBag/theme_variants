import 'package:flutter/material.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';
import 'package:theme_variants/theme_variants.dart';

/// Convenience merger for [BoxDecoration].
BoxDecoration mergeBoxDecoration(BoxDecoration base, BoxDecoration next) {
  return base.copyWith(
    color: next.color,
    image: next.image,
    border: mergeBoxBorder(base.border, next.border),
    borderRadius: next.borderRadius,
    boxShadow: mergeBoxShadows(base.boxShadow, next.boxShadow),
    gradient: next.gradient,
    backgroundBlendMode: next.backgroundBlendMode,
    shape: _mergeBoxShape(base.shape, next.shape),
  );
}

BoxShape _mergeBoxShape(BoxShape base, BoxShape next) {
  if (base != BoxShape.rectangle && next == BoxShape.rectangle) {
    return base;
  }

  return next;
}

InputBorder mergeInputBorder(InputBorder base, InputBorder next) {
  if (next is PartialNoInputBorder) {
    if (base is PartialInputBorderSide) {
      throw StateError(conflictingInputBorderPartsMessage);
    }

    return InputBorder.none;
  }

  if (next case final PartialInputBorderSide partial) {
    if (base == InputBorder.none) {
      throw StateError(conflictingInputBorderPartsMessage);
    }

    if (base is PartialInputBorderSide) {
      return PartialInputBorderSide(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        hasBorderSide: base.hasBorderSide || partial.hasBorderSide,
      );
    }

    if (base is OutlineInputBorder) {
      return base.copyWith(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
      );
    }

    if (base is UnderlineInputBorder) {
      return base.copyWith(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
      );
    }

    return base.copyWith(
      borderSide: partial.hasBorderSide
          ? mergeBorderSide(base.borderSide, partial.borderSide)
          : base.borderSide,
    );
  }

  if (next case final PartialUnderlineInputBorder partial) {
    if (base is PartialInputBorderSide) {
      return UnderlineInputBorder(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
      );
    }

    if (base is OutlineInputBorder) {
      return UnderlineInputBorder(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : base.borderRadius,
      );
    }

    if (base is UnderlineInputBorder) {
      return base.copyWith(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : base.borderRadius,
      );
    }

    return UnderlineInputBorder(
      borderSide: partial.hasBorderSide
          ? mergeBorderSide(base.borderSide, partial.borderSide)
          : partial.borderSide,
      borderRadius: partial.hasBorderRadius
          ? partial.borderRadius
          : const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              topRight: Radius.circular(4.0),
            ),
    );
  }

  if (next case final PartialOutlineInputBorder partial) {
    if (base is PartialInputBorderSide) {
      return OutlineInputBorder(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : const BorderRadius.all(Radius.circular(4.0)),
        gapPadding: partial.hasGapPadding ? partial.gapPadding : 4.0,
      );
    }

    if (base is OutlineInputBorder) {
      return base.copyWith(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : base.borderRadius,
        gapPadding: partial.hasGapPadding
            ? partial.gapPadding
            : base.gapPadding,
      );
    }

    if (base is UnderlineInputBorder) {
      return OutlineInputBorder(
        borderSide: partial.hasBorderSide
            ? mergeBorderSide(base.borderSide, partial.borderSide)
            : base.borderSide,
        borderRadius: partial.hasBorderRadius
            ? partial.borderRadius
            : base.borderRadius,
        gapPadding: partial.hasGapPadding ? partial.gapPadding : 4.0,
      );
    }

    return OutlineInputBorder(
      borderSide: partial.hasBorderSide
          ? mergeBorderSide(base.borderSide, partial.borderSide)
          : partial.borderSide,
      borderRadius: partial.hasBorderRadius
          ? partial.borderRadius
          : const BorderRadius.all(Radius.circular(4.0)),
      gapPadding: partial.hasGapPadding ? partial.gapPadding : 4.0,
    );
  }

  return next;
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
