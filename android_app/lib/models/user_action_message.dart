import 'package:android_app/models/chat_message.dart';

class UserActionMessage extends ChatMessage {
  final String affectedUser;
  final UserAction action;

  UserActionMessage(
      {required super.chatId,
      required super.user,
      required super.content,
      required super.time,
      required this.affectedUser,
      required this.action});

  factory UserActionMessage.fromJson(Map<String, dynamic> json) {
    return UserActionMessage(
      chatId: json['chatId'] as String,
      user: json['user'] as String,
      content: json['content'] as String,
      time: DateTime.parse(json['time'] as String),
      affectedUser: json['affectedUser'] as String,
      action: json['action'] == 'joined' ? UserAction.joined : UserAction.left,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()
      ..addAll({
        'affectedUser': affectedUser,
        'action': action.name,
      });
  }
}

enum UserAction {
  joined,
  left,
}
