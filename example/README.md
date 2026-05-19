# example

## `dart_mappable` Persistence Example

This package does not persist data by default. You can persist controller state
using `dart_mappable` DTOs and the controller's `exportToMap` / `importFromMap`
APIs.

Add dependencies:

```yaml
dependencies:
  dart_mappable: ^4.3.0

dev_dependencies:
  build_runner: ^2.4.0
  dart_mappable_builder: ^4.3.0
```

### 1) Define mappable DTOs

```dart
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'theme_persistence.mapper.dart';

@MappableClass()
class ThemeDataDto with ThemeDataDtoMappable {
  const ThemeDataDto({
    required this.brightness,
    required this.seedColorValue,
    required this.useMaterial3,
  });

  final String brightness; // "light" | "dark"
  final int seedColorValue;
  final bool useMaterial3;

  ThemeData toThemeData() {
    final mode = switch (brightness) {
      'dark' => Brightness.dark,
      _ => Brightness.light,
    };
    return ThemeData(
      brightness: mode,
      colorSchemeSeed: Color(seedColorValue),
      useMaterial3: useMaterial3,
    );
  }

  static ThemeDataDto fromThemeData(ThemeData theme) {
    return ThemeDataDto(
      brightness: theme.brightness.name,
      seedColorValue: theme.colorScheme.primary.value,
      useMaterial3: theme.useMaterial3,
    );
  }
}
```

```dart
@MappableClass()
class AppTokensDto with AppTokensDtoMappable {
  const AppTokensDto({
    required this.primaryValue,
    required this.onPrimaryValue,
    required this.dangerValue,
    required this.onDangerValue,
    required this.radius,
    required this.borderWidth,
    required this.spaceSm,
    required this.spaceMd,
    required this.spaceLg,
  });

  final int primaryValue;
  final int onPrimaryValue;
  final int dangerValue;
  final int onDangerValue;
  final double radius;
  final double borderWidth;
  final double spaceSm;
  final double spaceMd;
  final double spaceLg;
}
```

```dart
// Convert DTO <-> your AppTokens record type.
AppTokens dtoToTokens(AppTokensDto dto) => (
  primary: Color(dto.primaryValue),
  onPrimary: Color(dto.onPrimaryValue),
  danger: Color(dto.dangerValue),
  onDanger: Color(dto.onDangerValue),
  radius: dto.radius,
  borderWidth: dto.borderWidth,
  spaceSm: dto.spaceSm,
  spaceMd: dto.spaceMd,
  spaceLg: dto.spaceLg,
);

AppTokensDto tokensToDto(AppTokens tokens) => AppTokensDto(
  primaryValue: tokens.primary.value,
  onPrimaryValue: tokens.onPrimary.value,
  dangerValue: tokens.danger.value,
  onDangerValue: tokens.onDanger.value,
  radius: tokens.radius,
  borderWidth: tokens.borderWidth,
  spaceSm: tokens.spaceSm,
  spaceMd: tokens.spaceMd,
  spaceLg: tokens.spaceLg,
);
```

Generate mappers:

```bash
dart run build_runner build
```

### 2) Export controller state

```dart
final exported = controller.exportToMap(
  encodeThemeData: (themeData) => ThemeDataDto.fromThemeData(themeData).toMap(),
  encodeTokens: (tokens) => tokensToDto(tokens).toMap(),
);
```

Persist `exported` to your DB or file (for example `jsonEncode(exported)`).

### 3) Import controller state

```dart
controller.importFromMap(
  persistedMap,
  decodeThemeData: (raw) {
    final dto = ThemeDataDtoMapper.fromMap(
      Map<String, dynamic>.from(raw as Map),
    );
    return dto.toThemeData();
  },
  decodeTokens: (raw) {
    final dto = AppTokensDtoMapper.fromMap(
      Map<String, dynamic>.from(raw as Map),
    );
    return dtoToTokens(dto);
  },
  replaceExisting: true, // false = merge into current registry
);
```
