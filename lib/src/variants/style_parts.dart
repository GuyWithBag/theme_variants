import 'package:flutter/material.dart';

import 'package:theme_variants/theme_variants.dart';

import 'decoration_partials.dart';

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

  static StylePart<TextStyle> letterSpacing(double letterSpacing) {
    return (style) => style.copyWith(letterSpacing: letterSpacing);
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

  static StylePart<IconThemeData> size(double size) {
    return (theme) => theme.copyWith(size: size);
  }

  static StylePart<IconThemeData> fill(double fill) {
    return (theme) => theme.copyWith(fill: fill);
  }

  static StylePart<IconThemeData> weight(double weight) {
    return (theme) => theme.copyWith(weight: weight);
  }

  static StylePart<IconThemeData> grade(double grade) {
    return (theme) => theme.copyWith(grade: grade);
  }

  static StylePart<IconThemeData> opticalSize(double opticalSize) {
    return (theme) => theme.copyWith(opticalSize: opticalSize);
  }

  static StylePart<IconThemeData> color(Color color) {
    return (theme) => theme.copyWith(color: color);
  }

  static StylePart<IconThemeData> opacity(double opacity) {
    return (theme) => theme.copyWith(opacity: opacity);
  }

  static StylePart<IconThemeData> shadows(List<Shadow> shadows) {
    return (theme) => theme.copyWith(shadows: shadows);
  }

  static StylePart<IconThemeData> shadowParts(
    Iterable<StylePart<Shadow>> parts, {
    int index = 0,
  }) {
    return (theme) {
      final shadows = <Shadow>[
        ...?theme.shadows?.map(PartialShadow.fromShadow),
      ];

      while (shadows.length <= index) {
        shadows.add(const PartialShadow());
      }

      shadows[index] = applyStyleParts<Shadow>(shadows[index], parts);

      return theme.copyWith(shadows: shadows);
    };
  }

  static StylePart<IconThemeData> applyTextScaling(bool applyTextScaling) {
    return (theme) => theme.copyWith(applyTextScaling: applyTextScaling);
  }
}

class ShadowPart {
  const ShadowPart._();

