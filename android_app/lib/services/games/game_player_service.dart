import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/states/game_player_state.dart';
import 'package:android_app/utils/show_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/sockets/socket_connection_service.dart';
import 'base_game_service.dart';

final gamePlayerStateProvider =
    StateNotifierProvider<GamePlayerService, GamePlayerState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  return GamePlayerService(socketService, notificationService);
});

final gamePlayerServiceProvider = Provider<GamePlayerService>(
    (ref) => ref.read(gamePlayerStateProvider.notifier));

class GamePlayerService extends BaseGameService<GamePlayerState> {
  final NotificationService notificationService;

  GamePlayerService(SocketConnectionService socketService, this.notificationService)
  : super(socketService, const GamePlayerState());

  void updateHasSubmittedAnswer(bool hasSubmitted) {
    state = state.copyWith(hasSubmittedAnswer: hasSubmitted);
  }

  void submitAnswers() {
    updateHasSubmittedAnswer(true);
    notificationService.showBottomLeftNotification(S.current.game_message_answers_sent);
    socketService.emit('submitAnswers');
    state = state.copyWith(hintUsable: false);
  }
  
  void updateNumericAnswer(int answer) {
    socketService.emit('updateNumericAnswer', answer);
  }

  void updateAnswerResponse(String response) {
    socketService.emit('updateAnswerResponse', response);
  }

  void buyHint() {
    socketService.emit('buyHint');
    state = state.copyWith(hintUsable: false);
  }

  @override
  void setUpSocketListener() {
    addSocketListener('questionData', (_) {
      state = state.copyWith(hasSubmittedAnswer: false);
    });

    addSocketListener('updateScore', (dynamic score) {
      state = state.copyWith(currentScore: score as int);
    });

    addSocketListener('eliminatePlayer', (_) {
      state = state.copyWith(isEliminated: true);
    });

    addSocketListener('correctAnswers', (_) {
      updateHasSubmittedAnswer(true);
    });

    addSocketListener('sendHint', (index) {
      state = state.copyWith(receivedHint: index - 1);
    });

    addSocketListener('gameHintCost', (cost) {
      state = state.copyWith(hintCost: cost as int);
    });

    addSocketListener('questionData', (_) {
      state = state.copyWith(receivedHint: -1, hintUsable: true);
    });
  }

  @override
  void initializeState() {
    state = const GamePlayerState();
  }
}
