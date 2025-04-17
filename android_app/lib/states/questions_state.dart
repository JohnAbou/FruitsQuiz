import 'package:android_app/models/enums/question_type.dart';
import 'package:android_app/models/question.dart';

class QuestionsState {
  final List<Question> questions;

  int get specialQuestionCount => questions
      .where((q) => q.type == QuestionType.qcm || q.type == QuestionType.qre)
      .length;

  bool get specialQuizAvailable => specialQuestionCount >= 5;

  const QuestionsState({this.questions = const []});

  QuestionsState copyWith({List<Question>? questions}) {
    return QuestionsState(
      questions: questions ?? this.questions,
    );
  }
}
