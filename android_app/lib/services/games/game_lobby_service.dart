import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameLobbyStateProvider =
    StateNotifierProvider<GameLobbyService, GameLobbyState>((ref) {
  return GameLobbyService(ref.read(socketConnectionServiceProvider));
});

final gameLobbyServiceProvider = Provider<GameLobbyService>((ref) {
  return ref.read(gameLobbyStateProvider.notifier);
});

class GameLobbyState {
  final bool isLobbyLocked;
  final bool canStartGame;

  const GameLobbyState({
    this.isLobbyLocked = false,
    this.canStartGame = false,
  });

  GameLobbyState copyWith({
    bool? isLobbyLocked,
    bool? canStartGame,
  }) {
    return GameLobbyState(
      isLobbyLocked: isLobbyLocked ?? this.isLobbyLocked,
      canStartGame: canStartGame ?? this.canStartGame,
    );
  }
}

class GameLobbyService extends BaseGameService<GameLobbyState> {
  GameLobbyService(SocketConnectionService socketService)
      : super(socketService, const GameLobbyState());

  void toggleLobbyLock() {
    socketService.emitWithAck('toggleLock', (isLocked) {
      state = state.copyWith(isLobbyLocked: isLocked);
    });
  }

  void addBot() {
    socketService.emit('addBot');
  }

  void updateBotDifficulty(String botName, String difficulty) {
    socketService.emit('updateBotDifficulty',
        {'playerName': botName, 'difficulty': difficulty});
  }

  void startGame() {
    socketService.emit('startGame');
  }

  void banPlayer(String playerName) {
    socketService.emit('banPlayer', playerName);
  }

  @override
  void initializeState() {
    state = const GameLobbyState();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('canStartGame', (canStart) {
      state = state.copyWith(canStartGame: canStart);
    });
  }
}
