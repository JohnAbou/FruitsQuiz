import 'package:flutter/material.dart';

class ChatNotificationBadge extends StatelessWidget {
  final int count;
  final double size;

  const ChatNotificationBadge({
    super.key,
    required this.count,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final String displayText = count > 99 ? '99+' : count.toString();
    final double fontSize = count > 99 ? size * 0.45 : size * 0.6;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
