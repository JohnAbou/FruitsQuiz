import 'package:android_app/services/games/game_creation_service.dart';
import 'package:android_app/services/questions_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class QuestionCountSelection extends ConsumerWidget {
  const QuestionCountSelection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameCreationService = ref.watch(gameCreationServiceProvider);
    final totalQuestions = ref.watch(
        questionsStateProvider.select((state) => state.specialQuestionCount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S
            .of(context)
            .special_quiz_count_selected(gameCreationService.questionCount)),
        if (totalQuestions != 5) ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(S.of(context).special_quiz_nb_question_details),
                const SizedBox(width: 10),
                SizedBox(
                  width: 300,
                  child: Slider(
                    min: 5,
                    max: totalQuestions.toDouble(),
                    value: gameCreationService.questionCount.toDouble(),
                    divisions: totalQuestions - 5,
                    label: gameCreationService.questionCount.toString(),
                    onChanged: (value) {
                      gameCreationService.questionCount = value.toInt();
                    },
                  ),
                )
              ],
            ),
          ),
        ] else ...[
          SizedBox(height: 8),
          Text(S.of(context).special_quiz_cant_change),
        ],
      ],
    );
  }
}
