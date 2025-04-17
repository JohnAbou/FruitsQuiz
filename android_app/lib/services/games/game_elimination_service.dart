import 'package:android_app/generated/l10n.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/widgets/elimination_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameEliminationState {
  final bool isEliminated;
  final String? eliminationReason;

  const GameEliminationState({
    this.isEliminated = false,
    this.eliminationReason,
  });

  GameEliminationState copyWith({
    bool? isEliminated,
    String? eliminationReason,
  }) {
    return GameEliminationState(
      isEliminated: isEliminated ?? this.isEliminated,
      eliminationReason: eliminationReason ?? this.eliminationReason,
    );
  }
}

final gameEliminationStateProvider = StateNotifierProvider<GameEliminationService, GameEliminationState>((ref) {
  return GameEliminationService(
    socketService: ref.read(socketConnectionServiceProvider),
  );
});

final gameEliminationServiceProvider = Provider<GameEliminationService>((ref) {
  return ref.watch(gameEliminationStateProvider.notifier);
});

class GameEliminationService extends StateNotifier<GameEliminationState> {
  final SocketConnectionService socketService;

  GameEliminationService({required this.socketService}) : super(const GameEliminationState()) {
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socketService.on('eliminatePlayer', (data) {
      Future.microtask(() => onRegularElimination(data));
    });
  }

  void onRegularElimination(dynamic reason) {
    int reasonCode = reason is int ? reason : 0;
    if (reasonCode == 0) return;

    String reasonString = "";

    switch (reasonCode) {
      case 1:
        reasonString = S.current.game_elimination_service_wrong_answer;
        break;
      case 2:
        reasonString = S.current.game_elimination_service_last_answer;
        break;
      case 3:
        reasonString = S.current.game_elimination_service_no_answer;
        break;
    }

    state = state.copyWith(
      isEliminated: true,
      eliminationReason: reasonString,
    );
    showEliminationModal(reasonString);
  }

  void showEliminationModal(String message) {
    if (navigatorKey.currentContext == null) return;
    EliminationModal.show(navigatorKey.currentContext!, message);
  }

  void reset() {
    state = const GameEliminationState();
  }
}
