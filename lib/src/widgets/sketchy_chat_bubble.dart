import 'package:flutter/widgets.dart';

import '../primitives/sketchy_primitives.dart';
import '../theme/sketchy_theme.dart';
import 'sketchy_surface.dart';

/// Alignment options for [SketchyChatBubble].
enum SketchyChatBubbleAlignment {
  /// Bubble aligns to the start (left in LTR).
  start,

  /// Bubble aligns to the end (right in LTR).
  end,
}

/// A chat message bubble with sketchy styling.
///
/// Supports optional top content (username, timestamp), main content,
/// and optional bottom content (reactions, etc.).
class SketchyChatBubble extends StatefulWidget {
  /// Creates a sketchy chat bubble.
  const SketchyChatBubble({
    required this.content,
    super.key,
    this.topContent,
    this.bottomContent,
    this.alignment = SketchyChatBubbleAlignment.start,
    this.bubbleColor,
    this.maxWidth,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.cornerRadius = 12,
    this.onTap,
    this.onLongPress,
  });

  /// The main content of the bubble (typically a Text widget).
  final Widget content;

  /// Optional content shown above the bubble (username, timestamp, etc.).
  final Widget? topContent;

  /// Optional content shown below the bubble (reactions, etc.).
  final Widget? bottomContent;

  /// Alignment of the bubble within its parent.
  final SketchyChatBubbleAlignment alignment;

  /// Background color of the bubble (defaults based on alignment).
  final Color? bubbleColor;

  /// Maximum width of the bubble (defaults to 80% of parent).
  final double? maxWidth;

  /// Internal padding of the bubble.
  final EdgeInsetsGeometry padding;

  /// Corner radius for the bubble.
  final double cornerRadius;

  /// Callback when the bubble is tapped.
  final VoidCallback? onTap;

  /// Callback when the bubble is long-pressed.
  final VoidCallback? onLongPress;

  @override
  State<SketchyChatBubble> createState() => _SketchyChatBubbleState();
}

class _SketchyChatBubbleState extends State<SketchyChatBubble> {
  late final SketchyPrimitive _bubblePrimitive;

  @override
  void initState() {
    super.initState();
    _bubblePrimitive = SketchyPrimitive.roundedRectangle(
      cornerRadius: widget.cornerRadius,
      fill: SketchyFill.solid,
    );
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final isEnd = widget.alignment == SketchyChatBubbleAlignment.end;
      final bubbleColor =
          widget.bubbleColor ??
          (isEnd ? theme.secondaryColor : theme.primaryColor);

      final bubble = SketchySurface(
        padding: widget.padding,
        fillColor: bubbleColor,
        strokeColor: theme.inkColor,
        createPrimitive: () => _bubblePrimitive,
        child: DefaultTextStyle(
          style: theme.typography.body.copyWith(color: theme.inkColor),
          child: widget.content,
        ),
      );

      final bubbleWithConstraints = ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth ?? double.infinity,
        ),
        child: IntrinsicWidth(child: IntrinsicHeight(child: bubble)),
      );

      final wrappedBubble = widget.onTap != null || widget.onLongPress != null
          ? GestureDetector(
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: bubbleWithConstraints,
              ),
            )
          : bubbleWithConstraints;

      final column = Column(
        crossAxisAlignment: isEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.topContent != null) ...[
            DefaultTextStyle(
              style: theme.typography.caption.copyWith(
                color: theme.inkColor.withValues(alpha: 0.7),
              ),
              child: widget.topContent!,
            ),
            const SizedBox(height: 4),
          ],
          wrappedBubble,
          if (widget.bottomContent != null) ...[
            const SizedBox(height: 4),
            widget.bottomContent!,
          ],
        ],
      );

      return Align(
        alignment: isEnd ? Alignment.centerRight : Alignment.centerLeft,
        child: column,
      );
    },
  );
}
