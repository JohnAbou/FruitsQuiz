import 'package:android_app/models/game_metrics_update.dart';
import 'package:android_app/models/game_result.dart';
import 'package:android_app/models/game_time.dart';
import 'package:android_app/models/win_streak_update.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameResultState {
  final GameResult gameResult;
  final WinStreakUpdate winStreakUpdate;
  final GameMetricsUpdate gameMetricsUpdate;
  final GameTimeUpdate gameTimeUpdate;

  GameResultState({
    required this.gameResult,
    required this.winStreakUpdate,
    required this.gameMetricsUpdate,
    required this.gameTimeUpdate
  });

  GameResultState copyWith(
      {GameResult? gameResult,
      WinStreakUpdate? winStreakUpdate,
      GameMetricsUpdate? gameMetricsUpdate,
      GameTimeUpdate? gameTimeUpdate}) {
    return GameResultState(
      gameResult: gameResult ?? this.gameResult,
      winStreakUpdate: winStreakUpdate ?? this.winStreakUpdate,
      gameMetricsUpdate: gameMetricsUpdate ?? this.gameMetricsUpdate,
      gameTimeUpdate: gameTimeUpdate ?? this.gameTimeUpdate,
    );
  }
}

final defaultGameResultState = GameResultState(
  gameResult: GameResult(wasTie: false),
  winStreakUpdate: WinStreakUpdate(wsState: WinStreakState.lost, current: 0, winCount: 0),
  gameMetricsUpdate: GameMetricsUpdate(
      newPoints: 0,
      gainedPoints: 0,
      newSurvivedQuestion: 0,
      gainedSurvivedQuestion: 0),
  gameTimeUpdate: GameTimeUpdate(currentTime: 0, addedTime: 0)
);

class GameResultsService extends BaseGameService<GameResultState> {
  GameResultsService(SocketConnectionService socketService)
      : super(socketService, defaultGameResultState);

  @override
  void initializeState() {
    state = defaultGameResultState;
  }

  @override
  void setUpSocketListener() {
    addSocketListener('sendGameResult', (data) {
      _onGetResult(GameResult.fromJson(data));
    });

    addSocketListener('gameWinStreakUpdated', (data) {
      _onGetWinStreak(WinStreakUpdate.fromJson(data));
    });

    addSocketListener('gameMetricsUpdated', (data) {
      _onGetGameMetrics(GameMetricsUpdate.fromJson(data));
    });

    addSocketListener('gameTimeUpdated', (data) {
      _onGetGameTime(GameTimeUpdate.fromJson(data));
    });
  }

  _onGetWinStreak(WinStreakUpdate update) {
    state = state.copyWith(winStreakUpdate: update);
  }

  _onGetResult(GameResult result) {
    state = state.copyWith(gameResult: result);
  }

  _onGetGameMetrics(GameMetricsUpdate update) {
    state = state.copyWith(gameMetricsUpdate: update);
  }

  _onGetGameTime(GameTimeUpdate update) {
    state = state.copyWith(gameTimeUpdate: update);
  }
}

final gameResultProvider =
    StateNotifierProvider<GameResultsService, GameResultState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameResultsService(socketService);
});
