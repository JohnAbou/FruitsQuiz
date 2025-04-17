class QuizReview {
  final String quizId;
  final int score;

  const QuizReview({
    required this.quizId,
    required this.score,
  });

  factory QuizReview.fromJson(Map<String, dynamic> data) {
    return QuizReview(
      quizId: data['quizId'],
      score: data['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'score': score,
    };
  }
}
