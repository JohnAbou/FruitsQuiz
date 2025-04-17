class User {
  final String id;
  final String username;
  final String email;
  final List<String> avatarIds;
  final String activeAvatarId;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarIds,
    required this.activeAvatarId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      avatarIds: List<String>.from(json['avatarIds'] ?? []),
      activeAvatarId: json['activeAvatarId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatarIds': avatarIds,
      'activeAvatarId': activeAvatarId,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    List<String>? avatarIds,
    String? activeAvatarId,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarIds: avatarIds ?? this.avatarIds,
      activeAvatarId: activeAvatarId ?? this.activeAvatarId,
    );
  }
}

