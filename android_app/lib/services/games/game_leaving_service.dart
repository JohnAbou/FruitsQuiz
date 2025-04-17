import 'package:android_app/models/enums/user_game_state.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/utils/message_translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/sockets/socket_connection_service.dart';
import '../../services/chat_service.dart';
import 'base_game_service.dart';

final gameLeavingServiceProvider = Provider<GameLeavingService>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final authService = ref.read(authServiceProvider);
  final chatService = ref.read(chatServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  return GameLeavingService(socketService, authService, chatService, notificationService);
});

final canSafelyLeaveGameProvider = Provider<bool>((ref) {
  final gameState = ref.watch(gameStateProvider);
  return gameState.userState == UserGameState.leaderboard || gameState.userState == UserGameState.none;
});

class GameLeavingService extends BaseGameService<void> {
  final AuthService authService;
  final ChatService chatService;
  final NotificationService notificationService;

  GameLeavingService(
    SocketConnectionService socketService,
    this.authService,
    this.chatService,
    this.notificationService
  ) : super(socketService, null) {
    authService.onDisconnectionSubject.subscribe(leaveGame);
  }

  void leaveGame([String reason = ""]) {
    socketService.emit('playerLeftGame');
  }

  @override
  void dispose() {
    authService.onDisconnectionSubject.unsubscribe(leaveGame);
    super.dispose();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('kickedOutFromGame', _playerRemoved);
  }

  void _playerRemoved(dynamic reason) {
    _updateService();
    if (reason == null || reason == 0) return;
    
    navigatorKey.currentContext?.go('/home');

    notificationService.showInformationCardPopup(message: getTranslatedMessage(reason));
  }

  void _updateService() {
    chatService.leaveGameChat();
  }

  @override
  void initializeState() {}
}
