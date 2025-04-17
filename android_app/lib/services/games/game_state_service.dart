import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../states/game_state.dart';
import '../../models/enums/user_game_state.dart';
import '../../services/sockets/socket_connection_service.dart';

final gameStateProvider =
    StateNotifierProvider<GameStateService, GameState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameStateService(socketService);
});

final gameStateServiceProvider =
    Provider<GameStateService>((ref) => ref.read(gameStateProvider.notifier));


class GameStateService extends BaseGameService<GameState> {
  GameStateService(SocketConnectionService socketService)
      : super(socketService, const GameState());

  @override
  void initializeState() {
    state = const GameState();
  }

  void setState(UserGameState userState) {
    state = state.copyWith(userState: userState);
  }

  void setRole(UserGameRole userRole) {
    state = state.copyWith(userRole: userRole);
  }

  UserGameState getCurrentState() {
    return state.userState;
  }

    @override
  void setUpSocketListener() {
    addSocketListener('updateGameState', (dynamic state) {
      setState(UserGameState.fromValue(state as int));
    });

    addSocketListener('updateGameRole', (dynamic state) {
      setRole(UserGameRole.fromValue(state as int));
    });
  }
}
