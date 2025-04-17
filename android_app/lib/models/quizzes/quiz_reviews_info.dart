class QuizReviewsInfo {
  final String quizId;
  final double averageScore;
  final int reviewCount;

  const QuizReviewsInfo({
    required this.quizId,
    required this.averageScore,
    required this.reviewCount,
  });

  factory QuizReviewsInfo.fromJson(Map<String, dynamic> json) {
    return QuizReviewsInfo(
      quizId: json['quizId'],
      averageScore: (json['averageScore'] is int)
          ? (json['averageScore'] as int).toDouble()
          : json['averageScore'] as double,
      reviewCount: json['reviewCount'] as int,
    );
  }
}