enum WinStreakState {
  lost(1),
  improved(2),
  best(3);

  final int value;

  const WinStreakState(this.value);
}

class WinStreakUpdate {
  final WinStreakState wsState;
  final int current;
  final int winCount;

  WinStreakUpdate({
    required this.wsState,
    required this.current,
    required this.winCount,
  });

  factory WinStreakUpdate.fromJson(Map<String, dynamic> json) {
    return WinStreakUpdate(
      wsState: WinStreakState.values[(json['wsState'] as int)-1],
      current: json['current'] as int,
      winCount: json['winCount'] as int,
    );
  }
}
