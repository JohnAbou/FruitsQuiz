import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/user_stats_service.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardCarouselWidget extends ConsumerStatefulWidget {
  const LeaderboardCarouselWidget({super.key});

  @override
  ConsumerState<LeaderboardCarouselWidget> createState() =>
      _LeaderboardCarouselWidgetState();
}

class _LeaderboardCarouselWidgetState
    extends ConsumerState<LeaderboardCarouselWidget>
    with SingleTickerProviderStateMixin {
  List<String> highlights = [];
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  UsersService? usersService;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 90),
      vsync: this,
    )..repeat();

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2, 0),
    ).animate(_controller);

    _initializeData();
  }

  Future<void> _initializeData() async {
    await ref.read(allUsersStatsProvider.future);
    if (mounted) {
      _generateHighlights();
      _subscribeToEvents();
    }
  }

  void _subscribeToEvents() {
    usersService = ref.read(usersProvider.notifier);

    usersService?.avatarModified.subscribe(_onUserUpdated);
    usersService?.usernameModified.subscribe(_onUserUpdated);
  }

  @override
  void dispose() {
    _controller.dispose();
    usersService?.avatarModified.unsubscribe(_onUserUpdated);
    usersService?.usernameModified.unsubscribe(_onUserUpdated);
    super.dispose();
  }

  void _onUserUpdated(dynamic event) {
    final _ = ref.refresh(allUsersStatsProvider);
    _generateHighlights();
  }

  String _getTranslatedText(String key) {
    switch (key) {
      case 'MostWins':
        return S.of(context).HomeCarousel_MostWins;
      case 'MostCoinsSpent':
        return S.of(context).HomeCarousel_MostCoinsSpent;
      case 'MostPoints':
        return S.of(context).HomeCarousel_MostPoints;
      case 'LongestGameTime':
        return S.of(context).HomeCarousel_LongestGameTime;
      case 'HighestCurrentWinStreak':
        return S.of(context).HomeCarousel_HighestCurrentWinStreak;
      case 'BestWinStreak':
        return S.of(context).HomeCarousel_BestWinStreak;
      case 'BestSurvivalScore':
        return S.of(context).HomeCarousel_BestSurvivalScore;
      case 'NoDataAvailable':
        return S.of(context).HomeCarousel_NoDataAvailable;
      default:
        return key;
    }
  }

  void _generateHighlights() {
    final usersStatsAsync = ref.read(allUsersStatsProvider);

    usersStatsAsync.whenData((leaderboard) {
      if (leaderboard.isEmpty) {
        setState(() {
          highlights = [_getTranslatedText('NoDataAvailable')];
        });
        return;
      }

      final topWins = leaderboard.reduce((prev, curr) =>
          (curr.userStats.totalGameWon > prev.userStats.totalGameWon)
              ? curr
              : prev);
      final topCoins = leaderboard.reduce((prev, curr) =>
          (curr.userStats.coinSpent > prev.userStats.coinSpent) ? curr : prev);
      final topPoints = leaderboard.reduce((prev, curr) =>
          (curr.userStats.totalPoints > prev.userStats.totalPoints)
              ? curr
              : prev);
      final topBestSurvival = leaderboard.reduce((prev, curr) =>
          (curr.userStats.bestSurvivalScore > prev.userStats.bestSurvivalScore)
              ? curr
              : prev);
      final topGameTime = leaderboard.reduce((prev, curr) =>
          (curr.userStats.totalGameTime > prev.userStats.totalGameTime)
              ? curr
              : prev);
      final topCurrentStreak = leaderboard.reduce((prev, curr) =>
          (curr.userStats.currentWinStreak > prev.userStats.currentWinStreak)
              ? curr
              : prev);
      final topBestStreak = leaderboard.reduce((prev, curr) =>
          (curr.userStats.bestWinStreak > prev.userStats.bestWinStreak)
              ? curr
              : prev);

      setState(() {
        highlights = [
          "${topWins.username}: ${_getTranslatedText('MostWins')} (${topWins.userStats.totalGameWon})",
          "${topCoins.username}: ${_getTranslatedText('MostCoinsSpent')} (${topCoins.userStats.coinSpent})",
          "${topPoints.username}: ${_getTranslatedText('MostPoints')} (${topPoints.userStats.totalPoints})",
          "${topBestSurvival.username}: ${_getTranslatedText('BestSurvivalScore')} (${topBestSurvival.userStats.bestSurvivalScore})",
          "${topGameTime.username}: ${_getTranslatedText('LongestGameTime')} (${formatTime(topGameTime.userStats.totalGameTime)})",
          "${topCurrentStreak.username}: ${_getTranslatedText('HighestCurrentWinStreak')} (${topCurrentStreak.userStats.currentWinStreak})",
          "${topBestStreak.username}: ${_getTranslatedText('BestWinStreak')} (${topBestStreak.userStats.bestWinStreak})",
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final primaryColor =
        customColors?.accentColor ?? Theme.of(context).colorScheme.primary;
    final boxColor = customColors?.boxColor ?? Colors.grey.shade100;
    final textColor = customColors?.textColor ?? Colors.black87;

    final usersStatsAsync = ref.watch(allUsersStatsProvider);

    return usersStatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (_) => Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 1000),
        decoration: BoxDecoration(
          color: boxColor,
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            SlideTransition(
              position: _offsetAnimation,
              child: _buildTickerContent(textColor, primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTickerContent(Color textColor, Color primaryColor) {
    return Row(
      children: [
        _buildTickerItems(textColor, primaryColor),
        _buildTickerItems(textColor, primaryColor),
        _buildTickerItems(textColor, primaryColor),
        _buildTickerItems(textColor, primaryColor),
      ],
    );
  }

  Widget _buildTickerItems(Color textColor, Color primaryColor) {
    return Row(
      children: highlights.map((highlight) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                highlight,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '•',
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
        );
      }).toList(),
    );
  }
}
