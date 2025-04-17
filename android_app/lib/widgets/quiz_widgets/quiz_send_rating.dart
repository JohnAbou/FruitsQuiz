import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/quizzes/quiz_review.dart';
import 'package:android_app/services/quizzes/quiz_review_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizSendRating extends ConsumerStatefulWidget {
  final String quizId;
  final Color? backgroundColor;

  const QuizSendRating({
    super.key,
    required this.quizId,
    this.backgroundColor,
  });

  @override
  ConsumerState<QuizSendRating> createState() => _QuizSendRatingsState();
}

class _QuizSendRatingsState extends ConsumerState<QuizSendRating> {
  late int score = 0;
  late bool hasReviewed = false;
  final List<int> hearts = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
    final quizReviewService = ref.read(quizReviewServiceProvider);
    quizReviewService.getQuizReview(widget.quizId).then((value) {
      if (value.score == -1) return;
      setState(() {
        hasReviewed = true;
        score = value.score;
      });
    });
  }

  void rateQuiz(int value) {
    if (score >= value) {
      value -= 1;
    }
    setState(() {
      score = value;
      hasReviewed = true;
    });
    final QuizReview review = QuizReview(quizId: widget.quizId, score: score);
    ref.read(quizReviewServiceProvider).addQuizReview(widget.quizId, review);
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final effectivePrimaryColor = Theme.of(context).colorScheme.primary;
    final effectiveBackgroundColor = widget.backgroundColor ?? customColors?.boxColor ?? const Color(0xFFDFFFDE);

    return Container(
      margin: const EdgeInsets.all(20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: effectivePrimaryColor, width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Hearts (favorites icons)
                ...hearts.map((heart) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => rateQuiz(heart),
                        child: Icon(
                          Icons.favorite,
                          color: heart <= score ? effectivePrimaryColor : Colors.grey,
                          size: 28,
                        ),
                      ),
                    )),
                const SizedBox(width: 15),
                // Rating display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      score.toString(),
                      style: TextStyle(
                        color: effectivePrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Text(
                      '/5',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Floating title
          Positioned(
            top: -7,
            left: 20,
            child: Container(
              color: effectiveBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                hasReviewed
                    ? S.of(context).quiz_send_rating_update_rating
                    : S.of(context).quiz_send_rating_rate_quiz,
                style: TextStyle(
                  fontSize: 14,
                  color: effectivePrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
