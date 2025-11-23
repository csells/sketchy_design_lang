import 'package:flutter/widgets.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';

/// Symbols supported by [SketchySymbol].
enum SketchySymbols {
  /// Plus icon.
  plus,

  /// Chevron pointing to the right.
  chevronRight,

  /// Chevron pointing down.
  chevronDown,

  /// Rectangle outline.
  rectangle,

  /// Paper-plane “send” icon.
  send,

  /// Solid bullet (filled circle).
  bullet,

  /// Close/Cancel icon (X).
  x,
}

/// Custom painter-based symbol rendered in the sketch style using
/// rough_flutter.
class SketchySymbol extends StatelessWidget {
  /// Creates an icon for the given [symbol].
  const SketchySymbol({
    required this.symbol,
    super.key,
    this.size = 20,
    this.color,
  });

  /// Symbol to draw.
  final SketchySymbols symbol;

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
        painter: _SketchySymbolPainter(
          symbol: symbol,
          color: color ?? theme.inkColor,
          roughness: theme.roughness,
        ),
      ),
    ),
  );
}

class _SketchySymbolPainter extends CustomPainter {
  _SketchySymbolPainter({
    required this.symbol,
    required this.color,
    required this.roughness,
  });

  final SketchySymbols symbol;
  final Color color;
  final double roughness;

  @override
  void paint(Canvas canvas, Size size) {
    final generator = SketchyGenerator.createGenerator(
      seed: symbol.hashCode, // Stable seed based on symbol
      roughness: roughness,
    );

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Helper to draw a list of drawables
    void draw(List<Drawable> drawables) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      for (final d in drawables) {
        canvas.drawRough(d, paint, fillPaint);
      }
    }

    switch (symbol) {
      case SketchySymbols.plus:
        draw([
          generator.line(size.width / 2, 2, size.width / 2, size.height - 2),
          generator.line(2, size.height / 2, size.width - 2, size.height / 2),
        ]);
      case SketchySymbols.chevronRight:
        draw([
          generator.linearPath([
            PointD(4, 4),
            PointD(size.width - 4, size.height / 2),
            PointD(4, size.height - 4),
          ]),
        ]);
      case SketchySymbols.chevronDown:
        draw([
          generator.linearPath([
            PointD(4, 4),
            PointD(size.width / 2, size.height - 4),
            PointD(size.width - 4, 4),
          ]),
        ]);
      case SketchySymbols.rectangle:
        draw([generator.rectangle(2, 2, size.width - 4, size.height - 4)]);
      case SketchySymbols.send:
        draw([
          generator.polygon([
            PointD(2, size.height - 2),
            PointD(size.width - 2, size.height / 2),
            PointD(2, 2),
            PointD(size.width / 3, size.height / 2),
          ]),
        ]);
      case SketchySymbols.bullet:
        // Solid fill (clean)
        canvas.drawOval(
          Rect.fromLTWH(2, 2, size.width - 4, size.height - 4),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
        // Rough outline
        draw([
          generator.ellipse(
            size.width / 2,
            size.height / 2,
            size.width - 4,
            size.height - 4,
          ),
        ]);
      case SketchySymbols.x:
        const inset = 4.0;
        draw([
          generator.line(inset, inset, size.width - inset, size.height - inset),
          generator.line(size.width - inset, inset, inset, size.height - inset),
        ]);
    }
  }

  @override
  bool shouldRepaint(covariant _SketchySymbolPainter oldDelegate) =>
      oldDelegate.symbol != symbol ||
      oldDelegate.color != color ||
      oldDelegate.roughness != roughness;
}
