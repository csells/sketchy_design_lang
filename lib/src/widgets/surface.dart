import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';

/// Utility widget that paints a [SketchyPrimitive] behind [child].
class SketchySurface extends StatefulWidget {
  /// Creates a sketchy surface with the given primitive background.
  const SketchySurface({
    required this.child,
    super.key,
    this.padding = EdgeInsets.zero,
    this.height,
    this.width,
    this.strokeColor,
    this.fillColor,
    this.strokeWidth,
    this.alignment = Alignment.center,
    this.createPrimitive,
  });

  /// Widget rendered above the primitive.
  final Widget child;

  /// Optional factory for customizing the primitive shape.
  final SketchyPrimitive Function()? createPrimitive;

  /// Inner padding applied around [child].
  final EdgeInsetsGeometry padding;

  /// Optional fixed height.
  final double? height;

  /// Optional fixed width.
  final double? width;

  /// Stroke color override.
  final Color? strokeColor;

  /// Fill color override.
  final Color? fillColor;

  /// Stroke width override.
  final double? strokeWidth;

  /// Alignment of [child] within the painted area.
  final AlignmentGeometry? alignment;

  @override
  State<SketchySurface> createState() => _SketchySurfaceState();
}

class _SketchySurfaceState extends State<SketchySurface> {
  late final SketchyPrimitive _primitive =
      widget.createPrimitive?.call() ?? SketchyPrimitive.rectangle();

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) {
          final painted = CustomPaint(
            painter: SketchyShapePainter(
              primitive: _primitive,
              strokeColor: widget.strokeColor ?? theme.colors.ink,
              fillColor: widget.fillColor ?? theme.colors.paper,
              strokeWidth: widget.strokeWidth ?? theme.strokeWidth,
              roughness: theme.roughness,
            ),
            child: Padding(
              padding: widget.padding,
              child: widget.alignment != null
                  ? Align(alignment: widget.alignment!, child: widget.child)
                  : widget.child,
            ),
          );

          if (widget.width != null || widget.height != null) {
            return SizedBox(
              width: widget.width,
              height: widget.height,
              child: painted,
            );
          }

          return painted;
        },
      );
}
