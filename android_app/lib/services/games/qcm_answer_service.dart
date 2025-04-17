import 'package:android_app/services/games/game_player_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/sockets/socket_connection_service.dart';
import 'base_game_service.dart';
import '../../states/qcm_answer_state.dart';
import '../../services/games/game_current_question_service.dart';

final qcmAnswerStateProvider =
    StateNotifierProvider<QcmAnswerService, QcmAnswerState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final gameManagerService = ref.read(gamePlayerServiceProvider);
  final currentQuestionService = ref.read(gameCurrentQuestionProvider.notifier);
  return QcmAnswerService(socketService, gameManagerService, currentQuestionService);
});

final qcmAnswerServiceProvider = Provider<QcmAnswerService>(
    (ref) => ref.watch(qcmAnswerStateProvider.notifier));

class QcmAnswerService extends BaseGameService<QcmAnswerState> {
  final GamePlayerService gameManagerService;
  final GameCurrentQuestionService currentQuestionService;

  QcmAnswerService(
      SocketConnectionService socketService, 
      this.gameManagerService,
      this.currentQuestionService)
      : super(socketService, const QcmAnswerState());

  void toggleAnswerChoice(int buttonId) {
    if (!gameManagerService.state.canSubmitAnswer()) return;

    final newAnswers = List<int>.from(state.selectedAnswers);
    final index = newAnswers.indexOf(buttonId);

    if (index == -1) {
      // Add the answer (no more restrictions)
      newAnswers.add(buttonId);
      state = state.copyWith(selectedAnswers: newAnswers);
      socketService.emit('toggleAnswerChoice', buttonId + 1);
    } else {
      // Always allow deselection
      newAnswers.removeAt(index);
      state = state.copyWith(selectedAnswers: newAnswers);
      socketService.emit('toggleAnswerChoice', buttonId + 1);
    }
  }

  void unselectAnswerChoice(int buttonId) {
    final newAnswers = List<int>.from(state.selectedAnswers);
    final index = newAnswers.indexOf(buttonId);

    if (index != -1) {
      newAnswers.removeAt(index);
      state = state.copyWith(selectedAnswers: newAnswers);
      socketService.emit('toggleAnswerChoice', buttonId + 1);
    }
  }

  @override
  void setUpSocketListener() {
    addSocketListener('questionData', (_) {
      initializeState();
    });

    addSocketListener('correctAnswers', (dynamic answersIndex) {
      state = state.copyWith(
        correctAnswer: List<int>.from(answersIndex as List),
        showCorrectAnswer: true,
      );
    });
  }

  @override
  void initializeState() {
    state = const QcmAnswerState();
  }
}
