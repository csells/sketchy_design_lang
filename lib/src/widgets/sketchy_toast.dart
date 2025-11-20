import 'dart:async';

import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'surface.dart';
import 'text.dart';

/// Displays transient "Sketchy message" banners.
class SketchyToast {
  /// Shows a top-anchored message that slides into view.
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    TextCase? textCase,
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => _SketchyToastState(
        message: message,
        duration: duration,
        onDismissed: () => entry.remove(),
        textCase: textCase,
      ),
    );

    overlay.insert(entry);
  }
}

class _SketchyToastState extends StatefulWidget {
  const _SketchyToastState({
    required this.message,
    required this.duration,
    required this.onDismissed,
    this.textCase,
  });

  final String message;
  final Duration duration;
  final TextCase? textCase;
  final VoidCallback onDismissed;

  @override
  State<_SketchyToastState> createState() => _SketchyToastStateState();
}

class _SketchyToastStateState extends State<_SketchyToastState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    unawaited(_controller.forward());
    _dismissTimer = Timer(widget.duration, () async {
      await _controller.reverse();
      if (mounted) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Align(
            alignment: Alignment.topCenter,
            child: SlideTransition(
              position: _offset,
              child: UnconstrainedBox(
                child: SketchySurface(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  fillColor: theme.inkColor,
                  strokeColor: theme.inkColor,
                  createPrimitive: () => SketchyPrimitive.roundedRectangle(
                    fill: SketchyFill.solid,
                    cornerRadius: theme.borderRadius,
                  ),
                  child: SketchyText(
                    widget.message,
                    textCase: widget.textCase,
                    style: theme.typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.paperColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
