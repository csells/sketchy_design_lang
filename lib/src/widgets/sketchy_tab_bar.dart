import 'package:flutter/material.dart'
    show DefaultTabController, Tab, TabController;
import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';

export 'package:flutter/material.dart'
    show DefaultTabController, Tab, TabController;

/// Segmented control used to switch between sections.
class SketchyTabBar extends StatefulWidget {
  /// Creates a new tab bar with the provided tabs.
  const SketchyTabBar({
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.padding,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.onTap,
    this.textCase,
    this.detachSelected = false,
    this.detachGap = 4,
    this.backgroundColor,
    this.eraseSelectedBorder = false,
    super.key,
  });

  /// Typically a list of two or more [Tab] widgets.
  final List<Widget> tabs;

  /// This widget's selection and animation state.
  final TabController? controller;

  /// Whether this tab bar can be scrolled horizontally.
  final bool isScrollable;

  /// The amount of space by which to inset the tab bar.
  final EdgeInsetsGeometry? padding;

  /// The text style of the selected tab labels.
  final TextStyle? labelStyle;

  /// The text style of the unselected tab labels.
  final TextStyle? unselectedLabelStyle;

  /// An optional callback that's called when the [SketchyTabBar] is tapped.
  final ValueChanged<int>? onTap;

  // Sketchy specifics
  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  /// When true, reserves [detachGap] below the active tab to reveal the
  /// background color (useful for overlapping containers).
  final bool detachSelected;

  /// Height of the gap rendered when [detachSelected] is true.
  final double detachGap;

  /// Background color painted in the detached gap.
  final Color? backgroundColor;

  /// Paints over the active tab's bottom border so it blends with the
  /// container underneath.
  final bool eraseSelectedBorder;

  @override
  State<SketchyTabBar> createState() => _SketchyTabBarState();
}

class _SketchyTabBarState extends State<SketchyTabBar> {
  TabController? _controller;
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateController();
  }

  @override
  void didUpdateWidget(SketchyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateController();
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_handleTabControllerTick);
    super.dispose();
  }

  void _updateController() {
    final newController =
        widget.controller ?? DefaultTabController.maybeOf(context);
    if (newController != _controller) {
      _controller?.removeListener(_handleTabControllerTick);
      _controller = newController;
      _controller?.addListener(_handleTabControllerTick);
      _currentIndex = _controller?.index ?? 0;
    }
  }

  void _handleTabControllerTick() {
    if (_controller != null && _controller!.index != _currentIndex) {
      setState(() {
        _currentIndex = _controller!.index;
      });
    }
  }

  void _handleTap(int index) {
    if (_controller != null) {
      _controller!.animateTo(index);
    }
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: widget.isScrollable
          ? null
          : const NeverScrollableScrollPhysics(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.tabs.length; i++) ...[
            GestureDetector(
              onTap: () => _handleTap(i),
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTabSurface(theme, i),
                    if (widget.detachSelected && widget.detachGap > 0)
                      SizedBox(
                        height: widget.detachGap,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: i == _currentIndex
                                ? widget.backgroundColor ?? theme.paperColor
                                : const Color(0x00000000),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );

  Widget _buildTabSurface(SketchyThemeData theme, int i) {
    final isSelected = i == _currentIndex;
    SketchyPrimitive primitiveBuilder() => SketchyPrimitive.rectangle(
      fill: isSelected ? SketchyFill.solid : SketchyFill.none,
    );

    final tab = widget.tabs[i];

    Widget surface = SketchySurface(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      fillColor: isSelected ? theme.secondaryColor : theme.paperColor,
      strokeColor: theme.inkColor,
      createPrimitive: primitiveBuilder,
      child: DefaultTextStyle(
        style:
            (isSelected ? widget.labelStyle : widget.unselectedLabelStyle) ??
            theme.typography.body.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              color: theme.inkColor, // Ensure text is always visible
            ),
        child: tab,
      ),
    );

    if (widget.eraseSelectedBorder && isSelected) {
      surface = Stack(
        clipBehavior: Clip.none,
        children: [
          surface,
          Positioned(
            left: 0,
            right: 0,
            bottom: -theme.strokeWidth,
            child: SizedBox(
              height: theme.strokeWidth,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ?? theme.paperColor,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return surface;
  }
}
