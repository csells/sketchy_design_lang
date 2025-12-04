import 'dart:math' as math;

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

  /// Paper-plane "send" icon.
  send,

  /// Solid bullet (filled circle).
  bullet,

  /// Close/Cancel icon (X).
  x,

  /// Paperclip/attachment icon.
  paperclip,

  /// Smiley face/emoji icon.
  smiley,

  /// At symbol (@) for mentions.
  at,

  /// Gear/settings icon.
  gear,

  /// Hash/pound symbol (#).
  hash,

  /// Menu (hamburger) icon.
  menu,

  /// Pencil/edit icon.
  pencil,

  /// External link icon.
  externalLink,

  /// Checkmark icon.
  check,

  /// People/users icon.
  people,
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
      case SketchySymbols.paperclip:
        // Paperclip shape
        final w = size.width;
        final h = size.height;
        draw([
          generator.linearPath([
            PointD(w * 0.7, h * 0.15),
            PointD(w * 0.85, h * 0.3),
            PointD(w * 0.85, h * 0.7),
            PointD(w * 0.7, h * 0.85),
            PointD(w * 0.3, h * 0.85),
            PointD(w * 0.15, h * 0.7),
            PointD(w * 0.15, h * 0.4),
            PointD(w * 0.3, h * 0.25),
            PointD(w * 0.55, h * 0.25),
            PointD(w * 0.7, h * 0.4),
            PointD(w * 0.7, h * 0.6),
            PointD(w * 0.55, h * 0.75),
            PointD(w * 0.4, h * 0.75),
            PointD(w * 0.3, h * 0.6),
            PointD(w * 0.3, h * 0.45),
          ]),
        ]);
      case SketchySymbols.smiley:
        // Simple smiley face
        final cx = size.width / 2;
        final cy = size.height / 2;
        final r = size.width * 0.4;
        draw([
          // Face outline
          generator.ellipse(cx, cy, r * 2, r * 2),
          // Left eye
          generator.ellipse(cx - r * 0.35, cy - r * 0.2, r * 0.2, r * 0.25),
          // Right eye
          generator.ellipse(cx + r * 0.35, cy - r * 0.2, r * 0.2, r * 0.25),
          // Smile
          generator.arc(cx, cy, r * 1.2, r * 1.0, 0.2, 2.94, false),
        ]);
      case SketchySymbols.at:
        // @ symbol
        final cx = size.width / 2;
        final cy = size.height / 2;
        final r = size.width * 0.35;
        draw([
          // Outer circle
          generator.ellipse(cx, cy, r * 2.2, r * 2.2),
          // Inner 'a' part - simplified spiral
          generator.arc(cx + r * 0.2, cy, r * 0.8, r * 0.8, -0.5, 5.5, false),
        ]);
      case SketchySymbols.gear:
        // Settings gear
        final cx = size.width / 2;
        final cy = size.height / 2;
        final outerR = size.width * 0.4;
        final innerR = size.width * 0.2;
        // Inner circle
        draw([generator.ellipse(cx, cy, innerR * 2, innerR * 2)]);
        // Gear teeth (simplified as lines)
        const teeth = 6;
        for (var i = 0; i < teeth; i++) {
          final angle = (i / teeth) * math.pi * 2;
          final cosA = math.cos(angle);
          final sinA = math.sin(angle);
          draw([
            generator.line(
              cx + innerR * 0.8 * cosA,
              cy + innerR * 0.8 * sinA,
              cx + outerR * cosA,
              cy + outerR * sinA,
            ),
          ]);
        }
        // Outer rough circle
        draw([generator.ellipse(cx, cy, outerR * 1.6, outerR * 1.6)]);
      case SketchySymbols.hash:
        // # symbol
        final w = size.width;
        final h = size.height;
        draw([
          // Vertical lines
          generator.line(w * 0.35, h * 0.1, w * 0.25, h * 0.9),
          generator.line(w * 0.75, h * 0.1, w * 0.65, h * 0.9),
          // Horizontal lines
          generator.line(w * 0.1, h * 0.35, w * 0.9, h * 0.35),
          generator.line(w * 0.1, h * 0.65, w * 0.9, h * 0.65),
        ]);
      case SketchySymbols.menu:
        // Hamburger menu
        final w = size.width;
        final h = size.height;
        draw([
          generator.line(w * 0.15, h * 0.25, w * 0.85, h * 0.25),
          generator.line(w * 0.15, h * 0.5, w * 0.85, h * 0.5),
          generator.line(w * 0.15, h * 0.75, w * 0.85, h * 0.75),
        ]);
      case SketchySymbols.pencil:
        // Pencil icon
        final w = size.width;
        final h = size.height;
        draw([
          // Pencil body
          generator.linearPath([
            PointD(w * 0.15, h * 0.85),
            PointD(w * 0.1, h * 0.9),
            PointD(w * 0.25, h * 0.75),
          ]),
          generator.line(w * 0.25, h * 0.75, w * 0.85, h * 0.15),
          generator.line(w * 0.15, h * 0.85, w * 0.75, h * 0.25),
          // Tip
          generator.line(w * 0.75, h * 0.25, w * 0.85, h * 0.15),
        ]);
      case SketchySymbols.externalLink:
        // External link icon (box with arrow pointing out)
        final w = size.width;
        final h = size.height;
        draw([
          // Box (missing top-right corner)
          generator.linearPath([
            PointD(w * 0.6, h * 0.15),
            PointD(w * 0.15, h * 0.15),
            PointD(w * 0.15, h * 0.85),
            PointD(w * 0.85, h * 0.85),
            PointD(w * 0.85, h * 0.4),
          ]),
          // Arrow
          generator.line(w * 0.45, h * 0.55, w * 0.85, h * 0.15),
          generator.line(w * 0.85, h * 0.15, w * 0.65, h * 0.15),
          generator.line(w * 0.85, h * 0.15, w * 0.85, h * 0.35),
        ]);
      case SketchySymbols.check:
        // Checkmark
        final w = size.width;
        final h = size.height;
        draw([
          generator.linearPath([
            PointD(w * 0.15, h * 0.5),
            PointD(w * 0.4, h * 0.75),
            PointD(w * 0.85, h * 0.25),
          ]),
        ]);
      case SketchySymbols.people:
        // People/users icon (two figures)
        final w = size.width;
        final h = size.height;
        draw([
          // First person (front)
          generator.ellipse(w * 0.4, h * 0.25, w * 0.25, h * 0.25),
          generator.arc(w * 0.4, h * 0.85, w * 0.4, h * 0.5, 3.14, 3.14, false),
          // Second person (back, slightly offset)
          generator.ellipse(w * 0.65, h * 0.2, w * 0.2, h * 0.2),
          generator.arc(
            w * 0.65,
            h * 0.75,
            w * 0.35,
            h * 0.4,
            3.14,
            3.14,
            false,
          ),
        ]);
    }
  }

  @override
  bool shouldRepaint(covariant _SketchySymbolPainter oldDelegate) =>
      oldDelegate.symbol != symbol ||
      oldDelegate.color != color ||
      oldDelegate.roughness != roughness;
}
