import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';

/// A tile representing a user or agent in the sidebar.
class UserTile extends StatelessWidget {
  /// Creates a user tile.
  const UserTile({
    super.key,
    required this.participant,
    this.onTap,
    this.showRole = true,
    this.showModelString = true,
    this.compact = false,
  });

  /// The participant to display.
  final ChatParticipant participant;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether to show the role/title.
  final bool showRole;

  /// Whether to show the model string for agents.
  final bool showModelString;

  /// Whether to use compact layout.
  final bool compact;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final avatarRadius = compact ? 14.0 : 18.0;

      Widget? badge;
      if (participant.isAgent) {
        badge = SketchyChip(
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
        );
      }

      final content = Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: compact ? 4 : 6,
        ),
        child: Row(
          children: [
            SketchyAvatar(
              initials: participant.initials,
              radius: avatarRadius,
              showOnlineIndicator: true,
              isOnline: participant.isOnline,
              badge: badge,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: SketchyText(
                          participant.name,
                          style: theme.typography.body.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.inkColor,
                            fontSize: compact ? 13 : 14,
                          ),
                        ),
                      ),
                      if (participant.isOnline) ...[
                        const SizedBox(width: 6),
                        SketchyText(
                          'online',
                          style: theme.typography.caption.copyWith(
                            color: SketchyColors.onlineGreen,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (showRole && participant.role != null) ...[
                    SketchyText(
                      participant.role!,
                      style: theme.typography.caption.copyWith(
                        color: theme.inkColor.withValues(alpha: 0.6),
                        fontSize: compact ? 11 : 12,
                      ),
                    ),
                  ],
                  if (showModelString &&
                      participant.isAgent &&
                      participant.modelString != null) ...[
                    SketchyText(
                      participant.modelString!,
                      style: theme.typography.caption.copyWith(
                        color: theme.primaryColor,
                        fontSize: compact ? 10 : 11,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );

      if (onTap != null) {
        return GestureDetector(
          onTap: onTap,
          child: MouseRegion(cursor: SystemMouseCursors.click, child: content),
        );
      }
      return content;
    },
  );
}
