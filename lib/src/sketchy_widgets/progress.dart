// ignore_for_file: public_member_api_docs
import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Sketchy progress bar.
///
/// Usage:
/// ```dart
/// final _controller = AnimationController(
///    duration: const Duration(milliseconds: 1000), vsync: this);
/// ......
/// SketchyProgressBar(controller: _controller, value: 0.5),
/// ......
/// _controller.forward();
/// _controller.stop();
/// _controller.reset();
/// ```
class SketchyProgressBar extends StatefulWidget {
  const SketchyProgressBar({this.controller, super.key, this.value = 0.0});

  /// The current progress value, range is 0.0 ~ 1.0.
  final double value;

  final AnimationController? controller;

  @override
  State<SketchyProgressBar> createState() => _SketchyProgressBarState();
}

class _SketchyProgressBarState extends State<SketchyProgressBar> {
  final double _progressHeight = 20;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_handleTick);
    // Delay for calculating `_getWidth()` during the next frame.
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant SketchyProgressBar oldWidget) {
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
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final progress = (widget.controller?.value ?? widget.value).clamp(0.0, 1.0);

    return SizedBox(
      height: _progressHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          final inset = theme.strokeWidth * 0.35;
          final verticalInset = theme.strokeWidth * 0.25;
          final fillOptions = _buildFillOptions(theme.roughness);
          final interiorWidth = (availableWidth - inset * 2)
              .clamp(0.0, double.infinity);
          final fillWidth = interiorWidth * progress;

          return Stack(
            fit: StackFit.expand,
            children: [
              SketchyFrame(
                height: _progressHeight,
                strokeColor: theme.borderColor,
                strokeWidth: theme.strokeWidth,
                fill: SketchyFill.none,
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
                      color: theme.borderColor,
                      fillOptions: fillOptions,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTick);
    super.dispose();
  }

  SketchyFillOptions _buildFillOptions(double roughness) {
    final gap = lerpDouble(6, 1.5, roughness) ?? 3;
    final weight = lerpDouble(0.7, 1.6, roughness) ?? 1.0;
    return SketchyFillOptions(
      hachureGap: gap,
      fillWeight: weight,
    );
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
