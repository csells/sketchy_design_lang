import 'package:flutter/widgets.dart';
import 'package:rough_flutter/rough_flutter.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';
import 'value_sync_mixin.dart';

/// Sketchy checkbox.
///
/// Usage:
/// ```dart
/// Checkbox(
///   value: false,
///   onChanged: (value) {
/// 	print('Checkbox toggled: $value');
///   },
/// ),
/// ```
class Checkbox extends StatefulWidget {
  /// Creates a sketchy checkbox with the provided [value] and [onChanged].
  const Checkbox({required this.value, required this.onChanged, super.key});

  /// Determines the checkbox checked or not.
  final bool? value;

  /// Called once the checkbox check status changes.
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool?) onChanged;

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox>
    with ValueSyncMixin<bool, Checkbox> {
  @override
  bool get widgetValue => widget.value!;

  @override
  bool getOldWidgetValue(Checkbox oldWidget) => oldWidget.value!;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => GestureDetector(
      onTap: () {
        final newValue = !value;
        updateValue(newValue);
        widget.onChanged(newValue);
      },
      child: SketchySurface(
        width: 27,
        height: 27,
        strokeColor: theme.borderColor,
        strokeWidth: theme.strokeWidth,
        fillColor: theme.secondaryColor,
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        createPrimitive: () =>
            SketchyPrimitive.rectangle(fill: SketchyFill.none),
        child: value
            ? Transform.scale(
                scale: 0.7,
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CustomPaint(
                    painter: _SketchyCheckPainter(color: theme.inkColor),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    ),
  );
}

class _SketchyCheckPainter extends CustomPainter {
  _SketchyCheckPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final generator = SketchyGenerator.createGenerator(seed: 1);

    final drawable = generator.linearPath([
      PointD(4, size.height / 2),
      PointD(size.width / 2.5, size.height - 4),
      PointD(size.width - 4, 4),
    ]);

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRough(drawable, paint, paint);
  }

  @override
  bool shouldRepaint(_SketchyCheckPainter oldDelegate) =>
      oldDelegate.color != color;
}
