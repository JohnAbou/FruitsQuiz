import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/services/user_level_service.dart';
import 'package:android_app/services/user_stats_service.dart';
import 'package:android_app/widgets/friend_widgets/friend_request_control_widget.dart';
import 'package:android_app/utils/avatar.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/widgets/achievements_container.dart';

class PublicProfileCard extends ConsumerWidget {
  final String userId;
  final VoidCallback? onClose;

  const PublicProfileCard({super.key, required this.userId, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = Theme.of(context).extension<CustomColors>();

    final boxColor = customColors?.sidebarBox ?? Colors.white;
    final borderColor = customColors?.profileCardBorder ?? const Color(0xFF618A5E);
    final textColor = customColors?.profileTextColor ?? const Color(0xFF618A5E);
    final achievementBoxColor = customColors?.profileAchievementBox ?? Colors.white;

    final userAsync = ref.watch(userFutureProvider(userId));
    final levelAsync = ref.watch(userLevelByIdProvider(userId));
    final statsAsync = ref.watch(userStatsProvider(userId));

    return userAsync.when(
      data: (user) => Center(
        child: Stack(
          children: [
            Container(
              width: 675,
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(getAvatarSource(user.activeAvatarId, ref)),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 22,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  levelAsync.when(
                    data: (level) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${S.of(context).current_level} ${level?.level ?? 0}',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '${(level?.experience ?? 0).ceil()} ${S.of(context).XP}',
                          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    loading: () => const CircularProgressIndicator(),
                    error: (e, stack) => const Text('Failed to load level'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).achievements,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: statsAsync.when(
                      data: (stats) => AchievementsContainer(stats: stats, size: 0.10),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, stack) => const Center(child: Text('Failed to load stats')),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: achievementBoxColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: FriendRequestControlWidget(username: user.username),
              ),
            ),
            if (onClose != null)
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: achievementBoxColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor),
                    ),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, stack) => const Center(child: Text('Failed to load profile')),
    );
  }
}

