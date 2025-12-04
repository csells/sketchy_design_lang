// Test chat-like ListView with many items
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Chat List Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => ColoredBox(
          color: theme.paperColor,
          child: Column(
            children: [
              // Header like sidebar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    SketchyText(
                      'Test App',
                      style: theme.typography.title.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SketchySymbol(
                      symbol: SketchySymbols.gear,
                      size: 20,
                      color: theme.inkColor,
                    ),
                  ],
                ),
              ),
              const SketchyDivider(),
              // Message list like chat main area
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 20,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildMessage(theme, index),
                  ),
                ),
              ),
              const SketchyDivider(),
              // Input like chat input
              Padding(
                padding: const EdgeInsets.all(12),
                child: SketchyChatInput(
                  hintText: 'Type a message...',
                  onSubmitted: (text) => print('Sent: $text'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildMessage(SketchyThemeData theme, int index) {
    final isCurrentUser = index % 3 == 0;
    final isAgent = index % 2 == 0 && !isCurrentUser;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isCurrentUser) ...[
          SketchyAvatar(
            initials: isAgent ? 'AI' : 'U${index % 5}',
            radius: 18,
            showOnlineIndicator: false,
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: SketchyChatBubble(
            alignment: isCurrentUser
                ? SketchyChatBubbleAlignment.end
                : SketchyChatBubbleAlignment.start,
            bubbleColor:
                isCurrentUser ? theme.secondaryColor : theme.primaryColor,
            topContent: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SketchyText(
                  isCurrentUser
                      ? 'You'
                      : (isAgent ? 'AI Agent $index' : 'User $index'),
                  style: theme.typography.body.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (isAgent) ...[
                  const SizedBox(width: 4),
                  SketchyChip(
                    label: SketchyText(
                      'AI',
                      style: theme.typography.label.copyWith(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    compact: true,
                    tone: SketchyChipTone.accent,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  ),
                ],
              ],
            ),
            maxWidth: 400,
            content: SketchyText(
              'This is message number $index. It contains some text '
              'that could be longer to test wrapping behavior.',
              style: theme.typography.body.copyWith(fontSize: 14),
            ),
          ),
        ),
        if (isCurrentUser) ...[
          const SizedBox(width: 8),
          SketchyAvatar(initials: 'ME', radius: 18),
        ],
      ],
    );
  }
}