  static StylePart<Shadow> color(Color color) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<Shadow> offset(Offset offset) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasOffset: true,
    ).copyPartial(offset: offset);
  }

  static StylePart<Shadow> blurRadius(double blurRadius) {
    return (shadow) => PartialShadow.fromShadow(
      shadow,
      hasBlurRadius: true,
    ).copyPartial(blurRadius: blurRadius);
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

  static StylePart<InputDecorationThemeData> borderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      border: applyStyleParts<InputBorder>(
        theme.border ?? const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> enabledBorder(InputBorder border) {
    return (theme) => theme.copyWith(enabledBorder: border);
  }

  static StylePart<InputDecorationThemeData> enabledBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      enabledBorder: applyStyleParts<InputBorder>(
        theme.enabledBorder ?? theme.border ?? const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> focusedBorder(InputBorder border) {
    return (theme) => theme.copyWith(focusedBorder: border);
  }

  static StylePart<InputDecorationThemeData> focusedBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      focusedBorder: applyStyleParts<InputBorder>(
        theme.focusedBorder ?? theme.border ?? const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> disabledBorder(
    InputBorder border,
  ) {
    return (theme) => theme.copyWith(disabledBorder: border);
  }

  static StylePart<InputDecorationThemeData> disabledBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      disabledBorder: applyStyleParts<InputBorder>(
        theme.disabledBorder ?? theme.border ?? const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> errorBorder(InputBorder border) {
    return (theme) => theme.copyWith(errorBorder: border);
  }

  static StylePart<InputDecorationThemeData> errorBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      errorBorder: applyStyleParts<InputBorder>(
        theme.errorBorder ?? theme.border ?? const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> focusedErrorBorder(
    InputBorder border,
  ) {
    return (theme) => theme.copyWith(focusedErrorBorder: border);
  }

  static StylePart<InputDecorationThemeData> focusedErrorBorderParts(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return (theme) => theme.copyWith(
      focusedErrorBorder: applyStyleParts<InputBorder>(
        theme.focusedErrorBorder ??
            theme.focusedBorder ??
            theme.border ??
            const UnderlineInputBorder(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> outlineBorder(BorderSide border) {
    return (theme) => theme.copyWith(outlineBorder: border);
  }

  static StylePart<InputDecorationThemeData> outlineBorderParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (theme) => theme.copyWith(
      outlineBorder: applyStyleParts<BorderSide>(
        theme.outlineBorder ?? const BorderSide(),
        parts,
      ),
    );
  }

  static StylePart<InputDecorationThemeData> activeIndicatorBorder(
    BorderSide border,
  ) {
    return (theme) => theme.copyWith(activeIndicatorBorder: border);
  }

  static StylePart<InputDecorationThemeData> activeIndicatorBorderParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (theme) => theme.copyWith(
      activeIndicatorBorder: applyStyleParts<BorderSide>(
        theme.activeIndicatorBorder ?? const BorderSide(),
        parts,
      ),
    );
  }
}

class TextFieldStylePart {
  const TextFieldStylePart._();

  static StylePart<TextFieldStyle> textAlign(TextAlign textAlign) {
    return (style) => style.copyWith(textAlign: textAlign);
  }

  static StylePart<TextFieldStyle> cursorColor(Color cursorColor) {
    return (style) => style.copyWith(cursorColor: cursorColor);
  }

  static StylePart<TextFieldStyle> text(Iterable<StylePart<TextStyle>> parts) {
    return content({ContentStylePart.text(parts)});
  }

  static StylePart<TextFieldStyle> content(
    Iterable<StylePart<ContentStyle>> parts,
  ) {
    return (style) {
      final resolvedContent = applyStyleParts<ContentStyle>(
        ContentStyle(textStyle: style.textStyle, textAlign: style.textAlign),
        parts,
      );

      return style.copyWith(
        textStyle: resolvedContent.textStyle,
        textAlign: resolvedContent.textAlign,
      );
    };
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

  static StylePart<TextFieldStyle> border(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.borderParts(parts)});
  }

  static StylePart<TextFieldStyle> enabledBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.enabledBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> focusedBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.focusedBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> disabledBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.disabledBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> errorBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.errorBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> focusedErrorBorder(
    Iterable<StylePart<InputBorder>> parts,
  ) {
    return decoration({InputDecorationPart.focusedErrorBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> outlineBorder(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return decoration({InputDecorationPart.outlineBorderParts(parts)});
  }

  static StylePart<TextFieldStyle> activeIndicatorBorder(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return decoration({InputDecorationPart.activeIndicatorBorderParts(parts)});
  }
}

class InputBorderPart {
  const InputBorderPart._();

  static StylePart<InputBorder> borderSide(BorderSide borderSide) {
    return (border) {
      if (border is UnderlineInputBorder) {
        return PartialUnderlineInputBorder.fromBorder(
          border,
          hasBorderSide: true,
        ).copyPartial(borderSide: borderSide);
      }
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasBorderSide: true,
        ).copyPartial(borderSide: borderSide);
      }
      return border.copyWith(borderSide: borderSide);
    };
  }

  static StylePart<InputBorder> borderSideParts(
    Iterable<StylePart<BorderSide>> parts,
  ) {
    return (border) {
      final resolvedSide = applyStyleParts<BorderSide>(
        border.borderSide,
        parts,
      );
      return borderSide(resolvedSide)(border);
    };
  }

  static StylePart<InputBorder> borderRadius(BorderRadiusGeometry radius) {
    return (border) {
      if (border is UnderlineInputBorder) {
        return PartialUnderlineInputBorder.fromBorder(
          border,
          hasBorderRadius: true,
        ).copyPartial(borderRadius: radius.resolve(null));
      }
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasBorderRadius: true,
        ).copyPartial(borderRadius: radius.resolve(null));
      }
      return border;
    };
  }

  static StylePart<InputBorder> gapPadding(double gapPadding) {
    return (border) {
      if (border is OutlineInputBorder) {
        return PartialOutlineInputBorder.fromBorder(
          border,
          hasGapPadding: true,
        ).copyPartial(gapPadding: gapPadding);
      }
      return border;
    };
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

  static StylePart<BoxDecoration> borderParts(
    Iterable<StylePart<Border>> parts,
  ) {
    return (decoration) {
      final border = decoration.border is Border
          ? decoration.border! as Border
          : const Border();

      return decoration.copyWith(
        border: applyStyleParts<Border>(
          PartialBorder.fromBorder(border),
          parts,
        ),
      );
    };
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

  static StylePart<BoxDecoration> boxShadowParts(
    Iterable<StylePart<BoxShadow>> parts, {
    int index = 0,
  }) {
    return (decoration) {
      final boxShadow = <BoxShadow>[
        ...?decoration.boxShadow?.map(PartialBoxShadow.fromShadow),
      ];

      while (boxShadow.length <= index) {
        boxShadow.add(const PartialBoxShadow());
      }

      boxShadow[index] = applyStyleParts<BoxShadow>(boxShadow[index], parts);

      return decoration.copyWith(boxShadow: boxShadow);
    };
  }

  static StylePart<BoxDecoration> shape(BoxShape shape) {
    return (decoration) => decoration.copyWith(shape: shape);
  }
}

class BoxShadowPart {
  const BoxShadowPart._();

  static StylePart<BoxShadow> color(Color color) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<BoxShadow> offset(Offset offset) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasOffset: true,
    ).copyPartial(offset: offset);
  }

  static StylePart<BoxShadow> blurRadius(double blurRadius) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasBlurRadius: true,
    ).copyPartial(blurRadius: blurRadius);
  }

  static StylePart<BoxShadow> spreadRadius(double spreadRadius) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasSpreadRadius: true,
    ).copyPartial(spreadRadius: spreadRadius);
  }

  static StylePart<BoxShadow> blurStyle(BlurStyle blurStyle) {
    return (shadow) => PartialBoxShadow.fromShadow(
      shadow,
      hasBlurStyle: true,
    ).copyPartial(blurStyle: blurStyle);
  }
}

class BorderSidePart {
  const BorderSidePart._();

  static StylePart<BorderSide> color(Color color) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasColor: true,
    ).copyPartial(color: color);
  }

  static StylePart<BorderSide> width(double width) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasWidth: true,
    ).copyPartial(width: width);
  }

  static StylePart<BorderSide> style(BorderStyle style) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasStyle: true,
    ).copyPartial(style: style);
  }

  static StylePart<BorderSide> strokeAlign(double strokeAlign) {
    return (side) => PartialBorderSide.fromSide(
      side,
      hasStrokeAlign: true,
    ).copyPartial(strokeAlign: strokeAlign);
  }
}

