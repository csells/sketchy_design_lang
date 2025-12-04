// Test just the message list from ChatMainArea
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'package:example_chat/src/models/mock_data.dart';
import 'package:example_chat/src/widgets/chat_message_widget.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Messages Only Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the requirements channel (has 10 messages)
    final messages = MockData.getMessagesForChannel('requirements');

    return SketchyTheme.consumer(
      builder: (context, theme) => ColoredBox(
        color: theme.paperColor,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            final isCurrentUser = message.senderId == MockData.currentUser.id;
            return ChatMessageWidget(
              message: message,
              isCurrentUser: isCurrentUser,
            );
          },
        ),
      ),
    );
  }
}
