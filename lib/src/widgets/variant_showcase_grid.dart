import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

/// Builds a preview for one resolved variant combination.
typedef VariantShowcaseBuilder<TValue> =
    Widget Function(
      BuildContext context,
      TValue style,
      List<Object> selectedVariants,
    );

/// Describes one variant group shown by [VariantShowcaseGrid].
class VariantShowcaseAxis {
  const VariantShowcaseAxis({
    required this.variants,
    this.label,
    this.labels = const {},
  });

  /// Display name for this group, for example `Size` or `Tone`.
  final String? label;

  /// Variants from the same variant type or design axis.
  final List<Object> variants;

  /// Optional display labels for variants. Defaults to `variant.toString()`.
  final Map<Object, String> labels;

  String labelFor(Object variant) {
    final label = labels[variant];
    if (label != null) {
      return label;
    }
    if (variant case final Enum enumValue) {
      return enumValue.name;
    }
    return variant.toString();
  }
}

/// Displays every combination from a set of variant axes.
///
/// The widget resolves [style] with the nearest `ThemeVariantsProvider` tokens
/// and delegates actual preview rendering to [builder], so it works with
/// `ButtonStyle`, `TextStyle`, `SurfaceStyle`, or custom style values.
class VariantShowcaseGrid<TTokens> extends StatelessWidget {
  const VariantShowcaseGrid({
    required this.style,
    this.axes,
    this.builder,
    this.title,
    this.minCellWidth = 180,
    this.spacing = 12,
    this.runSpacing = 12,
    this.cellPadding = const EdgeInsets.all(12),
    this.previewText = 'Preview',
    this.showCompoundVariants = true,
    super.key,
  }) : assert(minCellWidth > 0),
       assert(spacing >= 0),
       assert(runSpacing >= 0);

  final VariantStyle<TTokens, dynamic> style;
  final List<VariantShowcaseAxis>? axes;
  final VariantShowcaseBuilder<dynamic>? builder;
  final Widget? title;
  final double minCellWidth;
  final double spacing;
  final double runSpacing;
  final EdgeInsetsGeometry cellPadding;
  final String previewText;
  final bool showCompoundVariants;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<TTokens>();
    final resolvedAxes = axes ?? _axesFromStyle(style);
    final combinations = _variantCombinations(
      resolvedAxes,
      style: style,
      includeCompoundVariants: showCompoundVariants,
    );

    if (combinations.isEmpty) {
      return const SizedBox.shrink();
    }

