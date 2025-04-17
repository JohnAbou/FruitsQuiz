import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/models/enums/user_game_state.dart';

class GameState {
  final UserGameState userState;
  final UserGameRole userRole;

  const GameState({
    this.userState = UserGameState.none,
    this.userRole = UserGameRole.none,
  });

  GameState copyWith({
    UserGameState? userState,
    UserGameRole? userRole,
  }) {
    return GameState(
      userState: userState ?? this.userState,
      userRole: userRole ?? this.userRole,
    );
  }
}