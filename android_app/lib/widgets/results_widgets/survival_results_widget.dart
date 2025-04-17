import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/question.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_survival_service.dart';
import 'package:android_app/theme/app_styles.dart';
import 'package:android_app/widgets/game_loot_widget.dart';
import 'package:android_app/widgets/results_widgets/stats_result_widget.dart';
import 'package:android_app/widgets/survival_best_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurvivalResultsWidget extends ConsumerWidget {
  const SurvivalResultsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref
        .watch(gameInfoStateProvider.select((state) => state.quiz.questions));
    final questionSurvived = ref
        .watch(gameSurvivalProvider.select((state) => state.questionSurvived));
    final hasWonGame = questions.length == questionSurvived;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            hasWonGame
                ? S.of(context).survival_result_won_title
                : S.of(context).survival_result_lost_title,
            textAlign: TextAlign.center,
            style: AppTextStyles.fruitzSubtitle(context),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 5),
                Expanded(
                  flex: 65,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 65,
                        child: _buildQuestionResultCard(
                            context, ref, questions, questionSurvived),
                      ),
                      const Spacer(flex: 5),
                      Expanded(
                        flex: 40,
                        child: GameLootWidget(showCoinsPaid: false),
                      ),
                    ]
                  ),
                ),
                const Spacer(flex: 5),
                Expanded(
                  flex: 25,
                  child: Column(
                    children: [
                      SurvivalBestScore(),
                      const SizedBox(height: 16),
                      StatsResultWidget(),
                    ],
                  ),
                ),
                const Spacer(flex: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionResultCard(BuildContext context, WidgetRef ref,
      List<Question> questions, int questionSurvived) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.08),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.of(context).survival_result_mode,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    S.of(context).survival_result_questions_correct(
                        questionSurvived, questions.length),
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final isCorrect = index < questionSurvived;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black.withOpacity(0.08),
                      ),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {}, // Optional: handle tap
                      hoverColor: Colors.black.withOpacity(0.02),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                questions[index].text,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Icon(
                              isCorrect ? Icons.check_circle : Icons.cancel,
                              color: isCorrect ? Colors.green : Colors.red,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
