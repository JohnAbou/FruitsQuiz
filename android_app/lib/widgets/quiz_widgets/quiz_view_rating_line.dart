import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/quizzes/quiz_review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizViewRatingLine extends ConsumerStatefulWidget {
  final String quizId;
  final Color? backgroundColor;

  const QuizViewRatingLine({
    super.key,
    required this.quizId,
    this.backgroundColor,
  });

  @override
  ConsumerState<QuizViewRatingLine> createState() => _QuizViewRatingState();
}

class _QuizViewRatingState extends ConsumerState<QuizViewRatingLine> {
  late int reviewCount = 0;
  late double averageScore = 0;
  late QuizReviewService quizReviewService;

  void updateStateCallback(_) => updateState();

  bool isSpecialQuiz() {
    return widget.quizId == '0';
  }

  @override
  void initState() {
    super.initState();
    quizReviewService = ref.read(quizReviewServiceProvider);
    _setupListener();
    updateState();
  }

  @override
  void didUpdateWidget(QuizViewRatingLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quizId == widget.quizId) return;
    quizReviewService.offQuizReviewUpdated(oldWidget.quizId);
    _setupListener();
    updateState();
  }

  void _setupListener() {
    quizReviewService.onQuizReviewUpdated(widget.quizId, updateStateCallback);
  }

  @override
  void dispose() {
    quizReviewService.offQuizReviewUpdated(widget.quizId);
    super.dispose();
  }

  void updateState() {
    if (!isSpecialQuiz()) {
      quizReviewService.getQuizReviewsInfo(widget.quizId).then((value) {
        setState(() {
          reviewCount = value.reviewCount;
          averageScore = value.averageScore;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final effectiveBackgroundColor = Colors.white;

    if (isSpecialQuiz()) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        color: effectiveBackgroundColor,
        child: Text(S.of(context).quiz_view_rating_unrateable),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: effectiveBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            averageScore.toStringAsFixed(1),
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Text('/5'),
          const SizedBox(width: 4),
          Text(
            '($reviewCount ${S.of(context).quiz_view_rating_reviews})',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
