import 'chat_models.dart';

/// Mock data for the chat example.
class MockData {
  MockData._();

  // ---- Participants ----

  /// The current logged-in user.
  static const currentUser = ChatParticipant(
    id: 'chris',
    name: 'Chris',
    type: ParticipantType.human,
    role: 'Architect',
    isOnline: true,
  );

  /// All human participants.
  static const humans = [
    ChatParticipant(
      id: 'alice',
      name: 'Alice Chen',
      type: ParticipantType.human,
      role: 'Tech Lead',
      isOnline: true,
    ),
    ChatParticipant(
      id: 'marcus',
      name: 'Marcus Webb',
      type: ParticipantType.human,
      role: 'Engineer',
      isOnline: true,
    ),
  ];

  /// All AI agent participants.
  static const agents = [
    ChatParticipant(
      id: 'kevin',
      name: 'Kevin the PM',
      type: ParticipantType.agent,
      modelString: 'anthropic:claude-sonnet-4-20250514',
      isOnline: true,
    ),
    ChatParticipant(
      id: 'sky',
      name: 'Sky the UX Designer',
      type: ParticipantType.agent,
      modelString: 'google:gemini-2.5-flash',
      isOnline: true,
    ),
    ChatParticipant(
      id: 'rudy',
      name: 'Rudy the Dev',
      type: ParticipantType.agent,
      modelString: 'anthropic:claude-sonnet-4-20250514',
      isOnline: true,
    ),
  ];

  /// All participants.
  static List<ChatParticipant> get allParticipants => [
    currentUser,
    ...humans,
    ...agents,
  ];

  /// Get a participant by ID.
  static ChatParticipant? getParticipant(String id) {
    for (final p in allParticipants) {
      if (p.id == id) return p;
    }
    return null;
  }

  // ---- Channels ----

  /// All chat channels.
  static const channels = [
    ChatChannel(
      id: 'general',
      name: 'general',
      description: 'General discussion',
      unreadCount: 0,
    ),
    ChatChannel(
      id: 'requirements',
      name: 'requirements',
      description: 'Defining the human-agent chat platform',
      unreadCount: 0,
    ),
    ChatChannel(
      id: 'design-specs',
      name: 'design-specs',
      description: 'Design specifications and mockups',
      unreadCount: 8,
    ),
    ChatChannel(
      id: 'engineering',
      name: 'engineering',
      description: 'Engineering discussions',
      unreadCount: 3,
    ),
  ];

  // ---- Messages ----

  /// Messages for the #requirements channel.
  static final requirementsMessages = [
    ChatMessage(
      id: 'm1',
      channelId: 'requirements',
      senderId: 'kevin',
      content:
          "Alright team, let's nail down the core requirements. I see three "
          'user types: humans, AI agents, and maybe a hybrid "assisted human" '
          'mode. Thoughts?',
      timestamp: DateTime(2025, 8, 14, 14, 15),
    ),
    ChatMessage(
      id: 'm2',
      channelId: 'requirements',
      senderId: 'chris',
      content:
          'I think we need to be careful about the "assisted" mode. Let\'s '
          'keep it simple for v1: humans and agents, clearly distinguished. '
          'We can layer in hybrid later.',
      timestamp: DateTime(2025, 8, 14, 14, 16),
    ),
    ChatMessage(
      id: 'm3',
      channelId: 'requirements',
      senderId: 'alice',
      content:
          'Agreed with Chris. But how do we handle visibility? Should humans '
          "always know when they're talking to an agent?",
      timestamp: DateTime(2025, 8, 14, 14, 17),
    ),
    ChatMessage(
      id: 'm4',
      channelId: 'requirements',
      senderId: 'sky',
      content:
          "Transparency is key for trust. I'm thinking: colored avatar rings, "
          'a subtle "AI" badge, and the model string visible on hover or in a '
          'details panel. Never hidden, but not screaming either.',
      timestamp: DateTime(2025, 8, 14, 14, 18),
    ),
    ChatMessage(
      id: 'm5',
      channelId: 'requirements',
      senderId: 'chris',
      content:
          'Sky, I like that. What about showing the model string inline but '
          'in a muted style? Something like "google:gemini-2.5-flash" right '
          "under the agent's name.",
      timestamp: DateTime(2025, 8, 14, 14, 19),
    ),
    ChatMessage(
      id: 'm6',
      channelId: 'requirements',
      senderId: 'marcus',
      content:
          'What about agent-to-agent conversations? Do we allow them to spin '
          'up side threads without human oversight?',
      timestamp: DateTime(2025, 8, 14, 14, 20),
    ),
    ChatMessage(
      id: 'm7',
      channelId: 'requirements',
      senderId: 'kevin',
      content:
          "Good edge case. I'd propose: agents can DM each other, but any "
          'decisions get surfaced to a human-visible channel. We need an '
          'audit trail.',
      timestamp: DateTime(2025, 8, 14, 14, 21),
    ),
    ChatMessage(
      id: 'm8',
      channelId: 'requirements',
      senderId: 'chris',
      content:
          "Kevin, yes — audit trail is non-negotiable. Let's add that to the "
          'requirements doc. Rudy, can you think through the schema '
          'implications?',
      timestamp: DateTime(2025, 8, 14, 14, 22),
    ),
    ChatMessage(
      id: 'm9',
      channelId: 'requirements',
      senderId: 'rudy',
      content:
          "On it, Chris. We'll need a message schema with sender_type, "
          "model_id, and a visibility flag for audit purposes. I'll draft "
          'the data model and share it in #engineering.',
      timestamp: DateTime(2025, 8, 14, 14, 23),
    ),
    ChatMessage(
      id: 'm10',
      channelId: 'requirements',
      senderId: 'sky',
      content:
          "Love it. I'll sketch some wireframes for the agent profile card — "
          'showing name, role, model string, and a "capabilities" summary. '
          'Back in 20 with mockups.',
      timestamp: DateTime(2025, 8, 14, 14, 25),
    ),
  ];

