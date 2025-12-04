import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/mock_data.dart';
import 'channel_tile.dart';
import 'chat_sidebar_section.dart';
import 'user_tile.dart';

/// The sidebar for the chat app showing channels and users.
class ChatSidebar extends StatelessWidget {
  /// Creates a chat sidebar.
  const ChatSidebar({
    required this.selectedChannelId,
    required this.onChannelSelected,
    required this.onSettingsPressed,
    super.key,
  });

  /// The currently selected channel ID.
  final String selectedChannelId;

  /// Callback when a channel is selected.
  final ValueChanged<String> onChannelSelected;

  /// Callback when the settings button is pressed.
  final VoidCallback onSettingsPressed;

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => ColoredBox(
      color: theme.paperColor,
      child: Column(
        children: [
          // App Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: SketchyText(
                    'Chatarang',
                    style: theme.typography.title.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.inkColor,
                    ),
                  ),
                ),
                SketchySymbol(
                  symbol: SketchySymbols.externalLink,
                  size: 18,
                  color: theme.inkColor.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          const SketchyDivider(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Channels section
                  ChatSidebarSection(
                    title: 'Channels',
                    children: [
                      for (final channel in MockData.channels)
                        ChannelTile(
                          channel: channel,
                          isSelected: channel.id == selectedChannelId,
                          onTap: () => onChannelSelected(channel.id),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Humans section
                  ChatSidebarSection(
                    title: 'Humans',
                    children: [
                      for (final human in MockData.humans)
                        UserTile(
                          participant: human,
                          mode: UserTileMode.minimal,
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // AI Agents section
                  ChatSidebarSection(
                    title: 'AI Agents',
                    children: [
                      for (final agent in MockData.agents)
                        UserTile(participant: agent, mode: UserTileMode.agent),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Current user footer
          const SketchyDivider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(
                  child: UserTile(
                    participant: MockData.currentUser,
                    mode: UserTileMode.footer,
                  ),
                ),
                SketchyIconButton(
                  icon: SketchySymbol(
                    symbol: SketchySymbols.gear,
                    size: 20,
                    color: theme.inkColor.withValues(alpha: 0.6),
                  ),
                  onPressed: onSettingsPressed,
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
