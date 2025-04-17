import 'dart:async';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/models/user.dart';
import 'package:android_app/models/user_action_message.dart';
import 'package:android_app/providers/chat_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/widgets.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ChatSocketEvent {
  static const String joinChat = 'joinChat';
  static const String joinGameChat = 'joinGameChat';
  static const String postMessage = 'postChatMessage';
  static const String getMessage = 'getChatMessage';
  static const String userLeft = 'userLeftChat';
  static const String leaveChat = 'leaveChat';
  static const String banUser = 'banChatUser';
  static const String onUserBanned = 'onChatUserBanned';
  static const String updateUsername = 'updateChatUsername';
  static const String joinChats = 'joinChats';
  static const String createChat = 'createChat';
  static const String onChatJoined = 'onChatJoined';
  static const String initializeChats = 'initializeChats';
  static const String getNonUserChats = 'getNonUserChats';
  static const String onNonUserChats = 'onNonUserChats';
  static const String removeChat = 'removeChat';
  static const String deleteChat = 'deleteChat';
  static const String onChatCreated = 'onChatCreated';
  static const String onChatDeleted = 'onChatDeleted';
  static const String chatExists = 'chatExists';
  static const String notFriendError = 'notFriendError';
  static const String getUserNotifications = 'getUserNotifications';
  static const String resetUserNotifications = 'resetUserNotifications';
}

final chatServiceProvider = Provider<ChatService>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final chatNotifier = ref.read(chatNotifierProvider.notifier);
  final authService = ref.read(authServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  final chatService = ChatService(
      socketService, chatNotifier, authService, notificationService);

  ref.listen<User>(
    userInfoServiceProvider,
    (previous, next) {
      if (previous?.username != next.username) {
        chatService.onUsernameUpdate(next.username);
      }
    },
  );

  return chatService;
});

class ChatService {
  final SocketConnectionService _socketService;
  final ChatNotifier chatNotifier;
  final NotificationService notificationService;

  AppLifecycleState _appState = AppLifecycleState.resumed;

  List<Chat> chats = [];
  late String username = '';

  final List<String> _listeners = [];

  ChatService(this._socketService, this.chatNotifier, AuthService authService,
      this.notificationService) {
    authService.onConnectionSubject.subscribe((username) {
      setupEventListeners();
      fetchUserChats(username);
    });

    authService.onDisconnectionSubject.subscribe((username) {
      for (var listener in _listeners) {
        _socketService.off(listener);
      }
    });
  }

  void updateAppState(AppLifecycleState state) {
    _appState = state;
  }

  void addSocketListener(String listener, void Function(dynamic) callback) {
    _listeners.add(listener);
    _socketService.on(listener, (data) {
      Future.microtask(() => callback(data));
    });
  }

  void setupEventListeners() {
    addSocketListener(ChatSocketEvent.onChatJoined, (dynamic data) {
      Chat chat = chatNotifier.addChat(data);
      final chatMessage = {
        'chatId': chat.id,
        'user': '',
        'content': '',
        'time': DateTime.now().toString(),
        'affectedUser': username,
        'action': UserAction.joined.name,
      };
      _socketService.emit(ChatSocketEvent.postMessage, chatMessage);
    });

    addSocketListener(ChatSocketEvent.initializeChats, (dynamic data) {
      chatNotifier.setChatOpen(false);
      chatNotifier.setChats(data);
      chatNotifier.selectChat('');
      _socketService.emitWithAck(
        ChatSocketEvent.getUserNotifications,
        (dynamic response) {
          if (response is List) {
            chatNotifier.setChatsNotifications(response);
          }
        },
        {
          'username': username,
        },
      );
    });

    addSocketListener(ChatSocketEvent.removeChat, (dynamic data) {
      chatNotifier.removeChat(data);
    });

    addSocketListener(ChatSocketEvent.onChatCreated, (dynamic data) {
      chatNotifier.onChatCreated(data);
    });

    addSocketListener(ChatSocketEvent.onNonUserChats, (dynamic data) {
      chatNotifier.getNonUserChats(data);
    });

    addSocketListener(ChatSocketEvent.onChatDeleted, (dynamic data) {
      chatNotifier.onChatDeleted(data);
    });

    addSocketListener(ChatSocketEvent.getMessage, (dynamic data,
        [Function? ack]) {
      handleMessageWithAck(data, chatNotifier.addMessageFromServer);
    });

    addSocketListener(ChatSocketEvent.userLeft, (dynamic data) {
      handleMessageWithAck(data, chatNotifier.onUserLeft);
    });

    addSocketListener(ChatSocketEvent.onUserBanned, (dynamic data) {
      chatNotifier.setChatBanState(data);
      notificationService
          .showBottomLeftNotification(getUserChatBannedString(data));
    });

    addSocketListener(ChatSocketEvent.notFriendError, (dynamic data) {
      notificationService.showBottomLeftNotification(
          S.current.chat_friend_only_response(data));
    });

    addSocketListener('chatUsernameChangedNotification', (dynamic _) {
      updateUserChats();
    });
  }

