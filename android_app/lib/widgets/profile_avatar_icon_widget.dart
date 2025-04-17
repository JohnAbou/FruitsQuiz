import 'package:android_app/models/user.dart';
import 'package:android_app/providers/avatar_navigation_provider.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/utils/avatar.dart';
import 'package:android_app/widgets/public_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/models/bot_player.dart';

class ProfileAvatarIconWidget extends ConsumerWidget {
  final User? user;
  final BotPlayer? bot;
  final double size;

  const ProfileAvatarIconWidget({
    super.key,
    this.user,
    this.bot,
    this.size = 40,
  });

  void _goToProfile(BuildContext context, WidgetRef ref, String userId) {
    if (ref.read(canSafelyNavigateProvider)) {
      navigatorKey.currentContext?.go('/public-profile?id=$userId');
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: PublicProfileCard(
            userId: userId,
            onClose: () => Navigator.of(context).pop(),
          ),
        ),
      );
    }
  }

  String getBotAvatarSource(BotPlayer bot) {
    final filename =
        '${bot.difficulty.name.toLowerCase()}_${bot.avatarType.name}.png';
    return 'assets/bot-avatars/$filename';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (user != null) {
      return GestureDetector(
        onTap: () => _goToProfile(context, ref, user!.id),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.teal, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: Image.network(
              getAvatarSource(user!.activeAvatarId, ref),
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.account_circle,
                    size: size, color: Colors.teal);
              },
            ),
          ),
        ),
      );
    } else if (bot != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.teal, width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: Image.asset(
            getBotAvatarSource(bot!),
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
