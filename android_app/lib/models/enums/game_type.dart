enum GameType {
  lobbyGame(0),
  normalGame(1),
  survivalGame(2),
  randomGame(3);

  final int value;

  const GameType(this.value);

  static GameType fromValue(int value) {
    return GameType.values
        .firstWhere((type) => type.value == value);
  }
}
