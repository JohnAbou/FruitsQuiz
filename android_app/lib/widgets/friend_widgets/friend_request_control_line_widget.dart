import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/models/enums/friend_status.dart';

class FriendRequestControlLineWidget extends ConsumerWidget {
  final String username;
  const FriendRequestControlLineWidget({super.key, required this.username});

  sendRequest(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).sendFriendRequest(username);
  }

  deleteRequest(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).deleteFriendRequest(username);
  }

  answerRequest(WidgetRef ref, bool answer) {
    ref
        .read(friendsServiceProvider.notifier)
        .answerFriendRequestByUsername(username, answer);
  }

  removeFriend(WidgetRef ref) {
    ref.read(friendsServiceProvider.notifier).removeFriend(username);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendStatus = ref.watch(getFriendStatusProvider(username));
    final tealColor = Theme.of(context).colorScheme.primary;

    switch (friendStatus) {
      case FriendStatus.none:
        return Row(
          children: [
            Text(
              S.of(context).friend_requests_add_friend,
              style: TextStyle(color: tealColor),
            ),
            IconButton(
              icon: Icon(Icons.person_add, color: tealColor),
              onPressed: () => sendRequest(ref),
            ),
          ],
        );
      case FriendStatus.friend:
      case FriendStatus.self:
        return Center();
      case FriendStatus.receivedRequest:
        return Row(
          children: [
            Text(
              S.of(context).friend_requests_answer_request,
              style: TextStyle(color: tealColor),
            ),
            IconButton(
              icon: Icon(Icons.check, color: tealColor),
              onPressed: () => answerRequest(ref, true),
            ),
            IconButton(
              icon: Icon(Icons.close, color: tealColor),
              onPressed: () => answerRequest(ref, false),
            ),
          ],
        );
      case FriendStatus.sentRequest:
        return Row(
          children: [
            Text(
              S.of(context).friend_requests_revoke_sent_request,
              style: TextStyle(color: tealColor),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: tealColor),
              onPressed: () => deleteRequest(ref),
            ),
          ],
        );
    }
  }
}
