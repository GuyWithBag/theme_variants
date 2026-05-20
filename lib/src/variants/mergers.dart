import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Convenience merger for [TextStyle].
TextStyle mergeTextStyle(TextStyle base, TextStyle next) => base.merge(next);

/// Convenience merger for [TextTheme].
TextTheme mergeTextTheme(TextTheme base, TextTheme next) => base.merge(next);

/// Convenience merger for [ButtonStyle].
ButtonStyle mergeButtonStyle(ButtonStyle base, ButtonStyle next) {
  return next.merge(base);
}

/// Convenience merger for [IconThemeData].
IconThemeData mergeIconThemeData(IconThemeData base, IconThemeData next) {
  return base.merge(next);
}

/// Convenience merger for [InputDecorationThemeData].
InputDecorationThemeData mergeInputDecorationThemeData(
  InputDecorationThemeData base,
  InputDecorationThemeData next,
) {
  return next.merge(base);
}

/// Convenience merger for [ListTileThemeData].
ListTileThemeData mergeListTileThemeData(
  ListTileThemeData base,
  ListTileThemeData next,
) {
  return base.copyWith(
    dense: next.dense,
    shape: next.shape,
    style: next.style,
    selectedColor: next.selectedColor,
    iconColor: next.iconColor,
    textColor: next.textColor,
    titleTextStyle: next.titleTextStyle,
    subtitleTextStyle: next.subtitleTextStyle,
    leadingAndTrailingTextStyle: next.leadingAndTrailingTextStyle,
    contentPadding: next.contentPadding,
    tileColor: next.tileColor,
    selectedTileColor: next.selectedTileColor,
    horizontalTitleGap: next.horizontalTitleGap,
    minVerticalPadding: next.minVerticalPadding,
    minLeadingWidth: next.minLeadingWidth,
    minTileHeight: next.minTileHeight,
    enableFeedback: next.enableFeedback,
    mouseCursor: next.mouseCursor,
    isThreeLine: next.isThreeLine,
    visualDensity: next.visualDensity,
    titleAlignment: next.titleAlignment,
    controlAffinity: next.controlAffinity,
  );
}

/// Convenience merger for [CardThemeData].
CardThemeData mergeCardThemeData(CardThemeData base, CardThemeData next) {
  return base.copyWith(
    clipBehavior: next.clipBehavior,
    color: next.color,
    shadowColor: next.shadowColor,
    surfaceTintColor: next.surfaceTintColor,
    elevation: next.elevation,
    margin: next.margin,
    shape: next.shape,
  );
}

/// Convenience merger for [ChipThemeData].
ChipThemeData mergeChipThemeData(ChipThemeData base, ChipThemeData next) {
  return base.copyWith(
    color: next.color,
    backgroundColor: next.backgroundColor,
    deleteIconColor: next.deleteIconColor,
    disabledColor: next.disabledColor,
    selectedColor: next.selectedColor,
    secondarySelectedColor: next.secondarySelectedColor,
    shadowColor: next.shadowColor,
    surfaceTintColor: next.surfaceTintColor,
    selectedShadowColor: next.selectedShadowColor,
    showCheckmark: next.showCheckmark,
    checkmarkColor: next.checkmarkColor,
    labelPadding: next.labelPadding,
    padding: next.padding,
    side: next.side,
    shape: next.shape,
    labelStyle: next.labelStyle,
    secondaryLabelStyle: next.secondaryLabelStyle,
    brightness: next.brightness,
    elevation: next.elevation,
    pressElevation: next.pressElevation,
    iconTheme: next.iconTheme,
    avatarBoxConstraints: next.avatarBoxConstraints,
    deleteIconBoxConstraints: next.deleteIconBoxConstraints,
  );
}

/// Convenience merger for [NavigationBarThemeData].
NavigationBarThemeData mergeNavigationBarThemeData(
  NavigationBarThemeData base,
  NavigationBarThemeData next,
) {
  return base.copyWith(
    height: next.height,
    backgroundColor: next.backgroundColor,
    elevation: next.elevation,
    shadowColor: next.shadowColor,
    surfaceTintColor: next.surfaceTintColor,
    indicatorColor: next.indicatorColor,
    indicatorShape: next.indicatorShape,
    labelTextStyle: next.labelTextStyle,
    iconTheme: next.iconTheme,
    labelBehavior: next.labelBehavior,
    overlayColor: next.overlayColor,
    labelPadding: next.labelPadding,
  );
}

