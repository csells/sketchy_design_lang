import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';
import 'surface.dart';
import 'text.dart';

/// Tones supported by [SketchyBadge].
enum SketchyBadgeTone {
  /// Informational tone.
  info,

  /// Accent tone for primary emphasis.
  accent,

  /// Success tone.
  success,

  /// Neutral ink tone.
  neutral,
}

/// Pill-shaped label used for tagging content.
class SketchyBadge extends StatelessWidget {
  /// Creates a badge with the provided [label] and [tone].
  const SketchyBadge({
    required this.label,
    super.key,
    this.tone = SketchyBadgeTone.info,
    this.textCase,
  });

  /// Text displayed inside the badge.
  final String label;

  /// Visual tone applied to the badge fill.
  final SketchyBadgeTone tone;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final typography = SketchyTypography.of(context);
    final color = switch (tone) {
      SketchyBadgeTone.info => theme.colors.info,
      SketchyBadgeTone.accent => theme.colors.primary,
      SketchyBadgeTone.success => theme.colors.success,
      SketchyBadgeTone.neutral => theme.colors.ink,
    };

    return SketchySurface(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      fillColor: color.withValues(alpha: 0.18),
      strokeColor: theme.colors.ink,
      createPrimitive: () => SketchyPrimitive.pill(fill: SketchyFill.hachure),
      child: SketchyText(
        label,
        textCase: textCase,
        style: typography.label.copyWith(color: theme.colors.ink),
      ),
    );
  }
}