  void handleMessageWithAck(
    dynamic data,
    void Function(Map<String, dynamic> message, Function? ack) handler,
  ) {
    if (data is List && data.isNotEmpty) {
      final messageData = data[0];
      final Function? ack =
          data.length > 1 && data[1] is Function ? data[1] : null;

      handler(messageData, ack);

      if (_appState == AppLifecycleState.paused ||
          _appState == AppLifecycleState.inactive) {
        _showLocalNotification(
          messageData['user'] ?? 'Someone',
          messageData['content'] ?? '',
        );
      }
    }
  }

  void selectChat(String chatId) {
    if (chatNotifier.selectChat(chatId)) {
      _socketService.emit(ChatSocketEvent.resetUserNotifications, {
        'chatId': chatId,
        'username': chatNotifier.username,
      });
    }
  }

  void clearUnreadForChat(String chatId) {
    if (chatNotifier.clearUnreadForChat(chatId)) {
      _socketService.emit(ChatSocketEvent.resetUserNotifications, {
        'chatId': chatId,
        'username': chatNotifier.username,
      });
    }
  }

  void onUsernameUpdate(String newUsername) {
    username = newUsername;
    chatNotifier.setUsername(newUsername);
  }

  void updateUserChats() {
    final gameId = chatNotifier.findGameChatId();

    _socketService.emitWithAck(
      'updateUserChats',
      (dynamic response) {
        if (response is List) {
          chatNotifier.setChats(response);
        }
      },
      {
        'username': username,
        'gameId': gameId,
      },
    );
  }

  void fetchNonUserChats(String username) {
    _socketService.emit(ChatSocketEvent.getNonUserChats, username);
  }

  void joinChat(String chatId) {
    _socketService.emit(
        ChatSocketEvent.joinChat, {'chatId': chatId, 'username': username});
  }

  void joinGameChat(String gameId) {
    _socketService.emit(
        ChatSocketEvent.joinGameChat, {'chatId': gameId, 'username': username});
  }

  void createChat(String chatName, bool isFriendsOnly) {
    _socketService.emit(ChatSocketEvent.createChat, {
      'chatName': chatName,
      'isFriendsOnly': isFriendsOnly,
      'username': username
    });
  }

  void deleteChat(String chatId) {
    _socketService.emit(
        ChatSocketEvent.deleteChat, {'chatId': chatId, 'username': username});
  }

  void leaveChat(String chatId) {
    _socketService.emit(
        ChatSocketEvent.leaveChat, {'chatId': chatId, 'username': username});
  }

  void leaveGameChat() {
    final gameId = chatNotifier.findGameChatId();
    if (gameId == '') return;
    _socketService.emit(
        ChatSocketEvent.leaveChat, {'chatId': gameId, 'username': username});
  }

  void sendMessage(String chatId, String message, String username) {
    final chatMessage = {
      'chatId': chatId,
      'user': username,
      'content': message,
      'time': DateTime.now().toString(),
    };
    _socketService.emit(ChatSocketEvent.postMessage, chatMessage);
  }

  void fetchUserChats(String username) {
    this.username = username;
    chatNotifier.setUsername(username);
    chatNotifier.setChats([]);
    _socketService.emit(ChatSocketEvent.joinChats, username);
  }

  void banUser(String chatId, String username) {
    _socketService.emit(
        ChatSocketEvent.banUser, {'chatId': chatId, 'username': username});
  }

  Future<bool> checkChatNameExists(String chatName) async {
    try {
      final Completer<bool> completer = Completer<bool>();

      _socketService.emitWithAck(ChatSocketEvent.chatExists, (response) {
        completer.complete(response);
      }, {'chatName': chatName});

      return await completer.future;
    } catch (e) {
      return false;
    }
  }

  Future<void> _showLocalNotification(String sender, String content) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      S.current.new_message,
      content,
      notificationDetails,
    );
  }

  String getUserChatBannedString(bool data) {
    String organizer = S.current.chat_banned_service_organizer;
    String action = data
        ? S.current.chat_banned_service_removed
        : S.current.chat_banned_service_added;
    String chatRight = S.current.chat_banned_service_chat_right;

    return "$organizer $action $chatRight";
  }
}
