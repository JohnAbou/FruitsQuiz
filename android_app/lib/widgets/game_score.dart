import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_player_service.dart';
import 'package:android_app/widgets/animated_heart.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameScore extends ConsumerWidget {
  const GameScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isClassicalGame = ref.watch(gameInfoStateProvider
        .select((state) => state.gameType == GameType.normalGame));
    final score = ref
        .watch(gamePlayerStateProvider.select((state) => state.currentScore));
    final isEliminated = ref
        .watch(gamePlayerStateProvider.select((state) => state.isEliminated));

    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.primary;
    final isAlive = !isEliminated;
    final customColors = Theme.of(context).extension<CustomColors>();
    final textColor = customColors?.textColor ?? Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 4),
            color: Colors.black26,
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 140),
      child: isClassicalGame
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).game_score_your_score,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$score pts',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedHeartbeatIcon(
                  icon: isAlive ? Icons.favorite : Icons.heart_broken,
                  color: textColor,
                  animate: isAlive,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isAlive
                        ? S.of(context).game_score_alive
                        : S.of(context).game_score_eliminated,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}


