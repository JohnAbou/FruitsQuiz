import 'package:android_app/models/quizzes/quiz.dart';

class QuizzesState {
  final List<Quiz> quizzes;
  final Quiz selectedQuiz;

  const QuizzesState({
    this.quizzes = const [],
    required this.selectedQuiz,
  });

  QuizzesState copyWith({
    List<Quiz>? quizzes,
    Quiz? selectedQuiz,
  }) {
    return QuizzesState(
      quizzes: quizzes ?? this.quizzes,
      selectedQuiz: selectedQuiz ?? this.selectedQuiz,
    );
  }
}