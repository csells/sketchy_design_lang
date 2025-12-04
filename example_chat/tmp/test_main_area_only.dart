// Test ChatMainArea only
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'package:example_chat/src/models/mock_data.dart';
import 'package:example_chat/src/widgets/chat_main_area.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Main Area Test',
        theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
        home: const TestPage(),
      );
}

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = MockData.channels.first;
    return ChatMainArea(channel: channel);
  }
}
