import 'dart:async';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/models/chat_message.dart';
import 'package:android_app/models/user_action_message.dart';
import 'package:android_app/states/chats_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatsState>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<ChatsState> {
  final _messageAddedStreamController = StreamController<void>.broadcast();
  final AudioPlayer _audioPlayer = AudioPlayer();

  ChatNotifier()
      : super(ChatsState(
            userChats: [], nonUserChats: [], selectedChat: '', username: ''));

  Stream<void> get messageAddedStream => _messageAddedStreamController.stream;
  String get username => state.username;
  List<Chat> get userChats => state.userChats;
  List<Chat> get nonUserChats => state.nonUserChats;
  String get selectedChat => state.selectedChat;
  bool get isChatBanned => state.isChatBanned;
  bool get isChatOpen => state.isChatOpen;

  @override
  void dispose() {
    _messageAddedStreamController.close();
    super.dispose();
  }

  void setUsername(String username) {
    state = state.copyWith(username: username);
  }

  void setChats(List<dynamic> data) {
    final chats = _sortChats(data
        .map((chatJson) => Chat.fromJson(chatJson as Map<String, dynamic>))
        .toList());

    state = state.copyWith(userChats: chats);
  }

  bool selectChat(String chatId) {
    final chatIndex = state.userChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final chat = state.userChats[chatIndex];
      chat.unreadMessages = 0;
      state = state.copyWith(
        userChats: [...state.userChats],
        selectedChat: chatId,
      );
    } else {
      state = state.copyWith(selectedChat: chatId);
    }
    return chatIndex != -1;
  }

  Chat addChat(dynamic chatData) {
    Chat newChat = Chat.fromJson(chatData as Map<String, dynamic>);

    final updatedChats = _sortChats([...state.userChats, newChat]);
    state = state.copyWith(userChats: updatedChats, selectedChat: newChat.id);
    return newChat;
  }

  void removeChat(String chatId) {
    final updatedChats =
        state.userChats.where((chat) => chat.id != chatId).toList();
    state = state.copyWith(userChats: updatedChats);

    if (state.selectedChat == chatId) {
      state = state.copyWith(selectedChat: '');
    }
  }

  void onChatCreated(dynamic chatData) {
    Chat chat = Chat.fromJson(chatData as Map<String, dynamic>);
    if (chat.creatorUsername != state.username) {
      addNonUserChat(chat);
    }
  }

  void addNonUserChat(Chat chat) {
    final updatedNonUserChats = [...state.nonUserChats, chat];
    state = state.copyWith(nonUserChats: updatedNonUserChats);
  }

  void getNonUserChats(dynamic chatData) {
    final nonUserChats = (chatData as List)
        .map((chatJson) => Chat.fromJson(chatJson as Map<String, dynamic>))
        .toList();
    state = state.copyWith(nonUserChats: nonUserChats);
  }

  void onChatDeleted(String chatId) {
    if (state.userChats.any((chat) => chat.id == chatId)) {
      removeChat(chatId);
    } else {
      removeFromNonUserChats(chatId);
    }
  }

  void removeFromNonUserChats(String chatId) {
    final updatedNonUserChats =
        state.nonUserChats.where((chat) => chat.id != chatId).toList();
    state = state.copyWith(nonUserChats: updatedNonUserChats);
  }

  void addMessageFromServer(Map<String, dynamic> messageData, [Function? ack]) {
    ChatMessage newMessage;

    if (messageData.containsKey('affectedUser')) {
      newMessage = UserActionMessage.fromJson(messageData);
    } else {
      newMessage = ChatMessage.fromJson(messageData);
    }

    addMessage(newMessage, ack);
  }

  String getMessageContent(UserActionMessage message) {
    return '${message.action == UserAction.left ? S.current.user_left(message.affectedUser) : S.current.user_joined(message.affectedUser)} ${message.chatId.length == 4 ? S.current.the_game : S.current.the_chatroom}';
  }

  void addMessage(ChatMessage newMessage, [Function? ack]) {
    final chatIndex =
        state.userChats.indexWhere((chat) => chat.id == newMessage.chatId);
    if (chatIndex != -1) {
      final chat = state.userChats[chatIndex];
      chat.messages.add(newMessage);

      if (!state.isChatOpen || state.selectedChat != chat.id) {
        chat.unreadMessages++;
      }

      state = state.copyWith(userChats: [...state.userChats]);

      _handleNotifications(newMessage.chatId, ack);
    }
  }

  void _handleNotifications(String newMessageId, [Function? ack]) {
    bool isInCurrentChat =
        state.isChatOpen && newMessageId == state.selectedChat;

    if (!isInCurrentChat) {
      _audioPlayer.play(AssetSource('sounds/message1.mp3'));
    }
    _messageAddedStreamController.add(null);

    if (ack != null) {
      ack({
        'username': username,
        'chatSelected': isInCurrentChat,
      });
    }
  }

  void onUserLeft(Map<String, dynamic> data, [Function? ack]) {
    final userActionMessage = UserActionMessage.fromJson(data);
    if (userActionMessage.affectedUser == state.username) return;
    addMessage(userActionMessage, ack);
  }

  void setChatBanState(bool data) {
    state = state.copyWith(isChatBanned: data);
  }

  void resetAllUnread() {
    final updatedChats = state.userChats.map((chat) {
      chat.unreadMessages = 0;
      return chat;
    }).toList();

    state = state.copyWith(userChats: updatedChats);
  }

  void toggleChatOpen() {
    state = state.copyWith(isChatOpen: !isChatOpen);
  }

  void setChatOpen(bool isOpen) {
    state = state.copyWith(isChatOpen: isOpen);
  }

  bool clearUnreadForChat(String chatId) {
    final chatIndex = state.userChats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final chat = state.userChats[chatIndex];
      if (chat.unreadMessages > 0) {
        chat.unreadMessages = 0;
        state = state.copyWith(userChats: [...state.userChats]);
        return true;
      }
    }
    return false;
  }

  void setChatsNotifications(List<dynamic> data) {
    final updatedChats = state.userChats.map((chat) {
      final matchingNotification = data.firstWhere(
        (item) => item['id'] == chat.id,
        orElse: () => null,
      );
      if (matchingNotification != null) {
        chat.unreadMessages = matchingNotification['nUnreadMessages'] ?? 0;
      }

      return chat;
    }).toList();

    state = state.copyWith(userChats: updatedChats);
  }

  String? findGameChatId() {
    return state.userChats
        .firstWhere((chat) => chat.name == 'Partie' || chat.name == 'Game',
            orElse: () => Chat(
                id: '',
                name: '',
                messages: [],
                creatorUsername: '',
                isFriendsOnly: false))
        .id;
  }

  List<Chat> _sortChats(List<Chat> chats) {
    chats.sort((a, b) {
      if (a.name == 'Global') return -1;
      if (b.name == 'Global') return 1;
      if (a.name == 'Partie') return -1;
      if (b.name == 'Partie') return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return chats;
  }
}
