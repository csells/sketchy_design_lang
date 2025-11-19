import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Rough-styled push button following the Sketchy aesthetic.
class SketchyButton extends StatelessWidget {
  /// Creates a sketchy button that renders [child] within a hand-drawn frame.
  const SketchyButton({required this.child, this.onPressed, super.key});

  /// Widget displayed inside the button.
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SketchyFrame(
      height: 42,
      padding: EdgeInsets.zero,
      strokeColor: theme.borderColor,
      strokeWidth: theme.strokeWidth,
      fill: SketchyFill.none,
      child: SizedBox(
        height: double.infinity,
        child: MouseRegion(
          cursor: onPressed != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: onPressed,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    color: onPressed != null
                        ? theme.textColor
                        : theme.disabledTextColor,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
