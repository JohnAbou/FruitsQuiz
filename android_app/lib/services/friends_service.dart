import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/enums/friend_status.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/routes/app_routes.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/states/friends_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';
import '../models/friend_request.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:audioplayers/audioplayers.dart';

final friendsServiceProvider =
    StateNotifierProvider<FriendsNotifier, FriendsState>((ref) {
  final authService = ref.read(authServiceProvider);
  final socketService = ref.read(socketConnectionServiceProvider);
  final notificationService = ref.read(notificationServiceProvider);
  final baseUrl = ref.read(apiUrlProvider);

  return FriendsNotifier(
    authService: authService,
    socketService: socketService,
    notificationService: notificationService,
    baseUrl: baseUrl,
  );
});

class FriendsNotifier extends StateNotifier<FriendsState> {
  final AuthService _authService;
  final SocketConnectionService _socketService;
  final NotificationService _notificationService;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final String _baseUrl;

  FriendsNotifier({
    required AuthService authService,
    required SocketConnectionService socketService,
    required NotificationService notificationService,
    required String baseUrl,
  })  : _authService = authService,
        _socketService = socketService,
        _notificationService = notificationService,
        _baseUrl = baseUrl,
        super(FriendsState()) {
    authService.onConnectionSubject.subscribe((_) {
      init();
    });

    authService.onDisconnectionSubject.subscribe((_) {
      destroy();
    });
  }

  void init() {
    _socketService.onUnique('friend-socket:receivedRequest', _addReceivedRequest);
    _socketService.onUnique('friend-socket:removedRequest', _removeReceivedRequest);
    _socketService.onUnique('friend-socket:acceptedRequest', _onAcceptedRequest);

    _socketService.onUnique('friend-socket:removedFriend', _friendRemoved);
    _socketService.onUnique('friend-socket:addedFriend', _friendAdded);

    _socketService.onUnique('friend-socket:requestUpdated', (_) {
      refreshReceivedRequest();
      refreshSentRequests();
    });

    _socketService.onUnique('friend-socket:relationUpdated', (_) {
      refreshFriends();
    });

    _socketService.emit('friend-socket:join', _authService.getSessionId());

    refreshFriends();
    refreshSentRequests();
    refreshReceivedRequestsOnLogIn();
  }

  void destroy() {
    _socketService.off('friend-socket:receivedRequest');
    _socketService.off('friend-socket:removedRequest');
    _socketService.off('friend-socket:acceptedRequest');

    _socketService.off('friend-socket:removedFriend');
    _socketService.off('friend-socket:addedFriend');

    _socketService.off('friend-socket:requestUpdated');
    _socketService.off('friend-socket:relationUpdated');
  }

