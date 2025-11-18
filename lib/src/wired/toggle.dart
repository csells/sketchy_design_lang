// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';
import 'canvas/wired_canvas.dart';
import 'wired_base.dart';
import '../theme/sketchy_theme.dart';

/// Wired toggle
class SketchyToggle extends StatefulWidget {
  const SketchyToggle({
    required this.value,
    required this.onChanged,
    super.key,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  _SketchyToggleState createState() => _SketchyToggleState();
}

class _SketchyToggleState extends State<SketchyToggle>
    with SingleTickerProviderStateMixin, WiredRepaintMixin {
  bool _isSwitched = false;
  final double _thumbRadius = 24;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _isSwitched = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _animation =
        Tween<double>(begin: -_thumbRadius, end: _thumbRadius * 1.5).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeIn),
        )..addListener(() {
          setState(() {});
        });

    _toggle();
  }

  @override
  void didUpdateWidget(covariant SketchyToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isSwitched = widget.value;
      _toggle();
    }
  }

  @override
  Widget build(BuildContext context) => buildWiredElement(
    child: GestureDetector(
      onTap: () {
        final nextValue = !_isSwitched;
        widget.onChanged?.call(nextValue);
        _isSwitched = nextValue;
        _toggle();
      },
      child: _buildSwicher(context),
    ),
  );

  Widget _buildSwicher(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: _animation.value,
          top: -_thumbRadius / 2,
          child: SizedBox(
            height: _thumbRadius * 2,
            width: _thumbRadius * 2,
            child: WiredCanvas(
              painter: WiredCircleBase(
                diameterRatio: .7,
                fillColor: theme.textColor,
                strokeColor: theme.textColor,
              ),
              fillerType: RoughFilter.HachureFiller,
              fillerConfig: FillerConfig.build(hachureGap: 1),
            ),
          ),
        ),
        SizedBox(
          width: _thumbRadius * 2.5,
          height: _thumbRadius,
          child: WiredCanvas(
            painter: WiredRectangleBase(strokeColor: theme.borderColor),
            fillerType: RoughFilter.NoFiller,
          ),
        ),
      ],
    );
  }

  void _toggle() {
    _isSwitched ? _controller.forward() : _controller.reverse();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
