import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'surface.dart';

/// Alignment options for [SketchyListTile].
enum SketchyTileAlignment {
  /// Bubble aligns to the start (left in LTR).
  start,

  /// Bubble aligns to the end (right in LTR).
  end,
}

/// Sketchy-styled list tile widget.
class SketchyListTile extends StatelessWidget {
  /// Creates a new list tile with optional leading/trailing widgets.
  const SketchyListTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.alignment = SketchyTileAlignment.start,
  });

  /// Widget placed before the title.
  final Widget? leading;

  /// Primary label widget.
  final Widget? title;

  /// Secondary label widget.
  final Widget? subtitle;

  /// Widget placed at the end of the row.
  final Widget? trailing;

  /// Tap handler for the tile.
  final VoidCallback? onTap;

  /// Alignment of the bubble (start for agent, end for customer, etc.).
  final SketchyTileAlignment alignment;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) {
          final bubbleFill = alignment == SketchyTileAlignment.start
              ? theme.colors.paper
              : theme.colors.secondary.withValues(alpha: 0.5);

          final content = SketchySurface(
            padding: const EdgeInsets.all(12),
            fillColor: bubbleFill,
            strokeColor: theme.colors.ink,
            createPrimitive: () => SketchyPrimitive.roundedRectangle(
              cornerRadius: theme.borderRadius,
              fill: SketchyFill.solid,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 12)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (title != null)
                        DefaultTextStyle(
                          style: theme.typography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          child: title!,
                        ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        DefaultTextStyle(
                            style: theme.typography.caption, child: subtitle!),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 12), trailing!],
              ],
            ),
          );

          final bubble = alignment == SketchyTileAlignment.end
              ? Align(alignment: Alignment.centerRight, child: content)
              : Align(alignment: Alignment.centerLeft, child: content);

          if (onTap == null) return bubble;
          return GestureDetector(onTap: onTap, child: bubble);
        },
      );
}
