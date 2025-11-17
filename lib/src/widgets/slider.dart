import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'surface.dart';

/// Rough-styled slider that avoids Material dependencies.
class SketchySlider extends StatefulWidget {
  /// Creates a slider with the provided [value], [min], and [max].
  const SketchySlider({
    required this.value,
    super.key,
    this.min = 0,
    this.max = 1,
    this.onChanged,
  });

  /// Current slider value.
  final double value;

  /// Minimum selectable value.
  final double min;

  /// Maximum selectable value.
  final double max;

  /// Callback invoked when the slider value changes.
  final ValueChanged<double>? onChanged;

  @override
  State<SketchySlider> createState() => _SketchySliderState();
}

class _SketchySliderState extends State<SketchySlider> {
  void _emitValue(double dx, double width) {
    if (widget.onChanged == null || width <= 0 || width.isInfinite) return;
    final factor = (dx / width).clamp(0, 1);
    final newValue = widget.min + (widget.max - widget.min) * factor;
    widget.onChanged!(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final range = widget.max - widget.min;
        final normalized = range == 0
            ? 0.0
            : ((widget.value - widget.min) / range).clamp(0, 1);
        final knobOffset = normalized * trackWidth;
        final knobLeft = trackWidth.isFinite
            ? math.max(0, math.min(trackWidth - 32, knobOffset - 16)).toDouble()
            : knobOffset - 16;

        return GestureDetector(
          onTapDown: (details) =>
              _emitValue(details.localPosition.dx, trackWidth),
          onHorizontalDragUpdate: (details) =>
              _emitValue(details.localPosition.dx, trackWidth),
          child: SizedBox(
            height: 48,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Positioned.fill(
                  child: SketchySurface(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    fillColor: theme.colors.paper,
                    strokeColor: theme.colors.ink,
                    createPrimitive: () => SketchyPrimitive.roundedRectangle(
                      cornerRadius: theme.borderRadius,
                      fill: SketchyFill.none,
                    ),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: theme.colors.secondary.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: knobLeft,
                  child: SketchySurface(
                    key: ValueKey(widget.value),
                    width: 32,
                    height: 32,
                    fillColor: theme.colors.secondary,
                    strokeColor: theme.colors.ink,
                    createPrimitive: () =>
                        SketchyPrimitive.circle(fill: SketchyFill.solid),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
