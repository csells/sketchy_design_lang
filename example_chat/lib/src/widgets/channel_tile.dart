import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';

/// A tile representing a chat channel in the sidebar.
class ChannelTile extends StatelessWidget {
  /// Creates a channel tile.
  const ChannelTile({
    required this.channel,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  /// The channel to display.
  final ChatChannel channel;

  /// Whether this channel is currently selected.
  final bool isSelected;

  /// Callback when the tile is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final bgColor = isSelected
          ? theme.primaryColor.withValues(alpha: 0.15)
          : null;

      return GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                SketchySymbol(
                  symbol: SketchySymbols.hash,
                  size: 14,
                  color: isSelected
                      ? theme.inkColor
                      : theme.inkColor.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SketchyText(
                    channel.name,
                    style: theme.typography.body.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: theme.inkColor,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  SketchySymbol(
                    symbol: SketchySymbols.check,
                    size: 14,
                    color: theme.inkColor,
                  ),
                ] else if (channel.unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  SketchyText(
                    '${channel.unreadCount}',
                    style: theme.typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.inkColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}
