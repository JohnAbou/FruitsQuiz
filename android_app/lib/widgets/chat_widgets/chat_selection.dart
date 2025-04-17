import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/widgets/chat_widgets/chat.dart';
import 'package:android_app/widgets/chat_widgets/chat_notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:android_app/theme/custom_colors.dart';

class ChatSelection extends StatelessWidget {
  final List<Chat> userChats;
  final String username;
  final VoidCallback onClose;
  final Function(ChatInterfaceState) changeState;
  final Function(String) selectChat;
  final Function(String, String) deleteChat;
  final Function(String, String) leaveChat;

  const ChatSelection({
    required this.userChats,
    required this.username,
    required this.onClose,
    required this.changeState,
    required this.selectChat,
    required this.deleteChat,
    required this.leaveChat,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  S.of(context).select_chatroom,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  changeState(ChatInterfaceState.creatingChat);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 24, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).create,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Fredoka One',
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  changeState(ChatInterfaceState.joiningChat);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: Row(
                  children: [
                    const Icon(Icons.person_add, size: 24, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).join,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Fredoka One',
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userChats.length,
              itemBuilder: (context, index) {
                final chat = userChats[index];
                bool isCreator = chat.creatorUsername == username;

                String chatName = chat.name;
                if (chatName == 'Partie') {
                  chatName = S.of(context).game_chat_name;
                }
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    // Use theme-defined chatListBackground from CustomColors
                    color: customColors.chatListBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: customColors.accentColor,
                      width: 2,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Also use theme-defined chatListBackground here
                      backgroundColor: customColors.chatListBackground,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontFamily: 'Fredoka One',
                        fontSize: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 3),
                    ),
                    onPressed: () => selectChat(chat.id),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chatName,
                          style: const TextStyle(
                            fontFamily: 'Fredoka One',
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (chat.unreadMessages > 0)
                            ChatNotificationBadge(
                              count: chat.unreadMessages,
                              size: 24,
                            ),
                          if (isCreator &&
                              chatName != 'Partie' &&
                              chatName != 'Game' &&
                              chatName != 'Global')
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.trashCan,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteChat(chat.id, chat.name);
                              },
                            ),
                          if (!isCreator &&
                              chatName != 'Partie' &&
                              chatName != 'Game' &&
                              chatName != 'Global')
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.rightFromBracket,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                leaveChat(chat.id, chat.name);
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
