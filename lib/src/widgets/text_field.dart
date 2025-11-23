import 'package:flutter/material.dart'
    show
        FocusNode,
        InputBorder,
        InputDecoration,
        Material,
        MaterialType,
        TextCapitalization,
        TextEditingController,
        TextInputAction,
        TextInputType,
        TextSelectionThemeData,
        Theme;
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart' show TextInputFormatter;
import 'package:flutter/widgets.dart' hide Text;

import '../theme/sketchy_text_case.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_frame.dart';
import 'text.dart' as sketchy;

export 'package:flutter/material.dart'
    show
        FocusNode,
        InputBorder,
        InputDecoration,
        TextCapitalization,
        TextEditingController,
        TextInputAction,
        TextInputType;

/// Sketchy text input.
class TextField extends StatefulWidget {
  /// Creates a sketchy-styled text field.
  const TextField({
    super.key,
    this.controller,
    this.focusNode,
    this.style,
    this.decoration,
    this.onChanged,
    this.onSubmitted,
    this.textCase,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.readOnly = false,
    this.showCursor,
    this.maxLength,
    this.onTap,
    this.onTapOutside,
    this.inputFormatters,
    this.enabled,
    this.autofocus = false,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The text style for input.
  final TextStyle? style;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates that they are done editing the text in the
  /// field.
  final ValueChanged<String>? onSubmitted;

  /// Text casing transformation for label and hint. If null, uses theme
  /// default. Note: This does NOT affect the actual input text, only the label
  /// and hint.
  final TextCase? textCase;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform should select capital letters.
  final TextCapitalization textCapitalization;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// Whether to show input suggestions.
  final bool enableSuggestions;

  /// The maximum number of lines to show at one time, wrapping if necessary.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// Whether the text can be changed.
  final bool readOnly;

  /// Whether to show the cursor.
  final bool? showCursor;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  final int? maxLength;

  /// Called for each distinct tap except for every second tap of a double tap.
  final GestureTapCallback? onTap;

  /// Called for each tap that occurs outside of the [TextFieldTapRegion] group
  /// when the text field is focused.
  final TapRegionCallback? onTapOutside;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// If false the text field is "disabled": it ignores taps and its
  /// decoration is rendered in grey.
  final bool? enabled;

  /// Whether this text field should focus itself if nothing else is already
  /// focused.
  final bool autofocus;

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void didUpdateWidget(covariant TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller = widget.controller!;
    }
    if (widget.focusNode != null && widget.focusNode != _focusNode) {
      _focusNode = widget.focusNode!;
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final casing = widget.textCase ?? theme.textCase;
      final decoration = widget.decoration ?? const InputDecoration();

      final effectiveLabelStyle =
          decoration.labelStyle ??
          TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
      final effectiveStyle =
          widget.style ??
          TextStyle(fontFamily: theme.fontFamily, color: theme.textColor);
      final effectiveHintStyle =
          decoration.hintStyle ??
          TextStyle(
            fontFamily: theme.fontFamily,
            color: theme.disabledTextColor,
          );

      final displayLabel = decoration.labelText != null
          ? applyTextCase(decoration.labelText!, casing)
          : null;
      final displayHint = decoration.hintText != null
          ? applyTextCase(decoration.hintText!, casing)
          : null;

      // Calculate height based on lines if not expanding
      final height = widget.expands
          ? null
          : (widget.maxLines ?? 1) * 24.0 + 24.0;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (displayLabel != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: sketchy.Text(displayLabel, style: effectiveLabelStyle),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: SketchyFrame(
              height: height,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              fill: SketchyFill.none,
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: theme.inkColor,
                      selectionColor: theme.primaryColor.withValues(alpha: 0.3),
                      selectionHandleColor: theme.inkColor,
                    ),
                  ),
                  child: Material(
                    type: MaterialType.transparency,
                    child: material.TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      style: effectiveStyle,
                      cursorColor: theme.inkColor,
                      decoration: InputDecoration(
                        hintText: displayHint,
                        hintStyle: effectiveHintStyle,
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 4,
                        ),
                        counterText: '', // Hide default counter
                        prefixIcon: decoration.prefixIcon,
                        suffixIcon: decoration.suffixIcon,
                        errorText: decoration.errorText,
                      ),
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      textCapitalization: widget.textCapitalization,
                      obscureText: widget.obscureText,
                      autocorrect: widget.autocorrect,
                      enableSuggestions: widget.enableSuggestions,
                      maxLines: widget.maxLines,
                      minLines: widget.minLines,
                      expands: widget.expands,
                      readOnly: widget.readOnly,
                      showCursor: widget.showCursor,
                      maxLength: widget.maxLength,
                      onTap: widget.onTap,
                      onTapOutside: widget.onTapOutside,
                      inputFormatters: widget.inputFormatters,
                      enabled: widget.enabled,
                      autofocus: widget.autofocus,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
