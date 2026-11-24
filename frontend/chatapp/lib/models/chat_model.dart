class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({required this.text, required this.isUser, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['content']?.toString() ?? '',
      isUser: json['role'] == 'user',
      timestamp: DateTime.parse(json['created_at']),
    );
  }
}

class ChatSession {
  final String id;
  String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  DateTime lastMessageAt;

  ChatSession({
    required this.id,
    required this.title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) : messages = messages ?? [],
       createdAt = createdAt ?? DateTime.now(),
       lastMessageAt = lastMessageAt ?? DateTime.now();

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    final createdAt = DateTime.parse(json['created_at']);

    return ChatSession(
      id: json['id'].toString(),
      title: json['title']?.toString() ?? 'New Chat',
      createdAt: createdAt,
      lastMessageAt: createdAt,
    );
  }
}
