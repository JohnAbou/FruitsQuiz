import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSurvivalState {
  final int questionSurvived;
  final int bestScore;

  GameSurvivalState({required this.questionSurvived, required this.bestScore});
}

class GameSurvivalService extends BaseGameService<GameSurvivalState> {
  GameSurvivalService(SocketConnectionService socketService)
      : super(socketService, GameSurvivalState(questionSurvived: 0, bestScore: 0));

  @override
  void initializeState() {
    state = GameSurvivalState(questionSurvived: 0, bestScore: 0);
  }

  @override
  void setUpSocketListener() {
    addSocketListener('survivedRound', (survived) {
      _onSurvived(survived);
    });

    addSocketListener('survivalResult', (bestScore) {
      _onResult(bestScore);
    });
  }

  void _onSurvived(bool survived) {
    if (survived) {
      state = GameSurvivalState(questionSurvived: state.questionSurvived + 1, bestScore: state.bestScore);
    }
  }

  _onResult(int bestScore) {
    state = GameSurvivalState(questionSurvived: state.questionSurvived, bestScore: bestScore);
  }
}

final gameSurvivalProvider =
    StateNotifierProvider<GameSurvivalService, GameSurvivalState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameSurvivalService(socketService);
});
