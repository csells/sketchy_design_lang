import 'package:flutter/widgets.dart';

import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import '../widgets/sketchy_frame.dart';

/// Sketchy text input.
///
/// Usage:
/// ```dart
/// SketchyTextInput(
///   controller: controller1,
///   style: TextStyle(
/// 	fontFamily: handWriting2,
/// 	fontSize: 18.0,
///   ),
///   labelText: 'Name',
///   labelStyle: TextStyle(
/// 	fontFamily: handWriting2,
/// 	fontSize: 18.0,
///   ),
/// ),
/// ```
class SketchyTextInput extends StatefulWidget {
  /// Creates a sketchy-styled text field.
  const SketchyTextInput({
    super.key,
    this.controller,
    this.style,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.onChanged,
    this.textCase,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// The text style for input.
  final TextStyle? style;

  /// Text that describes the input field.
  final String? labelText;

  /// The style to use for the [labelText] when the label is above (i.e.,
  /// vertically adjacent to) the input field.
  final TextStyle? labelStyle;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// The style to use for the [hintText].
  final TextStyle? hintStyle;

  /// Called when the text changes.
  final void Function(String)? onChanged;

  /// Text casing transformation for label and hint. If null, uses theme
  /// default. Note: This does NOT affect the actual input text, only the
  /// label and hint.
  final TextCase? textCase;

  @override
  State<SketchyTextInput> createState() => _SketchyTextInputState();
}

class _SketchyTextInputState extends State<SketchyTextInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant SketchyTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller = widget.controller!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) {
          final casing = widget.textCase ?? theme.textCase;
          final effectiveLabelStyle = widget.labelStyle ??
              TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
          final effectiveStyle = widget.style ??
              TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
          final effectiveHintStyle = widget.hintStyle ??
              TextStyle(
                fontFamily: theme.fontFamily,
                color: theme.disabledTextColor,
              );

          final displayLabel = widget.labelText != null
              ? applyTextCase(widget.labelText!, casing)
              : null;
          final displayHint = widget.hintText != null
              ? applyTextCase(widget.hintText!, casing)
              : null;

          return Row(
            children: [
              if (displayLabel != null)
                Text(displayLabel, style: effectiveLabelStyle),
              if (displayLabel != null) const SizedBox(width: 10),
              Expanded(
                child: SketchyFrame(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  fill: SketchyFill.none,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        if (displayHint != null && _controller.text.isEmpty)
                          Text(displayHint, style: effectiveHintStyle),
                        EditableText(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: effectiveStyle,
                          cursorColor: theme.colors.ink,
                          backgroundCursorColor: theme.colors.paper,
                          onChanged: (value) {
                            setState(() {}); // To update hint visibility
                            widget.onChanged?.call(value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
}
