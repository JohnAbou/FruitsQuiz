// import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/games/game_current_question_service.dart';
import 'package:android_app/theme/custom_colors.dart';

class QuestionHeader extends ConsumerWidget {
  const QuestionHeader({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(gameCurrentQuestionProvider.select((state) => state.question));
    final questionTotalNumber = ref.watch(gameInfoStateProvider.select((state) => state.quiz.questions.length));
    
    final customColors = Theme.of(context).extension<CustomColors>();
    final backgroundColor = customColors?.buttonBox ?? const Color(0xFF009688);
    
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Question ${question.index + 1}/$questionTotalNumber',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
              child: Text(
                question.text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Right - Points
          Text(
            '${question.points} pts',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}