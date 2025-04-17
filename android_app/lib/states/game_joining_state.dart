import 'package:android_app/models/game_info.dart';

class GameJoiningState {
  final List<GameInfo> filteredGames;
  final String filter;
  final List<GameInfo> allGames;

  GameJoiningState({
    this.filteredGames = const [],
    this.filter = '',
    this.allGames = const [],
  });

  GameJoiningState copyWith({
    List<GameInfo>? filteredGames,
    String? filter,
    List<GameInfo>? allGames,
  }) {
    return GameJoiningState(
      filteredGames: filteredGames ?? this.filteredGames,
      filter: filter ?? this.filter,
      allGames: allGames ?? this.allGames,
    );
  }
}
