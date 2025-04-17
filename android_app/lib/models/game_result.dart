import 'package:android_app/models/player.dart';

class GameResult {
  final Player? winner;
  final bool wasTie;

  GameResult({this.winner, required this.wasTie});

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      winner: json['winner'] != null ? Player.fromJson(json['winner']) : null,
      wasTie: json['wasTie'] as bool,
    );
  }
}