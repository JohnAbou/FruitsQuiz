import 'dart:convert';
import 'package:android_app/models/user_stats.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/auth_service.dart';
class UsersStatService {
  final String _baseUrl;

  UsersStatService({
    required String baseUrl,
  }) : _baseUrl = baseUrl;

  Future<UserStats?> getUser(String userId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/accounts/stats/$userId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200
        ? UserStats.fromJson(json.decode(response.body))
        : null;
  }

  Future<List<UserWithStats>> getUsersStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/accounts/stats/all'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List)
            .where((user) => user['userStats'] != null)
            .map((user) => UserWithStats.fromJson(user as Map<String, dynamic>))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<UserStats?> getLoggedInUserStats(String sessionId) async {
  final response = await http.get(
    Uri.parse('$_baseUrl/accounts/me/stats'),
    headers: {
      'Content-Type': 'application/json',
      'x-session-id': sessionId, // Matches your AuthService header format
    },
  );

  return response.statusCode == 200
      ? UserStats.fromJson(json.decode(response.body))
      : null;
}


}



final usersStatServiceProvider = Provider<UsersStatService>((ref) {
  return UsersStatService(baseUrl: ref.read(apiUrlProvider));
});

final userStatsProvider =
    FutureProvider.family<UserStats?, String>((ref, userId) async {
  final userService = ref.read(usersStatServiceProvider);
  return await userService.getUser(userId);
});

final allUsersStatsProvider = FutureProvider<List<UserWithStats>>((ref) async {
  final userService = ref.read(usersStatServiceProvider);
  return await userService.getUsersStats();
});

final loggedInUserStatsProvider = FutureProvider<UserStats?>((ref) async {
  final authService = ref.read(authServiceProvider);
  final sessionId = authService.getSessionId();

  if (sessionId.isEmpty) return null;

  final statsService = ref.read(usersStatServiceProvider);
  return await statsService.getLoggedInUserStats(sessionId);
});



