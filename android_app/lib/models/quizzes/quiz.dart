import 'package:android_app/models/question.dart';

class Quiz {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int duration;
  final bool isPublic;
  final String owner;

  const Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.duration,
    required this.isPublic,
    required this.owner,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] as int,
      isPublic: json['isPublic'] as bool,
      owner: json['owner'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Quiz) return false;
    return id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}
