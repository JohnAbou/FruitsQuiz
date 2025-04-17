import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/game_organizer_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_player_service.dart';
import 'package:android_app/services/games/qrl_answer_service.dart';
import 'package:android_app/generated/l10n.dart';

class QrlAnswer extends ConsumerWidget {
  const QrlAnswer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(gameStateProvider.select((state) => state.userRole));
    final qrlAnswerState = ref.watch(qrlAnswerStateProvider);
    final correctionState = qrlAnswerState.correctionState;

    if (correctionState == 2) {
      return role == UserGameRole.player
          ? const PlayerCorrectionCard()
          : const OrganizerCorrectionCard();
    }
    
    if (correctionState == 1) {
      return LongAnswerTextArea(
        isInteractive: role == UserGameRole.player,
        defaultText: role == UserGameRole.player 
            ? "" 
            : S.of(context).game_organizer_waiting_answers,
      );
    }
    
    if (correctionState == 3) {
      return const CompletionMessage();
    }
    
    return const SizedBox();
  }
}

class PlayerCorrectionCard extends ConsumerWidget {
  const PlayerCorrectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final customColors = Theme.of(context).extension<CustomColors>();
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            width: double.infinity,
            child: Text(
              S.of(context).game_player_waiting_correction_title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: customColors?.boxColor ?? const Color(0xFFB3D9B3),
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                S.of(context).organizer_correcting,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrganizerCorrectionCard extends ConsumerWidget {
  const OrganizerCorrectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answerToCorrect = ref.watch(gameOrganizerStateProvider
        .select((state) => state.getCurrentAnswerToCorrect()));
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final customColors = Theme.of(context).extension<CustomColors>();
    
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            width: double.infinity,
            child: Text(
              S.of(context).game_organizer_correcting_answers,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Answer text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: customColors?.boxColor ?? const Color(0xFFB3D9B3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      answerToCorrect.answer,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Score buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreButton(
                      ref, 
                      "100%", 
                      1.0, 
                      const Color(0xFF4CAF50)
                    ),
                    _buildScoreButton(
                      ref, 
                      "50%", 
                      0.5, 
                      const Color(0xFFFF9800)
                    ),
                    _buildScoreButton(
                      ref, 
                      "0%", 
                      0.0, 
                      const Color(0xFFF44336)
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreButton(WidgetRef ref, String label, double score, Color color) {
    return ElevatedButton(
      onPressed: () => ref.read(gameOrganizerServiceProvider).scoreAnswer(score),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(80, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class LongAnswerTextArea extends ConsumerStatefulWidget {
  final bool isInteractive;
  final int maxCharacters;
  final String defaultText;

  const LongAnswerTextArea({
    super.key,
    required this.isInteractive,
    this.maxCharacters = 200,
    this.defaultText = "",
  });

  @override
  ConsumerState<LongAnswerTextArea> createState() => _LongAnswerTextAreaState();
}

class _LongAnswerTextAreaState extends ConsumerState<LongAnswerTextArea> {
  int currentLength = 0;
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    if (!widget.isInteractive && widget.defaultText.isNotEmpty) {
      textController.text = widget.defaultText;
    }
    
    textController.addListener(() {
      setState(() {
        currentLength = textController.text.length;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = ref.read(gamePlayerServiceProvider);
    final gameState = ref.watch(gamePlayerStateProvider);
    
    bool canSubmitAnswer = widget.isInteractive && !gameState.hasSubmittedAnswer;
    final customColors = Theme.of(context).extension<CustomColors>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: textController,
              maxLength: widget.maxCharacters,
              maxLines: null,
              expands: true,
              enabled: canSubmitAnswer,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: S.of(context).enter_answer,
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: customColors?.boxColor ?? const Color(0xFFB3D9B3),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: customColors?.boxColor ?? const Color(0xFFB3D9B3),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              onChanged: (value) {
                if (canSubmitAnswer) {
                  gameManager.updateAnswerResponse(value);
                }
              },
            ),
          ),
          if (widget.isInteractive)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                '$currentLength/${widget.maxCharacters}',
                style: TextStyle(
                  color: customColors?.textColor ?? const Color(0xFF2F4F2F),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}

class CompletionMessage extends StatelessWidget {
  const CompletionMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        S.of(context).qrl_correction_finished,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
