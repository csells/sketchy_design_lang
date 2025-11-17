import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Canvas playground mixing low-level drawing with palette controls.
class WhiteboardPaletteExample extends StatefulWidget {
  const WhiteboardPaletteExample({super.key});

  static Widget builder(BuildContext context) =>
      const WhiteboardPaletteExample();

  @override
  State<WhiteboardPaletteExample> createState() =>
      _WhiteboardPaletteExampleState();
}

class _WhiteboardPaletteExampleState extends State<WhiteboardPaletteExample> {
  double _stroke = 1.5;
  bool _showGrid = true;

  @override
  Widget build(BuildContext context) {
    final colors = SketchyTheme.of(context).colors;

    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Whiteboard Palette')),
      body: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: colors.paper,
              child: CustomPaint(
                painter: _WhiteboardPainter(showGrid: _showGrid),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SketchyCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tools'),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        SketchyIconButton(icon: SketchyIcons.pen),
                        SizedBox(width: 8),
                        SketchyIconButton(icon: SketchyIcons.rectangle),
                        SizedBox(width: 8),
                        SketchyIconButton(icon: SketchyIcons.eraser),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Stroke width: ${_stroke.toStringAsFixed(1)}'),
                    SketchySlider(
                      value: _stroke,
                      min: 0.5,
                      max: 4,
                      onChanged: (value) => setState(() => _stroke = value),
                    ),
                    const SizedBox(height: 12),
                    SketchySwitchTile(
                      label: 'Show grid',
                      value: _showGrid,
                      onChanged: (value) => setState(() => _showGrid = value),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteboardPainter extends CustomPainter {
  _WhiteboardPainter({required this.showGrid});
  final bool showGrid;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final paint = Paint()
        ..color = SketchyPalette.canvasShadow
        ..strokeWidth = 1;
      const gap = 32.0;
      for (var x = 0.0; x < size.width; x += gap) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
      for (var y = 0.0; y < size.height; y += gap) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }

    final strokePaint = Paint()
      ..color = SketchyPalette.gridLine
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final fillPaint = Paint()
      ..color = SketchyPalette.cream
      ..style = PaintingStyle.fill;

    final circleCenter = size.center(const Offset(-80, -40));
    canvas.drawCircle(circleCenter, 60, fillPaint);
    canvas.drawCircle(circleCenter, 60, strokePaint);

    final rectTopLeft = size.center(const Offset(40, 20));
    final rect = Rect.fromLTWH(rectTopLeft.dx, rectTopLeft.dy, 140, 80);
    final rectFill = Paint()
      ..color = SketchyPalette.sky
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, rectFill);
    canvas.drawRect(rect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _WhiteboardPainter oldDelegate) =>
      oldDelegate.showGrid != showGrid;
}
