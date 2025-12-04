import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';

/// Display mode for user tiles.
enum UserTileMode {
  /// Minimal: just green dot + name (for humans in sidebar).
  minimal,

  /// Agent: avatar + name with AI badge inline + model string below.
  agent,

  /// Footer: avatar + green dot + name + role (for current user).
  footer,
}

/// A tile representing a user or agent in the sidebar.
class UserTile extends StatelessWidget {
  /// Creates a user tile.
  const UserTile({
    required this.participant,
    super.key,
    this.mode = UserTileMode.minimal,
    this.onTap,
  });

  /// The participant to display.
  final ChatParticipant participant;

  /// Display mode for the tile.
  final UserTileMode mode;

  /// Callback when the tile is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      Widget content;

      switch (mode) {
        case UserTileMode.minimal:
          content = _buildMinimal(theme);
        case UserTileMode.agent:
          content = _buildAgent(theme);
        case UserTileMode.footer:
          content = _buildFooter(theme);
      }

      if (onTap != null) {
        return GestureDetector(
          onTap: onTap,
          child: MouseRegion(cursor: SystemMouseCursors.click, child: content),
        );
      }
      return content;
    },
  );

  /// Minimal mode: green dot + name only.
  Widget _buildMinimal(SketchyThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    child: Row(
      children: [
        if (participant.isOnline)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: SketchyColors.onlineGreen,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: SketchyText(
            participant.name,
            style: theme.typography.body.copyWith(
              color: theme.inkColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );

  /// Agent mode: avatar + name with AI badge + model string below.
  Widget _buildAgent(SketchyThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SketchyAvatar(
          initials: participant.initials,
          radius: 16,
          showOnlineIndicator: false,
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
                        fontSize: 14,
                      ),
                    ),
                  ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                  ),
                ],
              ),
              if (participant.modelString != null) ...[
                SketchyText(
                  participant.modelString!,
                  style: theme.typography.caption.copyWith(
                    color: theme.inkColor.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );

  /// Footer mode: avatar + green dot + name + role.
  Widget _buildFooter(SketchyThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    child: Row(
      children: [
        SketchyAvatar(
          initials: participant.initials,
          radius: 16,
          showOnlineIndicator: false,
        ),
        const SizedBox(width: 10),
        if (participant.isOnline)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: SketchyColors.onlineGreen,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SketchyText(
                participant.name,
                style: theme.typography.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.inkColor,
                  fontSize: 14,
                ),
              ),
              if (participant.role != null)
                SketchyText(
                  participant.role!,
                  style: theme.typography.caption.copyWith(
                    color: theme.inkColor.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
