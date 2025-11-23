import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';

/// Rough-styled icon button wrapper.
class IconButton extends StatelessWidget {
  /// Creates a new icon button with the given [icon].
  const IconButton({
    required this.icon,
    this.onPressed,
    this.iconSize = 40.0,
    this.padding,
    this.alignment,
    this.color,
    this.disabledColor,
    super.key,
  });

  /// Icon displayed in the button.
  final Widget icon;

  /// Tap handler; when null the button is disabled.
  final VoidCallback? onPressed;

  /// Width/height of the button.
  final double iconSize;

  /// Padding around the icon. (Currently mapped to size logic or ignored if not
  /// applicable easily)
  final EdgeInsetsGeometry? padding;

  /// Alignment of the icon.
  final AlignmentGeometry? alignment;

  /// Color of the icon when enabled.
  final Color? color;

  /// Color of the icon when disabled.
  final Color? disabledColor;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final content = SketchySurface(
        width: iconSize,
        height: iconSize,
        fillColor: theme.paperColor,
        strokeColor: theme.inkColor,
        createPrimitive: () =>
            SketchyPrimitive.rectangle(fill: SketchyFill.none),
        child: IconTheme(
          data: IconThemeData(color: color ?? theme.inkColor),
          child: icon,
        ),
      );

      if (onPressed == null) {
        return Opacity(opacity: 0.4, child: IgnorePointer(child: content));
      }

      return GestureDetector(onTap: onPressed, child: content);
    },
  );
}
