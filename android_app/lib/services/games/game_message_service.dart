import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/models/game_message.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/utils/message_translation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameMessageService {
  final SocketConnectionService socketService;
  final GameInfoService gameInfoService;
  final NotificationService notificationService;

  GameMessageService({required this.socketService, required this.gameInfoService, required this.notificationService}) {
    setUpSocket();
  }

  setUpSocket() {
    socketService.on('sendCorrectionMessage', (value) {
      showMessage(GameMessage.fromJson(value));
    });
  }

  showMessage(GameMessage gameMessage) {
    if (gameInfoService.getGameType() != GameType.normalGame) return;

    var message = getTranslatedMessageWithValues(gameMessage.code, gameMessage.values);
    notificationService.showBottomLeftNotification(message);
  }
}

final gameMessageServiceProvider = Provider<GameMessageService>((ref) {
  var socketService = ref.read(socketConnectionServiceProvider);
  var gameInfoService = ref.read(gameInfoStateProvider.notifier);
  var notificationService = ref.read(notificationServiceProvider);
  return GameMessageService(socketService: socketService, gameInfoService: gameInfoService, notificationService: notificationService);
});
