// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';
import 'value_sync_mixin.dart';

/// Sketchy toggle
class SketchySwitch extends StatefulWidget {
  const SketchySwitch({
    required this.value,
    required this.onChanged,
    super.key,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SketchySwitch> createState() => _SketchySwitchState();
}

// ignore: library_private_types_in_public_api
class _SketchySwitchState extends State<SketchySwitch>
    with SingleTickerProviderStateMixin, ValueSyncMixin<bool, SketchySwitch> {
  final double _thumbRadius = 18;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  bool get widgetValue => widget.value;

  @override
  bool getOldWidgetValue(SketchySwitch oldWidget) => oldWidget.value;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(covariant SketchySwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only toggle animation when the value actually changes
    if (widget.value != oldWidget.value) {
      _toggle();
    }
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => GestureDetector(
      onTap: () {
        final nextValue = !value;
        widget.onChanged?.call(nextValue);
        updateValue(nextValue);
        _toggle();
      },
      child: _buildSwitcher(theme),
    ),
  );

  Widget _buildSwitcher(SketchyThemeData theme) => Stack(
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
            fillColor: theme.inkColor,
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

  void _toggle() {
    unawaited(value ? _controller.forward() : _controller.reverse());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
