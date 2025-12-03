import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';

/// Position of the drawer.
enum SketchyDrawerPosition {
  /// Drawer slides in from the left.
  start,

  /// Drawer slides in from the right.
  end,
}

/// A controller for managing a [SketchyDrawer].
class SketchyDrawerController extends ChangeNotifier {
  bool _isOpen = false;

  /// Whether the drawer is currently open.
  bool get isOpen => _isOpen;

  /// Opens the drawer.
  void open() {
    if (!_isOpen) {
      _isOpen = true;
      notifyListeners();
    }
  }

  /// Closes the drawer.
  void close() {
    if (_isOpen) {
      _isOpen = false;
      notifyListeners();
    }
  }

  /// Toggles the drawer open/closed.
  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
}

/// A Material-like drawer with sketchy styling.
///
/// Use with [SketchyDrawerController] to open and close.
class SketchyDrawer extends StatefulWidget {
  /// Creates a sketchy drawer.
  const SketchyDrawer({
    super.key,
    required this.controller,
    required this.child,
    required this.drawer,
    this.position = SketchyDrawerPosition.end,
    this.drawerWidth = 300,
    this.scrimColor,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  /// Controller for opening/closing the drawer.
  final SketchyDrawerController controller;

  /// The main content behind the drawer.
  final Widget child;

  /// The drawer content.
  final Widget drawer;

  /// Position of the drawer (start = left, end = right).
  final SketchyDrawerPosition position;

  /// Width of the drawer.
  final double drawerWidth;

  /// Color of the scrim overlay (defaults to semi-transparent black).
  final Color? scrimColor;

  /// Duration of the slide animation.
  final Duration animationDuration;

  @override
  State<SketchyDrawer> createState() => _SketchyDrawerState();
}

class _SketchyDrawerState extends State<SketchyDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scrimAnimation;
  late final SketchyPrimitive _drawerPrimitive;

  @override
  void initState() {
    super.initState();
    _drawerPrimitive = SketchyPrimitive.rectangle(fill: SketchyFill.solid);
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _slideAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _scrimAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    widget.controller.addListener(_onControllerChanged);
    if (widget.controller.isOpen) {
      _animationController.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant SketchyDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (widget.controller.isOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final scrimColor =
          widget.scrimColor ?? const Color(0x66000000);
      final isEnd = widget.position == SketchyDrawerPosition.end;

      return Stack(
        children: [
          widget.child,
          // Scrim
          AnimatedBuilder(
            animation: _scrimAnimation,
            builder: (context, child) {
              if (_scrimAnimation.value == 0) {
                return const SizedBox.shrink();
              }
              return GestureDetector(
                onTap: widget.controller.close,
                child: ColoredBox(
                  color: scrimColor.withValues(
                    alpha: scrimColor.a * _scrimAnimation.value,
                  ),
                  child: const SizedBox.expand(),
                ),
              );
            },
          ),
          // Drawer
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              final offset = _slideAnimation.value * widget.drawerWidth;
              return Positioned(
                top: 0,
                bottom: 0,
                left: isEnd ? null : -offset,
                right: isEnd ? -offset : null,
                width: widget.drawerWidth,
                child: SketchySurface(
                  fillColor: theme.paperColor,
                  strokeColor: theme.inkColor,
                  createPrimitive: () => _drawerPrimitive,
                  child: widget.drawer,
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
