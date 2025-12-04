import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'src/pages/chat_page.dart';

void main() {
  runApp(const SketchChatApp());
}

/// The Sketch Chat example application.
class SketchChatApp extends StatelessWidget {
  /// Creates the Sketch Chat app.
  const SketchChatApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
    title: 'Sketch Chat',
    theme: SketchyThemeData.fromTheme(SketchyThemes.chat, roughness: 0.3),
    home: const ChatPage(),
  );
}
