import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/models/quizzes/quiz.dart';

class GameInfo {
  final int gameId;
  final Quiz quizToPlay;
  final GameType gameType;
  final int playersNb;
  final bool isLocked;
  final int entryFee;

  const GameInfo({
    required this.gameId,
    required this.quizToPlay,
    required this.gameType,
    required this.playersNb,
    required this.isLocked,
    required this.entryFee,
  });

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    return GameInfo(
      gameId: json['gameId'] as int,
      quizToPlay: Quiz.fromJson(json['quizToPlay'] as Map<String, dynamic>),
      gameType: GameType.fromValue(json['gameType'] as int),
      playersNb: json['playersNb'] as int,
      isLocked: json['isLocked'] as bool,
      entryFee: json['entryFee'] as int,
    );
  }
}