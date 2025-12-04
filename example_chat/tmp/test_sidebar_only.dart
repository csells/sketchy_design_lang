// Test ChatSidebar only
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'package:example_chat/src/widgets/chat_sidebar.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Sidebar Test',
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
  String _selectedChannelId = 'requirements';

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => SizedBox(
          width: 280,
          child: ChatSidebar(
            selectedChannelId: _selectedChannelId,
            onChannelSelected: (id) => setState(() => _selectedChannelId = id),
            onSettingsPressed: () {},
          ),
        ),
      );
}
