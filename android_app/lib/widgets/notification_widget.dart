import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback? arrowCallback;
  final VoidCallback onDismiss;

  const NotificationWidget({
    super.key,
    required this.message,
    required this.icon,
    this.arrowCallback,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = Color(0xFF323232);
    final primaryColor = theme.colorScheme.primary;

    return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Card(
          color: primaryColor,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (arrowCallback != null) ...[
                IconButton(
                  icon: Icon(
                    Icons.north_east,
                    color: Colors.white,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: arrowCallback,
                ),
              ],
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
                padding: EdgeInsets.zero,
                onPressed: onDismiss,
              ),
            ],
          ),
        ));
  }
}
