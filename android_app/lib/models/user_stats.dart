class UserStats {
  final String id;
  final int totalPoints;
  final int totalSurvivedQuestion;
  final double totalGameTime;
  final int totalGameWon;
  final int currentWinStreak;
  final int bestWinStreak;
  final int coinSpent;
  final int coinGained;
  final int challengeCompleted;
  final int bestSurvivalScore;
  final int totalGamesPlayed;
  final int totalQuestionAnswered;
  final int totalQuestionGotten;

  UserStats({
    required this.id,
    required this.totalPoints,
    required this.totalSurvivedQuestion,
    required this.totalGameTime,
    required this.totalGameWon,
    required this.currentWinStreak,
    required this.bestWinStreak,
    required this.coinSpent,
    required this.coinGained,
    required this.challengeCompleted,
    required this.bestSurvivalScore,
    required this.totalGamesPlayed,
    required this.totalQuestionAnswered,
    required this.totalQuestionGotten,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      id: json['id'] as String,
      totalPoints: json['totalPoints'] as int,
      totalSurvivedQuestion: json['totalSurvivedQuestion'] as int,
      totalGameTime: (json['totalGameTime'] is int)
          ? (json['totalGameTime'] as int).toDouble()
          : (json['totalGameTime'] as double),
      totalGameWon: json['totalGameWon'] as int,
      currentWinStreak: json['currentWinStreak'] as int,
      bestWinStreak: json['bestWinStreak'] as int,
      coinSpent: json['coinSpent'] as int,
      coinGained: json['coinGained'] as int,
      challengeCompleted: (json['challengeCompleted'] ?? 0) as int,
      bestSurvivalScore: (json['bestSurvivalScore'] ?? 0) as int,
      totalGamesPlayed: (json['totalGamePlayed'] ?? 0) as int,
      totalQuestionAnswered: (json['totalQuestionAnswered'] ?? 0) as int,
      totalQuestionGotten: (json['totalQuestionGotten'] ?? 0) as int,
    );
  }
}

class UserWithStats {
  final String id;
  final String username;
  final String activeAvatarId;
  final UserStats userStats;

  UserWithStats({
    required this.id,
    required this.username,
    required this.activeAvatarId,
    required this.userStats,
  });

  factory UserWithStats.fromJson(Map<String, dynamic> json) {
    return UserWithStats(
      id: json['id'] as String,
      username: json['username'] as String,
      activeAvatarId: json['activeAvatarId'] as String,
      userStats: UserStats.fromJson(json['userStats'] as Map<String, dynamic>),
    );
  }

UserWithStats copyWith({
    String? username,
    String? activeAvatarId,
    UserStats? userStats,
  }) {
    return UserWithStats(
      id: id,
      username: username ?? this.username,
      activeAvatarId: activeAvatarId ?? this.activeAvatarId,
      userStats: userStats ?? this.userStats,
    );
  }
}
