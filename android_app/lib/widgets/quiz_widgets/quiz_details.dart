import 'package:android_app/models/enums/question_type.dart';
import 'package:android_app/services/quizzes/quizzes_services.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_view_rating.dart';
import 'package:flutter/material.dart';
import 'package:android_app/generated/l10n.dart';
import '../../models/quizzes/quiz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_creation_service.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'dart:math' as math;

class QuizDetails extends ConsumerWidget {
  const QuizDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final customColors = theme.extension<CustomColors>();
    final gameCreationService = ref.read(gameCreationServiceProvider);
    final quiz = ref.watch(quizzesStateProvider).selectedQuiz;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Header with back button and title
        Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(emptyQuiz),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            quiz.title,
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            color: primaryColor,
            ),
          ),
        ),
      ],
        ),
        const SizedBox(height: 24),

        // Quiz info grid
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.description, color: primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            quiz.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.quiz, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).quiz_detail_component_nb_questions} ${quiz.questions.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.person, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).quiz_detail_component_creator} ${quiz.owner}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        const SizedBox(width: 16),
            // Right Column
            Expanded(
              child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
                  color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    Row(
                      children: [
                        Icon(Icons.timer, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          '${S.of(context).quiz_detail_component_time_to_respond} ${quiz.duration}s',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
          const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: primaryColor),
                        const SizedBox(width: 8),
                        QuizViewRating(
                          quizId: quiz.id,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Game options
        Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
            color: theme.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
                S.of(context).game_creation_game_options,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Consumer(
                builder: (context, ref, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Entry Price Container
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${S.of(context).game_creation_entry_price}: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: customColors?.sidebarText,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final currentFee = ref.read(gameCreationServiceProvider).entryFee;
                                      ref.read(gameCreationServiceProvider).entryFee = math.max(0, currentFee - 1);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: customColors?.buttonBox ?? Colors.white,
                                      foregroundColor: customColors?.buttonText ?? primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black.withOpacity(0.1),
                                    ),
                                    child: Icon(Icons.remove, size: 24),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Consumer(
                                  builder: (context, ref, _) {
                                    final entryFee = ref.watch(gameCreationServiceProvider).entryFee;
                                    return SizedBox(
                                      width: 72,
                                      height: 48,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: primaryColor,
                                            width: 3,
                                          ),
                                        ),
                                        child: TextFormField(
                                          controller: TextEditingController(text: entryFee.toString()),
                                          textAlign: TextAlign.center,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 12,
                                            ),
                                            isDense: true,
                                          ),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: customColors?.textColor,
                                          ),
                                          onChanged: (value) {
                                            final newValue = int.tryParse(value) ?? 0;
                                            if (newValue >= 0) {
                                              ref.read(gameCreationServiceProvider).entryFee = newValue;
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final currentFee = ref.read(gameCreationServiceProvider).entryFee;
                                      ref.read(gameCreationServiceProvider).entryFee = currentFee + 1;
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: customColors?.buttonBox ?? Colors.white,
                                      foregroundColor: customColors?.buttonText ?? primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black.withOpacity(0.1),
                                    ),
                                    child: Icon(Icons.add, size: 24),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 48,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: customColors?.buttonBox ?? Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final isFriendsOnly = ref.watch(gameCreationServiceProvider).isFriendsOnly;
                                      return PopupMenuButton<bool>(
                                        onSelected: (value) {
                                          ref.read(gameCreationServiceProvider).isFriendsOnly = value;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                isFriendsOnly ? Icons.group : Icons.public,
                                                color: customColors?.buttonText ?? primaryColor,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  isFriendsOnly
                                                      ? S.of(context).game_creation_friends_only
                                                      : S.of(context).game_creation_public,
                                                  style: TextStyle(
                                                    color: customColors?.buttonText ?? primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: customColors?.buttonText ?? primaryColor,
                                                size: 24,
                                              ),
                                            ],
                                          ),
                                        ),
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<bool>>[
                                          PopupMenuItem<bool>(
                                            value: false,
                                            child: Row(
                                              children: [
                                                Icon(Icons.public, size: 24, color: customColors?.buttonText ?? primaryColor),
                                                const SizedBox(width: 8),
                                                Text(
                                                  S.of(context).game_creation_public,
                                                  style: TextStyle(
                                                    color: customColors?.buttonText ?? primaryColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<bool>(
                                            value: true,
                                            child: Row(
                                              children: [
                                                Icon(Icons.group, size: 24, color: customColors?.buttonText ?? primaryColor),
                                                const SizedBox(width: 8),
                                                Text(
                                                  S.of(context).game_creation_friends_only,
                                                  style: TextStyle(
                                                    color: customColors?.buttonText ?? primaryColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final result = gameCreationService.createGame(quiz.id, false);
                                      if (result) {
                                        context.go('/game-view');
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: customColors?.buttonBox ?? Colors.white,
                                      foregroundColor: customColors?.buttonText ?? primaryColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: primaryColor,
                                          width: 3,
                                        ),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.black.withOpacity(0.1),
                                    ),
                                    child: Text(
                                      S.of(context).game_creation_create_game,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: customColors?.buttonText ?? primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Questions expansion panel
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              title: Row(
                children: [
                  Icon(
                    Icons.format_list_bulleted,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${S.of(context).game_creation_question_list} (${quiz.questions.length})',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: primaryColor,
                  width: 4,
                ),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: primaryColor,
                  width: 4,
                ),
              ),
              backgroundColor: Colors.transparent,
              collapsedBackgroundColor: Colors.transparent,
              iconColor: primaryColor,
              collapsedIconColor: primaryColor,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quiz.questions.length,
            itemBuilder: (context, index) {
              final question = quiz.questions[index];
                      return ListTile(
                        leading: Icon(
                          _getQuestionTypeIcon(question.type),
                          color: primaryColor,
                        ),
                        title: Text(
                          '${index + 1}. ${question.text}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                ),
              );
            },
                  ),
          ),
        ],
      ),
          ),
        ),
      ],
    );
  }

  IconData _getQuestionTypeIcon(QuestionType type) {
    switch (type) {
      case QuestionType.qcm:
        return Icons.check_box;  // Multiple choice icon
      case QuestionType.qrl:
        return Icons.subject;    // Long text/paragraph icon
      case QuestionType.qre:
        return Icons.calculate;  // Calculator/numeric icon
      default:
        return Icons.help;      // Default fallback icon
    }
  }
}
