import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/models/enums/question_type.dart';
import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/game_current_question_service.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_players_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/widgets/answer_widgets/qcm_answer.dart';
import 'package:android_app/widgets/answer_widgets/qre_answer.dart';
import 'package:android_app/widgets/answer_widgets/qrl_answer.dart';
import 'package:android_app/widgets/answer_widgets/submit_answer_button.dart';
import 'package:android_app/widgets/continue_game_button.dart';
import 'package:android_app/widgets/game_buy_hint_widget.dart';
import 'package:android_app/widgets/game_player_list.dart';
import 'package:android_app/widgets/game_score.dart';
import 'package:android_app/widgets/organizer_timer.dart';
import 'package:android_app/widgets/question_header.dart';
import 'package:android_app/widgets/survival_mode_progression.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/widgets/timer.dart';
import 'package:android_app/widgets/question_image_widget.dart';


class GamePlayPage extends ConsumerWidget {
  const GamePlayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));
    final isOrganizer = userRole == UserGameRole.organizer;

    final gameType =
        ref.watch(gameInfoStateProvider.select((state) => state.gameType));
    final isNormalGame = gameType == GameType.normalGame;
    final isSurvivalGame = gameType == GameType.survivalGame;

    final questionState = ref.watch(
        gameCurrentQuestionProvider.select((state) => state.question.type));

    final imageUrl = ref.watch(questionImageUrlProvider);
    final hintAvailable = ref.watch(hintAvailableProvider);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuestionHeader(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Timer and controls
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (isOrganizer) ? OrganizerTimer() : Timer(),
                        const SizedBox(height: 16),
                        (isOrganizer) ? ContinueGameButton() : GameScore(),
                        if (userRole == UserGameRole.player && hintAvailable)
                          Container(
                            margin: const EdgeInsets.only(top: 16),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            child: GameBuyHintWidget(),
                          ),
                      ],
                    ),
                  ),
                ),
                // Center - Question content
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Image section - fixed height
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.20,
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        child: imageUrl.isNotEmpty
                            ? QuestionImageWidget(imageUrl: imageUrl)
                            : const SizedBox(), // Empty container when no image
                      ),
                      // Answer section - fixed height with scrolling if needed
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.35,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (questionState == QuestionType.qcm) QcmAnswer(),
                              if (questionState == QuestionType.qrl) QrlAnswer(),
                              if (questionState == QuestionType.qre) QreAnswer(),
                            ],
                          ),
                        ),
                      ),
                      // Submit button section - fixed position
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.20,
                        alignment: Alignment.topCenter,
                        child: userRole == UserGameRole.player
                            ? SubmitButton()
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
                // Right side - Player list or survival progress
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: isSurvivalGame
                      ? SurvivalModeProgression()
                      : GamePlayerList(
                          showScore: isNormalGame,
                          showRound: !isNormalGame,
                          sortFunction: isNormalGame
                              ? scoreSortFunction
                              : roundSortFunction,
                          banOption: isOrganizer,
                          displayHeader: true,
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
