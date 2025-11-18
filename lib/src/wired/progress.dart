// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';
import '../theme/sketchy_theme.dart';

/// Wired progress
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

class _SketchyProgressBarState extends State<SketchyProgressBar>
    with WiredRepaintMixin {
  final double _progressHeight = 20;
  double _width = 0;

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
  Widget build(BuildContext context) =>
      buildWiredElement(child: _buildWidget(context));

  Widget _buildWidget(BuildContext context) {
    final theme = SketchyTheme.of(context);
    _width = _getWidth();
    final progress = (widget.controller?.value ?? widget.value).clamp(0.0, 1.0);

    return Stack(
      children: [
        SizedBox(
          height: _progressHeight,
          width: _width * progress,
          child: WiredCanvas(
            painter: WiredRectangleBase(
              fillColor: theme.borderColor,
              strokeColor: theme.borderColor,
            ),
            fillerType: RoughFilter.HachureFiller,
            fillerConfig: FillerConfig.build(hachureGap: 1.5),
          ),
        ),
        SizedBox(
          height: _progressHeight,
          width: _width,
          child: WiredCanvas(
            painter: WiredRectangleBase(strokeColor: theme.borderColor),
            fillerType: RoughFilter.NoFiller,
          ),
        ),
        LinearProgressIndicator(
          backgroundColor: Colors.transparent,
          minHeight: _progressHeight,
          color: Colors.transparent,
          value: progress,
        ),
      ],
    );
  }

  double _getWidth() {
    double width = 0;
    try {
      final box = context.findRenderObject()! as RenderBox;
      width = box.size.width;
    } catch (e) {}

    return width;
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTick);
    super.dispose();
  }
}
