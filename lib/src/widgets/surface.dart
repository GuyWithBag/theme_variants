import 'package:flutter/material.dart';

import '../variants/surface_style.dart';

/// Applies a [SurfaceStyle] to a widget subtree.
///
/// This is the render helper for styles that combine a box surface with text
/// and icon styling.
class Surface extends StatelessWidget {
  const Surface({
    required this.style,
    required this.child,
    this.duration,
    this.curve = Curves.linear,
    this.onEnd,
    super.key,
  });

  final SurfaceStyle style;
  final Widget child;
  final Duration? duration;
  final Curve curve;
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final content = IconTheme(
      data: style.iconTheme,
      child: DefaultTextStyle(
        style: style.textStyle,
        textAlign: style.contentStyle.textAlign,
        softWrap: style.contentStyle.effectiveSoftWrap,
        overflow: style.contentStyle.effectiveOverflow,
        maxLines: style.contentStyle.maxLines,
        textWidthBasis: style.contentStyle.effectiveTextWidthBasis,
        textHeightBehavior: style.contentStyle.textHeightBehavior,
        child: child,
      ),
    );

    final styledContent = style.effectiveOpacity == 1
        ? content
        : Opacity(opacity: style.effectiveOpacity, child: content);

    if (duration case final duration?) {
      return AnimatedContainer(
        alignment: style.alignment,
        padding: style.padding,
        decoration: style.decoration,
        foregroundDecoration: style.foregroundDecoration,
        width: style.width,
        height: style.height,
        constraints: style.constraints,
        margin: style.margin,
        transform: style.transform,
        transformAlignment: style.transformAlignment,
        clipBehavior: style.effectiveClipBehavior,
        duration: duration,
        curve: curve,
        onEnd: onEnd,
        child: styledContent,
      );
    }

    return Container(
      alignment: style.alignment,
      padding: style.padding,
      decoration: style.decoration,
      foregroundDecoration: style.foregroundDecoration,
      width: style.width,
      height: style.height,
      constraints: style.constraints,
      margin: style.margin,
      transform: style.transform,
      transformAlignment: style.transformAlignment,
      clipBehavior: style.effectiveClipBehavior,
      child: styledContent,
    );
  }
}
