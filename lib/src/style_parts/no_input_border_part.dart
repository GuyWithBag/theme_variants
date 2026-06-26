import 'package:flutter/material.dart';
import 'package:theme_variants/src/messages/conflicting_input_border_parts_message.dart';
import 'package:theme_variants/theme_variants.dart';

class NoInputBorderPart {
  const NoInputBorderPart._();

  static StylePart<InputBorder> none() {
    return (border) {
      if (border is PartialOutlineInputBorder ||
          border is PartialUnderlineInputBorder) {
        throw StateError(conflictingInputBorderPartsMessage);
      }

      return const PartialNoInputBorder();
    };
  }
}
