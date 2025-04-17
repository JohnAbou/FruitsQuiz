class UserPreferences {
  String theme;
  String background;
  String language;

  UserPreferences({
    this.theme = 'lemon-theme',
    this.background = 'none',
    this.language = 'fr',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'] ?? 'lemon-theme',
      background: json['background'] ?? 'none',
      language: json['language'] ?? 'fr',
    );
  }
}