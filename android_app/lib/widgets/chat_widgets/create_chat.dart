import 'package:android_app/generated/l10n.dart';
import 'package:android_app/widgets/chat_widgets/chat.dart';
import 'package:flutter/material.dart';
import 'package:android_app/theme/custom_colors.dart';

class CreateChatWidget extends StatefulWidget {
  final VoidCallback onClose;
  final Function(ChatInterfaceState) onBack;
  final Function(TextEditingController, bool) onCreate;
  final Future<bool> Function(String) checkChatNameExists;

  const CreateChatWidget({
    super.key,
    required this.onClose,
    required this.onBack,
    required this.onCreate,
    required this.checkChatNameExists,
  });

  @override
  _CreateChatWidgetState createState() => _CreateChatWidgetState();
}

class _CreateChatWidgetState extends State<CreateChatWidget> {
  final TextEditingController _chatNameController = TextEditingController();
  bool _friendsOnly = false;
  String? _errorMessage;
  bool _isChecking = false;

  bool validateRestrictedName(String chatName) {
    if (chatName == "Partie" || chatName == "Game") {
      setState(() {
        _errorMessage = S.of(context).chat_name_restricted_error;
      });
      return false;
    }
    return true;
  }

  bool validateEmptyName(String chatName) {
    if (chatName.isEmpty) {
      setState(() {
        _errorMessage = S.of(context).chat_name_empty_error;
      });
      return false;
    }
    return true;
  }

  Future<void> _validateAndCreateChat() async {
    String chatName = _chatNameController.text.trim();

    if (!validateEmptyName(chatName)) return;
    if (!validateRestrictedName(chatName)) return;

    setState(() {
      _isChecking = true;
      _errorMessage = null;
    });

    try {
      bool exists = await widget.checkChatNameExists(chatName);

      if (exists) {
        setState(() {
          _errorMessage = S.of(context).chat_name_taken_error;
        });
      } else {
        widget.onCreate(_chatNameController, _friendsOnly);
      }
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
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
                  S.of(context).create_chatroom,
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _chatNameController,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: S.of(context).chat_name_placeholder,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: customColors.accentColor,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: customColors.accentColor,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: customColors.accentColor,
                    width: 2,
                  ),
                ),
                errorText: _errorMessage,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Checkbox(
                  value: _friendsOnly,
                  onChanged: (value) {
                    setState(() {
                      _friendsOnly = value!;
                    });
                  },
                  activeColor: customColors.accentColor,
                  checkColor: Colors.black,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return customColors.accentColor;
                    }
                    return Colors.white;
                  }),
                ),
                Text(S.of(context).friends_only),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isChecking ? null : _validateAndCreateChat,
            child: _isChecking
                ? CircularProgressIndicator(color: Colors.white)
                : Text(S.of(context).create),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
