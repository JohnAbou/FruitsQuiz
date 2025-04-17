import 'dart:convert';
import 'package:android_app/models/language_settings.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageSettingServiceProvider = Provider<LanguageSettingsService>((ref) {
  final authState = ref.watch(authStateProvider);
  final apiUrl = ref.read(apiUrlProvider);
  final socketService = ref.read(socketConnectionServiceProvider);
  return LanguageSettingsService(
      socketService: socketService, authState: authState, baseUrl: apiUrl);
});

class LanguageSettingsService {
  final SocketConnectionService socketService;
  final AuthState authState;
  final String baseUrl;

  LanguageSettingsService({
    required this.socketService,
    required this.authState,
    required this.baseUrl,
  });

  Future<String> getUserLanguage(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/language/$userId'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return LanguageResponse.fromJson(body).language;
    }
    throw Exception('Failed to fetch language');
  }

  Future<void> updateUserLanguage(String userId, String language) async {
    final requestBody = LanguageUpdateRequest(language: language);
    final response = await http.post(
      Uri.parse('$baseUrl/language/$userId'),
      headers: _getSessionIdHeaders(),
      body: jsonEncode(requestBody.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update language');
    }
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': authState.sessionId,
    };
  }
}
