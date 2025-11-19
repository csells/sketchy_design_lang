import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';

/// Basic tooltip that appears on hover similar to Flutter's Material tooltip.
class SketchyTooltip extends StatefulWidget {
  /// Creates a tooltip that displays [message] near the pointer.
  const SketchyTooltip({
    required this.message,
    required this.child,
    this.preferBelow = false,
    super.key,
  });

  /// Text shown when hovering.
  final String message;

  /// Widget that triggers the tooltip.
  final Widget child;

  /// Whether the tooltip should render below the pointer instead of above.
  final bool preferBelow;

  @override
  State<SketchyTooltip> createState() => _SketchyTooltipState();
}

class _SketchyTooltipState extends State<SketchyTooltip> {
  OverlayEntry? _entry;
  Timer? _hideTimer;
  Offset? _pointerPosition;

  @override
  Widget build(BuildContext context) => MouseRegion(
        opaque: true,
        onEnter: (event) => _showTooltip(event.position),
        onHover: (event) => _updatePosition(event.position),
        onExit: (_) => _hideTooltip(),
        child: widget.child,
      );

  void _updatePosition(Offset position) {
    _pointerPosition = position;
    _entry?.markNeedsBuild();
  }

  void _showTooltip(Offset position) {
    _pointerPosition = position;
    _hideTimer?.cancel();
    if (_entry == null) {
      _entry = OverlayEntry(
        builder: (context) => _SketchyTooltipOverlay(
          message: widget.message,
          target: _pointerPosition ?? _fallbackPosition(),
          preferBelow: widget.preferBelow,
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }
    _hideTimer = Timer(const Duration(seconds: 2), _hideTooltip);
  }

  Offset _fallbackPosition() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      return renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    }
    return Offset.zero;
  }

  void _hideTooltip() {
    _hideTimer?.cancel();
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hideTooltip();
    super.dispose();
  }
}

class _SketchyTooltipOverlay extends StatelessWidget {
  const _SketchyTooltipOverlay({
    required this.message,
    required this.target,
    required this.preferBelow,
  });

  final String message;
  final Offset target;
  final bool preferBelow;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final typography = SketchyTypography.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomSingleChildLayout(
          delegate: _SketchyTooltipPositionDelegate(
            target: target,
            preferBelow: preferBelow,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colors.ink,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              message,
              style: typography.label.copyWith(color: theme.colors.paper),
            ),
          ),
        ),
      ),
    );
  }
}

class _SketchyTooltipPositionDelegate extends SingleChildLayoutDelegate {
  const _SketchyTooltipPositionDelegate({
    required this.target,
    required this.preferBelow,
  });

  final Offset target;
  final bool preferBelow;
  static const double _verticalOffset = 18;
  static const EdgeInsets _screenPadding = EdgeInsets.all(8);

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final availableWidth =
        size.width - _screenPadding.horizontal - childSize.width;
    final x = math.min(
      math.max(target.dx - childSize.width / 2, _screenPadding.left),
      _screenPadding.left + availableWidth,
    );

    final belowY = target.dy + _verticalOffset;
    final aboveY = target.dy - _verticalOffset - childSize.height;

    var y = preferBelow ? belowY : aboveY;
    if (y < _screenPadding.top) y = belowY;
    if (y + childSize.height + _screenPadding.bottom > size.height) {
      y = math.max(
        _screenPadding.top,
        size.height - childSize.height - _screenPadding.bottom,
      );
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_SketchyTooltipPositionDelegate oldDelegate) =>
      target != oldDelegate.target ||
      preferBelow != oldDelegate.preferBelow;
}
