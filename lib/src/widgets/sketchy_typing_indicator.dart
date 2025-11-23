import 'dart:async';

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import 'sketchy_symbols.dart';

/// Animated “typing” indicator made of three dots.
class SketchyTypingIndicator extends StatefulWidget {
  /// Creates a typing indicator.
  const SketchyTypingIndicator({super.key});

  @override
  State<SketchyTypingIndicator> createState() => _SketchyTypingIndicatorState();
}

class _SketchyTypingIndicatorState extends State<SketchyTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          final progress = (_controller.value + index * 0.2) % 1.0;
          final opacity = progress < 0.5 ? progress * 2 : (1 - progress) * 2;
          return Opacity(
            opacity: opacity,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: SketchySymbol(symbol: SketchySymbols.bullet, size: 6),
            ),
          );
        }),
      ),
    ),
  );
}