    final grid = LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final availableWidth = width.isFinite ? width : minCellWidth;
        final columnCount = (availableWidth / minCellWidth)
            .floor()
            .clamp(1, combinations.length)
            .toInt();
        final cellWidth =
            (availableWidth - (spacing * (columnCount - 1))) / columnCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final selectedVariants in combinations)
              SizedBox(
                width: cellWidth,
                child: _VariantShowcaseCell(
                  axes: resolvedAxes,
                  selectedVariants: selectedVariants,
                  isCompound: _matchesCompound(style, selectedVariants),
                  padding: cellPadding,
                  child: _buildPreview(
                    context,
                    style.resolve(tokens, selectedVariants),
                    selectedVariants,
                  ),
                ),
              ),
          ],
        );
      },
    );

    if (title == null) {
      return grid;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.titleMedium,
          child: title!,
        ),
        const SizedBox(height: 12),
        grid,
      ],
    );
  }

  static List<List<Object>> _variantCombinations<TTokens>(
    List<VariantShowcaseAxis> axes, {
    required VariantStyle<TTokens, dynamic> style,
    required bool includeCompoundVariants,
  }) {
    if (axes.isEmpty) {
      return const [[]];
    }

    var combinations = <List<Object>>[const []];
    for (final axis in axes) {
      combinations = [
        for (final combination in combinations)
          for (final variant in axis.variants) [...combination, variant],
      ];
    }

    if (includeCompoundVariants) {
      for (final compound in style.compoundVariants) {
        final combination = _sortVariantsForAxes(compound.when, axes);
        if (!_containsCombination(combinations, combination)) {
          combinations.add(combination);
        }
      }
    }

    return combinations;
  }

  static List<VariantShowcaseAxis> _axesFromStyle<TTokens>(
    VariantStyle<TTokens, dynamic> style,
  ) {
    final groups = <Type, List<Object>>{};
    for (final variant in style.variants.keys) {
      groups.putIfAbsent(variant.runtimeType, () => []).add(variant);
    }

    return [
      for (final entry in groups.entries)
        VariantShowcaseAxis(
          label: _displayTypeName(entry.key),
          variants: entry.value,
        ),
    ];
  }

  static List<Object> _sortVariantsForAxes(
    Set<Object> variants,
    List<VariantShowcaseAxis> axes,
  ) {
    return [
      for (final axis in axes)
        for (final variant in axis.variants)
          if (variants.contains(variant)) variant,
      for (final variant in variants)
        if (!axes.any((axis) => axis.variants.contains(variant))) variant,
    ];
  }

  static bool _containsCombination(
    List<List<Object>> combinations,
    List<Object> candidate,
  ) {
    return combinations.any((combination) {
      return combination.length == candidate.length &&
          combination.toSet().containsAll(candidate);
    });
  }

  static bool _matchesCompound<TTokens>(
    VariantStyle<TTokens, dynamic> style,
    List<Object> selectedVariants,
  ) {
    final selected = selectedVariants.toSet();
    return style.compoundVariants.any((compound) {
      return compound.matches(selected);
    });
  }

  static String _displayTypeName(Type type) {
    final name = type.toString();
    return name.replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (match) {
      return ' ${match.group(1)}';
    });
  }

  Widget _buildPreview(
    BuildContext context,
    dynamic resolvedStyle,
    List<Object> selectedVariants,
  ) {
    final customBuilder = builder;
    if (customBuilder != null) {
      return customBuilder(context, resolvedStyle, selectedVariants);
    }

    return switch (resolvedStyle) {
      ButtonStyle style => FilledButton(
        style: style,
        onPressed: () {},
        child: Text(previewText),
      ),
      TextStyle style => Text(previewText, style: style),
      TextTheme style => _TextThemePreview(textTheme: style, text: previewText),
      IconThemeData style => IconTheme(
        data: style,
        child: const Icon(Icons.auto_awesome),
      ),
      InputDecorationThemeData style => InputDecorator(
        decoration: InputDecoration(
          labelText: previewText,
        ).applyDefaults(style),
        child: const SizedBox.shrink(),
      ),
      TextFieldStyle style => _TextFieldStylePreview(
        style: style,
        text: previewText,
      ),
      ListTileThemeData style => ListTileTheme(
        data: style,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.palette_outlined),
          title: Text(previewText),
        ),
      ),
      CardThemeData style => CardTheme(
        data: style,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(previewText),
          ),
        ),
      ),
      ChipThemeData style => ChipTheme(
        data: style,
        child: Chip(label: Text(previewText)),
      ),
      NavigationBarThemeData style => NavigationBarTheme(
        data: style,
        child: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          ],
        ),
      ),
      TabBarThemeData style => DefaultTabController(
        length: 2,
        child: TabBarTheme(
          data: style,
          child: const TabBar(
            tabs: [
              Tab(text: 'One'),
              Tab(text: 'Two'),
            ],
          ),
        ),
      ),
      BoxDecoration style => DecoratedBox(
        decoration: style,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(previewText),
        ),
      ),
      SurfaceStyle style => Surface(style: style, child: Text(previewText)),
      ContentStyle style => IconTheme(
        data: style.iconTheme,
        child: DefaultTextStyle(
          style: style.textStyle,
          textAlign: style.textAlign,
          softWrap: style.effectiveSoftWrap,
          overflow: style.effectiveOverflow,
          maxLines: style.maxLines,
          textWidthBasis: style.effectiveTextWidthBasis,
          textHeightBehavior: style.textHeightBehavior,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.palette_outlined),
              const SizedBox(width: 8),
              Text(previewText),
            ],
          ),
        ),
      ),
      _ => Text(resolvedStyle.toString()),
    };
  }
}

class _VariantShowcaseCell extends StatelessWidget {
  const _VariantShowcaseCell({
    required this.axes,
    required this.selectedVariants,
    required this.isCompound,
    required this.padding,
    required this.child,
  });

  final List<VariantShowcaseAxis> axes;
  final List<Object> selectedVariants;
  final bool isCompound;
  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final variant in selectedVariants)
                  _VariantEyebrow(
                    label: _axisLabelFor(variant),
                    value: _variantLabelFor(variant),
                  ),
                if (isCompound)
                  const _VariantEyebrow(label: 'State', value: 'Compound'),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  String _axisLabelFor(Object variant) {
    for (final axis in axes) {
      if (axis.variants.contains(variant)) {
        return axis.label ??
            VariantShowcaseGrid._displayTypeName(variant.runtimeType);
      }
    }
    return VariantShowcaseGrid._displayTypeName(variant.runtimeType);
  }

  String _variantLabelFor(Object variant) {
    for (final axis in axes) {
      if (axis.variants.contains(variant)) {
        return axis.labelFor(variant);
      }
    }
    if (variant case final Enum enumValue) {
      return enumValue.name;
    }
    return variant.toString();
  }
}

class _VariantEyebrow extends StatelessWidget {
  const _VariantEyebrow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(value, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _TextThemePreview extends StatelessWidget {
  const _TextThemePreview({required this.textTheme, required this.text});

  final TextTheme textTheme;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text, style: textTheme.titleMedium),
        Text(text, style: textTheme.bodyMedium),
      ],
    );
  }
}

class _TextFieldStylePreview extends StatelessWidget {
  const _TextFieldStylePreview({required this.style, required this.text});

  final TextFieldStyle style;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      textAlign: style.textAlign,
      decoration: InputDecoration(
        labelText: text,
      ).applyDefaults(style.decorationTheme),
      child: Text(text, style: style.textStyle),
    );
  }
}
