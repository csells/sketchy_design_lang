import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'icons.dart';
import 'surface.dart';

/// Rough-styled icon button wrapper.
class SketchyIconButton extends StatelessWidget {
  /// Creates a new icon button with the given [icon].
  const SketchyIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.size = 40,
  });

  /// Icon displayed in the button.
  final SketchyIconSymbol icon;

  /// Tap handler; when null the button is disabled.
  final VoidCallback? onPressed;

  /// Width/height of the button.
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final content = SketchySurface(
      width: size,
      height: size,
      fillColor: theme.colors.paper,
      strokeColor: theme.colors.ink,
      createPrimitive: () => SketchyPrimitive.rectangle(fill: SketchyFill.none),
      child: SketchyIcon(icon: icon),
    );

    if (onPressed == null) {
      return Opacity(opacity: 0.4, child: IgnorePointer(child: content));
    }

    return GestureDetector(onTap: onPressed, child: content);
  }
}
