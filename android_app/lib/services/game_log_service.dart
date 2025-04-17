import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/models/game_log.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GameLogService extends StateNotifier<List<GameLog>> {
  final String baseUrl;
  final AuthService authService;

  GameLogService({required this.baseUrl, required this.authService}) : super([]);

  Future<void> reloadGameLogs() async {
    try {
      final logs = await _fetchGameLogs();
      state = logs.reversed.toList();
    } catch (e) {
      // shuuuuuuuuuuuuut
    }
  }

  Future<List<GameLog>> _fetchGameLogs() async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/me/game-logs'),
      headers: _getSessionIdHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> logsJson = json.decode(response.body);
      return logsJson.map((log) => GameLog.fromJson(log)).toList();
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

final gameLogServiceProvider = StateNotifierProvider<GameLogService, List<GameLog>>((ref) {
  final authService = ref.read(authServiceProvider);
  final url = ref.read(apiUrlProvider);
  return GameLogService(baseUrl: url, authService: authService);
});
