import 'package:flutter/material.dart' show ButtonStyle;
import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';

/// Rough-styled push button following the Sketchy aesthetic.
class OutlinedButton extends StatelessWidget {
  /// Creates a sketchy button that renders [child] within a hand-drawn frame.
  const OutlinedButton({
    required this.onPressed,
    required this.child,
    this.style,
    super.key,
  });

  /// Widget displayed inside the button.
  final Widget child;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Custom style for the button. (Currently unused in Sketchy implementation)
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => IntrinsicWidth(
      child: IntrinsicHeight(
        child: SketchyFrame(
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
        ),
      ),
    ),
  );
}
