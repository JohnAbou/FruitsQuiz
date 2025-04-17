class QcmAnswerState {
  final List<int> correctAnswer;
  final bool showCorrectAnswer;
  final List<int> selectedAnswers;

  const QcmAnswerState({
    this.correctAnswer = const [],
    this.showCorrectAnswer = false,
    this.selectedAnswers = const [],
  });

  QcmAnswerState copyWith({
    List<int>? correctAnswer,
    bool? showCorrectAnswer,
    List<int>? selectedAnswers,
  }) {
    return QcmAnswerState(
      correctAnswer: correctAnswer ?? this.correctAnswer,
      showCorrectAnswer: showCorrectAnswer ?? this.showCorrectAnswer,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
    );
  }

  bool isAnswerCorrected(int answerIndex) {
    return showCorrectAnswer && correctAnswer.contains(answerIndex);
  }

  bool isAnswerSelected(int buttonId) {
    return selectedAnswers.contains(buttonId);
  }
}
