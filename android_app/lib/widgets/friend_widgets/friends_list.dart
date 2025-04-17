import 'package:android_app/generated/l10n.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FriendsList extends ConsumerWidget {
  const FriendsList({super.key});

  navigateToUsersPage(BuildContext context) {
    navigatorKey.currentContext?.go('/users');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsState = ref.watch(friendsServiceProvider);
    final theme = Theme.of(context);

    return SizedBox(
      height: 400,
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.08),
                  ),
                ),
              ),
              child: Text(
                S.of(context).friends_list_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton.icon(
                    onPressed: () => navigateToUsersPage(context),
                    icon: const Icon(Icons.people),
                    label: Text(
                      S.of(context).friends_list_find_new_friends,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black.withOpacity(0.08),
            ),

            // Card Content
            Expanded(
              child: friendsState.friends.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, bottom: 20, left: 20, right: 20),
                          child: Text(
                            S.of(context).friends_list_no_friends,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 4),
                        ),
                        const Spacer(),
                      ],
                    )
                  : ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        scrollbars: false,
                      ),
                      child: RawScrollbar(
                        thumbColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.4),
                        radius: const Radius.circular(20),
                        thickness: 4,
                        thumbVisibility: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: friendsState.friends.length,
                          itemBuilder: (context, index) {
                            final friend = friendsState.friends[index];
                            final isLastItem =
                                index == friendsState.friends.length - 1;

                            return InkWell(
                              onTap: () {},
                              hoverColor: Colors.black.withOpacity(0.03),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: !isLastItem
                                      ? Border(
                                          bottom: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          ProfileAvatarIconWidget(
                                              user: ref.read(
                                                  userProviderByUsername(
                                                      friend)),
                                              size: 30),
                                          const SizedBox(width: 10),
                                          Text(
                                            friend,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.person_remove,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      splashRadius: 24,
                                      onPressed: () {
                                        ref
                                            .read(
                                                friendsServiceProvider.notifier)
                                            .removeFriend(friend);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),

            // Card Footer
            Container(
              height: 16,
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.08),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
