import 'dart:async';

import 'package:flutter/widgets.dart' hide Text;

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';
import 'text.dart' as sketchy;

/// Displays transient "Sketchy message" banners.
class SnackBar extends StatefulWidget {
  /// Creates a snack bar.
  const SnackBar({
    required this.content,
    super.key,
    this.backgroundColor,
    this.elevation,
    this.margin,
    this.padding,
    this.width,
    this.shape,
    this.behavior,
    this.action,
    this.duration = const Duration(seconds: 4),
    this.animation,
    this.onVisible,
    this.dismissDirection,
    this.clipBehavior = Clip.hardEdge,
    // Sketchy specifics
    this.textCase,
  });

  /// The primary content of the snack bar.
  final Widget content;

  /// The background color of the snack bar.
  final Color? backgroundColor;

  /// The z-coordinate at which to place the snack bar. (Unused)
  final double? elevation;

  /// The empty space that surrounds the snack bar.
  final EdgeInsetsGeometry? margin;

  /// The amount of padding to apply to the snack bar's content.
  final EdgeInsetsGeometry? padding;

  /// The width of the snack bar.
  final double? width;

  /// The shape of the snack bar's material. (Unused)
  final ShapeBorder? shape;

  /// Defines the behavior of the snack bar.
  final SnackBarBehavior? behavior;

  /// An action that the user can take based on the snack bar.
  final SnackBarAction? action;

  /// The amount of time the snack bar should be displayed.
  final Duration duration;

  /// The animation driving the entrance and exit of the snack bar.
  final Animation<double>? animation;

  /// Called when the snack bar is visible.
  final VoidCallback? onVisible;

  /// The direction in which the snack bar can be dismissed.
  final DismissDirection? dismissDirection;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  /// Sketchy specifics / Text casing transformation. If null, uses theme
  /// default.
  final TextCase? textCase;

  /// Shows a top-anchored message that slides into view.
  ///
  /// This is a convenience method that uses an Overlay to display the SnackBar,
  /// similar to the old SketchyToast.
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
      builder: (context) => _SnackBarOverlay(
        content: sketchy.Text(message),
        duration: duration,
        onDismissed: () => entry.remove(),
        textCase: textCase,
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<SnackBar> createState() => _SnackBarState();
}

class _SnackBarState extends State<SnackBar> {
  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SketchySurface(
      padding:
          widget.padding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      fillColor: widget.backgroundColor ?? theme.inkColor,
      strokeColor: theme.inkColor,
      createPrimitive: () => SketchyPrimitive.roundedRectangle(
        fill: SketchyFill.solid,
        cornerRadius: theme.borderRadius,
      ),
      child: DefaultTextStyle(
        style: theme.typography.body.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.paperColor,
        ),
        child: widget.textCase != null && widget.content is sketchy.Text
            ? sketchy.Text(
                (widget.content as sketchy.Text).data,
                textCase: widget.textCase,
              )
            : widget.content,
      ),
    ),
  );
}

class _SnackBarOverlay extends StatefulWidget {
  const _SnackBarOverlay({
    required this.content,
    required this.duration,
    required this.onDismissed,
    this.textCase,
  });

  final Widget content;
  final Duration duration;
  final TextCase? textCase;
  final VoidCallback onDismissed;

  @override
  State<_SnackBarOverlay> createState() => _SnackBarOverlayState();
}

class _SnackBarOverlayState extends State<_SnackBarOverlay>
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
                child: SnackBar(
                  content: widget.content,
                  duration: widget.duration,
                  textCase: widget.textCase,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Placeholder classes for Material compatibility if they are not exported by
/// widgets / Action to be taken in the snack bar.
class SnackBarAction {
  /// Creates a snack bar action.
  const SnackBarAction({
    required this.label,
    required this.onPressed,
    this.textColor,
    this.disabledTextColor,
  });

  /// The label for the action.
  final String label;

  /// The callback to execute when the action is pressed.
  final VoidCallback onPressed;

  /// The text color for the action.
  final Color? textColor;

  /// The disabled text color for the action.
  final Color? disabledTextColor;
}

/// The behavior of the snack bar.
enum SnackBarBehavior {
  /// Fixed behavior.
  fixed,

  /// Floating behavior.
  floating,
}
