import 'dart:async';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/models/chat_message.dart';
import 'package:android_app/models/user_action_message.dart';
import 'package:android_app/providers/chat_provider.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/widgets/chat_widgets/chat_notification_badge.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedChatWidget extends ConsumerStatefulWidget {
  final Chat chat;
  final bool isChatBanned;
  final VoidCallback onClose;
  final VoidCallback onChanged;
  final VoidCallback onBack;
  final TextEditingController messageController;
  final ScrollController chatScrollController;
  final FocusNode messageFocusNode;
  final VoidCallback onSendMessage;
  final String username;

  const SelectedChatWidget({
    super.key,
    required this.chat,
    required this.isChatBanned,
    required this.onClose,
    required this.onChanged,
    required this.onBack,
    required this.messageController,
    required this.chatScrollController,
    required this.messageFocusNode,
    required this.onSendMessage,
    required this.username,
  });

  @override
  _SelectedChatWidgetState createState() => _SelectedChatWidgetState();
}

class _SelectedChatWidgetState extends ConsumerState<SelectedChatWidget> {
  late StreamSubscription _messageAddedSubscription;

  @override
  void initState() {
    super.initState();
    _messageAddedSubscription =
        ref.read(chatNotifierProvider.notifier).messageAddedStream.listen((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageAddedSubscription.cancel();
    super.dispose();
  }

  String formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp).toLocal();
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final bool isCurrentUser = message.user == widget.username;
    final bool isSystem = message.user == 'System' || message.user == 'Système';
    final bool userLeft =
        message is UserActionMessage && message.action == UserAction.left;

    Color backgroundColor;
    CrossAxisAlignment alignment;
    Alignment bubbleAlignment;

    if (isCurrentUser) {
      backgroundColor = Color(0xB6FF8DEE);
      alignment = CrossAxisAlignment.end;
      bubbleAlignment = Alignment.centerRight;
    } else if (isSystem) {
      alignment = CrossAxisAlignment.center;
      bubbleAlignment = Alignment.center;
      if (userLeft) {
        backgroundColor = Color(0xFFFF8989);
      } else {
        backgroundColor = Color(0xFF75D475);
      }
    } else {
      backgroundColor = Color(0xB6FDFFA4);
      alignment = CrossAxisAlignment.start;
      bubbleAlignment = Alignment.centerLeft;
    }

    return Align(
      alignment: bubbleAlignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: alignment,
          children: [
            (!isSystem)
                ? Row(
                    mainAxisAlignment: isCurrentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: isCurrentUser
                        ? [
                            Text(
                              message.user,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1C3F03),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ProfileAvatarIconWidget(
                              user: ref
                                  .watch(userProviderByUsername(message.user)),
                              size: 30,
                            ),
                          ]
                        : [
                            ProfileAvatarIconWidget(
                              user: ref
                                  .watch(userProviderByUsername(message.user)),
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              message.user,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1C3F03),
                              ),
                            ),
                          ],
                  )
                : Text(
                    message.user,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C3F03),
                    ),
                  ),
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = isSystem
                    ? constraints.maxWidth
                    : constraints.maxWidth * 0.7;
                return Align(
                  alignment: isSystem
                      ? Alignment.center
                      : isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(isSystem
                              ? 12
                              : isCurrentUser
                                  ? 12
                                  : 0),
                          bottomRight: Radius.circular(isSystem
                              ? 12
                              : isCurrentUser
                                  ? 0
                                  : 12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isCurrentUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.content,
                            style: const TextStyle(fontSize: 16),
                            textAlign: isCurrentUser
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatDateTime(message.time.toIso8601String()),
                            style: TextStyle(
                                fontSize: 10, color: Colors.grey[600]),
                            textAlign: isCurrentUser
                                ? TextAlign.right
                                : TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.chatScrollController.hasClients && _isUserNearBottom()) {
        widget.chatScrollController.animateTo(
          widget.chatScrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _isUserNearBottom() {
    if (!widget.chatScrollController.hasClients) return false;
    final position = widget.chatScrollController.position;
    final currentScroll = position.pixels;
    const threshold = 300.0;
    return (currentScroll) <= threshold;
  }

  List<ChatMessage> _translateUserActionMessages(
      List<ChatMessage> messages, BuildContext context) {
    return messages.map((message) {
      if (message is UserActionMessage) {
        return _translateUserActionMessage(message, context);
      }
      return message;
    }).toList();
  }

  UserActionMessage _translateUserActionMessage(
      UserActionMessage message, BuildContext context) {
    return UserActionMessage(
      chatId: message.chatId,
      user: S.of(context).system,
      content: getMessageContent(message, context),
      time: message.time,
      affectedUser: message.affectedUser,
      action: message.action,
    );
  }

  String getMessageContent(UserActionMessage message, BuildContext context) {
    return '${message.action == UserAction.left ? S.of(context).user_left(message.affectedUser) : S.of(context).user_joined(message.affectedUser)} ${message.chatId.length == 4 ? S.of(context).the_game : S.of(context).the_chatroom}';
  }

  @override
  Widget build(BuildContext context) {
    String chatName = widget.chat.name;
    final unreadFromOtherChats = ref
        .watch(chatNotifierProvider)
        .userChats
        .where((chat) => chat.id != widget.chat.id)
        .fold(0, (sum, chat) => sum + chat.unreadMessages);

    bool isChatBannedAndSelected = widget.isChatBanned && chatName == 'Partie';
    if (chatName == 'Partie') {
      chatName = S.of(context).game_chat_name;
    }
    final messages =
        _translateUserActionMessages(widget.chat.messages, context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () => widget.onBack(),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, size: 24),
                            onPressed: () => widget.onBack(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(S.of(context).other),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(S.of(context).chatrooms),
                                  if (unreadFromOtherChats > 0)
                                    ChatNotificationBadge(
                                      count: unreadFromOtherChats,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        chatName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                controller: widget.chatScrollController,
                reverse: true,
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final reversedIndex = messages.length - 1 - index;
                  final message = messages[reversedIndex];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).extension<CustomColors>()!.boxColor,
              border: Border(
                  top:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.messageController,
                    focusNode: widget.messageFocusNode,
                    maxLength: 200,
                    enabled: !isChatBannedAndSelected,
                    style: const TextStyle(fontFamily: 'Fredoka One'),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      counterText: '',
                    ),
                    onChanged: (_) => widget.onChanged(),
                    onSubmitted: (_) => widget.onSendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                        isChatBannedAndSelected ? null : widget.onSendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 0,
                    ),
                    child: const FaIcon(FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
