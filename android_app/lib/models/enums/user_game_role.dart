enum UserGameRole {
  player,
  organizer,
  observer,
  none;

  int get value => index;

  static UserGameRole fromValue(int value) {
    return UserGameRole.values[value];
  }
}