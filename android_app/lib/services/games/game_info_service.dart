import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/services/chat_service.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/models/game_info.dart';
import 'package:android_app/states/game_info_state.dart';

final gameInfoStateProvider =
    StateNotifierProvider<GameInfoService, GameInfoState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final chatService = ref.read(chatServiceProvider);
  return GameInfoService(socketService, chatService);
});

class GameInfoService extends BaseGameService<GameInfoState> {
  final ChatService _chatService;

  GameInfoService(SocketConnectionService socketService, this._chatService)
      : super(socketService, const GameInfoState());

  getGameType() {
    return state.gameType;
  }

  @override
  void initializeState() {
    state = const GameInfoState();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('sendGameInfo', (data) {
      _updateGameInfo(GameInfo.fromJson(data));
    });
  }

  void _updateGameInfo(GameInfo gameInfo) {
    state = state.copyWith(
      gameId: gameInfo.gameId,
      quiz: gameInfo.quizToPlay,
      gameType: gameInfo.gameType,
    );
    if (gameInfo.gameType == GameType.survivalGame) return;
    _chatService.joinGameChat(gameInfo.gameId.toString());
  }
}
