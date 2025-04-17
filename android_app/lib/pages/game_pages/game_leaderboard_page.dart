import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/games/game_challenge_service.dart';
import 'package:android_app/services/games/game_info_service.dart';
import 'package:android_app/services/games/game_leaving_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/widgets/challenge_presentation_widget.dart';
import 'package:android_app/widgets/game_loot_widget.dart';
import 'package:android_app/widgets/result_winner_widget.dart';
import 'package:android_app/widgets/results_widgets/results_stats_leaderboard.dart';
import 'package:android_app/widgets/results_widgets/results_stats_quiz.dart';
import 'package:android_app/widgets/results_widgets/stats_result_widget.dart';
import 'package:android_app/widgets/results_widgets/survival_results_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameLeaderboardPage extends ConsumerStatefulWidget {
  const GameLeaderboardPage({super.key});

  @override
  ConsumerState<GameLeaderboardPage> createState() =>
      _GameLeaderboardPageState();
}

class _GameLeaderboardPageState extends ConsumerState<GameLeaderboardPage> {
  int _currentSlide = 0;

  void _goToSlide(int index) {
    setState(() {
      _currentSlide = index;
    });
  }

  void _previousSlide() {
    final gameRole = ref.read(gameStateProvider).userRole;
    final showChallenges = ref.read(gameChallengeStateProvider).code != 0;

    int maxSlides = 2;
    if (showChallenges) maxSlides++;
    if (gameRole != UserGameRole.organizer) maxSlides += 2;

    setState(() {
      _currentSlide = (_currentSlide > 0) ? _currentSlide - 1 : maxSlides - 1;
    });
  }

  void _nextSlide() {
    final gameRole = ref.read(gameStateProvider).userRole;
    final showChallenges = ref.read(gameChallengeStateProvider).code != 0;

    int maxSlides = 2;
    if (showChallenges) maxSlides++;
    if (gameRole != UserGameRole.organizer) maxSlides += 2;

    setState(() {
      _currentSlide = (_currentSlide < maxSlides - 1) ? _currentSlide + 1 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameType =
        ref.watch(gameInfoStateProvider.select((state) => state.gameType));

    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: gameType == GameType.survivalGame
                    ? _buildSurvivalResult()
                    : _buildClassicResult(),
              ),
            ),
            _buildButtonContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildClassicResult() {
    return Column(
      children: [
        ResultWinnerWidget(),
        const SizedBox(height: 16),
        Expanded(child: _buildStatsContainer()),
      ],
    );
  }

  Widget _buildStatsContainer() {
    final gameRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));
    final showChallenges = ref
        .watch(gameChallengeStateProvider.select((state) => state.code != 0));

    // Calculate slide indices based on conditions
    int quizStatsIndex = showChallenges ? 2 : 1;
    int achievementsIndex = showChallenges ? 3 : 2;
    int gameLoootIndex = showChallenges ? 4 : 3;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Centered Card
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Leaderboard Slide
                _buildCarouselSlide(
                  0,
                  Icons.leaderboard,
                  S.of(context).result_view_leaderboard,
                  ResultsStatsLeaderboard(),
                ),

                // Challenges Slide (conditional)
                if (showChallenges)
                  _buildCarouselSlide(
                    1,
                    Icons.flag,
                    S.of(context).result_view_challenges,
                    ChallengePresentationWidget(),
                  ),

                // Quiz Stats Slide
                _buildCarouselSlide(
                  quizStatsIndex,
                  Icons.analytics,
                  S.of(context).result_view_quiz_stats,
                  ResultsStatsQuiz(),
                ),

                // Achievements Slide (conditional on role)
                if (gameRole != UserGameRole.organizer)
                  _buildCarouselSlide(
                    achievementsIndex,
                    Icons.emoji_events,
                    S.of(context).result_view_achivements,
                    StatsResultWidget(),
                  ),

                // Game Loot Slide (conditional on role)
                if (gameRole != UserGameRole.organizer)
                  _buildCarouselSlide(
                    gameLoootIndex,
                    Icons.monetization_on,
                    S.of(context).result_view_game_loot,
                    GameLootWidget(),
                  ),
              ],
            ),
          ),

          // Positioned Tab Navigation to the right
          Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            top: 0,
            bottom: 0,
            child: Center(
              child: _buildVerticalControls(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalControls() {
    final gameRole =
        ref.watch(gameStateProvider.select((state) => state.userRole));
    final showChallenges = ref
        .watch(gameChallengeStateProvider.select((state) => state.code != 0));

    // Calculate slide indices based on conditions
    int quizStatsIndex = showChallenges ? 2 : 1;
    int achievementsIndex = showChallenges ? 3 : 2;
    int gameLoootIndex = showChallenges ? 4 : 3;

    return Container(
      margin: const EdgeInsets.only(left: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSlideIndicator(0, Icons.leaderboard),
          if (showChallenges) _buildSlideIndicator(1, Icons.flag),
          _buildSlideIndicator(quizStatsIndex, Icons.analytics),
          if (gameRole != UserGameRole.organizer) ...[
            _buildSlideIndicator(achievementsIndex, Icons.emoji_events),
            _buildSlideIndicator(gameLoootIndex, Icons.monetization_on),
          ],
        ],
      ),
    );
  }

  Widget _buildSlideIndicator(int index, IconData icon) {
    final isActive = _currentSlide == index;
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _goToSlide(index),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 48,
            height: 48,
            child: Center(
              child: Icon(
                icon,
                color: isActive ? primaryColor : Colors.grey,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlide(
      int index, IconData icon, String title, Widget content) {
    final isActive = _currentSlide == index;
    
    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedScale(
        scale: isActive ? 1.0 : 0.98,
        duration: const Duration(milliseconds: 400),
        child: Visibility(
          visible: isActive,
          maintainState: true,
          maintainAnimation: true,
          maintainSize: true,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(icon, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: content,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurvivalResult() {
    return SurvivalResultsWidget();
  }

  Widget _buildButtonContainer() {
    final gameType =
        ref.watch(gameInfoStateProvider.select((state) => state.gameType));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFooterButton(
            Icons.exit_to_app,
            S.of(context).quit_button,
            () {
              navigatorKey.currentContext?.go('/home');
              ref.read(gameLeavingServiceProvider).leaveGame();
            },
          ),
          if (gameType != GameType.survivalGame) ...[
            const SizedBox(width: 32),
            _buildFooterButton(
              Icons.skip_previous,
              S.of(context).game_result_previous_slide_button,
              _previousSlide,
            ),
            const SizedBox(width: 32),
            _buildFooterButton(
              Icons.skip_next,
              S.of(context).game_result_next_slide_button,
              _nextSlide,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFooterButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
