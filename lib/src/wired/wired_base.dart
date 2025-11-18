// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../theme/sketchy_theme.dart';
import 'canvas/wired_painter_base.dart';

Paint _strokePaint(Color color, double width) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = true
  ..strokeCap = StrokeCap.square
  ..strokeWidth = width;

Paint _fillPaint(Color color) => Paint()
  ..color = color
  ..style = PaintingStyle.stroke
  ..isAntiAlias = true
  ..strokeWidth = 1;

/// The wired base widget usually being extends by specific wired widgets like
/// [SketchyButton] for the purpose of isolates repaints.
///
/// If not do this, all the wired widgets (use rough decoration like
/// [RoughBoxDecoration]) in current screen will repaints together, which is not
/// make sence.
abstract class WiredBaseWidget extends StatelessWidget {
  const WiredBaseWidget({super.key});

  /// Wrap with [RepaintBoundary] to isolates repaints.
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(key: key, child: buildWiredElement(context));

  /// The method for extended widget to implement to build widgets.
  Widget buildWiredElement(BuildContext context);
}

/// Mixin to wrap content with a [RepaintBoundary] to isolate repaints.
mixin WiredRepaintMixin {
  Widget buildWiredElement({required Widget child, Key? key}) =>
      RepaintBoundary(key: key, child: child);
}

/// Base wired rectangle.
class WiredRectangleBase extends WiredPainterBase {
  WiredRectangleBase({
    this.leftIndent = 0.0,
    this.rightIndent = 0.0,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
  });

  /// The amount of empty space to the leading edge of the rectangle.
  final double leftIndent;

  /// The amount of empty space to the trailing edge of the rectangle.
  final double rightIndent;

  final Color? fillColor;
  final Color? strokeColor;
  final double? strokeWidth;

  @override
  void paintRough(
    Canvas canvas,
    Size size,
    DrawConfig drawConfig,
    Filler filler,
    SketchyThemeData theme,
  ) {
    final generator = Generator(drawConfig, filler);

    final figure = generator.rectangle(
      0 + leftIndent,
      0,
      size.width - leftIndent - rightIndent,
      size.height,
    );
    final stroke = _strokePaint(
      strokeColor ?? theme.borderColor,
      strokeWidth ?? theme.strokeWidth,
    );
    final fill = _fillPaint(fillColor ?? theme.fillColor);
    canvas.drawRough(figure, stroke, fill);
  }
}

/// Base wired inverted triangle.
class WiredInvertedTriangleBase extends WiredPainterBase {
  WiredInvertedTriangleBase({
    this.strokeColor,
    this.fillColor,
    this.strokeWidth,
  });

  final Color? strokeColor;
  final Color? fillColor;
  final double? strokeWidth;

  @override
  void paintRough(
    Canvas canvas,
    Size size,
    DrawConfig drawConfig,
    Filler filler,
    SketchyThemeData theme,
  ) {
    final generator = Generator(drawConfig, filler);

    final points = [
      PointD(0, 0),
      PointD(size.width, 0),
      PointD(size.width / 2, size.height),
    ];
    final figure = generator.polygon(points);
    final stroke = _strokePaint(
      strokeColor ?? theme.borderColor,
      strokeWidth ?? theme.strokeWidth,
    );
    final fill = _fillPaint(fillColor ?? theme.fillColor);
    canvas.drawRough(figure, stroke, fill);
  }
}

/// Base wired line with start point [x1], [y1] and end point [x2], [y2] using
/// [strokeWidth].
///
/// [strokeWidth] defaults to 1.
class WiredLineBase extends WiredPainterBase {
  WiredLineBase({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    this.strokeWidth = 1,
    this.color,
  });
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final double strokeWidth;
  final Color? color;

  @override
  void paintRough(
    Canvas canvas,
    Size size,
    DrawConfig drawConfig,
    Filler filler,
    SketchyThemeData theme,
  ) {
    var startX = x1;
    var startY = y1;
    var endX = x2;
    var endY = y2;
    if (startX < 0) startX = 0;
    if (startX > size.width) startX = size.width;
    if (startY < 0) startY = 0;
    if (startY > size.height) startY = size.height;

    if (endX < 0) endX = 0;
    if (endX > size.width) endX = size.width;
    if (endY < 0) endY = 0;
    if (endY > size.height) endY = size.height;

    final generator = Generator(drawConfig, filler);

    final figure = generator.line(startX, startY, endX, endY);
    final stroke = _strokePaint(color ?? theme.borderColor, strokeWidth);
    canvas.drawRough(figure, stroke, _fillPaint(theme.fillColor));
  }
}

/// Base wired circle with [diameterRatio] and [fillColor].
///
/// If [diameterRatio] = 1, then the diameter of circle is the canvas's width.
class WiredCircleBase extends WiredPainterBase {
  WiredCircleBase({
    this.diameterRatio = 1,
    this.fillColor,
    this.strokeColor,
    this.strokeWidth,
  });
  final double diameterRatio;
  final Color? fillColor;
  final Color? strokeColor;
  final double? strokeWidth;

  @override
  void paintRough(
    Canvas canvas,
    Size size,
    DrawConfig drawConfig,
    Filler filler,
    SketchyThemeData theme,
  ) {
    final generator = Generator(drawConfig, filler);

    final figure = generator.circle(
      size.width / 2,
      size.height / 2,
      size.width > size.height
          ? size.width * diameterRatio
          : size.height * diameterRatio,
    );
    final stroke = _strokePaint(
      strokeColor ?? theme.borderColor,
      strokeWidth ?? theme.strokeWidth,
    );
    final fill = _fillPaint(fillColor ?? theme.fillColor);
    canvas.drawRough(figure, stroke, fill);
  }
}
