import 'package:android_app/models/player.dart';

class GamePlayersState {
  final List<Player> players;

  const GamePlayersState({
    this.players = const [],
  });

  removePlayer(Player player) {
    final newPlayers = players.where((p) => p.name != player.name).toList();
    newPlayers.sort((a, b) => a.score.compareTo(b.score));
    return GamePlayersState(players: newPlayers);
  }

  addPlayer(Player player) {
    final newPlayers = [...players, player];
    newPlayers.sort((a, b) => a.score.compareTo(b.score));
    return GamePlayersState(players: newPlayers);
  }
}
