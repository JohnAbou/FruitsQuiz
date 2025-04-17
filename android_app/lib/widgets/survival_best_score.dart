import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/game_survival_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurvivalBestScore extends ConsumerWidget {
  const SurvivalBestScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionSurvived = ref.watch(
        gameSurvivalProvider.select((state) => state.questionSurvived));
    final bestScore = ref.watch(
        gameSurvivalProvider.select((state) => state.bestScore));

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 350),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  S.of(context).survival_best_score_title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                // Current Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6FFFA), // Light teal background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: const Color(0xFF319795), // Teal icon color
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${S.of(context).survival_best_score_current_score}:",
                          style: const TextStyle(
                            color: Color(0xFF2C7A7B), // Teal text color
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        questionSurvived.toString(),
                        style: const TextStyle(
                          color: Color(0xFF2C7A7B),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Best Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFCBF), // Light yellow background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: const Color(0xFFD69E2E), // Yellow icon color
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "${S.of(context).survival_best_score_best_score}:",
                          style: const TextStyle(
                            color: Color(0xFF975A16), // Yellow text color
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        bestScore.toString(),
                        style: const TextStyle(
                          color: Color(0xFF975A16),
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}