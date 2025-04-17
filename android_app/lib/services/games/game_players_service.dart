import 'package:android_app/models/player.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/states/game_players_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gamePlayersStateProvider =
    StateNotifierProvider<GamePlayersService, GamePlayersState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GamePlayersService(socketService);
});

final gamePlayersServiceProvider = Provider<GamePlayersService>(
    (ref) => ref.read(gamePlayersStateProvider.notifier));

List<Player> scoreSortFunction(List<Player> players) {
  players.sort((a, b) => b.score != a.score
      ? b.score.compareTo(a.score)
      : a.averageAnswerTime != b.averageAnswerTime
          ? a.averageAnswerTime.compareTo(b.averageAnswerTime)
          : a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return players;
}

List<Player> roundSortFunction(List<Player> players) {
  players.sort((a, b) => b.roundSurvived != a.roundSurvived
      ? b.roundSurvived.compareTo(a.roundSurvived)
      : a.averageAnswerTime != b.averageAnswerTime
          ? a.averageAnswerTime.compareTo(b.averageAnswerTime)
          : a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  return players;
}

List<Player> defaultSortFunction(List<Player> players) {
  return players;
}

class GamePlayersService extends BaseGameService<GamePlayersState> {
  GamePlayersService(SocketConnectionService socketService)
      : super(socketService, const GamePlayersState());

  @override
  void initializeState() {
    state = const GamePlayersState();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('playerJoined', (data) {
      state = state.addPlayer(Player.fromJson(data));
    });
    addSocketListener('playerLeft', (data) {
      state = state.removePlayer(Player.fromJson(data));
    });
    addSocketListener('sendPlayersStat', (data) {
      if (data is List) {
        try {
          final players =
              data.map((player) => Player.fromJson(player)).toList();
          players.sort((a, b) => b.score.compareTo(a.score));
          state = GamePlayersState(players: players);
        } catch (e) {
          // pass
        }
      } else {
        // pass
      }
    });
  }
}
