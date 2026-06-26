import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ChipPart {
  const ChipPart._();

  static StylePart<ChipThemeData> backgroundColor(Color color) {
    return (theme) => theme.copyWith(backgroundColor: color);
  }

  static StylePart<ChipThemeData> selectedColor(Color color) {
    return (theme) => theme.copyWith(selectedColor: color);
  }

  static StylePart<ChipThemeData> secondarySelectedColor(Color color) {
    return (theme) => theme.copyWith(secondarySelectedColor: color);
  }

  static StylePart<ChipThemeData> disabledColor(Color color) {
    return (theme) => theme.copyWith(disabledColor: color);
  }

  static StylePart<ChipThemeData> labelStyle(TextStyle style) {
    return (theme) => theme.copyWith(labelStyle: style);
  }

  static StylePart<ChipThemeData> secondaryLabelStyle(TextStyle style) {
    return (theme) => theme.copyWith(secondaryLabelStyle: style);
  }

  static StylePart<ChipThemeData> text(Iterable<StylePart<TextStyle>> parts) {
    return content({ContentStylePart.text(parts)});
  }

  static StylePart<ChipThemeData> icon(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return content({ContentStylePart.icon(parts)});
  }

  static StylePart<ChipThemeData> iconThemeParts(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return icon(parts);
  }

  static StylePart<ChipThemeData> content(
    Iterable<StylePart<ContentStyle>> parts,
  ) {
    return (theme) {
      final resolvedContent = applyStyleParts<ContentStyle>(
        ContentStyle(
          textStyle: theme.labelStyle ?? const TextStyle(),
          iconTheme: theme.iconTheme ?? const IconThemeData(),
        ),
        parts,
      );

      return theme.copyWith(
        labelStyle: resolvedContent.textStyle,
        secondaryLabelStyle: resolvedContent.textStyle,
        iconTheme: resolvedContent.iconTheme,
      );
    };
  }

  static StylePart<ChipThemeData> deleteIconColor(Color color) {
    return (theme) => theme.copyWith(deleteIconColor: color);
  }

  static StylePart<ChipThemeData> checkmarkColor(Color color) {
    return (theme) => theme.copyWith(checkmarkColor: color);
  }

  static StylePart<ChipThemeData> showCheckmark(bool showCheckmark) {
    return (theme) => theme.copyWith(showCheckmark: showCheckmark);
  }

  static StylePart<ChipThemeData> labelPadding(
    EdgeInsetsGeometry labelPadding,
  ) {
    return (theme) => theme.copyWith(labelPadding: labelPadding);
  }

  static StylePart<ChipThemeData> padding(EdgeInsetsGeometry padding) {
    return (theme) => theme.copyWith(padding: padding);
  }

  static StylePart<ChipThemeData> side(BorderSide side) {
    return (theme) => theme.copyWith(side: side);
  }

  static StylePart<ChipThemeData> shape(OutlinedBorder shape) {
    return (theme) => theme.copyWith(shape: shape);
  }

  static StylePart<ChipThemeData> elevation(double elevation) {
    return (theme) => theme.copyWith(elevation: elevation);
  }

  static StylePart<ChipThemeData> pressElevation(double pressElevation) {
    return (theme) => theme.copyWith(pressElevation: pressElevation);
  }

  static StylePart<ChipThemeData> iconTheme(IconThemeData iconTheme) {
    return (theme) => theme.copyWith(iconTheme: iconTheme);
  }
}
