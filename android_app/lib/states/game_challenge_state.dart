class GameChallengeState {
  final int code;
  final int price;
  final bool? success;

  const GameChallengeState({
    required this.code,
    required this.price,
    this.success,
  });

  GameChallengeState copyWith({
    int? code,
    int? price,
    bool? success,
  }) {
    return GameChallengeState(
      code: code ?? this.code,
      price: price ?? this.price,
      success: success ?? this.success,
    );
  }
} 