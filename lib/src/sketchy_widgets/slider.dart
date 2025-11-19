import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';
import '../widgets/value_sync_mixin.dart';

/// Hand-drawn slider control for adjusting a numeric value.
class SketchySlider extends StatefulWidget {
  /// Creates a sketchy slider configured with the provided [value] and bounds.
  const SketchySlider({
    required this.value,
    required this.onChanged,
    super.key,
    this.divisions,
    this.label,
    this.min = 0.0,
    this.max = 1.0,
  }) : assert(min < max, 'min must be less than max'),
       assert(
         value >= min && value <= max,
         'value must be between min and max',
       ),
       assert(
         divisions == null || divisions > 0,
         'divisions must be positive',
       );

  /// Current slider value.
  final double value;

  /// Callback fired when the slider thumb moves.
  final ValueChanged<double>? onChanged;

  /// Number of discrete stops between [min] and [max].
  final int? divisions;

  /// Optional textual label describing the slider.
  final String? label;

  /// Minimum value represented by the slider.
  final double min;

  /// Maximum value represented by the slider.
  final double max;

  @override
  State<SketchySlider> createState() => _SketchySliderState();
}

class _SketchySliderState extends State<SketchySlider>
    with ValueSyncMixin<double, SketchySlider> {
  @override
  double get widgetValue => widget.value;

  @override
  double getOldWidgetValue(SketchySlider oldWidget) => oldWidget.value;

  void _updateValue(double localDx, double width) {
    final range = widget.max - widget.min;
    final percent = (localDx / width).clamp(0.0, 1.0);
    var newValue = widget.min + (range * percent);

    if (widget.divisions != null && widget.divisions! > 0) {
      final divisionSize = range / widget.divisions!;
      final steps = ((newValue - widget.min) / divisionSize).round();
      newValue = widget.min + (steps * divisionSize);
    }

    newValue = newValue.clamp(widget.min, widget.max);

    if (newValue != value) {
      updateValue(newValue);
      widget.onChanged?.call(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SizedBox(
      height: 48,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const knobSize = 24.0;
          final trackWidth = (constraints.maxWidth - knobSize).clamp(
            0.0,
            double.infinity,
          );
          final range = (widget.max - widget.min).abs();
          final normalized = range == 0
              ? 0.0
              : ((value - widget.min) / range).clamp(0.0, 1.0);
          final knobLeft = trackWidth * normalized;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onHorizontalDragUpdate: (details) {
              _updateValue(details.localPosition.dx, constraints.maxWidth);
            },
            onTapDown: (details) {
              _updateValue(details.localPosition.dx, constraints.maxWidth);
            },
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: knobSize / 2),
                  child: SketchyFrame(
                    height: theme.strokeWidth,
                    fill: SketchyFill.none,
                    child: const SizedBox.expand(),
                  ),
                ),
                Positioned(
                  left: knobLeft,
                  top: (constraints.maxHeight - knobSize) / 2,
                  child: SketchyFrame(
                    width: knobSize,
                    height: knobSize,
                    shape: SketchyFrameShape.circle,
                    fill: SketchyFill.solid,
                    fillColor: theme.colors.ink,
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
