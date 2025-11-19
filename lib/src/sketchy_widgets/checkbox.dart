import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import '../widgets/icons.dart';
import '../widgets/surface.dart';
import '../widgets/value_sync_mixin.dart';

/// Sketchy checkbox.
///
/// Usage:
/// ```dart
/// SketchyCheckbox(
///   value: false,
///   onChanged: (value) {
/// 	print('Checkbox toggled: $value');
///   },
/// ),
/// ```
class SketchyCheckbox extends StatefulWidget {
  /// Creates a sketchy checkbox with the provided [value] and [onChanged].
  const SketchyCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Determines the checkbox checked or not.
  final bool? value;

  /// Called once the checkbox check status changes.
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool?) onChanged;

  @override
  State<SketchyCheckbox> createState() => _SketchyCheckboxState();
}

class _SketchyCheckboxState extends State<SketchyCheckbox>
    with ValueSyncMixin<bool, SketchyCheckbox> {
  @override
  bool get widgetValue => widget.value!;

  @override
  bool getOldWidgetValue(SketchyCheckbox oldWidget) => oldWidget.value!;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return GestureDetector(
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
        fillColor: theme.colors.secondary,
        padding: EdgeInsets.zero,
        alignment: Alignment.center,
        createPrimitive: () =>
            SketchyPrimitive.rectangle(fill: SketchyFill.none),
        child: value
            ? Transform.scale(
                scale: 0.7,
                child: SketchyIcon(
                  icon: SketchyIcons.check,
                  color: theme.colors.ink,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
