import 'package:android_app/widgets/game_win_streak.dart';
import 'package:android_app/widgets/results_widgets/game_metrics.dart';
import 'package:flutter/material.dart';

class StatsResultWidget extends StatelessWidget {
  const StatsResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GameMetrics(),
            SizedBox(height: 16),
            GameWinStreak(),
          ],
        ),
      ),
    );
  }
}
