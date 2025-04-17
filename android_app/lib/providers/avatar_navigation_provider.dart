import 'package:android_app/models/enums/user_game_state.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final canSafelyNavigateProvider = Provider<bool>((ref) {
  final gameState = ref.watch(gameStateProvider);
  return gameState.userState == UserGameState.none;
});
