// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'surface.dart';

export '../primitives/sketchy_primitives.dart' show SketchyFill;

enum SketchyFrameShape { rectangle, circle }

/// Convenience wrapper around [SketchySurface] that builds common frame shapes.
class SketchyFrame extends StatelessWidget {
  const SketchyFrame({
    required this.child,
    super.key,
    this.width,
    this.height,
    this.padding = EdgeInsets.zero,
    this.strokeColor,
    this.fillColor,
    this.strokeWidth,
    this.fill = SketchyFill.none,
    this.shape = SketchyFrameShape.rectangle,
    this.cornerRadius,
    this.alignment = Alignment.center,
    this.fillOptions,
  });

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final Color? strokeColor;
  final Color? fillColor;
  final double? strokeWidth;
  final SketchyFill fill;
  final SketchyFrameShape shape;
  final double? cornerRadius;
  final AlignmentGeometry? alignment;
  final SketchyFillOptions? fillOptions;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final primitive = _buildPrimitive();
    return SketchySurface(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      strokeColor: strokeColor ?? theme.colors.ink,
      fillColor: fillColor ?? const Color(0x00000000),
      strokeWidth: strokeWidth ?? theme.strokeWidth,
      createPrimitive: primitive,
      child: child,
    );
  }

  SketchyPrimitive Function() _buildPrimitive() {
    switch (shape) {
      case SketchyFrameShape.circle:
        return () => SketchyPrimitive.circle(
          fill: fill,
          fillOptions: fillOptions,
        );
      case SketchyFrameShape.rectangle:
        final radius = cornerRadius ?? 0;
        if (radius > 0) {
          return () => SketchyPrimitive.roundedRectangle(
            fill: fill,
            cornerRadius: radius,
            fillOptions: fillOptions,
          );
        }
        return () => SketchyPrimitive.rectangle(
          fill: fill,
          fillOptions: fillOptions,
        );
    }
  }
}
