import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/friend_request.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendRequests extends ConsumerStatefulWidget {
  const FriendRequests({super.key});

  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends ConsumerState<FriendRequests> {
  final ScrollController _sentController = ScrollController();
  final ScrollController _receivedController = ScrollController();

  @override
  void dispose() {
    _sentController.dispose();
    _receivedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsState = ref.watch(friendsServiceProvider);
    final theme = Theme.of(context);

    return SizedBox(
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
                S.of(context).friend_requests_title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    // Custom Tab Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: TabBar(
                        labelColor: Theme.of(context).colorScheme.primary,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: Theme.of(context).colorScheme.primary,
                        indicatorWeight: 3.0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                        tabs: [
                          Tab(
                            text:
                                S.of(context).friend_requests_received_requests,
                            height: 40,
                          ),
                          Tab(
                            text: S.of(context).friend_requests_sent_requests,
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                    // Tab Content
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildReceivedRequestsTab(
                            friendsState.receivedRequests,
                            context,
                          ),
                          _buildSentRequestsTab(
                            friendsState.sentRequests,
                            context,
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildSentRequestsTab(
      List<FriendRequest> sentRequests, BuildContext context) {
    if (sentRequests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          S.of(context).friend_requests_no_sent_requests,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: RawScrollbar(
        controller: _sentController,
        thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        radius: const Radius.circular(20),
        thickness: 4,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _sentController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: sentRequests.length,
          itemBuilder: (context, index) {
            final request = sentRequests[index];
            final isLastItem = index == sentRequests.length - 1;

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
                            color: Colors.black.withOpacity(0.08),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          ProfileAvatarIconWidget(
                              user: ref.read(userProviderByUsername(
                                  request.receiverUsername)),
                              size: 30),
                          const SizedBox(width: 10),
                          Text(
                            request.receiverUsername,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        ref
                            .read(friendsServiceProvider.notifier)
                            .deleteFriendRequest(request.receiverUsername);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReceivedRequestsTab(
      List<FriendRequest> receivedRequests, BuildContext context) {
    if (receivedRequests.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          S.of(context).friend_requests_no_received_requests,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: RawScrollbar(
        controller: _receivedController,
        thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        radius: const Radius.circular(20),
        thickness: 4,
        thumbVisibility: true,
        child: ListView.builder(
          controller: _receivedController,
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: receivedRequests.length,
          itemBuilder: (context, index) {
            final request = receivedRequests[index];
            final isLastItem = index == receivedRequests.length - 1;

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
                            color: Colors.black.withOpacity(0.08),
                          ),
                        )
                      : null,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        children: [
                          ProfileAvatarIconWidget(
                              user: ref.read(userProviderByUsername(
                                  request.senderUsername)),
                              size: 30),
                          const SizedBox(width: 10),
                          Text(
                            request.senderUsername,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        ref
                            .read(friendsServiceProvider.notifier)
                            .answerFriendRequest(request.id, true);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      splashRadius: 24,
                      onPressed: () {
                        ref
                            .read(friendsServiceProvider.notifier)
                            .answerFriendRequest(request.id, false);
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
