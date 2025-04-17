import 'package:android_app/models/friend_request.dart';

class FriendsState {
  final List<String> friends;
  final List<FriendRequest> sentRequests;
  final List<FriendRequest> receivedRequests;

  FriendsState({
    this.friends = const [],
    this.sentRequests = const [],
    this.receivedRequests = const [],
  });

  FriendsState copyWith({
    List<String>? friends,
    List<FriendRequest>? sentRequests,
    List<FriendRequest>? receivedRequests,
  }) {
    return FriendsState(
      friends: friends ?? this.friends,
      sentRequests: sentRequests ?? this.sentRequests,
      receivedRequests: receivedRequests ?? this.receivedRequests,
    );
  }
}
