import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/game_player_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/games/game_current_question_service.dart';
import '../../services/games/qcm_answer_service.dart';

class QcmAnswer extends ConsumerWidget {
  const QcmAnswer({super.key});

  Widget _buildAnswerButton({
    required UserGameRole role,
    required WidgetRef ref,
    required int index,
    required double size,
    required String text,
  }) {
    return (role == UserGameRole.player)
        ? _buildInteractiveAnswerButton(
            ref: ref, index: index, size: size, text: text)
        : _buildUninteraciveAnswerButton(
            ref: ref, index: index, size: size, text: text);
  }

  Widget _buildInteractiveAnswerButton({
    required WidgetRef ref,
    required int index,
    required double size,
    required String text,
  }) {
    final isCorrected = ref.watch(qcmAnswerStateProvider
        .select((state) => state.isAnswerCorrected(index)));

    final isSelected = ref.watch(qcmAnswerStateProvider
        .select((state) => state.isAnswerSelected(index)));

    final isHinted = ref.watch(
        gamePlayerStateProvider.select((state) => state.receivedHint == index));

    final theme = Theme.of(ref.context);
    final primaryColor = theme.colorScheme.primary;
    final customColors = theme.extension<CustomColors>();
    final accentColor = customColors?.accentColor ?? primaryColor;
    final textColor = customColors?.textColor ?? Colors.black;

    return SizedBox(
      width: size,
      height: size * 0.8,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(8),
          backgroundColor: isCorrected
              ? Colors.green
              : isSelected
                  ? accentColor.withOpacity(0.8)
                  : Colors.white,
          foregroundColor:
              (isCorrected || isSelected) ? Colors.white : textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: isCorrected
                  ? Colors.green
                  : isSelected
                      ? accentColor
                      : Colors.grey.shade300,
              width: 3,
            ),
          ),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        onPressed: !isHinted
            ? () => ref.read(qcmAnswerServiceProvider).toggleAnswerChoice(index)
            : null,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '${index + 1}. $text',
            style: TextStyle(
              fontSize: size * 0.1,
              fontWeight: FontWeight.bold,
              color: (isCorrected || isSelected) ? Colors.white : textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildUninteraciveAnswerButton({
    required WidgetRef ref,
    required int index,
    required double size,
    required String text,
  }) {
    final isCorrected = ref.watch(qcmAnswerStateProvider
        .select((state) => state.isAnswerCorrected(index)));

    final theme = Theme.of(ref.context);
    final customColors = theme.extension<CustomColors>();
    final textColor = customColors?.textColor ?? Colors.black;

    return SizedBox(
      width: size,
      height: size * 0.8, // Reduced height for better proportions
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isCorrected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isCorrected ? Colors.green : Colors.grey.shade300,
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
        child: Container(
          alignment: Alignment.center,
          child: Text(
            '${index + 1}. $text',
            style: TextStyle(
              fontSize: size * 0.1,
              fontWeight: FontWeight.bold,
              color: isCorrected ? Colors.white : textColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref
        .watch(gameCurrentQuestionProvider.select((state) => state.question));
    final gameRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));

    ref.listen(gamePlayerStateProvider.select((state) => state.receivedHint),
        (previous, next) {
      ref.read(qcmAnswerServiceProvider).unselectAnswerChoice(next);
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = screenWidth * 0.1;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.25,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 6, // Reduced from 8
          crossAxisSpacing: 6, // Reduced from 8
          childAspectRatio: 1.3, // Slightly increased for more compact height
          padding: EdgeInsets.zero, // Remove padding
          children: List.generate(
            question.choices.length,
            (index) => _buildAnswerButton(
              role: gameRole,
              ref: ref,
              index: index,
              size: buttonSize,
              text: question.choices[index].text,
            ),
          ),
        ),
      ),
    );
  }
}
