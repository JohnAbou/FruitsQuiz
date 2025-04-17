import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/theme/custom_colors.dart';
import 'package:android_app/utils/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/generated/l10n.dart';

class HeaderWidget extends ConsumerWidget implements PreferredSizeWidget {
  const HeaderWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void logOut(WidgetRef ref, BuildContext context) {
    ref.read(notificationServiceProvider).showConfirmationCardPopup(
      message: S.current.header_confirm_logout,
      onConfirm: () {
        ref.read(authServiceProvider).logout();
        context.go('/login');
      },
      onCancel: () {},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final headerColor = customColors?.headerColor ?? const Color(0xFFD1EED0);
    final borderColor = Theme.of(context).colorScheme.secondary;
    final user = ref.watch(userInfoServiceProvider);
    final avatarUrl = getAvatarSource(user.activeAvatarId, ref);
    final themeColor = Theme.of(context).colorScheme.primary;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor: headerColor,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: borderColor),
          ),
        ),
      ),
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      title: GestureDetector(
        onTap: () => context.go('/home'),
        child: Row(
          children: [
            Image.asset(
              customColors?.logoUrl ?? 'assets/images/logo.png',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'FRUITS QUIZ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: customColors?.textColor ?? const Color(0xFF467a45),
              ),
            ),
          ],
        ),
      ),
      actions: [
        _HeaderMenuButton(
          icon: Icons.sports_esports,
          label: S.of(context).header_game_menu,
          isActive: false,
          color: themeColor,
          items: [
            _MenuItem(label: S.of(context).header_create_game_button, onTap: () => context.go('/game-creation')),
            _MenuItem(label: S.of(context).header_join_game_button, onTap: () => context.go('/game-joining')),
          ],
        ),
        const SizedBox(width: 16),

        _SimpleHeaderButton(
          icon: Icons.people,
          label: S.of(context).header_users_button,
          route: '/users',
          fixedWidth: 150,
          color: themeColor,
        ),
        const SizedBox(width: 16),
        _SimpleHeaderButton(
          icon: Icons.leaderboard,
          label: S.of(context).header_leaderboard_button,
          route: '/leaderboard',
          fixedWidth: 150,
          color: themeColor,
        ),
        const SizedBox(width: 16),
        _SimpleHeaderButton(
          icon: Icons.storefront,
          label: S.of(context).header_shop_button,
          route: '/shop',
          fixedWidth: 150,
          color: themeColor,
        ),
        const SizedBox(width: 16),

        _HeaderMenuButton(
          iconWidget: CircleAvatar(backgroundImage: NetworkImage(avatarUrl), radius: 14),
          label: user.username,
          isActive: false,
          color: themeColor,
          items: [
            _MenuItem(label: S.of(context).header_profile_button, onTap: () => context.go('/personal-profile')),
            _MenuItem(label: S.of(context).header_game_history_button, onTap: () => context.go('/history')),
            _MenuItem(label: S.of(context).header_logout_button, onTap: () => logOut(ref, context)),
          ],
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _SimpleHeaderButton extends ConsumerWidget {
  final IconData icon;
  final String label;
  final String route;
  final double fixedWidth;
  final Color color;

  const _SimpleHeaderButton({
    required this.icon, 
    required this.label, 
    required this.route, 
    required this.color, 
    this.fixedWidth = 180 
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUri = GoRouter.of(context).routerDelegate.currentConfiguration.uri.toString();
    final isActive = currentUri == route;
    final customColors = Theme.of(context).extension<CustomColors>();
    final textColor = customColors?.textColor ?? color;

    return GestureDetector(
      onTap: () => context.go(route),
     child: Container(
      width: fixedWidth,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? textColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: textColor),
            const SizedBox(width: 6),
            Text(
              label, 
              style: TextStyle(
                color: textColor,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontSize: 16,
              ), 
              overflow: TextOverflow.ellipsis
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _HeaderMenuButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Widget? iconWidget;
  final List<_MenuItem> items;
  final bool isActive;
  final Color? color;

  const _HeaderMenuButton({
    required this.label,
    this.icon,
    this.iconWidget,
    required this.items,
    this.isActive = false,
    this.color,
  });

  @override
  State<_HeaderMenuButton> createState() => _HeaderMenuButtonState();
}

class _HeaderMenuButtonState extends State<_HeaderMenuButton> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final offset = renderBox.localToGlobal(Offset.zero);

      _overlayEntry = OverlayEntry(
        builder: (context) => Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (event) {
                  // Estimate the menu bounds
                  final menuStart = offset.dy + size.height;
                  final menuEnd = menuStart + (48.0 * widget.items.length); // approximate height
                  final menuLeft = offset.dx;
                  final menuRight = menuLeft + 180;
                  
                  // If tap is outside menu and button, close it
                  if (event.position.dy < offset.dy || 
                      event.position.dy > menuEnd || 
                      event.position.dx < menuLeft || 
                      event.position.dx > menuRight ||
                      (event.position.dy > offset.dy + size.height && event.position.dy < menuStart)) {
                    _removeDropdown();
                    // The listener with translucent behavior will allow the click to pass through
                  }
                },
              ),
            ),
            Positioned(
              width: 180,
              top: offset.dy + size.height,
              left: offset.dx,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height),
                child: Material(
                  elevation: 4,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.items,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _removeDropdown();
    }
    setState(() {});
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    final customColors = Theme.of(context).extension<CustomColors>();
    final textColor = customColors?.textColor ?? color;

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isActive ? textColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.iconWidget != null)
                widget.iconWidget!
              else if (widget.icon != null)
                Icon(widget.icon, size: 20, color: textColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis
                ),
              ),
              Icon(Icons.expand_more, size: 20, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MenuItem({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>();
    final textColor = customColors?.textColor ?? const Color(0xFF467a45);

    return SizedBox(
      width: double.infinity,
      child: ListTile(
        title: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ), 
          ),
        ),
        onTap: () => Future.microtask(onTap),
        dense: true,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}