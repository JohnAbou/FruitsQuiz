import 'package:android_app/models/win_streak_update.dart';
import 'package:android_app/services/games/game_results_service.dart';
import 'package:android_app/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class GameMetrics extends ConsumerWidget {
  const GameMetrics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameMetricsUpdate = ref.watch(gameResultProvider.select((state) => state.gameMetricsUpdate));
    final gameTime = ref.watch(gameResultProvider.select((state) => state.gameTimeUpdate));
    final winStreak = ref.watch(gameResultProvider.select((state) => state.winStreakUpdate));

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).game_metrics_title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.primary),
          ),
          SizedBox(height: 8),
          if (gameMetricsUpdate.gainedPoints > 0)
            _buildMetricsItem(
              context,
              '${gameMetricsUpdate.newPoints} (+${gameMetricsUpdate.gainedPoints})',
              S.of(context).game_metrics_points_gained,
            ),
          if (gameMetricsUpdate.gainedSurvivedQuestion > 0)
            _buildMetricsItem(
              context,
              '${gameMetricsUpdate.newSurvivedQuestion} (+${gameMetricsUpdate.gainedSurvivedQuestion})',
              S.of(context).game_metrics_questions_survived,
            ),
          _buildMetricsItem(
            context,
            '${formatTime(gameTime.currentTime)} (+${formatTime(gameTime.addedTime)})',
            S.of(context).game_metrics_game_time_added,
          ),
          _buildMetricsItem(
            context,
            '${winStreak.current} (+${winStreak.wsState == WinStreakState.lost ? 0 : 1})',
            S.of(context).game_metrics_game_won,
          )
        ],
      ),
    );
  }

  Widget _buildMetricsItem(BuildContext context, String status, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            status,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style:
                TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}
