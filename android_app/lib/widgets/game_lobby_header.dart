import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameLobbyHeader extends ConsumerWidget {
  const GameLobbyHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameId =
        ref.watch(gameInfoStateProvider.select((state) => state.gameId));
    final gameType =
        ref.watch(gameInfoStateProvider.select((state) => state.gameType));
    final quizTitle =
        ref.watch(gameInfoStateProvider.select((state) => state.quiz.title));
    final questionCount = ref.watch(
        gameInfoStateProvider.select((state) => state.quiz.questions.length));

    final quizText =
        '${gameType == GameType.randomGame ? S.of(context).random_quiz_header_title : quizTitle} - $questionCount questions';

    final String gameTypeText;
    if (gameType == GameType.randomGame) {
      gameTypeText = S.of(context).game_mode_elimination;
    } else if (gameType == GameType.survivalGame) {
      gameTypeText = S.of(context).game_mode_survival;
    } else {
      gameTypeText = S.of(context).game_mode_classical;
    }

    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: IntrinsicWidth(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBorderedText(context, gameTypeText),
                _buildBorderedText(context, quizText),
                _buildGameIdContainer(context, gameId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorderedText(BuildContext context, String text) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(11),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildGameIdContainer(BuildContext context, int gameId) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: () => Clipboard.setData(ClipboardData(text: gameId.toString())),
      child: Container(
        padding: const EdgeInsets.all(11),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Code: $gameId',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.content_copy, color: primaryColor, size: 20),
          ],
        ),
      ),
    );
  }
}
