import 'package:android_app/models/bot_player.dart';

class Player {
  final String name;
  final int score;
  final int bonusCount;
  final int roundSurvived;
  final double averageAnswerTime;

  const Player({
    this.name = '',
    this.score = 0,
    this.bonusCount = 0,
    this.roundSurvived = 0,
    this.averageAnswerTime = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    if (json['difficulty'] != null) {
      return BotPlayer.fromJson(json);
    }
    return Player(
      name: json['name'] as String,
      score: json['score'] as int,
      bonusCount: json['bonusCount'] as int,
      roundSurvived: json['roundSurvived'] as int,
      averageAnswerTime: (json['averageAnswerTime'] is int)
          ? (json['averageAnswerTime'] as int).toDouble()
          : (json['averageAnswerTime'] as double),
    );
  }
}
