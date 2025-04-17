import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/game_info.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/states/game_joining_state.dart';
import 'package:android_app/utils/message_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final gameJoiningStateProvider =
    StateNotifierProvider<GameJoiningService, GameJoiningState>((ref) {
  final socket = ref.read(socketConnectionServiceProvider);
  final authService = ref.read(authServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  return GameJoiningService(socket, authService, notificationService);
});

final gameJoiningServiceProvider = Provider<GameJoiningService>((ref) {
  return ref.read(gameJoiningStateProvider.notifier);
});

class GameJoiningService extends BaseGameService<GameJoiningState> {
  final AuthService _authservice;
  final NotificationService _notificationService;

  GameJoiningService(SocketConnectionService socket, this._authservice, this._notificationService)
      : super(socket, GameJoiningState()) {
    _loadGameInfos();
  }

  @override
  void initializeState() {
    state = GameJoiningState();
    _loadGameInfos();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('gameInfoChangedNotification', _updateGameInfos);
  }

  void joinGame(int gameId, BuildContext context) {
    final GameInfo game =
        state.allGames.firstWhere((game) => game.gameId == gameId);
    if (game == null) {
      _notificationService.showBottomLeftNotification(getTranslatedMessage(10016));
      return;
    }

    if (game.entryFee == 0) {
      socketService.emitWithAck('joinGameLobby', (response) {
        _onJoinGameLobbyResponse(response, context);
      }, {'gameId': gameId, 'sessionId': _authservice.state.sessionId});
      return;
    }

    openJoinGameDialog(context, gameId, game.entryFee);
  }

  void openJoinGameDialog(BuildContext context, int gameId, int entryFee) {
    _notificationService.showConfirmationCardPopup(
      message: S.of(context).game_joining_pay_to_join(entryFee),
      onConfirm: () {
        socketService.emitWithAck('joinGameLobby', (response) {
          _onJoinGameLobbyResponse(response, context);
        }, {
          'gameId': gameId,
          'sessionId': _authservice.state.sessionId
        });
      },
      onCancel: () {},
    );
  }

  void _onJoinGameLobbyResponse(dynamic response, BuildContext context) {
    final bool success = response['success'] ?? false;
    final int messageCode = response['code'] ?? -1;

    if (success) {
      context.go('/game-view');
    } else {
      _notificationService.showBottomLeftNotification(getTranslatedMessage(messageCode));
    }
  }

  void _loadGameInfos() {
    socketService.emitWithAck('getGamesInfo', _updateGameInfos);
  }

  void _updateGameInfos(dynamic response) {
    final games = (response as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map((json) => GameInfo.fromJson(json))
        .toList();

    state = state.copyWith(allGames: games);
    _applyFilter();
  }

  void _applyFilter() {
    final filtered = state.allGames.where((game) {
      final gameId = game.gameId.toString().toLowerCase();
      return gameId.contains(state.filter.toLowerCase());
    }).toList();

    state = state.copyWith(filteredGames: filtered);
  }
}
