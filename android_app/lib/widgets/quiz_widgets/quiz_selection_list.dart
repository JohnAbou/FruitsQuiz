import 'package:android_app/services/questions_services.dart';
import 'package:android_app/services/quizzes/quizzes_services.dart';
import 'package:android_app/widgets/quiz_widgets/random_quiz_header.dart';
import 'package:android_app/widgets/quiz_widgets/survival_quiz_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/quizzes/quiz.dart';
import 'quiz_header.dart';

class QuizSelectionList extends ConsumerStatefulWidget {
  const QuizSelectionList({super.key});

  @override
  ConsumerState<QuizSelectionList> createState() => _QuizSelectionListState();
}

class _QuizSelectionListState extends ConsumerState<QuizSelectionList> {
  selectEliminationQuiz(WidgetRef ref) {
    final service = ref.read(quizzesStateProvider.notifier);
    service.updateSelectedQuiz(randomQuiz);
  }

  selectSurvivalQuiz(WidgetRef ref) {
    final service = ref.read(quizzesStateProvider.notifier);
    service.updateSelectedQuiz(survivalQuiz);
  }

  selectQuiz(WidgetRef ref, Quiz quiz) {
    final service = ref.read(quizzesStateProvider.notifier);
    service.updateSelectedQuiz(quiz);
  }

  @override
  Widget build(BuildContext context) {
    final quizzesState = ref.watch(quizzesStateProvider);
    final quizzes = quizzesState.quizzes;

    final hasSpecialQuiz = ref.watch(
        questionsStateProvider.select((state) => state.specialQuizAvailable));

    return Column(
      children: [
        ListTile(
          title: const RandomQuizHeader(),
          onTap: () => selectEliminationQuiz(ref),
          enabled: hasSpecialQuiz,
        ),
        ListTile(
          title: const SurvivalQuizHeader(),
          onTap: () => selectSurvivalQuiz(ref),
          enabled: hasSpecialQuiz,
        ),
        ...quizzes.map((quiz) {
          return ListTile(
            title: QuizHeader(quiz: quiz),
            onTap: () => selectQuiz(ref, quiz),
          );
        }),
      ],
    );
  }
}
