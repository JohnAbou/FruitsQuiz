import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/games/game_leaving_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/custom_colors.dart';

class GameTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const GameTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void leaveGame(WidgetRef ref) {
    navigatorKey.currentContext?.go('/home');
    ref.read(gameLeavingServiceProvider).leaveGame();
  }

  void logOut(WidgetRef ref) {
    ref.read(notificationServiceProvider).showConfirmationCardPopup(
          message: S.current.header_confirm_logout,
          onConfirm: () {
            ref.read(authServiceProvider).logout();
            navigatorKey.currentContext?.go('/login');
          },
          onCancel: () {},
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSafelyLeaveGame = ref.watch(canSafelyLeaveGameProvider);
    final isOrganizer = ref.watch(gameStateProvider
        .select((state) => state.userRole == UserGameRole.organizer));

    final customColors = Theme.of(context).extension<CustomColors>();
    final headerColor = customColors?.headerColor ?? const Color(0xFFD1EED0);
    final accentColor = customColors?.accentColor ?? const Color(0xFF80A18A);
    final logoUrl = customColors?.logoUrl ?? 'assets/images/logo.png';
    final textColor = customColors?.textColor ?? const Color(0xFF467a45);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor: headerColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: accentColor,
              width: 1,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
      GestureDetector(
            onTap: () => leaveGame(ref),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Image.asset(
                logoUrl,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'FRUITS QUIZ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: _buildButton(
            onPressed: () => leaveGame(ref),
            label: canSafelyLeaveGame
                ? S.of(context).game_top_bar_quit
                : isOrganizer
                    ? S.of(context).game_top_bar_terminate
                    : S.of(context).game_top_bar_leave,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 4.0, top: 8.0, bottom: 8.0),
          child: _buildButton(
            onPressed: () => logOut(ref),
            label: S.of(context).game_top_bar_logout,
          ),
        ),
      ],
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 120,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFF4D4D),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
