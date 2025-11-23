import 'package:flutter/widgets.dart';

import '../theme/sketchy_theme.dart';

/// Symbols supported by [SketchyIcon].
enum SketchyIconSymbol {
  /// Plus icon.
  plus,

  /// Chevron pointing to the right.
  chevronRight,

  /// Pen icon.
  pen,

  /// Rectangle outline.
  rectangle,

  /// Eraser icon.
  eraser,

  /// Copy-esque double rectangle.
  copy,

  /// Paper-plane “send” icon.
  send,

  /// Checkmark icon.
  check,
}

/// Convenience constants for referencing [SketchyIconSymbol]s.
class SketchyIcons {
  /// Plus icon symbol.
  static const SketchyIconSymbol plus = SketchyIconSymbol.plus;

  /// Right chevron symbol.
  static const SketchyIconSymbol chevronRight = SketchyIconSymbol.chevronRight;

  /// Pen icon symbol.
  static const SketchyIconSymbol pen = SketchyIconSymbol.pen;

  /// Rectangle icon symbol.
  static const SketchyIconSymbol rectangle = SketchyIconSymbol.rectangle;

  /// Eraser icon symbol.
  static const SketchyIconSymbol eraser = SketchyIconSymbol.eraser;

  /// Copy icon symbol.
  static const SketchyIconSymbol copy = SketchyIconSymbol.copy;

  /// Send icon symbol.
  static const SketchyIconSymbol send = SketchyIconSymbol.send;

  /// Check icon symbol.
  static const SketchyIconSymbol check = SketchyIconSymbol.check;
}

/// Custom painter-based icon rendered in the sketch style.
class SketchyIcon extends StatelessWidget {
  /// Creates an icon for the given [icon] symbol.
  const SketchyIcon({
    required this.icon,
    super.key,
    this.size = 20,
    this.color,
  });

  /// Symbol to draw.
  final SketchyIconSymbol icon;

  /// Visual size of the icon.
  final double size;

  /// Optional override for the ink color.
  final Color? color;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _SketchyIconPainter(
          icon: icon,
          color: color ?? theme.inkColor,
        ),
      ),
    ),
  );
}

class _SketchyIconPainter extends CustomPainter {
  _SketchyIconPainter({required this.icon, required this.color});
  final SketchyIconSymbol icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    switch (icon) {
      case SketchyIconSymbol.plus:
        canvas.drawLine(
          Offset(size.width / 2, 2),
          Offset(size.width / 2, size.height - 2),
          paint,
        );
        canvas.drawLine(
          Offset(2, size.height / 2),
          Offset(size.width - 2, size.height / 2),
          paint,
        );
      case SketchyIconSymbol.chevronRight:
        final path = Path()
          ..moveTo(4, 4)
          ..lineTo(size.width - 4, size.height / 2)
          ..lineTo(4, size.height - 4);
        canvas.drawPath(path, paint);
      case SketchyIconSymbol.pen:
        final path = Path()
          ..moveTo(2, size.height - 4)
          ..lineTo(size.width / 2, 4)
          ..lineTo(size.width - 2, size.height / 2);
        canvas.drawPath(path, paint);
        canvas.drawLine(
          Offset(2, size.height - 4),
          Offset(size.width / 2.2, size.height - 2),
          paint,
        );
      case SketchyIconSymbol.rectangle:
        final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
        canvas.drawRect(rect, paint);
      case SketchyIconSymbol.eraser:
        final path = Path()
          ..moveTo(2, size.height - 6)
          ..lineTo(size.width / 2, 2)
          ..lineTo(size.width - 2, size.height / 2)
          ..lineTo(size.width / 2, size.height - 2)
          ..close();
        canvas.drawPath(path, paint);
      case SketchyIconSymbol.copy:
        final rect1 = Rect.fromLTWH(4, 4, size.width - 8, size.height - 8);
        final rect2 = rect1.shift(const Offset(-3, -3));
        canvas.drawRect(rect1, paint);
        canvas.drawRect(rect2, paint);
      case SketchyIconSymbol.send:
        final path = Path()
          ..moveTo(2, size.height - 2)
          ..lineTo(size.width - 2, size.height / 2)
          ..lineTo(2, 2)
          ..lineTo(size.width / 3, size.height / 2)
          ..close();
        canvas.drawPath(path, paint);
      case SketchyIconSymbol.check:
        final path = Path()
          ..moveTo(4, size.height / 2)
          ..lineTo(size.width / 2.5, size.height - 4)
          ..lineTo(size.width - 4, 4);
        canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SketchyIconPainter oldDelegate) =>
      oldDelegate.icon != icon || oldDelegate.color != color;
}
