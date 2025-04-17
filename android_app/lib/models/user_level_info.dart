class UserExperienceInfo {
  final String id;
  final String username;
  final int experience;
  final int level;
  final int expToNextLevel;

  UserExperienceInfo({
    required this.id,
    required this.username,
    required this.experience,
    required this.level,
    required this.expToNextLevel,
  });

  factory UserExperienceInfo.fromJson(Map<String, dynamic> json) {
    return UserExperienceInfo(
      id: json['id'],
      username: json['username'],
      experience: (json['experience'] as num).toInt(),
      expToNextLevel: (json['expToNextLevel'] as num).toInt(),
      level: (json['level'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'experience': experience,
      'level': level,
      'expToNextLevel': expToNextLevel,
    };
  }
}
