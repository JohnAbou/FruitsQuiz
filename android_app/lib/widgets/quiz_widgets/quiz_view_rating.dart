import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/quizzes/quiz_review_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/theme/custom_colors.dart';

class QuizViewRating extends ConsumerStatefulWidget {
  final String quizId;
  final Color? backgroundColor;

  const QuizViewRating({
    super.key,
    required this.quizId,
    this.backgroundColor,
  });

  @override
  ConsumerState<QuizViewRating> createState() => _QuizViewRatingState();
}

class _QuizViewRatingState extends ConsumerState<QuizViewRating> {
  late int reviewCount = 0;
  late double averageScore = 0;
  late QuizReviewService quizReviewService;

  void updateStateCallback(_) => updateState();

  @override
  void initState() {
    super.initState();
    quizReviewService = ref.read(quizReviewServiceProvider);
    _setupListener();
    updateState();
  }

  @override
  void didUpdateWidget(QuizViewRating oldWidget) {
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
    quizReviewService.getQuizReviewsInfo(widget.quizId).then((value) {
      setState(() {
        reviewCount = value.reviewCount;
        averageScore = value.averageScore;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final customColors = Theme.of(context).extension<CustomColors>();
    final effectiveBackgroundColor =
        widget.backgroundColor ?? customColors?.boxColor ?? const Color(0xFFDFFFDE);

    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$reviewCount ${S.of(context).quiz_view_rating_reviews}',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 5),
                Text(
                  averageScore.toStringAsFixed(1),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  '/5',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: -7,
            left: 20,
            child: Container(
              color: effectiveBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                S.of(context).quiz_view_rating_quiz_rating,
                style: TextStyle(
                  fontSize: 14,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
