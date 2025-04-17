import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:android_app/services/user_level_service.dart';
import 'package:android_app/services/user_stats_service.dart';
import 'package:android_app/utils/time.dart';
import 'package:android_app/utils/account_validation.dart';
import 'package:android_app/utils/login_validation_error_localizer.dart';

class PersonalInformation extends ConsumerStatefulWidget {
  const PersonalInformation({super.key});

  @override
  ConsumerState<PersonalInformation> createState() =>
      _PersonalInformationState();
}

class _PersonalInformationState extends ConsumerState<PersonalInformation> {
  bool isEditing = false;
  String? errorMessage;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = ref.read(userInfoServiceProvider);
    _usernameController.text = user.username;

    {
      // lmao wtf, flutter me force a utiliser un code block
      final _ = ref.refresh(userLevelProvider);
    }
    {
      final _ = ref.refresh(userStatsProvider(user.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoServiceProvider);
    final levelAsync = ref.watch(userLevelProvider);
    final statsAsync = ref.watch(userStatsProvider(user.id));
    final customColors = Theme.of(context).extension<CustomColors>();

    return Column(
      children: [
        const SizedBox(height: 30),
        Text(
          S.of(context).information_header,
          style: AppTextStyles.fruitzSubtitle(context),
        ),
        const SizedBox(height: 30),
        levelAsync.when(
          data: (level) {
            if (level == null) {
              return const Text('No level data');
            }
            final nextLevel = (level.experience + level.expToNextLevel).toInt();
            final progression = ((level.experience + 1) /
                    (level.experience + level.expToNextLevel) *
                    100)
                .toDouble();

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProfileBox(
                        user,
                        customColors?.sidebarText ?? Colors.black,
                        customColors?.boxColor ?? Colors.white,
                        customColors?.textColor ?? Colors.white),
                    const SizedBox(width: 40),
                    _buildLevelBox(
                        level,
                        progression,
                        nextLevel,
                        customColors?.sidebarText ?? Colors.black,
                        customColors?.boxColor ?? Colors.white),
                  ],
                ),
                const SizedBox(height: 40),
                statsAsync.when(
                  data: (stats) {
                    if (stats == null) {
                      return const Text('No stats data');
                    }
                    return _buildStatsBox(
                      stats,
                      customColors?.sidebarText ?? Colors.black,
                      customColors?.boxColor ?? Colors.white,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Failed to load stats: $error'),
                ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Failed to load level info: $error'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProfileBox(
      user, Color sidebarText, Color boxColor, Color textColor) {
    return Container(
      width: 330,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(color: sidebarText.withOpacity(0.7), width: 2),
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
          Center(
            child: Text(
              S.of(context).profile,
              style: TextStyle(
                color: sidebarText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
            const SizedBox(height: 15),
            Row(
            children: [
              isEditing
                ? Expanded(
                  child: TextField(
                  controller: _usernameController,
                  maxLength: 12,
                  decoration: InputDecoration(
                    labelText: S.current.information_profile_username,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 8),
                    counterText: '', // Hides the character counter
                  ),
                  ),
                )
                : Row(
                  children: [
                  Text(
                    '${S.of(context).username}: ',
                    style: TextStyle(color: sidebarText),
                  ),
                  Text(
                    '${user.username}',
                    style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    ),
                  ),
                  ],
                ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(isEditing ? Icons.check : Icons.edit,
                        size: 20, color: sidebarText),
                    onPressed: () async {
                      final newUsername = _usernameController.text.trim();
                      final currentUsername =
                          ref.read(userInfoServiceProvider).username;

                      if (isEditing) {
                        if (newUsername == currentUsername) {
                          setState(() {
                            isEditing = false;
                            errorMessage = null;
                            _usernameController.text = currentUsername;
                          });
                          return;
                        }

                        final validationError =
                            validateUsername(context, newUsername);
                        if (validationError != null) {
                          setState(() => errorMessage = validationError);
                          return;
                        }

                        final result = await ref
                            .read(userInfoServiceProvider.notifier)
                            .updateUsername(newUsername);

                        setState(() {
                          if (result['success']) {
                            isEditing = false;
                            errorMessage = null;
                          } else {
                            errorMessage =
                                getLocalizedError(result['error'], context);
                          }
                        });
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                  ),
                  if (isEditing)
                    IconButton(
                      icon: Icon(Icons.close, size: 20, color: sidebarText),
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                          errorMessage = null;
                          _usernameController.text =
                              ref.read(userInfoServiceProvider).username;
                        });
                      },
                    ),
                ],
              ),
            ],
          ),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${S.of(context).email}: ',
                  style: TextStyle(color: sidebarText)),
              Expanded(
                child: Text(
                  '${user.email}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBox(level, double progression, int nextLevel,
      Color sidebarText, Color boxColor) {
    return Container(
      width: 330,
      height: 170,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(color: sidebarText.withOpacity(0.7), width: 2),
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
          Center(
            child: Text(
              S.of(context).current_level,
              style: TextStyle(
                color: sidebarText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '${S.of(context).current_level}: ${level.level}',
            style: TextStyle(color: sidebarText, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).level_XP,
                  style: TextStyle(color: sidebarText)),
              Text(
                '${level.experience} / $nextLevel ${S.of(context).experience}',
                style: TextStyle(color: sidebarText),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            lineHeight: 10,
            percent: (progression / 100).clamp(0, 1).toDouble(),
            progressColor: sidebarText,
            backgroundColor: Colors.white,
            barRadius: const Radius.circular(8),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBox(stats, Color sidebarText, Color boxColor) {
    return Container(
      width: 700,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(color: sidebarText.withOpacity(0.7), width: 2),
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
          Center(
            child: Text(
              S.of(context).personal_profile_statistics,
              style: TextStyle(
                color: sidebarText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildStatItem(
                  S.of(context).personal_profile_challenge_completed,
                  stats.challengeCompleted.toString(),
                  sidebarText,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  S.of(context).personal_profile_game_played,
                  stats.totalGamesPlayed.toString(),
                  sidebarText,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  S.of(context).personal_profile_game_won,
                  stats.totalGameWon.toString(),
                  sidebarText,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  S.of(context).personal_profile_correct_answers,
                  '${((stats.totalQuestionGotten / (stats.totalQuestionAnswered == 0 ? 1 : stats.totalQuestionAnswered)) * 100).toStringAsFixed(1)}%',
                  sidebarText,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  S.of(context).personal_profile_game_time,
                  formatTime(stats.totalGameTime /
                      (stats.totalGamesPlayed == 0 ? 1 : stats.totalGamesPlayed)),
                  sidebarText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ],
    );
  }
}
