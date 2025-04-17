import 'package:android_app/models/enums/qrl_answer_to_correct.dart';

class GameOrganizerState {
  final bool canGoToNextQuestion;
  final List<QrlAnswerToCorrect> answersToCorrect;
  final int correctedAnswerIndex;

  const GameOrganizerState({
    this.canGoToNextQuestion = false,
    this.answersToCorrect = const [],
    this.correctedAnswerIndex = 0,
  });

  GameOrganizerState copyWith({
    bool? canGoToNextQuestion,
    List<QrlAnswerToCorrect>? answersToCorrect,
    int? correctedAnswerIndex,
  }) {
    return GameOrganizerState(
      canGoToNextQuestion: canGoToNextQuestion ?? this.canGoToNextQuestion,
      answersToCorrect: answersToCorrect ?? this.answersToCorrect,
      correctedAnswerIndex: correctedAnswerIndex ?? this.correctedAnswerIndex,
    );
  }

  QrlAnswerToCorrect getCurrentAnswerToCorrect() {
    if (correctedAnswerIndex < answersToCorrect.length) {
      return answersToCorrect[correctedAnswerIndex];
    }
    return QrlAnswerToCorrect(answer: '', score: 0, playerName: '');
  }

  GameOrganizerState scoreAnswer(double score) {
    answersToCorrect[correctedAnswerIndex].score = score;
    return copyWith(answersToCorrect: answersToCorrect, correctedAnswerIndex: correctedAnswerIndex + 1);
  }
}
