import 'package:flutter/material.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/utils/time.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/models/user_stats.dart';

class AchievementItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String value;
  final double size;
  final Color? textColor;
  final Color? bgColor;

  const AchievementItem({
    super.key,
    required this.imagePath,
    required this.title,
    required this.value,
    this.size = 0.15,
    this.textColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final color = textColor ?? customColors?.profileTextColor ?? const Color(0xFF618A5E);
    final backgroundColor = bgColor ?? customColors?.boxColor ?? Colors.white;
    
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth * size;
    
    return Container(
      width: containerWidth,
      height: containerWidth, 
      margin: EdgeInsets.only(bottom: screenWidth * 0.012),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.6), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.4,
            offset: Offset(0, 1.2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: containerWidth * 0.45,
            height: containerWidth * 0.45,
          ),
          SizedBox(height: containerWidth * 0.08),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenWidth * 0.011,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: containerWidth * 0.04),
          Text(
            value,
            style: TextStyle(
              fontSize: screenWidth * 0.012,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AchievementsContainer extends StatelessWidget {
  final UserStats? stats;
  final double size;

  const AchievementsContainer({
    super.key,
    required this.stats,
    this.size = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return const SizedBox.shrink();
    }

    final formattedGameTime = formatTime(stats!.totalGameTime);
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.012),
      child: Wrap(
        spacing: screenWidth * 0.015,
        runSpacing: screenWidth * 0.015,
        alignment: WrapAlignment.center,
        children: [
          AchievementItem(
            imagePath: 'assets/images/badges/bestStreak-removebg-preview.png',
            title: S.of(context).leaderboardPage_BestStreak,
            value: '${stats!.bestWinStreak}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/currentStreak-removebg-preview.png',
            title: S.of(context).leaderboardPage_CurrentStreak,
            value: '${stats!.currentWinStreak}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/totalGames-removebg-preview.png',
            title: S.of(context).leaderboardPage_GamesWon,
            value: '${stats!.totalGameWon}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/totalPoints-removebg-preview.png',
            title: S.of(context).leaderboardPage_Points,
            value: '${stats!.totalPoints}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/coinsSpent-removebg-preview.png',
            title: S.of(context).leaderboardPage_CoinsSpent,
            value: '${stats!.coinSpent}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/coinsSpent-removebg-preview.png',
            title: S.of(context).leaderboardPage_CoinsGained  ,
            value: '${stats!.coinGained}',
            size: size,
          ),
          AchievementItem(
            imagePath: 'assets/images/badges/gameTime-removebg-preview.png',
            title: S.of(context).leaderboardPage_GameTime,
            value: formattedGameTime,
            size: size,
          ),
        ],
      ),
    );
  }
}
