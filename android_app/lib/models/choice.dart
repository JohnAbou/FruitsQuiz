class Choice {
  final String text;
  final bool isCorrect;

  const Choice({
    required this.text,
    required this.isCorrect,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      text: json['text'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }
}