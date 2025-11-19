import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'surface.dart';

/// Rough-styled app bar used by Sketchy screens.
class SketchyAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a sketchy app bar with the given [title].
  const SketchyAppBar({
    required this.title,
    super.key,
    this.actions,
    this.leading,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) : margin = margin ?? const EdgeInsets.all(16),
       padding = padding ?? margin ?? const EdgeInsets.all(16);

  /// Title widget displayed at the center.
  final Widget title;

  /// Optional action widgets rendered on the trailing edge.
  final List<Widget>? actions;

  /// Optional leading widget (e.g., back button).
  final Widget? leading;

  /// Outer margin applied around the app bar surface.
  final EdgeInsetsGeometry margin;

  /// Inner padding applied to the sketched surface.
  final EdgeInsetsGeometry padding;

  @override
  Size get preferredSize {
    final resolved = padding.resolve(TextDirection.ltr);
    return Size.fromHeight(48 + resolved.vertical);
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
      final resolvedPadding = padding.resolve(direction);
      return Padding(
        padding: margin.resolve(direction),
        child: SketchySurface(
          padding: resolvedPadding,
          fillColor: theme.colors.paper,
          strokeColor: theme.colors.ink,
          createPrimitive: () => SketchyPrimitive.roundedRectangle(
            cornerRadius: theme.borderRadius,
            fill: SketchyFill.none,
          ),
          child: Row(
            children: [
              leading ?? const SizedBox.shrink(),
              if (leading != null) const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle(
                  style:
                      theme.typography.title.copyWith(color: theme.colors.ink),
                  child: title,
                ),
              ),
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(width: 8),
                ...actions!.map(
                  (widget) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: widget,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
