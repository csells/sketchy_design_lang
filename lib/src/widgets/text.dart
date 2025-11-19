import 'package:flutter/widgets.dart';

import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';

/// Text widget that automatically applies theme titleCasing.
class SketchyText extends StatelessWidget {
  /// Creates text that applies titleCasing transformation from theme.
  const SketchyText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.textCase,
  });

  /// The text to display.
  final String data;

  /// Text style to apply.
  final TextStyle? style;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow should be handled.
  final TextOverflow? overflow;

  /// Maximum number of lines for the text to span.
  final int? maxLines;

  /// Text casing transformation. If null, uses theme default.
  final TextCase? textCase;

  @override
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final casing = textCase ?? theme.titleCasing;
    final displayText = applyTextCase(data, casing);

    return Text(
      displayText,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
