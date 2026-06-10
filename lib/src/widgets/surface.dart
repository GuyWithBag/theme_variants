import 'package:flutter/material.dart';

import 'package:theme_variants/theme_variants.dart';

/// Applies a [SurfaceStyle] to a widget subtree.
///
/// This is the render helper for styles that combine a box surface with text
/// and icon styling.
class Surface extends StatelessWidget {
  const Surface({
    this.style,
    this.child,
    this.duration,
    this.curve = Curves.linear,
    this.onEnd,
    super.key,
    this.hasClipRRect = false,
  });

  final SurfaceStyle? style;
  final Widget? child;
  final Duration? duration;
  final Curve curve;
  final VoidCallback? onEnd;
  final bool hasClipRRect;

  @override
  Widget build(BuildContext context) {
    final resolvedStyle = style ?? const SurfaceStyle();
    final resolvedChild = child ?? const SizedBox.shrink();

    final content = IconTheme(
      data: resolvedStyle.iconTheme,
      child: DefaultTextStyle(
        style: resolvedStyle.textStyle,
        textAlign: resolvedStyle.contentStyle.textAlign,
        softWrap: resolvedStyle.contentStyle.effectiveSoftWrap,
        overflow: resolvedStyle.contentStyle.effectiveOverflow,
        maxLines: resolvedStyle.contentStyle.maxLines,
        textWidthBasis: resolvedStyle.contentStyle.effectiveTextWidthBasis,
        textHeightBehavior: resolvedStyle.contentStyle.textHeightBehavior,
        child: resolvedChild,
      ),
    );

    final styledContent = resolvedStyle.effectiveOpacity == 1
        ? content
        : Opacity(opacity: resolvedStyle.effectiveOpacity, child: content);

    if (duration case final duration?) {
      return AnimatedContainer(
        alignment: resolvedStyle.alignment,
        padding: resolvedStyle.padding,
        decoration: resolvedStyle.decoration,
        foregroundDecoration: resolvedStyle.foregroundDecoration,
        width: resolvedStyle.width,
        height: resolvedStyle.height,
        constraints: resolvedStyle.constraints,
        margin: resolvedStyle.margin,
        transform: resolvedStyle.transform,
        transformAlignment: resolvedStyle.transformAlignment,
        clipBehavior: resolvedStyle.effectiveClipBehavior,
        duration: duration,
        curve: curve,
        onEnd: onEnd,
        child: hasClipRRect
            ? ClipRRect(
                borderRadius: resolvedStyle.effectiveBorderRadius,
                child: styledContent,
              )
            : styledContent,
      );
    }

    return Container(
      alignment: resolvedStyle.alignment,
      padding: resolvedStyle.padding,
      decoration: resolvedStyle.decoration,
      foregroundDecoration: resolvedStyle.foregroundDecoration,
      width: resolvedStyle.width,
      height: resolvedStyle.height,
      constraints: resolvedStyle.constraints,
      margin: resolvedStyle.margin,
      transform: resolvedStyle.transform,
      transformAlignment: resolvedStyle.transformAlignment,
      clipBehavior: resolvedStyle.effectiveClipBehavior,
      child: hasClipRRect
          ? ClipRRect(
              borderRadius: resolvedStyle.effectiveBorderRadius,
              child: styledContent,
            )
          : styledContent,
    );
  }
}
