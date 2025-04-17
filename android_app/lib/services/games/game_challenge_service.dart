import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/states/game_challenge_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameChallengeStateProvider =
    StateNotifierProvider<GameChallengeService, GameChallengeState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameChallengeService(socketService);
});

final gameChallengeServiceProvider = Provider<GameChallengeService>(
    (ref) => ref.read(gameChallengeStateProvider.notifier));

class GameChallengeService extends BaseGameService<GameChallengeState> {
  GameChallengeService(SocketConnectionService socketService)
      : super(socketService, const GameChallengeState(code: 0, price: 0));

  @override
  void initializeState() {
    state = const GameChallengeState(code: 0, price: 0);
  }

  @override
  void setUpSocketListener() {
    addSocketListener('sendChallenge', (data) {
      if (data is Map<String, dynamic>) {
        state = state.copyWith(
          code: data['code'] as int,
          price: data['price'] as int,
        );
      }
    });

    addSocketListener('sendChallengeResult', (data) {
      if (data is Map<String, dynamic>) {
        state = state.copyWith(
          success: data['success'] as bool,
        );
      }
    });
  }
} 