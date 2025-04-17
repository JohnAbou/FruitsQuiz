import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/providers/chat_provider.dart';
import 'package:android_app/services/chat_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/states/chats_state.dart';
import 'package:android_app/widgets/chat_widgets/chat_notification_badge.dart';
import 'package:android_app/widgets/chat_widgets/chat_selection.dart';
import 'package:android_app/widgets/chat_widgets/create_chat.dart';
import 'package:android_app/widgets/chat_widgets/join_chat.dart';
import 'package:android_app/widgets/chat_widgets/selected_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:android_app/theme/custom_colors.dart';

class ChatWidget extends ConsumerStatefulWidget {
  const ChatWidget({super.key});

  @override
  ConsumerState<ChatWidget> createState() => _ChatWidgetState();
}

enum ChatInterfaceState { selectingChat, creatingChat, joiningChat }

class _ChatWidgetState extends ConsumerState<ChatWidget> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _chatScrollController = ScrollController();
  ChatInterfaceState chatInterfaceState = ChatInterfaceState.selectingChat;

  UserInfoService get userService => ref.read(userInfoServiceProvider.notifier);
  ChatNotifier get chatNotifier => ref.watch(chatNotifierProvider.notifier);
  ChatsState get chatState => ref.watch(chatNotifierProvider);
  ChatService get chatService => ref.watch(chatServiceProvider);

  @override
  void initState() {
    super.initState();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleChat() {
    if (mounted) {
      chatNotifier.toggleChatOpen();

      if (chatNotifier.isChatOpen && chatState.selectedChat.isNotEmpty) {
        chatService.clearUnreadForChat(chatState.selectedChat);
      }
    }
  }

  void onChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _sendMessage() {
    var message = _messageController.text.trim();
    message = message.replaceAll(RegExp(r'\s+'), ' ');
    if (message.isNotEmpty) {
      chatService.sendMessage(
          chatState.selectedChat, message, userService.getUsername());
      _messageController.clear();
      _messageFocusNode.requestFocus();
      _scrollToBottom();
    }
  }

  void changeState(ChatInterfaceState state) {
    if (mounted) {
      if (state == ChatInterfaceState.joiningChat) {
        chatService.fetchNonUserChats(userService.getUsername());
      }
      setState(() {
        chatInterfaceState = state;
      });
    }
  }

  void onCreate(TextEditingController chatNameController, bool friendsOnly) {
    final chatName = chatNameController.text.trim();
    chatService.createChat(chatName, friendsOnly);
    chatInterfaceState = ChatInterfaceState.selectingChat;
  }

  void onJoin(String chatId) {
    chatService.joinChat(chatId);
    chatInterfaceState = ChatInterfaceState.selectingChat;
  }

  void openDeleteChatDialog(String chatId, String chatName) {
    ref.read(notificationServiceProvider).showConfirmationCardPopup(
        message: S.of(context).confirm_delete_chat(chatName),
        onConfirm: () {
          chatService.deleteChat(chatId);
        },
        onCancel: () {});
  }

  void openLeaveChatDialog(String chatId, String chatName) {
    ref.read(notificationServiceProvider).showConfirmationCardPopup(
        message: S.of(context).confirm_leave_chat(chatName),
        onConfirm: () {
          chatService.leaveChat(chatId);
        },
        onCancel: () {});
  }

  Future<bool> checkChatNameExists(String chatName) async {
    return await chatService.checkChatNameExists(chatName);
  }

  Widget _buildChatContent(ChatInterfaceState chatInterfaceState,
      List<Chat> userChats, List<Chat> nonUserChats, Chat? chat) {
    switch (chatInterfaceState) {
      case ChatInterfaceState.selectingChat:
        return ChatSelection(
          userChats: userChats,
          username: userService.getUsername(),
          onClose: toggleChat,
          changeState: changeState,
          selectChat: chatService.selectChat,
          deleteChat: openDeleteChatDialog,
          leaveChat: openLeaveChatDialog,
        );
      case ChatInterfaceState.creatingChat:
        return CreateChatWidget(
            onClose: toggleChat,
            onBack: changeState,
            onCreate: onCreate,
            checkChatNameExists: checkChatNameExists);
      case ChatInterfaceState.joiningChat:
        return JoinChatWidget(
            onClose: toggleChat,
            onBack: changeState,
            onJoin: onJoin,
            nonUserChats: nonUserChats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedChatId = chatState.selectedChat;
    final customColors = Theme.of(context).extension<CustomColors>()!;
    bool wasKeyboardVisible = false;

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (isKeyboardVisible && !wasKeyboardVisible) {
          _scrollToBottom();
        }
        wasKeyboardVisible = isKeyboardVisible;
        if (chatState.userChats.isEmpty) {
          return Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: chatNotifier.isChatOpen ? 400 : 60,
              height: chatNotifier.isChatOpen
                  ? isKeyboardVisible
                      ? MediaQuery.of(context).size.height * 0.4
                      : 600
                  : 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(chatNotifier.isChatOpen ? 20 : 30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        }

        Chat? chat = chatState.userChats.cast<Chat?>().firstWhere(
              (chat) => chat!.id == selectedChatId,
              orElse: () => null,
            );

        return Positioned(
          bottom: 20,
          right: 20,
          child: Container(
            width: chatNotifier.isChatOpen ? 400 : 60,
            height: chatNotifier.isChatOpen
                ? isKeyboardVisible
                    ? MediaQuery.of(context).size.height * 0.4
                    : 600
                : 60,
            decoration: BoxDecoration(
              color: chatNotifier.isChatOpen
                  ? customColors.boxColor
                  : customColors.accentColor,
              borderRadius:
                  BorderRadius.circular(chatNotifier.isChatOpen ? 20 : 30),
              border: Border.all(
                color: customColors.accentColor,
                width: 1,
              ),
            ),
            child: chatNotifier.isChatOpen
                ? chat != null
                    ? SelectedChatWidget(
                        chat: chat,
                        isChatBanned: chatState.isChatBanned,
                        onClose: toggleChat,
                        onChanged: onChanged,
                        onBack: () => chatService.selectChat(''),
                        messageController: _messageController,
                        chatScrollController: _chatScrollController,
                        messageFocusNode: _messageFocusNode,
                        onSendMessage: _sendMessage,
                        username: userService.getUsername(),
                      )
                    : _buildChatContent(chatInterfaceState, chatState.userChats,
                        chatState.nonUserChats, chat)
                : Center(
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            toggleChat();
                          },
                        ),
                        if (chatState.userChats.fold(0,
                                    (sum, chat) => sum + chat.unreadMessages) >
                                0 &&
                            !chatNotifier.isChatOpen)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: ChatNotificationBadge(
                              count: chatState.userChats.fold(
                                  0, (sum, chat) => sum + chat.unreadMessages),
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
