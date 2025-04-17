import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/sockets/socket_connection_service.dart';
import '../../states/qrl_answer_state.dart';
import 'base_game_service.dart';

final qrlAnswerStateProvider =
    StateNotifierProvider<QrlAnswerService, QrlAnswerState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return QrlAnswerService(socketService);
});

final qrlAnswerServiceProvider = Provider<QrlAnswerService>(
    (ref) => ref.watch(qrlAnswerStateProvider.notifier));

class QrlAnswerService extends BaseGameService<QrlAnswerState> {
  QrlAnswerService(SocketConnectionService socketService)
      : super(socketService, const QrlAnswerState());

  @override
  void setUpSocketListener() {
    addSocketListener('questionData', (data) {
      state = const QrlAnswerState(correctionState: 1);
    });

    addSocketListener('qrlCorrectionStarted', (_) {
      state = const QrlAnswerState(correctionState: 2);
    });

    addSocketListener('qrlCorrectionFinished', (_) {
      state = const QrlAnswerState(correctionState: 3);
    });
  }

  @override
  void initializeState() {
    state = const QrlAnswerState();
  }
}
