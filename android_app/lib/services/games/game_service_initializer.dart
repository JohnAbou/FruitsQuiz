import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/games/game_challenge_service.dart';
import 'package:android_app/services/games/game_current_question_service.dart';
import 'package:android_app/services/games/game_elimination_service.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_joining_service.dart';
import 'package:android_app/services/games/game_leaving_service.dart';
import 'package:android_app/services/games/game_lobby_service.dart';
import 'package:android_app/services/games/game_loot_service.dart';
import 'package:android_app/services/games/game_message_service.dart';
import 'package:android_app/services/games/game_organizer_service.dart';
import 'package:android_app/services/games/game_player_service.dart';
import 'package:android_app/services/games/game_players_service.dart';
import 'package:android_app/services/games/game_results_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/services/games/game_survival_service.dart';
import 'package:android_app/services/games/qcm_answer_service.dart';
import 'package:android_app/services/games/qre_answer_service.dart';
import 'package:android_app/services/games/qrl_answer_service.dart';
import 'package:android_app/services/timer_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameServiceInitializerProvider = Provider<GameServiceInitializer>((ref) {
  return GameServiceInitializer(ref);
});

class GameServiceInitializer {
  final Ref _ref;

  GameServiceInitializer(Ref ref) : _ref = ref {
    final authService = ref.read(authServiceProvider);

    authService.onConnectionSubject.subscribe((username) {
      initializeGameService();
    });
  }

  void initializeGameService() {
    // Making sure the socket events are set up so we dont miss them
    _ref.read(gameInfoStateProvider.notifier);
    _ref.read(gameCurrentQuestionProvider.notifier);
    _ref.read(gameInfoStateProvider.notifier);

    _ref.read(gameJoiningServiceProvider);
    _ref.read(gameLeavingServiceProvider);
    _ref.read(gameLobbyServiceProvider);

    _ref.read(gameOrganizerServiceProvider);
    _ref.read(gamePlayerServiceProvider);

    _ref.read(gamePlayersServiceProvider);
    _ref.read(gameStateServiceProvider);

    _ref.read(qcmAnswerServiceProvider);
    _ref.read(qrlAnswerServiceProvider);
    _ref.read(qreAnswerServiceProvider);

    _ref.read(gameMessageServiceProvider);
    _ref.read(gameSurvivalProvider);
    _ref.read(gameResultProvider);
    _ref.read(gameChallengeServiceProvider);
    _ref.read(gameEliminationServiceProvider);
    _ref.read(gameLootProvider);
  }

  void initializeGameState() {
    _ref.read(gameCurrentQuestionServiceProvider).initializeState();
    _ref.read(gamePlayerServiceProvider).initializeState();
    _ref.read(timerProvider);
  }
}
