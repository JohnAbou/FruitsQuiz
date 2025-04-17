import 'dart:convert';

import 'package:android_app/models/enums/qrl_answer_to_correct.dart';
import 'package:android_app/services/games/base_game_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/states/game_organizer_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameOrganizerStateProvider =
    StateNotifierProvider<GameOrganizerService, GameOrganizerState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameOrganizerService(socketService);
});

final gameOrganizerServiceProvider = Provider<GameOrganizerService>(
    (ref) => ref.read(gameOrganizerStateProvider.notifier));

class GameOrganizerService extends BaseGameService<GameOrganizerState> {
  GameOrganizerService(SocketConnectionService socketService)
      : super(socketService, const GameOrganizerState());

  void goToNextQuestion() {
    socketService.emit('goToNextQuestion');
    state = state.copyWith(
      canGoToNextQuestion: false,
    );
  }

  void scoreAnswer(double score) {
    state = state.scoreAnswer(score);
    if (state.correctedAnswerIndex >= state.answersToCorrect.length) {
      socketService.emit(
          'sendAnswersCorrected', jsonEncode(state.answersToCorrect));
    }
  }

  void addBot() {
    socketService.emit('addBot');
  }

  @override
  void initializeState() {
    state = const GameOrganizerState();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('canGoToNextquestionEvent', (_) {
      state = state.copyWith(canGoToNextQuestion: true);
    });

    addSocketListener('sendAnswersToCorrect', (data) {
      final answersToCorrect = (data as List)
          .map((item) => QrlAnswerToCorrect.fromJson(item))
          .toList();
      state = state.copyWith(
          answersToCorrect: answersToCorrect, correctedAnswerIndex: 0);
    });
  }
}
