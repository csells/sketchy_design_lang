// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import '../widgets/surface.dart';
import 'wired_base.dart';

/// Wired checkbox.
///
/// Usage:
/// ```dart
/// SketchyCheckbox(
///   value: false,
///   onChanged: (value) {
/// 	print('Wired Checkbox $value');
///   },
/// ),
/// ```
class SketchyCheckbox extends StatefulWidget {
  const SketchyCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Determines the checkbox checked or not.
  final bool? value;

  /// Called once the checkbox check status changes.
  final void Function(bool?) onChanged;

  @override
  State<SketchyCheckbox> createState() => _SketchyCheckboxState();
}

class _SketchyCheckboxState extends State<SketchyCheckbox>
    with WiredRepaintMixin {
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value!;
  }

  @override
  Widget build(BuildContext context) =>
      buildWiredElement(key: widget.key, child: _buildWidget(context));

  Widget _buildWidget(BuildContext context) {
    final theme = SketchyTheme.of(context);
    return SketchySurface(
      width: 27,
      height: 27,
      strokeColor: theme.borderColor,
      strokeWidth: theme.strokeWidth,
      fillColor: theme.colors.secondary,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      createPrimitive: () => SketchyPrimitive.rectangle(fill: SketchyFill.none),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Transform.scale(
          scale: 1.5,
          child: Checkbox(
            fillColor: WidgetStateProperty.all(Colors.transparent),
            checkColor: theme.borderColor,
            side: BorderSide(
              color: theme.borderColor,
              width: theme.strokeWidth,
            ),
            onChanged: (value) {
              setState(() {
                widget.onChanged(value);
                _value = value!;
              });
            },
            value: _value,
          ),
        ),
      ),
    );
  }
}
