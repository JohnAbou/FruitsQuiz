class Estimations {
  final num exactValue;
  final num lowerBound;
  final num upperBound;
  final num toleranceMargin;

  const Estimations({
    required this.exactValue,
    required this.lowerBound,
    required this.upperBound,
    required this.toleranceMargin,
  });

  factory Estimations.fromJson(Map<String, dynamic> json) {
    return Estimations(
      exactValue: json['exactValue'] as num,
      lowerBound: json['lowerBound'] as num,
      upperBound: json['upperBound'] as num,
      toleranceMargin: json['toleranceMargin'] as num,
    );
  }
}
