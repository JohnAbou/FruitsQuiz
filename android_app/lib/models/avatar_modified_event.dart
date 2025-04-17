class AvatarModifiedEvent {
  final String username;
  final String newAvatar;

  AvatarModifiedEvent(this.username, this.newAvatar);

  factory AvatarModifiedEvent.fromJson(Map<String, dynamic> json) {
    return AvatarModifiedEvent(
      json['username'] as String,
      json['newAvatar'] as String,
    );
  }
}
