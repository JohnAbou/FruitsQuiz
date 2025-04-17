class GameMessage {
  final int code;
  final Map<String, dynamic> values;

  GameMessage({required this.code, required this.values});

  factory GameMessage.fromJson(Map<String, dynamic> json) {
    return GameMessage(
      code: json['code'] as int,
      values: json['values'] as Map<String, dynamic>,
    );
  }
}
