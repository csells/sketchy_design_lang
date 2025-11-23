import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../theme/text_styles.dart';
import '../widgets/section_card.dart';

class ConversationSection extends StatefulWidget {
  const ConversationSection({super.key});

  @override
  State<ConversationSection> createState() => _ConversationSectionState();
}

class _ConversationSectionState extends State<ConversationSection>
    with TickerProviderStateMixin {
  int _selectedConversationTab = 0;
  late final TabController _conversationTabController;

  static const List<String> _conversationTabs = ['Inbox', 'Updates', 'Archive'];
  static const List<String> _conversationSenders = [
    'Archie',
    'Product Ops',
    'System Bot',
  ];
  static const List<String> _conversationMessages = [
    'Inbox is stacked, so I drafted two quick replies for you.',
    'Palette tweaks landed in QA. Want me to grab reactions later?',
    'Archive is empty—want me to auto-file anything over a week old?',
  ];

  @override
  void initState() {
    super.initState();
    _conversationTabController = TabController(
      length: _conversationTabs.length,
      initialIndex: _selectedConversationTab,
      vsync: this,
      animationDuration: Duration.zero,
    );
    _conversationTabController.addListener(() {
      if (_conversationTabController.indexIsChanging) return;
      setState(
        () => _selectedConversationTab = _conversationTabController.index,
      );
    });
  }

  @override
  void dispose() {
    _conversationTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) {
      final tabIndex = _selectedConversationTab;
      final sender = _conversationSenders[tabIndex];
      final message = _conversationMessages[tabIndex];
      return SectionCard(
        title: 'Conversation cues',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _conversationTabController,
              tabs: _conversationTabs.map(Text.new).toList(),
              detachSelected: true,
              detachGap: theme.strokeWidth,
              backgroundColor: theme.paperColor,
              eraseSelectedBorder: true,
              onTap: (index) {
                // The controller listener handles the state update
              },
            ),
            Transform.translate(
              offset: Offset(0, -theme.strokeWidth),
              child: SketchySurface(
                padding: const EdgeInsets.all(16),
                strokeColor: theme.inkColor,
                fillColor: theme.paperColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sender,
                      style: theme.typography.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(message, style: bodyStyle(theme)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12 - theme.strokeWidth),
            Row(
              children: [
                const SketchyTypingIndicator(),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Archie is drafting a reply…',
                    style: mutedStyle(theme),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    SnackBar.show(
                      context,
                      message: 'Saved ${_conversationTabs[tabIndex]} note',
                    );
                  },
                  child: Text('Show toast', style: buttonLabelStyle(theme)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
