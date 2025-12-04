// Minimal test to isolate crash cause
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Crash Test',
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Test 1: Simple avatar
                const SketchyText('Testing SketchyAvatar:'),
                const SizedBox(height: 8),
                const SketchyAvatar(
                  initials: 'T1',
                  radius: 20,
                ),
                const SizedBox(height: 16),

                // Test 2: Chat bubble (has IntrinsicWidth/IntrinsicHeight)
                const SketchyText('Testing SketchyChatBubble:'),
                const SizedBox(height: 8),
                SketchyChatBubble(
                  content: SketchyText(
                    'Hello, this is a test message!',
                    style: theme.typography.body,
                  ),
                ),
                const SizedBox(height: 16),

                // Test 3: Multiple bubbles (like in a list)
                const SketchyText('Testing multiple bubbles:'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  width: 400,
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: SketchyChatBubble(
                        content: SketchyText(
                          'Message $index',
                          style: theme.typography.body,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
