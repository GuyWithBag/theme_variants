import 'package:flutter/material.dart';

import 'package:theme_variants/theme_variants.dart';

class CompoundVariantParts<TTokens, TValue> {
  const CompoundVariantParts({required this.when, required this.build});

  final Set<Object> when;
  final ThemeVariantPartsBuilder<TTokens, TValue> build;
}

TValue applyStyleParts<TValue>(TValue base, Iterable<StylePart<TValue>> parts) {
  return parts.fold(base, (value, part) => part(value));
}

class ButtonStylePart {
  const ButtonStylePart._();

  static StylePart<ButtonStyle> backgroundColor(Color color) {
    return (style) =>
        style.copyWith(backgroundColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> foregroundColor(Color color) {
    return (style) =>
        style.copyWith(foregroundColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> padding(EdgeInsetsGeometry padding) {
    return (style) => style.copyWith(padding: WidgetStatePropertyAll(padding));
  }

  static StylePart<ButtonStyle> side(BorderSide side) {
    return (style) => style.copyWith(side: WidgetStatePropertyAll(side));
  }

  static StylePart<ButtonStyle> shape(OutlinedBorder shape) {
    return (style) => style.copyWith(shape: WidgetStatePropertyAll(shape));
  }

  static StylePart<ButtonStyle> elevation(double elevation) {
    return (style) =>
        style.copyWith(elevation: WidgetStatePropertyAll(elevation));
  }

  static StylePart<ButtonStyle> shadowColor(Color color) {
    return (style) =>
        style.copyWith(shadowColor: WidgetStatePropertyAll(color));
  }

  static StylePart<ButtonStyle> textStyle(TextStyle textStyle) {
    return (style) =>
        style.copyWith(textStyle: WidgetStatePropertyAll(textStyle));
  }
}

class TextStylePart {
  const TextStylePart._();

  static StylePart<TextStyle> color(Color color) {
    return (style) => style.copyWith(color: color);
  }

  static StylePart<TextStyle> fontSize(double fontSize) {
    return (style) => style.copyWith(fontSize: fontSize);
  }

  static StylePart<TextStyle> fontWeight(FontWeight fontWeight) {
    return (style) => style.copyWith(fontWeight: fontWeight);
  }

  static StylePart<TextStyle> height(double height) {
    return (style) => style.copyWith(height: height);
  }

  static StylePart<TextStyle> decoration(TextDecoration decoration) {
    return (style) => style.copyWith(decoration: decoration);
  }
}

class TextThemePart {
  const TextThemePart._();

  static StylePart<TextTheme> displayLarge(TextStyle? style) {
    return (theme) => theme.copyWith(displayLarge: style);
  }

  static StylePart<TextTheme> headlineMedium(TextStyle? style) {
    return (theme) => theme.copyWith(headlineMedium: style);
  }

  static StylePart<TextTheme> titleMedium(TextStyle? style) {
    return (theme) => theme.copyWith(titleMedium: style);
  }

  static StylePart<TextTheme> bodyMedium(TextStyle? style) {
    return (theme) => theme.copyWith(bodyMedium: style);
  }
}

class IconThemePart {
  const IconThemePart._();

  static StylePart<IconThemeData> color(Color color) {
    return (theme) => theme.copyWith(color: color);
  }

  static StylePart<IconThemeData> size(double size) {
    return (theme) => theme.copyWith(size: size);
  }
}

class InputDecorationPart {
  const InputDecorationPart._();

  static StylePart<InputDecorationThemeData> contentPadding(
    EdgeInsetsGeometry padding,
  ) {
    return (theme) => theme.copyWith(contentPadding: padding);
  }

  static StylePart<InputDecorationThemeData> fillColor(Color color) {
    return (theme) => theme.copyWith(fillColor: color);
  }

  static StylePart<InputDecorationThemeData> filled(bool filled) {
    return (theme) => theme.copyWith(filled: filled);
  }

  static StylePart<InputDecorationThemeData> border(InputBorder border) {
    return (theme) => theme.copyWith(border: border);
  }

  static StylePart<InputDecorationThemeData> enabledBorder(InputBorder border) {
    return (theme) => theme.copyWith(enabledBorder: border);
  }

  static StylePart<InputDecorationThemeData> focusedBorder(InputBorder border) {
    return (theme) => theme.copyWith(focusedBorder: border);
  }
}

class TextFieldStylePart {
  const TextFieldStylePart._();

  static StylePart<TextFieldStyle> textAlign(TextAlign textAlign) {
    return (style) => style.copyWith(textAlign: textAlign);
  }

  static StylePart<TextFieldStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return (style) => style.copyWith(
      textStyle: applyStyleParts<TextStyle>(style.textStyle, parts),
    );
  }

  static StylePart<TextFieldStyle> decoration(
    Iterable<StylePart<InputDecorationThemeData>> parts,
  ) {
    return (style) => style.copyWith(
      decorationTheme: applyStyleParts<InputDecorationThemeData>(
        style.decorationTheme,
        parts,
      ),
    );
  }
}

class ListTilePart {
  const ListTilePart._();

  static StylePart<ListTileThemeData> contentPadding(
    EdgeInsetsGeometry padding,
  ) {
    return (theme) => theme.copyWith(contentPadding: padding);
  }

  static StylePart<ListTileThemeData> tileColor(Color color) {
    return (theme) => theme.copyWith(tileColor: color);
  }

  static StylePart<ListTileThemeData> selectedTileColor(Color color) {
    return (theme) => theme.copyWith(selectedTileColor: color);
  }

  static StylePart<ListTileThemeData> iconColor(Color color) {
    return (theme) => theme.copyWith(iconColor: color);
  }

  static StylePart<ListTileThemeData> textColor(Color color) {
    return (theme) => theme.copyWith(textColor: color);
  }

  static StylePart<ListTileThemeData> titleTextStyle(TextStyle style) {
    return (theme) => theme.copyWith(titleTextStyle: style);
  }
}

class CardPart {
  const CardPart._();

  static StylePart<CardThemeData> color(Color color) {
    return (theme) => theme.copyWith(color: color);
  }

  static StylePart<CardThemeData> margin(EdgeInsetsGeometry margin) {
    return (theme) => theme.copyWith(margin: margin);
  }

  static StylePart<CardThemeData> elevation(double elevation) {
    return (theme) => theme.copyWith(elevation: elevation);
  }

  static StylePart<CardThemeData> shape(ShapeBorder shape) {
    return (theme) => theme.copyWith(shape: shape);
  }

  static StylePart<CardThemeData> clipBehavior(Clip clipBehavior) {
    return (theme) => theme.copyWith(clipBehavior: clipBehavior);
  }
}

class ChipPart {
  const ChipPart._();

  static StylePart<ChipThemeData> backgroundColor(Color color) {
    return (theme) => theme.copyWith(backgroundColor: color);
  }

  static StylePart<ChipThemeData> labelStyle(TextStyle style) {
    return (theme) => theme.copyWith(labelStyle: style);
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
}

class NavigationBarPart {
  const NavigationBarPart._();

  static StylePart<NavigationBarThemeData> height(double height) {
    return (theme) => theme.copyWith(height: height);
  }

  static StylePart<NavigationBarThemeData> backgroundColor(Color color) {
    return (theme) => theme.copyWith(backgroundColor: color);
  }

  static StylePart<NavigationBarThemeData> elevation(double elevation) {
    return (theme) => theme.copyWith(elevation: elevation);
  }

  static StylePart<NavigationBarThemeData> indicatorColor(Color color) {
    return (theme) => theme.copyWith(indicatorColor: color);
  }

  static StylePart<NavigationBarThemeData> indicatorShape(ShapeBorder shape) {
    return (theme) => theme.copyWith(indicatorShape: shape);
  }

  static StylePart<NavigationBarThemeData> labelTextStyle(
    WidgetStateProperty<TextStyle?> labelTextStyle,
  ) {
    return (theme) => theme.copyWith(labelTextStyle: labelTextStyle);
  }

  static StylePart<NavigationBarThemeData> iconTheme(
    WidgetStateProperty<IconThemeData?> iconTheme,
  ) {
    return (theme) => theme.copyWith(iconTheme: iconTheme);
  }
}

class TabBarPart {
  const TabBarPart._();

  static StylePart<TabBarThemeData> labelColor(Color color) {
    return (theme) => theme.copyWith(labelColor: color);
  }

  static StylePart<TabBarThemeData> labelStyle(TextStyle style) {
    return (theme) => theme.copyWith(labelStyle: style);
  }

  static StylePart<TabBarThemeData> unselectedLabelColor(Color color) {
    return (theme) => theme.copyWith(unselectedLabelColor: color);
  }

  static StylePart<TabBarThemeData> unselectedLabelStyle(TextStyle style) {
    return (theme) => theme.copyWith(unselectedLabelStyle: style);
  }

  static StylePart<TabBarThemeData> indicator(Decoration indicator) {
    return (theme) => theme.copyWith(indicator: indicator);
  }

  static StylePart<TabBarThemeData> indicatorColor(Color color) {
    return (theme) => theme.copyWith(indicatorColor: color);
  }

  static StylePart<TabBarThemeData> labelPadding(EdgeInsetsGeometry padding) {
    return (theme) => theme.copyWith(labelPadding: padding);
  }
}

class DecorationPart {
  const DecorationPart._();

  static StylePart<BoxDecoration> color(Color color) {
    return (decoration) => decoration.copyWith(color: color);
  }

  static StylePart<BoxDecoration> border(BoxBorder border) {
    return (decoration) => decoration.copyWith(border: border);
  }

  static StylePart<BoxDecoration> borderRadius(BorderRadiusGeometry radius) {
    return (decoration) => decoration.copyWith(borderRadius: radius);
  }

  static StylePart<BoxDecoration> radius(double radius) {
    return borderRadius(BorderRadius.circular(radius));
  }

  static StylePart<BoxDecoration> boxShadow(List<BoxShadow> boxShadow) {
    return (decoration) => decoration.copyWith(boxShadow: boxShadow);
  }

  static StylePart<BoxDecoration> shape(BoxShape shape) {
    return (decoration) => decoration.copyWith(shape: shape);
  }
}

class SurfaceStylePart {
  const SurfaceStylePart._();

  static StylePart<SurfaceStyle> alignment(AlignmentGeometry alignment) {
    return (style) => style.copyWith(alignment: alignment);
  }

  static StylePart<SurfaceStyle> padding(EdgeInsetsGeometry padding) {
    return (style) => style.copyWith(padding: padding);
  }

  static StylePart<SurfaceStyle> margin(EdgeInsetsGeometry margin) {
    return (style) => style.copyWith(margin: margin);
  }

  static StylePart<SurfaceStyle> width(double width) {
    return (style) => style.copyWith(width: width);
  }

  static StylePart<SurfaceStyle> height(double height) {
    return (style) => style.copyWith(height: height);
  }

  static StylePart<SurfaceStyle> constraints(BoxConstraints constraints) {
    return (style) => style.copyWith(constraints: constraints);
  }

  static StylePart<SurfaceStyle> transform(Matrix4 transform) {
    return (style) => style.copyWith(transform: transform);
  }

  static StylePart<SurfaceStyle> transformAlignment(
    AlignmentGeometry alignment,
  ) {
    return (style) => style.copyWith(transformAlignment: alignment);
  }

  static StylePart<SurfaceStyle> clipBehavior(Clip clipBehavior) {
    return (style) => style.copyWith(clipBehavior: clipBehavior);
  }

  static StylePart<SurfaceStyle> opacity(double opacity) {
    return (style) => style.copyWith(opacity: opacity);
  }

  static StylePart<SurfaceStyle> decoration(
    Iterable<StylePart<BoxDecoration>> parts,
  ) {
    return (style) => style.copyWith(
      decoration: applyStyleParts<BoxDecoration>(style.decoration, parts),
    );
  }

  static StylePart<SurfaceStyle> foregroundDecoration(
    Iterable<StylePart<BoxDecoration>> parts,
  ) {
    return (style) => style.copyWith(
      foregroundDecoration: applyStyleParts<BoxDecoration>(
        style.foregroundDecoration ?? const BoxDecoration(),
        parts,
      ),
    );
  }

  static StylePart<SurfaceStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return content({ContentStylePart.text(parts)});
  }

  static StylePart<SurfaceStyle> icon(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return content({ContentStylePart.icon(parts)});
  }

  static StylePart<SurfaceStyle> content(
    Iterable<StylePart<ContentStyle>> parts,
  ) {
    return (style) => style.copyWith(
      contentStyle: applyStyleParts<ContentStyle>(style.contentStyle, parts),
    );
  }
}

class ContentStylePart {
  const ContentStylePart._();

  static StylePart<ContentStyle> textAlign(TextAlign textAlign) {
    return (style) => style.copyWith(textAlign: textAlign);
  }

  static StylePart<ContentStyle> softWrap(bool softWrap) {
    return (style) => style.copyWith(softWrap: softWrap);
  }

  static StylePart<ContentStyle> overflow(TextOverflow overflow) {
    return (style) => style.copyWith(overflow: overflow);
  }

  static StylePart<ContentStyle> maxLines(int maxLines) {
    return (style) => style.copyWith(maxLines: maxLines);
  }

  static StylePart<ContentStyle> textWidthBasis(TextWidthBasis textWidthBasis) {
    return (style) => style.copyWith(textWidthBasis: textWidthBasis);
  }

  static StylePart<ContentStyle> textHeightBehavior(
    TextHeightBehavior textHeightBehavior,
  ) {
    return (style) => style.copyWith(textHeightBehavior: textHeightBehavior);
  }

  static StylePart<ContentStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return (style) => style.copyWith(
      textStyle: applyStyleParts<TextStyle>(style.textStyle, parts),
    );
  }

  static StylePart<ContentStyle> icon(
    Iterable<StylePart<IconThemeData>> parts,
  ) {
    return (style) => style.copyWith(
      iconTheme: applyStyleParts<IconThemeData>(style.iconTheme, parts),
    );
  }
}
