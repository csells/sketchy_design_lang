import 'package:flutter/widgets.dart';
import 'package:wired_elements/wired_elements.dart';

import '../theme/sketchy_palette.dart';
import '../theme/sketchy_typography.dart';

/// Rough-styled text field wrapper.
class SketchyTextField extends StatelessWidget {
  /// Creates a text field with optional label, hint, and error text.
  const SketchyTextField({
    super.key,
    this.label,
    this.controller,
    this.onChanged,
    this.hintText,
    this.errorText,
  });

  /// Optional label displayed before the field.
  final String? label;

  /// Controller bound to the inner text field.
  final TextEditingController? controller;

  /// Callback invoked when the text changes.
  final ValueChanged<String>? onChanged;

  /// Placeholder hint rendered within the field.
  final String? hintText;

  /// Error message shown below the field.
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final typography = SketchyTypography.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WiredInput(
          labelText: label,
          labelStyle: typography.body,
          controller: controller,
          hintText: hintText,
          style: typography.body,
          onChanged: onChanged,
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: typography.caption.copyWith(color: SketchyPalette.error),
          ),
        ],
      ],
    );
  }
}
