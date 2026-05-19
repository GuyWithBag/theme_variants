import 'package:flutter/material.dart';

/// Theme-specific design values used by variant recipes.
///
/// This is closer to Tailwind theme config or CSS custom properties than CVA.
/// CVA decides which style pieces apply; tokens provide the values those style
/// pieces read from the active theme.
typedef AppTokens = ({
  Color primary,
  Color onPrimary,
  Color danger,
  Color onDanger,
  double radius,
  double borderWidth,
  double spaceSm,
  double spaceMd,
  double spaceLg,
});
