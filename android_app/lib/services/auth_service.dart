import 'package:android_app/models/signup_error.dart';
import 'package:android_app/models/user_preferences.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/utils/Subject.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final authStateProvider =
    StateNotifierProvider<AuthService, AuthState>((ref) => AuthService(ref));

final authServiceProvider =
    Provider<AuthService>((ref) => ref.read(authStateProvider.notifier));

class AuthState {
  final String sessionId;
  bool get isAuthenticated => sessionId.isNotEmpty;
  AuthState({String? sessionId, String? username})
      : sessionId = sessionId ?? "";

  AuthState copyWith({String? sessionId, String? username}) {
    return AuthState(sessionId: sessionId ?? this.sessionId);
  }
}

class AuthService extends StateNotifier<AuthState> {
  late String _apiUrl;
  late SocketConnectionService _socketService;

  Subject<String> onConnectionSubject = Subject();
  Subject<String> onDisconnectionSubject = Subject();
  Subject<UserPreferences> onPreferencesSubject = Subject();
  AuthService(Ref ref) : super(AuthState()) {
    _apiUrl = ref.read(apiUrlProvider);
    _socketService = ref.read(socketConnectionServiceProvider);
  }

  String getSessionId() {
    return state.sessionId;
  }

  Future<String> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/accounts/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _onSuccessfulAuth(data['sessionId'], UserPreferences.fromJson(data['preferences']), username);
      return '';
    }
    return data['error'] ?? 'AccountValidation.unknownError';
  }

  Future<SignupError> signup(
    String username,
    String email,
    String password, {
    required String avatar,
  }) async {
    final response = await http.post(
      Uri.parse('$_apiUrl/accounts/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'avatar': avatar,
      }),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      _onSuccessfulAuth(data['sessionId'], UserPreferences.fromJson(data['preferences']), username);
      return SignupError();
    }

    return SignupError(
        usernameError: data['usernameError'] ?? "",
        emailError: data['emailError'] ?? "",
        passwordError: data['passwordError'] ?? "");
  }

  logout() {
    _socketService.emit('forceDisconnect');
    state = AuthState();

    onDisconnectionSubject.signal('');
  }

  _onSuccessfulAuth(String sessionId, UserPreferences userPreferences, String username) {
    state = AuthState(sessionId: sessionId, username: username);
    _socketService.connect();

    _socketService.emit('join', {
      'sessionId': state.sessionId,
      'deviceType': 'android',
    });

    onConnectionSubject.signal(username);
    onPreferencesSubject.signal(userPreferences);
  }
}