/// Convenience merger for [TabBarThemeData].
TabBarThemeData mergeTabBarThemeData(
  TabBarThemeData base,
  TabBarThemeData next,
) {
  return base.copyWith(
    indicator: next.indicator,
    indicatorColor: next.indicatorColor,
    indicatorSize: next.indicatorSize,
    dividerColor: next.dividerColor,
    dividerHeight: next.dividerHeight,
    labelColor: next.labelColor,
    labelPadding: next.labelPadding,
    labelStyle: next.labelStyle,
    unselectedLabelColor: next.unselectedLabelColor,
    unselectedLabelStyle: next.unselectedLabelStyle,
    overlayColor: next.overlayColor,
    splashFactory: next.splashFactory,
    mouseCursor: next.mouseCursor,
    tabAlignment: next.tabAlignment,
    textScaler: next.textScaler,
    indicatorAnimation: next.indicatorAnimation,
    splashBorderRadius: next.splashBorderRadius,
  );
}

/// Convenience merger for [BoxDecoration].
BoxDecoration mergeBoxDecoration(BoxDecoration base, BoxDecoration next) {
  return base.copyWith(
    color: next.color,
    image: next.image,
    border: next.border,
    borderRadius: next.borderRadius,
    boxShadow: next.boxShadow,
    gradient: next.gradient,
    backgroundBlendMode: next.backgroundBlendMode,
    shape: next.shape,
  );
}

/// Convenience merger for [SurfaceStyle].
SurfaceStyle mergeSurfaceStyle(SurfaceStyle base, SurfaceStyle next) {
  return base.copyWith(
    decoration: mergeBoxDecoration(base.decoration, next.decoration),
    foregroundDecoration: switch ((
      base.foregroundDecoration,
      next.foregroundDecoration,
    )) {
      (final baseDecoration?, final nextDecoration?) => mergeBoxDecoration(
        baseDecoration,
        nextDecoration,
      ),
      (_, final nextDecoration?) => nextDecoration,
      (final baseDecoration?, _) => baseDecoration,
      _ => null,
    },
    contentStyle: mergeContentStyle(base.contentStyle, next.contentStyle),
    alignment: next.alignment ?? base.alignment,
    padding: next.padding ?? base.padding,
    margin: next.margin ?? base.margin,
    width: next.width ?? base.width,
    height: next.height ?? base.height,
    constraints: next.constraints ?? base.constraints,
    transform: next.transform ?? base.transform,
    transformAlignment: next.transformAlignment ?? base.transformAlignment,
    clipBehavior: next.clipBehavior ?? base.clipBehavior,
    opacity: next.opacity ?? base.opacity,
  );
}

/// Convenience merger for [ContentStyle].
ContentStyle mergeContentStyle(ContentStyle base, ContentStyle next) {
  return base.copyWith(
    textStyle: mergeTextStyle(base.textStyle, next.textStyle),
    iconTheme: mergeIconThemeData(base.iconTheme, next.iconTheme),
    textAlign: next.textAlign ?? base.textAlign,
    softWrap: next.softWrap ?? base.softWrap,
    overflow: next.overflow ?? base.overflow,
    maxLines: next.maxLines ?? base.maxLines,
    textWidthBasis: next.textWidthBasis ?? base.textWidthBasis,
    textHeightBehavior: next.textHeightBehavior ?? base.textHeightBehavior,
  );
}

/// Convenience merger for [TextFieldStyle].
TextFieldStyle mergeTextFieldStyle(TextFieldStyle base, TextFieldStyle next) {
  return base.copyWith(
    textStyle: mergeTextStyle(base.textStyle, next.textStyle),
    decorationTheme: mergeInputDecorationThemeData(
      base.decorationTheme,
      next.decorationTheme,
    ),
    textAlign: next.textAlign ?? base.textAlign,
    cursorColor: next.cursorColor ?? base.cursorColor,
  );
}
