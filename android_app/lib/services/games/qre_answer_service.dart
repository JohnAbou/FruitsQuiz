import 'package:android_app/services/games/game_player_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/sockets/socket_connection_service.dart';
import 'base_game_service.dart';
import '../../states/qre_answer_state.dart';

final qreAnswerStateProvider =
    StateNotifierProvider<QreAnswerService, QreAnswerState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final gameManagerService = ref.read(gamePlayerServiceProvider);
  return QreAnswerService(socketService, gameManagerService);
});

final qreAnswerServiceProvider = Provider<QreAnswerService>(
    (ref) => ref.watch(qreAnswerStateProvider.notifier));

class QreAnswerService extends BaseGameService<QreAnswerState> {
  final GamePlayerService gameManagerService;

  QreAnswerService(
      SocketConnectionService socketService, this.gameManagerService)
      : super(socketService, const QreAnswerState());

  void submitAnswer() {
    if (!gameManagerService.state.canSubmitAnswer()) return;

    gameManagerService.submitAnswers();
  }

  void updateNumericAnswer(int value) {
    if (!gameManagerService.state.canSubmitAnswer()) return;

    if (state.userAnswer != value) {
      state = state.copyWith(userAnswer: value);
      gameManagerService.updateNumericAnswer(value);
    }
  }

  @override
  void setUpSocketListener() {
    addSocketListener('questionData', (_) {
      initializeState();
    });

    addSocketListener('correctAnswers', (dynamic answer) {
      if (answer is! int) return;
      state = state.copyWith(
        correctAnswer: answer,
        showCorrectAnswer: true,
      );
    });
  }

  @override
  void initializeState() {
    state = const QreAnswerState();
  }
}
