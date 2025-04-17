enum UserGameState {
  none,
  inLobby,
  inGame,
  intermission,
  loading,
  leaderboard,
  correction,
  attemptingToJoin;

  int get value => index;

  static UserGameState fromValue(int value) {
    return UserGameState.values[value];
  }
}