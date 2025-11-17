import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import '../theme/sketchy_typography.dart';
import 'surface.dart';

/// Hand-drawn checkbox that avoids Material dependencies.
class SketchyCheckbox extends StatelessWidget {
  /// Creates a checkbox bound to [value].
  const SketchyCheckbox({required this.value, super.key, this.onChanged});

  /// Whether the checkbox is checked.
  final bool value;

  /// Change handler invoked with the new value.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: SketchySurface(
        width: 32,
        height: 32,
        padding: EdgeInsets.zero,
        fillColor: value
            ? theme.colors.secondary.withValues(alpha: 0.3)
            : theme.colors.paper,
        strokeColor: theme.colors.ink,
        createPrimitive: () => SketchyPrimitive.rectangle(
          fill: value ? SketchyFill.hachure : SketchyFill.none,
        ),
        child: value
            ? Center(
                child: CustomPaint(
                  size: const Size(20, 20),
                  painter: _CheckmarkPainter(color: theme.colors.ink),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

/// Painter for the checkmark.
class _CheckmarkPainter extends CustomPainter {
  _CheckmarkPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.75)
      ..lineTo(size.width * 0.8, size.height * 0.25);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Checkbox paired with a text label.
class SketchyCheckboxTile extends StatelessWidget {
  /// Creates a labeled checkbox.
  const SketchyCheckboxTile({
    required this.label,
    required this.value,
    super.key,
    this.onChanged,
  });

  /// Label rendered next to the checkbox.
  final String label;

  /// Whether the checkbox is checked.
  final bool value;

  /// Change handler invoked with the new value.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return Row(
      children: [
        Expanded(child: Text(label, style: typography.body)),
        SketchyCheckbox(value: value, onChanged: onChanged),
      ],
    );
  }
}
