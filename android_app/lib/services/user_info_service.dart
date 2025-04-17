import 'dart:convert';
import 'package:android_app/models/user.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserInfoService extends StateNotifier<User> {
  final String baseUrl;
  final AuthService authService;

  UserInfoService(
    super.state,
    this.baseUrl,
    this.authService,
  ) {
    authService.onConnectionSubject.subscribe((_) {
      _loadUsers();
    });

    if (authService.getSessionId().isNotEmpty) {
      _loadUsers();
    }
  }

  getUsername() {
    return state.username;
  }

  Future<void> _loadUsers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/me'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final dynamic data = json.decode(response.body);
      state = User.fromJson(data);
    }
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': authService.getSessionId(),
    };
  }

  Future<Map<String, dynamic>> updateUsername(String newUsername) async {
    final response = await http.put(
      Uri.parse('$baseUrl/accounts/me/username'),
      headers: _getSessionIdHeaders(),
      body: json.encode({'newUsername': newUsername}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _loadUsers();
      return {'success': true};
    } else {
      return {
        'success': false,
        'error': responseData['error'] ?? 'ERROR'
      };
    }
  }

  Future<void> setPredefinedAvatar(String avatarUrl) async {
    state = state.copyWith(activeAvatarId: avatarUrl);

    await http.post(
      Uri.parse('$baseUrl/accounts/me/avatar/select'),
      headers: _getSessionIdHeaders(),
      body: json.encode({'avatarUrl': avatarUrl}),
    );

    await _loadUsers();
  }

  Future<void> uploadUserAvatarFile(XFile pickedFile) async {
    final uri = Uri.parse('$baseUrl/accounts/me/avatar/upload');
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll(_getSessionIdHeaders());

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      pickedFile.path,
      filename: path.basename(pickedFile.path),
    ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody);
      final uploadedAvatarUrl = data['avatarId'] ?? data['avatarUrl'];

      if (uploadedAvatarUrl != null) {
        await setPredefinedAvatar(uploadedAvatarUrl);
      }

      await _loadUsers();
    } else {
      throw Exception('Failed to upload avatar: $responseBody');
    }
  }
}

final userInfoServiceProvider =
    StateNotifierProvider<UserInfoService, User>((ref) {
  final baseUrl = ref.read(apiUrlProvider);
  final authService = ref.read(authServiceProvider);

  final emptyUser = User(
    id: '',
    username: '',
    email: '',
    avatarIds: [],
    activeAvatarId: '',
  );

  return UserInfoService(emptyUser, baseUrl, authService);
});
