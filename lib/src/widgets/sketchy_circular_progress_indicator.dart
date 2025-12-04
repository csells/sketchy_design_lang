// lib/widgets/sketchy_circular_progress_indicator.dart
import 'dart:async';
import 'dart:math' show pi;

import 'package:flutter/material.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';

/// Creates a circular progress indicator.
class SketchyCircularProgressIndicator extends StatefulWidget {
  /// Creates a circular progress indicator.
  const SketchyCircularProgressIndicator({
    super.key,
    this.value,
    this.strokeWidth = 4.0,
    this.size,
    this.backgroundColor,
    this.color,
    this.semanticLabel,
  });

  /// The progress value between 0 and 1.
  final double? value;

  /// The width of the progress indicator's stroke.
  final double strokeWidth;

  /// The color of the progress indicator's background.
  final Color? backgroundColor;

  /// The size of the progress indicator.
  final double? size;

  /// The color of the progress indicator.
  final Color? color;

  /// The semantic label of the progress indicator.
  final String? semanticLabel;

  @override
  State<SketchyCircularProgressIndicator> createState() => _State();
}

class _State extends State<SketchyCircularProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<double> _spinAnimation;

  static const int _fixedSeed = 12345;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // CONTINUOUS ROTATION (0 → ∞)
    _spinAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    // Progress pulse (0.75 → 1.0 for indeterminate)
    _progressAnimation = Tween<double>(begin: 0.75, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_controller, _spinAnimation]),
    builder: (context, child) {
      final theme = SketchyTheme.of(context);
      final value = widget.value ?? _progressAnimation.value;
      final spinOffset = widget.value == null
          ? _spinAnimation.value * 2 * pi
          : 0;

      return Semantics(
        label: widget.semanticLabel ?? 'Circular progress indicator',
        value: widget.value != null
            ? '${(widget.value! * 100).round()}%'
            : null,
        child: SizedBox.square(
          dimension: widget.size ?? 48,
          child: Stack(
            children: [
              // Background track
              SizedBox.expand(
                child: CustomPaint(
                  painter: SketchyShapePainter(
                    primitive: SketchyPrimitive.circle(seed: _fixedSeed),
                    strokeColor:
                        widget.backgroundColor ??
                        (widget.color ?? theme.primaryColor).withValues(
                          alpha: 0.2,
                        ),
                    fillColor: Colors.transparent,
                    strokeWidth: widget.strokeWidth * 0.6,
                    roughness: theme.roughness,
                  ),
                ),
              ),
              // Foreground arc
              if (value > 0.01)
                SizedBox.expand(
                  child: CustomPaint(
                    painter: SketchyShapePainter(
                      primitive: SketchyPrimitive.arc(
                        seed: _fixedSeed,
                        startAngle: -pi / 2 + spinOffset,
                        sweepAngle: value * 2 * pi,
                      ),
                      strokeColor: widget.color ?? theme.primaryColor,
                      fillColor: Colors.transparent,
                      strokeWidth: widget.strokeWidth,
                      roughness: theme.roughness,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
