class GameMetricsUpdate {
  final int newPoints;
  final int gainedPoints;
  final int newSurvivedQuestion;
  final int gainedSurvivedQuestion;

  GameMetricsUpdate({
    required this.newPoints,
    required this.gainedPoints,
    required this.newSurvivedQuestion,
    required this.gainedSurvivedQuestion,
  });

  factory GameMetricsUpdate.fromJson(Map<String, dynamic> json) {
    return GameMetricsUpdate(
      newPoints: json['newPoints'] as int,
      gainedPoints: json['gainedPoints'] as int,
      newSurvivedQuestion: json['newSurvivedQuestion'] as int,
      gainedSurvivedQuestion: json['gainedSurvivedQuestion'] as int,
    );
  }
}