class BorderPart {
  const BorderPart._();

  static StylePart<Border> side(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: applyStyleParts<BorderSide>(border.top, parts),
      right: applyStyleParts<BorderSide>(border.right, parts),
      bottom: applyStyleParts<BorderSide>(border.bottom, parts),
      left: applyStyleParts<BorderSide>(border.left, parts),
    );
  }

  static StylePart<Border> color(Color color) {
    return side({BorderSidePart.color(color)});
  }

  static StylePart<Border> width(double width) {
    return side({BorderSidePart.width(width)});
  }

  static StylePart<Border> style(BorderStyle style) {
    return side({BorderSidePart.style(style)});
  }

  static StylePart<Border> strokeAlign(double strokeAlign) {
    return side({BorderSidePart.strokeAlign(strokeAlign)});
  }

  static StylePart<Border> top(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: applyStyleParts<BorderSide>(border.top, parts),
      right: border.right,
      bottom: border.bottom,
      left: border.left,
    );
  }

  static StylePart<Border> right(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: applyStyleParts<BorderSide>(border.right, parts),
      bottom: border.bottom,
      left: border.left,
    );
  }

  static StylePart<Border> bottom(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: border.right,
      bottom: applyStyleParts<BorderSide>(border.bottom, parts),
      left: border.left,
    );
  }

  static StylePart<Border> left(Iterable<StylePart<BorderSide>> parts) {
    return (border) => PartialBorder(
      top: border.top,
      right: border.right,
      bottom: border.bottom,
      left: applyStyleParts<BorderSide>(border.left, parts),
    );
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
