import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:sketchy_design_lang/sketchy_design_lang.dart';

import '../models/chat_models.dart';
import '../models/mock_data.dart';
import 'chat_message_widget.dart';

/// The main chat area showing messages and input.
class ChatMainArea extends StatefulWidget {
  /// Creates a chat main area.
  const ChatMainArea({required this.channel, super.key, this.onMenuPressed});

  /// The current channel.
  final ChatChannel channel;

  /// Callback when the menu button is pressed (for mobile).
  final VoidCallback? onMenuPressed;

  @override
  State<ChatMainArea> createState() => _ChatMainAreaState();
}

class _ChatMainAreaState extends State<ChatMainArea> {
  final _scrollController = ScrollController();
  final _inputController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void didUpdateWidget(covariant ChatMainArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.channel.id != widget.channel.id) {
      _loadMessages();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _loadMessages() {
    _messages = MockData.getMessagesForChannel(widget.channel.id);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      unawaited(
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        ),
      );
    }
  }

  void _onSendMessage(String text) {
    final newMessage = ChatMessage(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      channelId: widget.channel.id,
      senderId: MockData.currentUser.id,
      content: text,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages = [..._messages, newMessage];
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SketchyTheme.consumer(
    builder: (context, theme) => ColoredBox(
      color: theme.paperColor,
      child: Column(
        children: [
          // Header
          _buildHeader(theme),
          const SketchyDivider(),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isCurrentUser =
                    message.senderId == MockData.currentUser.id;
                return ChatMessageWidget(
                  message: message,
                  isCurrentUser: isCurrentUser,
                );
              },
            ),
          ),

          // Input
          const SketchyDivider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: SketchyChatInput(
              controller: _inputController,
              hintText: 'Message #${widget.channel.name}',
              onSubmitted: _onSendMessage,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildHeader(SketchyThemeData theme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        if (widget.onMenuPressed != null) ...[
          SketchyIconButton(
            icon: SketchySymbol(
              symbol: SketchySymbols.menu,
              size: 20,
              color: theme.inkColor,
            ),
            onPressed: widget.onMenuPressed,
            iconSize: 32,
          ),
          const SizedBox(width: 8),
        ],
        SketchySymbol(
          symbol: SketchySymbols.hash,
          size: 20,
          color: theme.inkColor,
        ),
        const SizedBox(width: 4),
        SketchyText(
          widget.channel.name,
          style: theme.typography.title.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.inkColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SketchyText(
            widget.channel.description ?? '',
            style: theme.typography.body.copyWith(
              color: theme.inkColor.withValues(alpha: 0.6),
            ),
          ),
        ),
        SketchySymbol(
          symbol: SketchySymbols.people,
          size: 18,
          color: theme.inkColor.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 4),
        SketchyText(
          '${_getMemberCount()}',
          style: theme.typography.body.copyWith(
            color: theme.inkColor.withValues(alpha: 0.6),
          ),
        ),
      ],
    ),
  );

  int _getMemberCount() {
    // Count unique participants in this channel's messages
    final senderIds = _messages.map((m) => m.senderId).toSet();
    return senderIds.length.clamp(1, MockData.allParticipants.length);
  }
}
