import 'package:theme_variants/theme_variants.dart';

/// Convenience merger for [SurfaceStyle].
SurfaceStyle mergeSurfaceStyle(SurfaceStyle base, SurfaceStyle next) {
  return base.merge(next);
}

/// Adds Flutter-style merge behavior to [SurfaceStyle].
extension SurfaceStyleMerge on SurfaceStyle {
  SurfaceStyle merge(SurfaceStyle next) {
    return copyWith(
      decoration: mergeBoxDecoration(decoration, next.decoration),
      foregroundDecoration: switch ((
        foregroundDecoration,
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
      contentStyle: contentStyle.merge(next.contentStyle),
      alignment: next.alignment ?? alignment,
      padding: next.padding ?? padding,
      margin: next.margin ?? margin,
      width: next.width ?? width,
      height: next.height ?? height,
      constraints: next.constraints ?? constraints,
      transform: next.transform ?? transform,
      transformAlignment: next.transformAlignment ?? transformAlignment,
      clipBehavior: next.clipBehavior ?? clipBehavior,
      opacity: next.opacity ?? opacity,
    );
  }
}

/// Convenience merger for [ContentStyle].
ContentStyle mergeContentStyle(ContentStyle base, ContentStyle next) {
  return base.merge(next);
}

/// Adds Flutter-style merge behavior to [ContentStyle].
extension ContentStyleMerge on ContentStyle {
  ContentStyle merge(ContentStyle next) {
    return copyWith(
      textStyle: mergeTextStyle(textStyle, next.textStyle),
      iconTheme: mergeIconThemeData(iconTheme, next.iconTheme),
      textAlign: next.textAlign ?? textAlign,
      softWrap: next.softWrap ?? softWrap,
      overflow: next.overflow ?? overflow,
      maxLines: next.maxLines ?? maxLines,
      textWidthBasis: next.textWidthBasis ?? textWidthBasis,
      textHeightBehavior: next.textHeightBehavior ?? textHeightBehavior,
    );
  }
}

/// Convenience merger for [TextFieldStyle].
TextFieldStyle mergeTextFieldStyle(TextFieldStyle base, TextFieldStyle next) {
  return base.merge(next);
}

/// Adds Flutter-style merge behavior to [TextFieldStyle].
extension TextFieldStyleMerge on TextFieldStyle {
  TextFieldStyle merge(TextFieldStyle next) {
    return copyWith(
      textStyle: mergeTextStyle(textStyle, next.textStyle),
      decorationTheme: mergeInputDecorationThemeData(
        decorationTheme,
        next.decorationTheme,
      ),
      textAlign: next.textAlign ?? textAlign,
      cursorColor: next.cursorColor ?? cursorColor,
    );
  }
}
