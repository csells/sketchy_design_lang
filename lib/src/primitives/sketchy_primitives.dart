import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:rough_flutter/rough_flutter.dart';

import 'sketchy_rendering_config.dart';

/// Fill strategies available for [SketchyPrimitive] shapes.
enum SketchyFill {
  /// Only strokes are drawn.
  none,

  /// Shape interior is filled with rough hachure lines.
  hachure,

  /// Shape interior is filled solid to match the stroke.
  solid,
}

/// Supported shape types for [SketchyPrimitive].
enum SketchyShapeType {
  /// A rectangle.
  rectangle,

  /// A rounded rectangle.
  roundedRectangle,

  /// A circle.
  circle,
}

/// Customization options for how hachure/solid fills are rendered.
@immutable
class SketchyFillOptions {
  /// Creates a bundle of overrides for sketchy fill rendering.
  const SketchyFillOptions({this.hachureGap, this.fillWeight});

  /// Overrides the spacing between hachure lines.
  final double? hachureGap;

  /// Overrides how thick individual hachure lines are.
  final double? fillWeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchyFillOptions &&
          runtimeType == other.runtimeType &&
          hachureGap == other.hachureGap &&
          fillWeight == other.fillWeight;

  @override
  int get hashCode => hachureGap.hashCode ^ fillWeight.hashCode;
}

/// Data class describing a rough shape.
///
/// Acts as a configuration for [SketchyGenerator].
@immutable
class SketchyPrimitive {
  /// Creates a new primitive configuration.
  const SketchyPrimitive({
    required this.type,
    required this.seed,
    this.fill = SketchyFill.none,
    this.fillOptions,
    this.cornerRadius = 0,
  });

  /// Rectangle primitive.
  factory SketchyPrimitive.rectangle({
    SketchyFill fill = SketchyFill.none,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive(
    type: SketchyShapeType.rectangle,
    fill: fill,
    fillOptions: fillOptions,
    seed: seed ?? _seedSource.nextInt(0x7fffffff),
  );

  /// Rounded rectangle primitive with the provided [cornerRadius].
  factory SketchyPrimitive.roundedRectangle({
    SketchyFill fill = SketchyFill.none,
    double cornerRadius = 12,
    int? seed,
    SketchyFillOptions? fillOptions,
  }) => SketchyPrimitive(
    type: SketchyShapeType.roundedRectangle,
    fill: fill,
    fillOptions: fillOptions,
    cornerRadius: cornerRadius,
    seed: seed ?? _seedSource.nextInt(0x7fffffff),
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
  }) => SketchyPrimitive(
    type: SketchyShapeType.circle,
    fill: fill,
    fillOptions: fillOptions,
    seed: seed ?? _seedSource.nextInt(0x7fffffff),
  );

  /// The type of shape to draw.
  final SketchyShapeType type;

  /// The fill strategy to use.
  final SketchyFill fill;

  /// Optional overrides for fill rendering.
  final SketchyFillOptions? fillOptions;

  /// Corner radius for rounded rectangles.
  final double cornerRadius;

  /// Random seed for deterministic rendering.
  final int seed;

  static final Random _seedSource = Random();

  /// Generates a drawable for this primitive.
  ///
  /// Note: This forwards to [SketchyGenerator.generate].
  Drawable drawableFor(Size size, double roughness) =>
      SketchyGenerator.generate(this, size, roughness);

  /// Generates a path for this primitive.
  ///
  /// Note: This forwards to [SketchyGenerator.generatePath].
  Path pathFor(Size size) => SketchyGenerator.generatePath(this, size);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchyPrimitive &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          fill == other.fill &&
          fillOptions == other.fillOptions &&
          cornerRadius == other.cornerRadius &&
          seed == other.seed;

  @override
  int get hashCode =>
      type.hashCode ^
      fill.hashCode ^
      fillOptions.hashCode ^
      cornerRadius.hashCode ^
      seed.hashCode;
}

/// Service responsible for generating rough drawables from [SketchyPrimitive]s.
class SketchyGenerator {
  static final Map<int, (Size, double, Drawable)> _cache = {};

