import 'package:android_app/models/enums/bot_avatar_type.dart';
import 'package:android_app/models/enums/bot_difficulty.dart';
import 'package:android_app/models/player.dart';

class BotPlayer extends Player {
  final BotDifficulty difficulty;
  final BotAvatarType avatarType;

  BotPlayer({
    required super.name,
    required super.score,
    required super.bonusCount,
    required super.roundSurvived,
    required this.difficulty,
    required this.avatarType,
  }) : super();

  factory BotPlayer.fromJson(Map<String, dynamic> json) {
    return BotPlayer(
      name: json['name'],
      score: json['score'],
      bonusCount: json['bonusCount'],
      roundSurvived: json['roundSurvived'],
      difficulty: BotDifficultyExtension.fromString(json['difficulty']),
      avatarType: BotAvatarTypeExtension.fromString(json['avatarType']),
    );
  }
}
