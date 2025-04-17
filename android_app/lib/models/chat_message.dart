class ChatMessage {
  final String chatId;
  final String user;
  final String content;
  final DateTime time;

  ChatMessage({
    required this.chatId,
    required this.user,
    required this.content,
    required this.time,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      chatId: json['chatId'] as String,
      user: json['user'] as String,
      content: json['content'] as String,
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'user': user,
      'content': content,
      'time': time.toIso8601String(),
    };
  }
}
