import 'package:android_app/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/user_stats_service.dart';
import 'package:android_app/widgets/achievements_container.dart';


class PersonalAchievementsWidget extends ConsumerWidget {
  final String userId;

  const PersonalAchievementsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(userStatsProvider(userId));
    final screenWidth = MediaQuery.of(context).size.width;

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Failed to load achievements')),
      data: (stats) {
        if (stats == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenWidth * 0.02),
            Text(
              S.of(context).your_stats,
              style: AppTextStyles.fruitzSubtitle(context),
            ),
            SizedBox(height: screenWidth * 0.015),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
              child: AchievementsContainer(stats: stats),
            )
          ],
        );
      },
    );
  }
}
