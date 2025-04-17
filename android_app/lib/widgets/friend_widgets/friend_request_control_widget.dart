import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/models/enums/friend_status.dart';
import 'package:android_app/theme/custom_colors.dart';

class FriendRequestControlWidget extends ConsumerWidget {
  final String username;
  const FriendRequestControlWidget({super.key, required this.username});

  void sendRequest(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).sendFriendRequest(username);
  }

  void deleteRequest(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).deleteFriendRequest(username);
  }

  void answerRequest(WidgetRef ref, bool answer) {
    ref.read(friendsServiceProvider.notifier).answerFriendRequestByUsername(username, answer);
  }

  void removeFriend(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).removeFriend(username);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendStatus = ref.watch(getFriendStatusProvider(username));
    final customColors = Theme.of(context).extension<CustomColors>();
    final sidebarText = customColors?.sidebarText ?? const Color(0xFF618A5E);
    final achievementBox = customColors?.boxColor ?? Colors.white;

    Widget content;

    switch (friendStatus) {
      case FriendStatus.none:
        content = _buildStatusContent(
          context,
          achievementBox,
          sidebarText,
          S.of(context).friend_request_control_add_friend,
          [
            IconButton(
              icon: const Icon(Icons.person_add),
              color: sidebarText,
              onPressed: () => sendRequest(ref),
            ),
          ],
        );
        break;
      case FriendStatus.friend:
        content = _buildStatusContent(
          context,
          sidebarText,
          achievementBox,
          S.of(context).friend_request_control_friend,
          [
            IconButton(
              icon: const Icon(Icons.person_remove),
              color: Colors.green,
              onPressed: () => removeFriend(ref),
            ),
          ],
        );
        break;
      case FriendStatus.receivedRequest:
        content = _buildStatusContent(
          context,
          sidebarText,
          achievementBox,
          S.of(context).friend_request_control_receive_request,
          [
            IconButton(
              icon: const Icon(Icons.check_circle),
              color: Color.fromARGB(255, 30, 138, 118),
              onPressed: () => answerRequest(ref, true),
            ),
            IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.green,
              onPressed: () => answerRequest(ref, false),
            ),
          ],
        );
        break;
      case FriendStatus.sentRequest:
        content = _buildStatusContent(
          context,
          sidebarText,
          achievementBox,
          S.of(context).friend_request_control_send_request,
          [
            IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.green,
              onPressed: () => deleteRequest(ref),
            ),
          ],
        );
        break;
      case FriendStatus.self:
        content = _buildStatusContent(
          context,
          sidebarText,
          achievementBox,
          S.of(context).friend_request_control_add_yourself_error,
          [],
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
      ),
      child: content,
    );
  }

  Widget _buildStatusContent(
    BuildContext context,
    Color sidebarText,
    Color boxColor,
    String message,
    List<Widget> actions,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
            color: sidebarText,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (actions.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: actions,
          ),
      ],
    );
  }
}

