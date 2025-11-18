// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

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
  State<SketchyToggle> createState() => _SketchyToggleState();
}

// ignore: library_private_types_in_public_api
class _SketchyToggleState extends State<SketchyToggle>
    with SingleTickerProviderStateMixin {
  bool _isSwitched = false;
  final double _thumbRadius = 18;
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      final nextValue = !_isSwitched;
      widget.onChanged?.call(nextValue);
      _isSwitched = nextValue;
      _toggle();
    },
    child: _buildSwitcher(context),
  );

  Widget _buildSwitcher(BuildContext context) {
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
            child: SketchyFrame(
              shape: SketchyFrameShape.circle,
              fill: SketchyFill.solid,
              fillColor: theme.colors.ink,
              child: const SizedBox.expand(),
            ),
          ),
        ),
        SizedBox(
          width: _thumbRadius * 2.5,
          height: _thumbRadius,
          child: const SketchyFrame(
            fill: SketchyFill.none,
            child: SizedBox.expand(),
          ),
        ),
      ],
    );
  }

  void _toggle() {
    unawaited(_isSwitched ? _controller.forward() : _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
