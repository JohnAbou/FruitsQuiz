import 'dart:convert';
import 'package:android_app/models/avatar_modified_event.dart';
import 'package:android_app/models/user.dart';
import 'package:android_app/models/username_modified_event.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/friends_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/services/user_info_service.dart';
import 'package:android_app/utils/subject.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class UsersState {
  final List<User> users;

  UsersState({this.users = const []});

  UsersState copyWith({
    List<User>? users,
  }) {
    return UsersState(
      users: users ?? this.users,
    );
  }
}

class UsersService extends StateNotifier<UsersState> {
  final AuthService _authService;
  final String _baseUrl;

  final Subject<UsernameModifiedEvent> usernameModified = Subject();
  final Subject<AvatarModifiedEvent> avatarModified = Subject();

  UsersService({
    required AuthService authService,
    required SocketConnectionService socketService,
    required String baseUrl,
  })  : _authService = authService,
        _baseUrl = baseUrl,
        super(UsersState()) {
    _loadUsers();
    _initializeSocket(socketService);
  }

  Future<User?> getUser(String username) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/$username'),
      headers: {'Content-Type': 'application/json',},
    );

    return response.statusCode == 200
        ? User.fromJson(json.decode(response.body))
        : null;
  }

  Future<void> _loadUsers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<User> users = data.map((e) => User.fromJson(e)).toList();
      state = state.copyWith(users: users);
    }
  }

  void _initializeSocket(SocketConnectionService socketService) {
    socketService.onUnique('users-socket:newUserRegistered', (user) {
      _addUser(User.fromJson(user));
    });

    socketService.on('usernameModified', (event) {
      _updateUserUsername(UsernameModifiedEvent.fromJson(event));
    });

    socketService.on('avatarModified', (event) {
      _updateUserAvatar(AvatarModifiedEvent.fromJson(event));
    });
  }

  void _addUser(User user) {
    state = state.copyWith(users: [...state.users, user]);
  }

  void _updateUserUsername(UsernameModifiedEvent event) {
    final updatedUsers = state.users.map((u) {
      return u.username == event.oldUsername
          ? u.copyWith(username: event.newUsername)
          : u;
    }).toList();

    state = state.copyWith(users: updatedUsers);
    usernameModified.signal(event);
  }

    void _updateUserAvatar(AvatarModifiedEvent event) {
    final updatedUsers = state.users.map((u) {
      return u.username == event.username
          ? u.copyWith(activeAvatarId: event.newAvatar)
          : u;
    }).toList();

    state = state.copyWith(users: updatedUsers);
    avatarModified.signal(event);
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': _authService.getSessionId(),
    };
  }
}

final usersProvider = StateNotifierProvider<UsersService, UsersState>((ref) {
  final authService = ref.read(authServiceProvider);
  final socketService = ref.read(socketConnectionServiceProvider);
  final baseUrl = ref.read(apiUrlProvider);

  return UsersService(
    authService: authService,
    socketService: socketService,
    baseUrl: baseUrl,
  );
});

final userProviderById = AutoDisposeProvider.family<User, String>((ref, id) {
  final users = ref.watch(usersProvider).users;
  return users.firstWhere((user) => user.id == id,
      orElse: () => User(
          id: id, username: '', email: '', activeAvatarId: '', avatarIds: []));
});

final userProviderByUsername = AutoDisposeProvider.family<User, String>((ref, username) {

  final userId = ref.read(usersProvider).users
      .firstWhere((user) => user.username == username,
          orElse: () => User(id: '', username: username, email: '', activeAvatarId: '', avatarIds: []))
      .id;

  return ref.watch(userProviderById(userId));
});

final nonFriendUsersProvider = Provider<List<User>>((ref) {
  final allUsers = ref.watch(usersProvider).users;
  final friends = ref.watch(friendsServiceProvider).friends;
  final ownUsername = ref.watch(userInfoServiceProvider).username;

  final friendUsernames = {...friends, ownUsername};

  return allUsers
      .where((user) => !friendUsernames.contains(user.username))
      .toList();
});

final userFutureProvider = FutureProvider.family<User, String>((ref, id) async {
  final users = ref.watch(usersProvider).users;
  return users.firstWhere((user) => user.id == id,
      orElse: () => User(
          id: id, username: '', email: '', activeAvatarId: '', avatarIds: []));
});
