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
        Theme;
import 'package:flutter/material.dart' as material;
import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_icon_button.dart';
import 'sketchy_surface.dart';
import 'sketchy_symbols.dart';

/// A chat message input field with sketchy styling.
///
/// Includes optional action buttons for attachments, emoji, and mentions.
class SketchyChatInput extends StatefulWidget {
  /// Creates a sketchy chat input.
  const SketchyChatInput({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.onSubmitted,
    this.onChanged,
    this.showAttachmentButton = true,
    this.showEmojiButton = true,
    this.showMentionButton = true,
    this.showEditButton = true,
    this.onAttachmentPressed,
    this.onEmojiPressed,
    this.onMentionPressed,
    this.onEditPressed,
    this.leading,
    this.trailing,
    this.autofocus = false,
  });

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// Placeholder text shown when the input is empty.
  final String? hintText;

  /// Called when the user submits the message (e.g., presses Enter or Send).
  final ValueChanged<String>? onSubmitted;

  /// Called when the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to show the attachment button.
  final bool showAttachmentButton;

  /// Whether to show the emoji button.
  final bool showEmojiButton;

  /// Whether to show the mention button.
  final bool showMentionButton;

  /// Whether to show the edit/pencil button.
  final bool showEditButton;

  /// Callback when attachment button is pressed.
  final VoidCallback? onAttachmentPressed;

  /// Callback when emoji button is pressed.
  final VoidCallback? onEmojiPressed;

  /// Callback when mention button is pressed.
  final VoidCallback? onMentionPressed;

  /// Callback when edit button is pressed.
  final VoidCallback? onEditPressed;

  /// Optional widget to show before the input.
  final Widget? leading;

  /// Optional widget to show after the input (replaces all action buttons).
  final Widget? trailing;

  /// Whether to autofocus the input.
  final bool autofocus;

  @override
  State<SketchyChatInput> createState() => _SketchyChatInputState();
}

class _SketchyChatInputState extends State<SketchyChatInput> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late final SketchyPrimitive _framePrimitive;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _framePrimitive = SketchyPrimitive.roundedRectangle(
      cornerRadius: 8,
      fill: SketchyFill.none,
    );
    _controller.addListener(_onTextChanged);
    _hasText = _controller.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant SketchyChatInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != _controller) {
      _controller.removeListener(_onTextChanged);
      _controller = widget.controller!;
      _controller.addListener(_onTextChanged);
    }
    if (widget.focusNode != null && widget.focusNode != _focusNode) {
      _focusNode = widget.focusNode!;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _onSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmitted?.call(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      // All action icons on the right side
      final trailing = widget.trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.showAttachmentButton)
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.paperclip,
                    size: 18,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  onPressed: widget.onAttachmentPressed ?? () {},
                  iconSize: 32,
                ),
              if (widget.showEmojiButton)
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.smiley,
                    size: 18,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  onPressed: widget.onEmojiPressed ?? () {},
                  iconSize: 32,
                ),
              if (widget.showMentionButton)
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.at,
                    size: 18,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  onPressed: widget.onMentionPressed ?? () {},
                  iconSize: 32,
                ),
              if (widget.showEditButton)
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.pencil,
                    size: 18,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  onPressed: widget.onEditPressed ?? () {},
                  iconSize: 32,
                ),
              SketchyIconButton(
                icon: SketchySymbol(
                  symbol: SketchySymbols.send,
                  size: 18,
                  color: _hasText ? theme.inkColor : theme.disabledTextColor,
                ),
                onPressed: _hasText ? _onSubmit : null,
                iconSize: 32,
              ),
            ],
          );

      return SketchySurface(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        fillColor: theme.paperColor,
        strokeColor: theme.inkColor,
        createPrimitive: () => _framePrimitive,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.leading != null) ...[
              widget.leading!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: material.TextSelectionThemeData(
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
                    style: theme.typography.body.copyWith(
                      color: theme.textColor,
                    ),
                    cursorColor: theme.inkColor,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: theme.typography.body.copyWith(
                        color: theme.disabledTextColor,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 4,
                      ),
                    ),
                    onChanged: widget.onChanged,
                    onSubmitted: (_) => _onSubmit(),
                    textInputAction: TextInputAction.send,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 4,
                    minLines: 1,
                    autofocus: widget.autofocus,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      );
    },
  );
}
