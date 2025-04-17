enum QuestionType {
  qcm('QCM'),
  qrl('QRL'),
  qre('QRE'),
  undefined('Undefined');

  final String value;
  const QuestionType(this.value);

  static QuestionType fromString(String value) {
    return QuestionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => QuestionType.undefined,
    );
  }
}
