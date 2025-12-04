// Test with full layout like ChatPage
import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import 'package:example_chat/src/models/chat_models.dart';
import 'package:example_chat/src/models/mock_data.dart';
import 'package:example_chat/src/widgets/chat_main_area.dart';
import 'package:example_chat/src/widgets/chat_sidebar.dart';
import 'package:example_chat/src/widgets/settings_drawer.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) => SketchyApp(
        title: 'Full Layout Test',
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
  ChatParticipant _currentUser = MockData.currentUser;
  final _drawerController = SketchyDrawerController();

  ChatChannel get _selectedChannel =>
      MockData.channels.firstWhere((c) => c.id == _selectedChannelId);

  void _onChannelSelected(String channelId) {
    setState(() => _selectedChannelId = channelId);
  }

  void _onSettingsPressed() {
    _drawerController.open();
  }

  void _onUserUpdated(ChatParticipant user) {
    setState(() => _currentUser = user);
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
        builder: (context, theme) => LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 768;

            Widget content;
            if (isWide) {
              content = Row(
                children: [
                  SizedBox(
                    width: 280,
                    child: ChatSidebar(
                      selectedChannelId: _selectedChannelId,
                      onChannelSelected: _onChannelSelected,
                      onSettingsPressed: _onSettingsPressed,
                    ),
                  ),
                  Container(
                    width: 1,
                    color: theme.inkColor.withValues(alpha: 0.2),
                  ),
                  Expanded(child: ChatMainArea(channel: _selectedChannel)),
                ],
              );
            } else {
              content = ChatMainArea(channel: _selectedChannel);
            }

            return SketchyDrawer(
              controller: _drawerController,
              position: SketchyDrawerPosition.end,
              drawerWidth: 320,
              drawer: SettingsDrawer(
                currentUser: _currentUser,
                onUserUpdated: _onUserUpdated,
                onClose: _drawerController.close,
              ),
              child: content,
            );
          },
        ),
      );
}
