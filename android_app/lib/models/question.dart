import 'package:android_app/models/choice.dart';
import 'package:android_app/models/enums/question_type.dart';
import 'package:android_app/models/estimations.dart';

class Question {
  final String id;
  final String text;
  final int points;
  final QuestionType type;
  final List<Choice> choices;
  final String? answer;
  final Estimations? estimations;
  final String? imageId;

  const Question({
    this.id = '',
    this.text = '',
    this.points = 0,
    this.type = QuestionType.undefined,
    this.choices = const [],
    this.answer,
    this.estimations,
    this.imageId,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      points: json['points'] as int,
      type: QuestionType.fromString(json['type'] as String),
      choices: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice as Map<String, dynamic>))
          .toList(),
      answer: json['answer'] as String?,
      estimations: json['estimations'] != null
          ? Estimations.fromJson(json['estimations'] as Map<String, dynamic>)
          : null,
      imageId: json['imageId'] as String?,
    );
  }
}

class QuestionWithIndex extends Question {
  final int index;

  const QuestionWithIndex({
    this.index = 0,
    super.id = '',
    super.text = '',
    super.points = 0,
    super.type = QuestionType.undefined,
    super.choices = const [],
    super.answer,
    super.estimations,
    super.imageId,
  });

  factory QuestionWithIndex.fromJson(Map<String, dynamic> json) {
    return QuestionWithIndex(
      id: json['id'] as String,
      text: json['text'] as String,
      points: json['points'] as int,
      type: QuestionType.fromString(json['type'] as String),
      choices: (json['choices'] as List)
          .map((choice) => Choice.fromJson(choice as Map<String, dynamic>))
          .toList(),
      answer: json['answer'] as String?,
      index: json['index'] as int,
      estimations: json['estimations'] != null
          ? Estimations.fromJson(json['estimations'] as Map<String, dynamic>)
          : null,
      imageId: json['imageId'] as String?,
    );
  }
}