  /// Messages for the #general channel.
  static final generalMessages = [
    ChatMessage(
      id: 'g1',
      channelId: 'general',
      senderId: 'alice',
      content: 'Good morning everyone! Ready for another productive day?',
      timestamp: DateTime(2025, 8, 14, 9, 0),
    ),
    ChatMessage(
      id: 'g2',
      channelId: 'general',
      senderId: 'kevin',
      content:
          "Morning! I've been reviewing the overnight analytics. "
          'Engagement is up 15% this week.',
      timestamp: DateTime(2025, 8, 14, 9, 5),
    ),
    ChatMessage(
      id: 'g3',
      channelId: 'general',
      senderId: 'chris',
      content: "That's great news! Let's keep the momentum going.",
      timestamp: DateTime(2025, 8, 14, 9, 10),
    ),
  ];

  /// Messages for the #design-specs channel.
  static final designSpecsMessages = [
    ChatMessage(
      id: 'd1',
      channelId: 'design-specs',
      senderId: 'sky',
      content:
          "I've uploaded the new color palette to Figma. Check it out and "
          'let me know what you think!',
      timestamp: DateTime(2025, 8, 14, 10, 0),
    ),
    ChatMessage(
      id: 'd2',
      channelId: 'design-specs',
      senderId: 'alice',
      content:
          'Love the warm tones! Very approachable. Could we see a dark mode '
          'variant too?',
      timestamp: DateTime(2025, 8, 14, 10, 15),
    ),
    ChatMessage(
      id: 'd3',
      channelId: 'design-specs',
      senderId: 'sky',
      content: 'Already working on it! Dark mode should be ready by EOD.',
      timestamp: DateTime(2025, 8, 14, 10, 20),
    ),
  ];

  /// Messages for the #engineering channel.
  static final engineeringMessages = [
    ChatMessage(
      id: 'e1',
      channelId: 'engineering',
      senderId: 'rudy',
      content:
          'Just pushed the initial schema draft to the repo. '
          'PR is up for review.',
      timestamp: DateTime(2025, 8, 14, 15, 0),
    ),
    ChatMessage(
      id: 'e2',
      channelId: 'engineering',
      senderId: 'marcus',
      content:
          "I'll take a look. Did you include the audit trail fields "
          'we discussed?',
      timestamp: DateTime(2025, 8, 14, 15, 5),
    ),
    ChatMessage(
      id: 'e3',
      channelId: 'engineering',
      senderId: 'rudy',
      content:
          'Yes! sender_type, model_id, visibility, and a full timestamp '
          'with timezone. Also added indexes for efficient querying.',
      timestamp: DateTime(2025, 8, 14, 15, 10),
    ),
  ];

  /// Get messages for a specific channel.
  static List<ChatMessage> getMessagesForChannel(String channelId) {
    switch (channelId) {
      case 'general':
        return generalMessages;
      case 'requirements':
        return requirementsMessages;
      case 'design-specs':
        return designSpecsMessages;
      case 'engineering':
        return engineeringMessages;
      default:
        return [];
    }
  }
}
