import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';

/// Sketchy card.
class Card extends StatelessWidget {
  /// Builds a card with a sketchy border around [child].
  const Card({
    super.key,
    this.child,
    this.color,
    this.margin,
    this.clipBehavior,
    this.elevation,
    this.shape,
    this.borderOnForeground = true,
    this.semanticContainer = true,
  });

  /// The [child] contained by the card.
  final Widget? child;

  /// The card's background color.
  final Color? color;

  /// The empty space that surrounds the card.
  final EdgeInsetsGeometry? margin;

  /// The content will be clipped (or not) according to this option.
  final Clip? clipBehavior;

  /// The z-coordinate at which to place this card. (Currently unused in
  /// Sketchy)
  final double? elevation;

  /// The shape of the card's border. (Currently unused in Sketchy)
  final ShapeBorder? shape;

  /// Whether to paint the [shape] border in front of the [child].
  /// (Currently unused)
  final bool borderOnForeground;

  /// Whether this widget represents a single semantic container.
  final bool semanticContainer;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final widget = SketchyFrame(
        padding: const EdgeInsets.all(16),
        strokeColor: theme.borderColor,
        strokeWidth: theme.strokeWidth,
        fill: color != null ? SketchyFill.solid : SketchyFill.none,
        fillColor: color,
        cornerRadius: theme.borderRadius,
        child: child ?? const SizedBox.shrink(),
      );

      if (margin != null) {
        return Padding(padding: margin!, child: widget);
      }
      return widget;
    },
  );
}
