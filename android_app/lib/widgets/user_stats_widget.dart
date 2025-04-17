import 'package:android_app/services/user_stats_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserStatsWidget extends ConsumerWidget {
  final String userId;

  const UserStatsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(userStatsProvider(userId));

    return statsAsyncValue.when(
      data: (stats) {
        if (stats == null) {
          return const Text('No stats available');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Time: ${stats.totalGameTime}'),
            Text('Win Streak: ${stats.bestWinStreak}'),
            Text('Current Win Streak: ${stats.currentWinStreak}'),
            Text('Total Games Won: ${stats.totalGameWon}'),
            Text('Total Points: ${stats.totalPoints}'),
            Text('Total Questions Survived: ${stats.totalSurvivedQuestion}'),
            Text('Total Coins Spent: ${stats.coinSpent}'),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'), // To remove
    );
  }
}