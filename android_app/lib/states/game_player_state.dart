class GamePlayerState {
  final bool hasSubmittedAnswer;
  final bool isEliminated;
  final int currentScore;
  final int receivedHint;
  final bool hintUsable;
  final int hintCost;

  const GamePlayerState({
    this.hasSubmittedAnswer = false,
    this.isEliminated = false,
    this.currentScore = 0,
    this.receivedHint = 0,
    this.hintUsable = false,
    this.hintCost = 0,
  });

  GamePlayerState copyWith({
    bool? hasSubmittedAnswer,
    bool? isEliminated,
    int? currentScore,
    int? receivedHint,
    bool? hintUsable,
    int? hintCost,
  }) {
    return GamePlayerState(
      hasSubmittedAnswer: hasSubmittedAnswer ?? this.hasSubmittedAnswer,
      isEliminated: isEliminated ?? this.isEliminated,
      currentScore: currentScore ?? this.currentScore,
      receivedHint: receivedHint ?? this.receivedHint,
      hintUsable: hintUsable ?? this.hintUsable,
      hintCost: hintCost ?? this.hintCost,
    );
  }

  bool canSubmitAnswer() => !hasSubmittedAnswer;
}
