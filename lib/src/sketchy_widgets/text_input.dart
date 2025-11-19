import 'package:flutter/widgets.dart';

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
  Widget build(BuildContext context) {
    final theme = SketchyTheme.of(context);
    final effectiveLabelStyle =
        widget.labelStyle ??
        TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
    final effectiveStyle =
        widget.style ??
        TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
    final effectiveHintStyle =
        widget.hintStyle ??
        TextStyle(fontFamily: theme.fontFamily, color: theme.disabledTextColor);

    return Row(
      children: [
        if (widget.labelText != null)
          Text('${widget.labelText}', style: effectiveLabelStyle),
        if (widget.labelText != null) const SizedBox(width: 10),
        Expanded(
          child: SketchyFrame(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            fill: SketchyFill.none,
            child: Center(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  if (widget.hintText != null && _controller.text.isEmpty)
                    Text(widget.hintText!, style: effectiveHintStyle),
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
  }
}
