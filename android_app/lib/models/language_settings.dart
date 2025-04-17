class LanguageResponse {
  final String language;

  LanguageResponse({required this.language});

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(language: json['language']);
  }

  Map<String, dynamic> toJson() {
    return {'language': language};
  }
}

class LanguageUpdateRequest {
  final String language;

  LanguageUpdateRequest({required this.language});

  Map<String, dynamic> toJson() {
    return {'language': language};
  }
}

class LanguageUpdateResponse {
  final String message;
  final String language;

  LanguageUpdateResponse({required this.message, required this.language});

  factory LanguageUpdateResponse.fromJson(Map<String, dynamic> json) {
    return LanguageUpdateResponse(
      message: json['message'],
      language: json['language'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'language': language,
    };
  }
}
