import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

/// Chat transcript showing list tiles, typing indicator, and annotations.
class LiveChatExample extends StatelessWidget {
  const LiveChatExample({super.key});

  static Widget builder(BuildContext context) => const LiveChatExample();

  @override
  Widget build(BuildContext context) {
    const messages = _sampleMessages;
    return SketchyScaffold(
      appBar: const SketchyAppBar(title: Text('Live Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final message = messages[index];
                return SketchyListTile(
                  leading: SketchyBadge(
                    label: message.authorInitials,
                    tone: message.isAgent
                        ? SketchyBadgeTone.info
                        : SketchyBadgeTone.accent,
                  ),
                  title: Text(message.text),
                  subtitle: Text(message.timestamp),
                  trailing: message.isTyping
                      ? const SketchyTypingIndicator()
                      : null,
                  alignment: message.isAgent
                      ? SketchyTileAlignment.start
                      : SketchyTileAlignment.end,
                );
              },
              separatorBuilder: (context, _) => const SizedBox(height: 12),
              itemCount: messages.length,
            ),
          ),
          SketchyCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Suggested replies'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final suggestion in _suggestions)
                      SketchyAnnotate.circle(
                        label: 'Auto-complete',
                        child: SketchyChip.suggestion(label: suggestion),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: SketchyTextField(label: 'Message')),
                    SizedBox(width: 8),
                    SketchyIconButton(icon: SketchyIcons.send),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.timestamp,
    required this.isAgent,
    this.isTyping = false,
  });
  final String text;
  final String timestamp;
  final bool isAgent;
  final bool isTyping;

  String get authorInitials => isAgent ? 'CS' : 'ME';
}

const _sampleMessages = [
  _ChatMessage(
    text: 'Hey there! Need a hand sketching your onboarding flow?',
    timestamp: '09:18',
    isAgent: true,
  ),
  _ChatMessage(
    text: 'Yes please. I want to highlight the hero CTA.',
    timestamp: '09:19',
    isAgent: false,
  ),
  _ChatMessage(
    text: 'Great—we can wrap it with SketchyAnnotate.highlight.',
    timestamp: '09:20',
    isAgent: true,
    isTyping: true,
  ),
];

const _suggestions = [
  'Share latest mockup',
  'Loop in teammate',
  'Schedule follow-up',
];
