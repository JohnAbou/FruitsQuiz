import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/widgets/avatar_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/utils/avatar.dart';


class SidebarProfile extends ConsumerWidget {
  final String currentPage;
  final void Function(String) setActivePage;

  const SidebarProfile({
    super.key,
    required this.currentPage,
    required this.setActivePage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userInfoServiceProvider);
    final customColors = Theme.of(context).extension<CustomColors>();
    final sidebarBox = customColors?.sidebarBox ?? const Color(0xFFBADAB8);

    if (user.username.isEmpty || user.activeAvatarId.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: 300,
      color: sidebarBox,
      child: Column(
        children: [
          const SizedBox(height: 60),
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (context) => const AvatarModal(),
            ),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                color: customColors?.accentColor ?? Theme.of(context).colorScheme.secondary,
                  width: 3,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.4,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(getAvatarSource(user.activeAvatarId, ref)),
                      backgroundColor: const Color.fromARGB(255, 170, 190, 162),
                    ),
                  ),
                  const Positioned(
                    child: Icon(Icons.edit, size: 30, color: Color.fromARGB(179, 18, 26, 19)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildSidebarItem(
                  context,
                  label: S.of(context).information,
                  icon: Icons.person,
                  tabName: 'information',
                ),
                _buildSidebarItem(
                  context,
                  label: S.of(context).side_bar_accomplishements,
                  icon: Icons.emoji_events,
                  tabName: 'accomplishments',
                ),
                _buildSidebarItem(
                  context,
                  label: S.of(context).side_bar_preferences,
                  icon: Icons.settings,
                  tabName: 'preferences',
                ),
                _buildSidebarItem(
                  context,
                  label: S.of(context).friends,
                  icon: Icons.people,
                  tabName: 'friends',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
  BuildContext context, {
  required String label,
  required IconData icon,
  required String tabName,
}) {
  final isActive = currentPage == tabName;
  final customColors = Theme.of(context).extension<CustomColors>();
  final sidebarText = customColors?.sidebarText ?? const Color(0xFF618A5E);
  final activeColor = customColors?.sidebarButtonSelected ?? const Color(0xFFA2D39E);
  
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color: isActive ? activeColor : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ListTile(
      onTap: () => setActivePage(tabName),
      leading: Icon(
        icon,
        color: sidebarText,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: sidebarText,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    ),
  );
}
}
