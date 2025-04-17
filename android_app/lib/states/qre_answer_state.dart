class QreAnswerState {
  final int correctAnswer;
  final bool showCorrectAnswer;
  final int? userAnswer;

  const QreAnswerState({
    this.correctAnswer = 0,
    this.showCorrectAnswer = false,
    this.userAnswer,
  });

  QreAnswerState copyWith({
    int? correctAnswer,
    bool? showCorrectAnswer,
    int? userAnswer,
  }) {
    return QreAnswerState(
      correctAnswer: correctAnswer ?? this.correctAnswer,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }

  bool get hasUserAnswered => userAnswer != null;
}