  /// Generates a [Drawable] for the given [primitive].
  static Drawable generate(
    SketchyPrimitive primitive,
    Size size,
    double roughness,
  ) {
    // Check cache (keyed by seed + size + roughness)
    // Note: This is a simplified cache strategy. In a real app you might want
    // a better key or LRU eviction.
    final cacheKey = primitive.seed;
    final cached = _cache[cacheKey];
    if (cached != null) {
      final (cachedSize, cachedRoughness, drawable) = cached;
      if (cachedSize == size && cachedRoughness == roughness) {
        return drawable;
      }
    }

    final config = _buildConfig(primitive.seed, roughness.clamp(0, 1));
    // Note: For solid, we use NoFiller here because the painter handles the fill.
    final effectiveFill = primitive.fill == SketchyFill.solid
        ? SketchyFill.none
        : primitive.fill;
    final filler = _buildFiller(
      config,
      effectiveFill,
      roughness,
      primitive.fillOptions,
    );
    final generator = Generator(config, filler);

    final drawable = _buildDrawable(generator, primitive, size);

    _cache[cacheKey] = (size, roughness, drawable);
    return drawable;
  }

  /// Generates a clean path for the given [primitive] (used for solid fills).
  static Path generatePath(SketchyPrimitive primitive, Size size) {
    switch (primitive.type) {
      case SketchyShapeType.rectangle:
        return Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      case SketchyShapeType.roundedRectangle:
        return Path()..addPolygon(
          _roundedRectPoints(
            size,
            primitive.cornerRadius,
          ).map((p) => Offset(p.x, p.y)).toList(),
          true,
        );
      case SketchyShapeType.circle:
        return Path()..addOval(Rect.fromLTWH(0, 0, size.width, size.height));
    }
  }

  static Drawable _buildDrawable(
    Generator generator,
    SketchyPrimitive primitive,
    Size size,
  ) {
    switch (primitive.type) {
      case SketchyShapeType.rectangle:
        return generator.rectangle(0, 0, size.width, size.height);
      case SketchyShapeType.roundedRectangle:
        return generator.polygon(
          _roundedRectPoints(size, primitive.cornerRadius),
        );
      case SketchyShapeType.circle:
        return generator.ellipse(
          size.width / 2,
          size.height / 2,
          size.width,
          size.height,
        );
    }
  }

  static DrawConfig _buildConfig(int seed, double roughness) =>
      DrawConfig.build(
        seed: seed,
        roughness: lerpDouble(
          SketchyRenderingConfig.roughnessMin,
          SketchyRenderingConfig.roughnessMax,
          roughness,
        ),
        bowing: lerpDouble(
          SketchyRenderingConfig.bowingMin,
          SketchyRenderingConfig.bowingMax,
          roughness,
        ),
        maxRandomnessOffset: lerpDouble(
          SketchyRenderingConfig.maxRandomnessOffsetMin,
          SketchyRenderingConfig.maxRandomnessOffsetMax,
          roughness,
        ),
        curveFitting: SketchyRenderingConfig.curveFitting,
      );

  static Filler _buildFiller(
    DrawConfig config,
    SketchyFill fill,
    double roughness,
    SketchyFillOptions? options,
  ) {
    final hachureGap =
        options?.hachureGap ??
        (lerpDouble(
              SketchyRenderingConfig.hachureGapMin,
              SketchyRenderingConfig.hachureGapMax,
              1 - roughness,
            ) ??
            SketchyRenderingConfig.defaultHachureGap);

    final fillWeight =
        options?.fillWeight ??
        (lerpDouble(
              SketchyRenderingConfig.fillWeightMin,
              SketchyRenderingConfig.fillWeightMax,
              roughness,
            ) ??
            SketchyRenderingConfig.defaultFillWeight);

    final fillerConfig = FillerConfig.build(
      drawConfig: config,
      hachureGap: hachureGap,
      fillWeight: fillWeight,
    );

    switch (fill) {
      case SketchyFill.none:
        return NoFiller(fillerConfig);
      case SketchyFill.hachure:
        return HachureFiller(fillerConfig);
      case SketchyFill.solid:
        // Fallback to solid filler if needed
        return SolidFiller(fillerConfig);
    }
  }

  static List<PointD> _roundedRectPoints(Size size, double radius) {
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
    if (primitive.fill == SketchyFill.solid) {
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
