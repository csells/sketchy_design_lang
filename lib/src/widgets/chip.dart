import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';
import 'surface.dart';
import 'text.dart';

/// Choice chip rendered with rough outlines.
class SketchyChip extends StatelessWidget {
  const SketchyChip._({
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.filled,
    this.textCase,
    super.key,
  });

  /// Selectable chip variant.
  const SketchyChip.choice({
    required String label,
    required bool selected,
    required VoidCallback onSelected,
    TextCase? textCase,
    Key? key,
  }) : this._(
         key: key,
         label: label,
         selected: selected,
         onSelected: onSelected,
         filled: true,
         textCase: textCase,
       );

  /// Non-interactive suggestion chip.
  const SketchyChip.suggestion({
    required String label,
    TextCase? textCase,
    Key? key,
  }) : this._(
         key: key,
         label: label,
         selected: false,
         onSelected: null,
         filled: false,
         textCase: textCase,
       );

  /// Chip label text.
  final String label;

  /// Whether the chip is currently selected.
  final bool selected;

  /// Callback invoked when the chip is tapped.
  final VoidCallback? onSelected;

  /// Whether the chip draws a filled background.
  final bool filled;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final typography = SketchyTypography.of(context);
    final bgColor = filled && selected
        ? theme.colors.secondary
        : theme.colors.paper;
    final fillStyle = filled && selected
        ? SketchyFill.hachure
        : SketchyFill.none;

    final chip = SketchySurface(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      fillColor: bgColor,
      strokeColor: theme.colors.ink,
      createPrimitive: () => SketchyPrimitive.pill(fill: fillStyle),
      child: SketchyText(
        label,
        textCase: textCase,
        style: typography.body.copyWith(
          color: theme.colors.ink,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    );

    if (onSelected == null) return chip;
    return GestureDetector(onTap: onSelected, child: chip);
  }
}
