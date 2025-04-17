import 'package:android_app/generated/l10n.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_send_rating.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_view_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_info_service.dart';

class ResultsStatsQuiz extends ConsumerWidget {
  const ResultsStatsQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameInfoState = ref.watch(gameInfoStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gameInfoState.quiz.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                '${S.of(context).result_view_created_by}${gameInfoState.quiz.owner}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const Divider(),
        _buildQuizRatingSection(ref, context),
      ],
    );
  }

  Widget _buildQuizRatingSection(WidgetRef ref, BuildContext context) {
    final gameInfoState = ref.watch(gameInfoStateProvider);

    if (gameInfoState.quiz.owner != 'system') {
      // Quiz Rating Section
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            QuizViewRating(
                quizId: gameInfoState.quiz.id,
                backgroundColor: Colors.white,),
            QuizSendRating(
                quizId: gameInfoState.quiz.id,
                backgroundColor: Colors.white,),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(S.of(context).result_view_cant_rate_system_quiz),
    );
  }
}
