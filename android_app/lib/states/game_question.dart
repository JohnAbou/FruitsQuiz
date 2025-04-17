import 'package:android_app/models/question.dart';

class GameQuestionState {
  final QuestionWithIndex question;

  const GameQuestionState({
    this.question = const QuestionWithIndex(),
  });

  GameQuestionState copyWith({
    QuestionWithIndex? question,
  }) {
    return GameQuestionState(
      question: question ?? this.question,
    );
  }
}