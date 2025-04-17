import 'package:android_app/services/questions_services.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SurvivalQuizHeader extends ConsumerWidget {
  const SurvivalQuizHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalQuestions = ref.watch(
      questionsStateProvider.select((state) => state.specialQuestionCount)
    );
    final primaryColor = Theme.of(context).colorScheme.primary;
    final defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).survival_quiz_header_title,
            textAlign: TextAlign.left,
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          Text(
            totalQuestions >= 5
                ? S.of(context).special_quiz_nb_question_header(totalQuestions)
                : S.of(context).special_quiz_activate_condition,
            style: TextStyle(
              fontSize: 16,
              color: defaultTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
