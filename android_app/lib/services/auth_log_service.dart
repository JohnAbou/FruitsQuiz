import 'package:android_app/models/auth_log.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthLogService extends StateNotifier<List<AuthLog>> {
  final String baseUrl;
  final AuthService authService;

  AuthLogService({required this.baseUrl, required this.authService}) : super([]);

  Future<void> reloadAuthLogs() async {
    try {
      final logs = await _fetchAuthLogs();
      state = logs.reversed.toList();
    } catch (e) {
      // shuuuuut
    }
  }

  Future<List<AuthLog>> _fetchAuthLogs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/me/authentication-logs'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> logsJson = json.decode(response.body);
      return logsJson.map((log) => AuthLog.fromJson(log)).toList();
    }
    return [];
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': authService.getSessionId(),
    };
  }
}

final authLogServiceProvider = StateNotifierProvider<AuthLogService, List<AuthLog>>((ref) {
  final authService = ref.read(authServiceProvider);
  final url = ref.read(apiUrlProvider);
  return AuthLogService(baseUrl: url, authService: authService);
});
