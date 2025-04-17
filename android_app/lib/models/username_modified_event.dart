class UsernameModifiedEvent {
  final String oldUsername;
  final String newUsername;

  UsernameModifiedEvent(this.newUsername, this.oldUsername);

  factory UsernameModifiedEvent.fromJson(Map<String, dynamic> json) {
    return UsernameModifiedEvent(
      json['newUsername'] as String,
      json['oldUsername'] as String,
    );
  }
}
