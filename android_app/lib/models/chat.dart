import 'package:android_app/models/user_action_message.dart';

import 'chat_message.dart';

class Chat {
  final String id;
  final String name;
  final String creatorUsername;
  final List<ChatMessage> messages;
  final bool isFriendsOnly;
  int unreadMessages;

  Chat({
    required this.id,
    required this.name,
    required this.creatorUsername,
    required this.messages,
    required this.isFriendsOnly,
    this.unreadMessages = 0,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    List<ChatMessage> messages = (json['messages'] as List<dynamic>).map((msg) {
      if (msg.containsKey('affectedUser')) {
        return UserActionMessage.fromJson(msg as Map<String, dynamic>);
      } else {
        return ChatMessage.fromJson(msg as Map<String, dynamic>);
      }
    }).toList();

    return Chat(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      creatorUsername: json['creatorUsername'] as String? ?? '',
      messages: messages,
      isFriendsOnly: (json['isFriendsOnly'] as bool?) ?? false,
      unreadMessages: json['unreadMessages'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'creatorUsername': creatorUsername,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'isFriendsOnly': isFriendsOnly,
      'unreadMessages': unreadMessages,
    };
  }

  Chat copyWith({
    String? id,
    String? name,
    String? creatorUsername,
    List<ChatMessage>? messages,
    bool? isFriendsOnly,
    int? unreadMessages,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorUsername: creatorUsername ?? this.creatorUsername,
      messages: messages ?? this.messages,
      isFriendsOnly: isFriendsOnly ?? this.isFriendsOnly,
      unreadMessages: unreadMessages ?? this.unreadMessages,
    );
  }
}
