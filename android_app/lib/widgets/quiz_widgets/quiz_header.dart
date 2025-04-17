import 'package:flutter/material.dart';
import 'package:android_app/generated/l10n.dart';
import '../../models/quizzes/quiz.dart';

class QuizHeader extends StatelessWidget {
  final Quiz quiz;

  const QuizHeader({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final defaultTextColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            quiz.title,
            style: TextStyle(
              fontSize: 20,
              color: primaryColor,
            ),
          ),
          Text(
            S.of(context).quiz_contains_questions(quiz.questions.length),
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
