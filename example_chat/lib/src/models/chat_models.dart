/// The type of chat participant.
enum ParticipantType {
  /// A human user.
  human,

  /// An AI agent.
  agent,
}

/// Represents a participant in the chat (human or AI agent).
class ChatParticipant {
  /// Creates a chat participant.
  const ChatParticipant({
    required this.id,
    required this.name,
    required this.type,
    this.role,
    this.modelString,
    this.imageUrl,
    this.isOnline = false,
  });

  /// Unique identifier.
  final String id;

  /// Display name.
  final String name;

  /// Whether this is a human or AI agent.
  final ParticipantType type;

  /// Role/title (e.g., "Tech Lead", "Engineer").
  final String? role;

  /// For AI agents, the model identifier (e.g., "anthropic:claude-sonnet-4").
  final String? modelString;

  /// Optional avatar image URL.
  final String? imageUrl;

  /// Whether the participant is currently online.
  final bool isOnline;

  /// Returns the initials for the avatar fallback.
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  /// Whether this is an AI agent.
  bool get isAgent => type == ParticipantType.agent;

  /// Creates a copy with modified properties.
  ChatParticipant copyWith({
    String? id,
    String? name,
    ParticipantType? type,
    String? role,
    String? modelString,
    String? imageUrl,
    bool? isOnline,
  }) => ChatParticipant(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    role: role ?? this.role,
    modelString: modelString ?? this.modelString,
    imageUrl: imageUrl ?? this.imageUrl,
    isOnline: isOnline ?? this.isOnline,
  );
}

/// Represents a chat channel.
class ChatChannel {
  /// Creates a chat channel.
  const ChatChannel({
    required this.id,
    required this.name,
    this.description,
    this.unreadCount = 0,
  });

  /// Unique identifier.
  final String id;

  /// Channel name (without the # prefix).
  final String name;

  /// Optional channel description.
  final String? description;

  /// Number of unread messages.
  final int unreadCount;

  /// Creates a copy with modified properties.
  ChatChannel copyWith({
    String? id,
    String? name,
    String? description,
    int? unreadCount,
  }) => ChatChannel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}

/// Represents a chat message.
class ChatMessage {
  /// Creates a chat message.
  const ChatMessage({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  /// Unique identifier.
  final String id;

  /// The channel this message belongs to.
  final String channelId;

  /// The sender's ID.
  final String senderId;

  /// Message content.
  final String content;

  /// When the message was sent.
  final DateTime timestamp;

  /// Formats the timestamp for display.
  String get formattedTime {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
