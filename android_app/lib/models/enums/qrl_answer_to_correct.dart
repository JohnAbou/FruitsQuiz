class QrlAnswerToCorrect {
  final String answer;
  double score;
  final String playerName;

  QrlAnswerToCorrect({
    required this.answer,
    required this.score,
    required this.playerName,
  });

  factory QrlAnswerToCorrect.fromJson(Map<String, dynamic> json) {
    return QrlAnswerToCorrect(
      answer: json['answer'] as String,
      score: 0,
      playerName: json['playerName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'score': score,
      'playerName': playerName,
    };
  }
}
