import 'package:android_app/services/games/game_organizer_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class ContinueGameButton extends ConsumerWidget {
  const ContinueGameButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameService = ref.read(gameOrganizerServiceProvider);
    final gameState = ref.watch(gameOrganizerStateProvider);
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>();
    final accentColor = customColors?.accentColor ?? theme.colorScheme.secondary;

    return Container(
      width: 370,
      height: 70,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        onPressed: gameState.canGoToNextQuestion
            ? () => gameService.goToNextQuestion()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          disabledForegroundColor: Colors.grey[700],
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).continue_game),
            const Icon(
              Icons.arrow_circle_right,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
