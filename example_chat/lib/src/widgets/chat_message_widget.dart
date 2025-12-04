import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';
import '../models/mock_data.dart';

/// Widget for displaying a single chat message.
class ChatMessageWidget extends StatelessWidget {
  /// Creates a chat message widget.
  const ChatMessageWidget({
    required this.message,
    required this.isCurrentUser,
    super.key,
  });

  /// The message to display.
  final ChatMessage message;

  /// Whether this message is from the current user.
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    final sender = MockData.getParticipant(message.senderId);
    if (sender == null) return const SizedBox.shrink();

    return SketchyTheme.consumer(
      builder: (context, theme) {
        final alignment = isCurrentUser
            ? SketchyChatBubbleAlignment.end
            : SketchyChatBubbleAlignment.start;

        // Build header content: name + [AI badge + model] + timestamp (right)
        final headerContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SketchyText(
              sender.name,
              style: theme.typography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.inkColor,
                fontSize: 13,
              ),
            ),
            if (sender.isAgent) ...[
              const SizedBox(width: 4),
              SketchyChip(
                label: SketchyText(
                  'AI',
                  style: theme.typography.label.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: theme.inkColor,
                  ),
                ),
                compact: true,
                tone: SketchyChipTone.accent,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.3),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              ),
            ],
            if (sender.isAgent && sender.modelString != null) ...[
              const SizedBox(width: 4),
              SketchyText(
                sender.modelString!,
                style: theme.typography.caption.copyWith(
                  color: theme.inkColor.withValues(alpha: 0.5),
                  fontSize: 11,
                ),
              ),
            ],
            const SizedBox(width: 8),
            SketchyText(
              message.formattedTime,
              style: theme.typography.caption.copyWith(
                color: theme.inkColor.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ],
        );

        // Avatar without AI badge
        final avatar = SketchyAvatar(
          initials: sender.initials,
          radius: 18,
          showOnlineIndicator: false,
        );

        final bubbleColor = isCurrentUser
            ? theme.secondaryColor
            : theme.primaryColor;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isCurrentUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isCurrentUser) ...[avatar, const SizedBox(width: 8)],
              Flexible(
                child: SketchyChatBubble(
                  alignment: alignment,
                  bubbleColor: bubbleColor,
                  topContent: headerContent,
                  maxWidth: 500,
                  content: SketchyText(
                    message.content,
                    style: theme.typography.body.copyWith(
                      color: theme.inkColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (isCurrentUser) ...[const SizedBox(width: 8), avatar],
            ],
          ),
        );
      },
    );
  }
}