  Future<void> refreshFriends() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/me/friends'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<String> friends = data.map((e) => e.toString()).toList();
      state = state.copyWith(friends: friends);
    }
  }

  Future<void> refreshSentRequests() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/sent'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<FriendRequest> requests = data
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(sentRequests: requests);
    }
  }

  Future<void> refreshReceivedRequest() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/received'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<FriendRequest> requests = data
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(receivedRequests: requests);
    }
  }

  Future<void> refreshReceivedRequestsOnLogIn() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/received'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<FriendRequest> requests = data
          .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(receivedRequests: requests);

      final unseenRequests =
          requests.where((request) => !request.seen).toList();
      _showUnseenRequestsNotification(unseenRequests);
    }
  }

  Future<void> sendFriendRequest(String username) async {
    await http.post(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/$username'),
      headers: _getSessionIdHeaders(),
    );

    await refreshSentRequests();
  }

  Future<void> deleteFriendRequest(String username) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/$username'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      await refreshSentRequests();
    }
  }

  Future<void> answerFriendRequestByUsername(String username, bool answer) {
    var request = state.receivedRequests
        .firstWhere((request) => request.senderUsername == username);
    return answerFriendRequest(request.id, answer);
  }

  Future<void> answerFriendRequest(String requestId, bool answer) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/accounts/me/friends/requests/answer/$requestId'),
      headers: _getSessionIdHeaders(),
      body: json.encode({'answer': answer}),
    );

    if (response.statusCode == 200) {
      await refreshReceivedRequest();
    }
  }

  void sawFriendRequest(String requestId) {
    _socketService.emit('friend-socket:seenRequest', requestId);
  }

  Future<void> removeFriend(String username) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/accounts/me/friends/$username'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      await refreshFriends();
    }
  }

  void _friendAdded(dynamic data) {
    final username = data.toString();
    final currentFriends = List<String>.from(state.friends);
    state = state.copyWith(friends: [...currentFriends, username]);
  }

  void _friendRemoved(dynamic data) {
    final username = data.toString();
    final currentFriends = List<String>.from(state.friends);
    state = state.copyWith(
      friends: currentFriends.where((friend) => friend != username).toList(),
    );
  }

  void _addReceivedRequest(dynamic data) {
    final request = FriendRequest.fromJson(data as Map<String, dynamic>);
    final currentRequests = List<FriendRequest>.from(state.receivedRequests);
    state = state.copyWith(receivedRequests: [...currentRequests, request]);

    _audioPlayer.play(AssetSource('sounds/message1.mp3'));

    _showFriendRequestNotification(request);
    sawFriendRequest(request.id);
  }

  void _removeReceivedRequest(dynamic data) {
    final removedRequest = FriendRequest.fromJson(data as Map<String, dynamic>);
    final currentRequests = List<FriendRequest>.from(state.receivedRequests);
    state = state.copyWith(
      receivedRequests: currentRequests
          .where((request) =>
              request.senderUsername != removedRequest.senderUsername)
          .toList(),
    );
  }

  void _onAcceptedRequest(dynamic data) {
    final response = data as Map<String, dynamic>;
    final accepterUsername = response['accepterUsername'] as String;
    final answer = response['answer'] as bool;

    final currentRequests = List<FriendRequest>.from(state.sentRequests);
    state = state.copyWith(
      sentRequests: currentRequests
          .where((request) => request.receiverUsername != accepterUsername)
          .toList(),
    );

    if (!answer) return;
    var message = S.current.friend_requests_request_accepted(accepterUsername);

    _audioPlayer.play(AssetSource('sounds/message1.mp3'));
    
    _notificationService.showTopRightNotification(
      message: message,
      icon: Icons.how_to_reg,
    );
  }

  void _showFriendRequestNotification(FriendRequest request) {
    var message =
        S.current.friend_requests_new_request_from(request.senderUsername);
    _notificationService.showTopRightNotification(
      message: message,
      icon: Icons.person_add,
    );
  }

  void _showUnseenRequestsNotification(List<FriendRequest> unseenRequests) {
    if (unseenRequests.isEmpty) return;

    var message =
        S.current.friend_requests_multiple_requests(unseenRequests.length);

    _notificationService.showTopRightNotification(
      message: message,
      icon: Icons.group_add,
      actionCallback: () {
        navigatorKey.currentContext?.go('/personal-profile?tab=friends');
      },
    );

    for (final request in unseenRequests) {
      sawFriendRequest(request.id);
    }
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': _authService.getSessionId(),
    };
  }
}

final getFriendStatusProvider =
    AutoDisposeProvider.family<FriendStatus, String>((ref, username) {
  if (username ==
      ref.watch(userInfoServiceProvider.select((state) => state.username))) {
    return FriendStatus.self;
  }

  final friendsSet = {
    ...ref.watch(friendsServiceProvider.select((state) => state.friends))
  };
  if (friendsSet.contains(username)) return FriendStatus.friend;

  final sentRequest =
      ref.watch(friendsServiceProvider.select((state) => state.sentRequests));
  final sentRequestsSet = {
    ...sentRequest.map((request) => request.receiverUsername)
  };
  if (sentRequestsSet.contains(username)) return FriendStatus.sentRequest;

  final receivedRequest = ref
      .watch(friendsServiceProvider.select((state) => state.receivedRequests));
  final receivedRequestsSet = {
    ...receivedRequest.map((request) => request.senderUsername)
  };
  if (receivedRequestsSet.contains(username)) {
    return FriendStatus.receivedRequest;
  }

  return FriendStatus.none;
});
