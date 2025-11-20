import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:rough_flutter/rough_flutter.dart';

/// Fill strategies available for [SketchyPrimitive] shapes.
enum SketchyFill {
  /// Only strokes are drawn.
  none,

  /// Shape interior is filled with rough hachure lines.
  hachure,

  /// Shape interior is filled solid to match the stroke.
  solid,
}

/// Customization options for how hachure/solid fills are rendered.
class SketchyFillOptions {
  /// Creates a bundle of overrides for sketchy fill rendering.
  const SketchyFillOptions({this.hachureGap, this.fillWeight});

  /// Overrides the spacing between hachure lines.
  final double? hachureGap;

  /// Overrides how thick individual hachure lines are.
  final double? fillWeight;
}

/// Deterministic rough shape that caches its seed at construction time.
class SketchyPrimitive {
  SketchyPrimitive._(
    this._builder,
    this._pathBuilder,
    this._fill,
    this._fillOptions, {
    int? seed,
  }) : _seed = seed ?? _seedSource.nextInt(0x7fffffff);

  /// Rectangle primitive.
  factory SketchyPrimitive.rectangle({
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive._(
    (generator, size) => generator.rectangle(0, 0, size.width, size.height),
    (size) => Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
    fill,
    fillOptions,
    seed: seed,
  );

  /// Rounded rectangle primitive with the provided [cornerRadius].
  factory SketchyPrimitive.roundedRectangle({
    SketchyFill fill = SketchyFill.none,
    double cornerRadius = 12,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive._(
    (generator, size) =>
        generator.polygon(_roundedRectPoints(size, cornerRadius)),
    (size) => Path()
      ..addPolygon(
        _roundedRectPoints(
          size,
          cornerRadius,
        ).map((p) => Offset(p.x, p.y)).toList(),
        true,
      ),
    fill,
    fillOptions,
    seed: seed,
  );

  /// Pill primitive (fully rounded rectangle).
  factory SketchyPrimitive.pill({
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive.roundedRectangle(
    fill: fill,
    cornerRadius: double.infinity,
    seed: seed,
    fillOptions: fillOptions,
  );

  /// Circle primitive that fits the available size.
  factory SketchyPrimitive.circle({
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive._(
    (generator, size) => generator.ellipse(
      size.width / 2,
      size.height / 2,
      size.width,
      size.height,
    ),
    (size) => Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height)),
    fill,
    fillOptions,
    seed: seed,
  );

  final Drawable Function(Generator, Size) _builder;
  final Path Function(Size) _pathBuilder;
  final SketchyFill _fill;
  final SketchyFillOptions? _fillOptions;
  final int _seed;

  Drawable? _cachedDrawable;
  Size? _cachedSize;
  double? _cachedRoughness;

  static final Random _seedSource = Random();

  /// Returns a cached drawable for the requested [size] and [roughness].
  Drawable drawableFor(Size size, double roughness) {
    if (_cachedDrawable != null &&
        _cachedSize == size &&
        _cachedRoughness == roughness) {
      return _cachedDrawable!;
    }

    final config = _buildConfig(roughness.clamp(0, 1));
    // Note: For solid, we use NoFiller here because the painter handles the
    // fill.
    final effectiveFill = _fill == SketchyFill.solid ? SketchyFill.none : _fill;
    final filler = _buildFiller(config, effectiveFill, roughness, _fillOptions);
    final generator = Generator(config, filler);

    _cachedDrawable = _builder(generator, size);
    _cachedSize = size;
    _cachedRoughness = roughness;
    return _cachedDrawable!;
  }

  /// Returns the clean geometric path for the shape (used for solid fills).
  Path pathFor(Size size) => _pathBuilder(size);

  DrawConfig _buildConfig(double roughness) => DrawConfig.build(
    seed: _seed,
    roughness: lerpDouble(0.35, 2.2, roughness),
    bowing: lerpDouble(0.04, 1.1, roughness),
    maxRandomnessOffset: lerpDouble(0.4, 3.4, roughness),
    curveFitting: 0.9,
  );
}

/// Custom painter that renders [SketchyPrimitive] instances.
class SketchyShapePainter extends CustomPainter {
  /// Creates a painter that draws [primitive] using the provided colors.
  const SketchyShapePainter({
    required this.primitive,
    required this.strokeColor,
    required this.fillColor,
    required this.strokeWidth,
    required this.roughness,
  });

  /// Primitive to draw.
  final SketchyPrimitive primitive;

  /// Stroke color.
  final Color strokeColor;

  /// Fill color rendered by the primitive.
  final Color fillColor;

  /// Stroke width.
  final double strokeWidth;

  /// Theme roughness value (0-1).
  final double roughness;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Handle Solid Fill (Custom)
    if (primitive._fill == SketchyFill.solid) {
      final path = primitive.pathFor(size);
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      canvas.drawPath(path, fillPaint);
    }

    // 2. Handle Stroke & Hachure Fill (Rough)
    final drawable = primitive.drawableFor(size, roughness);
    final stroke = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    final fill = Paint()
      ..color = fillColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawRough(drawable, stroke, fill);
  }

  @override
  bool shouldRepaint(covariant SketchyShapePainter oldDelegate) =>
      primitive != oldDelegate.primitive ||
      strokeColor != oldDelegate.strokeColor ||
      fillColor != oldDelegate.fillColor ||
      strokeWidth != oldDelegate.strokeWidth ||
      roughness != oldDelegate.roughness;
}

Filler _buildFiller(
  DrawConfig config,
  SketchyFill fill,
  double roughness,
  SketchyFillOptions? options,
) {
  final fillerConfig = FillerConfig.build(
    drawConfig: config,
    hachureGap: options?.hachureGap ?? (lerpDouble(6, 16, 1 - roughness) ?? 10),
    fillWeight: options?.fillWeight ?? (lerpDouble(0.6, 1.8, roughness) ?? 1),
  );

  switch (fill) {
    case SketchyFill.none:
      return NoFiller(fillerConfig);
    case SketchyFill.hachure:
      return HachureFiller(fillerConfig);
    case SketchyFill.solid:
      // Fallback to solid filler if this path is ever reached, though
      // drawableFor() now redirects solid -> none.
      return SolidFiller(fillerConfig);
  }
}

List<PointD> _roundedRectPoints(Size size, double radius) {
  final minSide = min(size.width, size.height);
  final effective = min(radius, minSide / 2);
  if (effective <= 0) {
    return [
      PointD(0, 0),
      PointD(size.width, 0),
      PointD(size.width, size.height),
      PointD(0, size.height),
    ];
  }

  return [
    PointD(effective, 0),
    PointD(size.width - effective, 0),
    PointD(size.width, effective),
    PointD(size.width, size.height - effective),
    PointD(size.width - effective, size.height),
    PointD(effective, size.height),
    PointD(0, size.height - effective),
    PointD(0, effective),
  ];
}
