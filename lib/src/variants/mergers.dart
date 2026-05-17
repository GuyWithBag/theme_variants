import 'package:flutter/material.dart';

/// Convenience merger for [TextStyle].
TextStyle mergeTextStyle(TextStyle base, TextStyle next) => base.merge(next);

/// Convenience merger for [ButtonStyle].
ButtonStyle mergeButtonStyle(ButtonStyle base, ButtonStyle next) {
  return next.merge(base);
}
