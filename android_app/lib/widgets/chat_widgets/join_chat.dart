import 'package:android_app/generated/l10n.dart';
import 'package:android_app/widgets/chat_widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:android_app/models/chat.dart';
import 'package:android_app/theme/custom_colors.dart';

class JoinChatWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(ChatInterfaceState) onBack;
  final Function(String) onJoin;
  final List<Chat> nonUserChats;

  const JoinChatWidget({
    super.key,
    required this.onClose,
    required this.onBack,
    required this.onJoin,
    required this.nonUserChats,
  });

  @override
  _JoinChatWidgetState createState() => _JoinChatWidgetState();
}

class _JoinChatWidgetState extends State<JoinChatWidget> {
  final TextEditingController _filterController = TextEditingController();
  List<Chat> _filteredChats = [];

  @override
  void initState() {
    super.initState();
    _filteredChats = widget.nonUserChats;
    _filterController.addListener(_filterChats);
  }

  @override
  void didUpdateWidget(covariant JoinChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.nonUserChats != oldWidget.nonUserChats) {
      _filterChats();
    }
  }

  void _filterChats() {
    final query = _filterController.text.toLowerCase();
    setState(() {
      _filteredChats = widget.nonUserChats
          .where((chat) => chat.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () =>
                        widget.onBack(ChatInterfaceState.selectingChat),
                  ),
                ),
                Text(
                  S.of(context).join_chatroom,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _filterController,
              decoration: InputDecoration(
                hintText: S.of(context).filter_placeholder,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color : customColors.accentColor, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color : customColors.accentColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color : customColors.accentColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: customColors.headerColor,
              ),
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: _filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = _filteredChats[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: customColors.chatListBackground,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontFamily: 'Fredoka One',
                            fontSize: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color: customColors.accentColor, width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () => widget.onJoin(chat.id),
                        child: Text(chat.name, textAlign: TextAlign.center),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_filteredChats.isEmpty)
            Text(
              S.of(context).no_chats,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
