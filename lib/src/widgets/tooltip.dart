import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'text.dart';

/// Basic tooltip that appears on hover similar to Flutter's Material tooltip.
class SketchyTooltip extends StatefulWidget {
  /// Creates a tooltip that displays [message] near the pointer.
  const SketchyTooltip({
    required this.message,
    required this.child,
    this.preferBelow = false,
    this.textCase,
    super.key,
  });

  /// Text shown when hovering.
  final String message;

  /// Widget that triggers the tooltip.
  final Widget child;

  /// Whether the tooltip should render below the pointer instead of above.
  final bool preferBelow;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

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
          textCase: widget.textCase,
        ),
      );
      Overlay.of(context, rootOverlay: true).insert(_entry!);
    } else {
      _entry!.markNeedsBuild();
    }
    _hideTimer = Timer(const Duration(seconds: 4), _hideTooltip);
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
    this.textCase,
  });

  final String message;
  final Offset target;
  final bool preferBelow;
  final TextCase? textCase;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) {
          final casing = textCase ?? theme.textCase;
          final displayMessage = applyTextCase(message, casing);
          final textPainter = TextPainter(
            text: TextSpan(text: displayMessage, style: theme.typography.label),
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: MediaQuery.of(context).size.width * 0.8);
          final tooltipSize =
              Size(textPainter.width + 16, textPainter.height + 8);
          final offset = _computeTooltipOffset(
            target,
            tooltipSize,
            MediaQuery.of(context).size,
            preferBelow,
          );

          return Positioned(
            left: offset.dx,
            top: offset.dy,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colors.ink,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: SketchyText(
                  message,
                  textCase: textCase,
                  style: theme.typography.label.copyWith(
                    color: theme.colors.paper,
                  ),
                ),
              ),
            ),
          );
        },
      );
}

Offset _computeTooltipOffset(
  Offset target,
  Size tooltipSize,
  Size screenSize,
  bool preferBelow,
) {
  const horizontalOffset = 8.0;
  const verticalOffset = 8.0;
  const padding = EdgeInsets.all(8);

  var x = target.dx + horizontalOffset;
  x = math.min(
    math.max(x, padding.left),
    screenSize.width - tooltipSize.width - padding.right,
  );

  var y = preferBelow
      ? target.dy + verticalOffset
      : target.dy - verticalOffset - tooltipSize.height;

  if (y < padding.top) {
    y = target.dy + verticalOffset;
  }

  final maxY = screenSize.height - tooltipSize.height - padding.bottom;
  if (y > maxY) {
    y = math.max(padding.top, maxY);
  }

  return Offset(x, y);
}
