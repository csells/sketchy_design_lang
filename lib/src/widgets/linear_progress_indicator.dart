import 'dart:ui';

import 'package:flutter/rendering.dart' show SemanticsProperties;
import 'package:flutter/semantics.dart' show SemanticsProperties;
import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';

/// Sketchy progress bar.
class LinearProgressIndicator extends StatefulWidget {
  /// Creates a linear progress indicator.
  const LinearProgressIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.color,
    this.valueColor,
    this.minHeight,
    this.semanticsLabel,
    this.semanticsValue,
    this.borderRadius,
    // Sketchy extension
    this.controller,
  });

  /// The value of this progress indicator.
  final double? value;

  /// The progress indicator's background color.
  final Color? backgroundColor;

  /// The progress indicator's color.
  final Color? color;

  /// The progress indicator's color as an animation.
  final Animation<Color?>? valueColor;

  /// The minimum height of the line.
  final double? minHeight;

  /// The [SemanticsProperties.label] for this progress indicator.
  final String? semanticsLabel;

  /// The [SemanticsProperties.value] for this progress indicator.
  final String? semanticsValue;

  /// The border radius of the progress indicator.
  final BorderRadiusGeometry? borderRadius;

  // Sketchy specifics
  /// The animation controller for the progress indicator.
  final AnimationController? controller;

  @override
  State<LinearProgressIndicator> createState() =>
      _LinearProgressIndicatorState();
}

class _LinearProgressIndicatorState extends State<LinearProgressIndicator> {
  double get _minHeight => widget.minHeight ?? 20;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTick);
    // Delay for calculating `_getWidth()` during the next frame.
    Future.delayed(Duration.zero, () {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant LinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleTick);
      widget.controller?.addListener(_handleTick);
    }
    if (widget.controller == null && oldWidget.value != widget.value) {
      setState(() {});
    }
  }

  void _handleTick() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final progress = (widget.controller?.value ?? widget.value ?? 0.0).clamp(
        0.0,
        1.0,
      );

      return SizedBox(
        height: _minHeight,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final inset = theme.strokeWidth * 0.35;
            final verticalInset = theme.strokeWidth * 0.25;
            final fillOptions = _buildFillOptions(theme.roughness);
            final interiorWidth = (availableWidth - inset * 2).clamp(
              0.0,
              double.infinity,
            );
            final fillWidth = interiorWidth * progress;

            return Stack(
              fit: StackFit.expand,
              children: [
                SketchyFrame(
                  height: _minHeight,
                  strokeColor: theme.borderColor,
                  strokeWidth: theme.strokeWidth,
                  fill: widget.backgroundColor != null
                      ? SketchyFill.solid
                      : SketchyFill.none,
                  fillColor: widget.backgroundColor,
                  child: const SizedBox.expand(),
                ),
                if (progress > 0)
                  Positioned(
                    left: inset,
                    top: verticalInset,
                    bottom: verticalInset,
                    child: SizedBox(
                      width: fillWidth,
                      child: _ProgressFill(
                        color:
                            widget.color ??
                            widget.valueColor?.value ??
                            theme.borderColor,
                        fillOptions: fillOptions,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      );
    },
  );

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTick);
    super.dispose();
  }

  SketchyFillOptions _buildFillOptions(double roughness) {
    final gap = lerpDouble(6, 1.5, roughness) ?? 3;
    final weight = lerpDouble(0.7, 1.6, roughness) ?? 1.0;
    return SketchyFillOptions(hachureGap: gap, fillWeight: weight);
  }
}

class _ProgressFill extends StatelessWidget {
  const _ProgressFill({required this.color, required this.fillOptions});

  final Color color;
  final SketchyFillOptions fillOptions;

  @override
  Widget build(BuildContext context) => SketchyFrame(
    fill: SketchyFill.hachure,
    fillOptions: fillOptions,
    fillColor: color,
    strokeColor: const Color(0x00000000),
    strokeWidth: 0,
    child: const SizedBox.expand(),
  );
}
