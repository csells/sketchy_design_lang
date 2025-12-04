// Test messages list + input combined (no header)
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
        title: 'Messages + Input Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = MockData.getMessagesForChannel('requirements');

    return SketchyTheme.consumer(
      builder: (context, theme) => ColoredBox(
        color: theme.paperColor,
        child: Column(
          children: [
            // Messages list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isCurrentUser =
                      message.senderId == MockData.currentUser.id;
                  return ChatMessageWidget(
                    message: message,
                    isCurrentUser: isCurrentUser,
                  );
                },
              ),
            ),
            // Divider
            const SketchyDivider(),
            // Input
            Padding(
              padding: const EdgeInsets.all(12),
              child: SketchyChatInput(
                controller: _inputController,
                hintText: 'Type a message...',
                onSubmitted: (text) {
                  debugPrint('Submitted: $text');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
