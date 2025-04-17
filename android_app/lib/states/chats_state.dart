import 'package:android_app/models/chat.dart';

class ChatsState {
  final List<Chat> userChats;
  final List<Chat> nonUserChats;
  final String selectedChat;
  final String username;
  final bool isChatBanned;
  final bool isChatOpen;

  ChatsState({
    required this.userChats,
    required this.nonUserChats,
    required this.selectedChat,
    required this.username,
    this.isChatBanned = false,
    this.isChatOpen = false,
  });

  ChatsState copyWith({
    List<Chat>? userChats,
    List<Chat>? nonUserChats,
    String? selectedChat,
    String? username,
    bool? isChatBanned,
    bool? isChatOpen,
  }) {
    return ChatsState(
      userChats: userChats ?? this.userChats,
      nonUserChats: nonUserChats ?? this.nonUserChats,
      selectedChat: selectedChat ?? this.selectedChat,
      username: username ?? this.username,
      isChatBanned: isChatBanned ?? this.isChatBanned,
      isChatOpen: isChatOpen ?? this.isChatOpen,
    );
  }
}
