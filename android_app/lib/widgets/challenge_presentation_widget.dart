import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/games/game_challenge_service.dart';
import 'package:android_app/states/game_challenge_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChallengePresentationWidget extends ConsumerWidget {
  const ChallengePresentationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeState = ref.watch(gameChallengeStateProvider);

    if (challengeState.code == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: _buildChallengeContent(context, challengeState),
    );
  }

  Widget _buildChallengeContent(BuildContext context, GameChallengeState state) {
    switch (state.code) {
      case 1:
        return _buildAnswerStreakChallenge(context, state);
      case 2:
        return _buildFastestChallenge(context, state);
      case 3:
        return _buildBonusCollectorChallenge(context, state);
      case 4:
      case 5:
      case 6:
        return _buildQuestionMasterChallenge(context, state);
      case 7:
        return _buildNeverLastChallenge(context, state);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildChallengeHeader(BuildContext context, String title, int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          S.of(context).challenge_price(price),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeStatus(BuildContext context, bool? success, String successText, String failureText) {
    if (success == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: success 
          ? Colors.green.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text(
            success ? "✓" : "✗",
            style: TextStyle(
              color: success ? Colors.green[800] : Colors.red[800],
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              success ? successText : failureText,
              style: TextStyle(
                color: success ? Colors.green[800] : Colors.red[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeDescription(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        description,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildAnswerStreakChallenge(BuildContext context, GameChallengeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChallengeHeader(context, S.of(context).challenge_answer_streak_title, state.price),
        _buildChallengeDescription(context, S.of(context).challenge_answer_streak_description),
        _buildChallengeStatus(
          context,
          state.success,
          S.of(context).challenge_answer_streak_success,
          S.of(context).challenge_answer_streak_failure,
        ),
      ],
    );
  }

  Widget _buildFastestChallenge(BuildContext context, GameChallengeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChallengeHeader(context, S.of(context).challenge_fastest_title, state.price),
        _buildChallengeDescription(context, S.of(context).challenge_fastest_description),
        _buildChallengeStatus(
          context,
          state.success,
          S.of(context).challenge_fastest_success,
          S.of(context).challenge_fastest_failure,
        ),
      ],
    );
  }

  Widget _buildBonusCollectorChallenge(BuildContext context, GameChallengeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChallengeHeader(context, S.of(context).challenge_bonus_collector_title, state.price),
        _buildChallengeDescription(context, S.of(context).challenge_bonus_collector_description),
        _buildChallengeStatus(
          context,
          state.success,
          S.of(context).challenge_bonus_collector_success,
          S.of(context).challenge_bonus_collector_failure,
        ),
      ],
    );
  }

  Widget _buildQuestionMasterChallenge(BuildContext context, GameChallengeState state) {
    String questionType = '';
    switch (state.code) {
      case 4:
        questionType = S.of(context).question_type_qcm;
        break;
      case 5:
        questionType = S.of(context).question_type_qrl;
        break;
      case 6:
        questionType = S.of(context).question_type_qre;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChallengeHeader(context, S.of(context).challenge_question_master_title, state.price),
        _buildChallengeDescription(context, S.of(context).challenge_question_master_description(questionType)),
        _buildChallengeStatus(
          context,
          state.success,
          S.of(context).challenge_question_master_success(questionType),
          S.of(context).challenge_question_master_failure(questionType),
        ),
      ],
    );
  }

  Widget _buildNeverLastChallenge(BuildContext context, GameChallengeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChallengeHeader(context, S.of(context).challenge_never_last_title, state.price),
        _buildChallengeDescription(context, S.of(context).challenge_never_last_description),
        _buildChallengeStatus(
          context,
          state.success,
          S.of(context).challenge_never_last_success,
          S.of(context).challenge_never_last_failure,
        ),
      ],
    );
  }
}