import 'dart:convert';
import 'package:android_app/providers/uri_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:android_app/models/user_level_info.dart';
import 'package:android_app/services/auth_service.dart';

class UserLevelService {
  final String baseUrl;
  final AuthService authService;

  UserLevelService(this.baseUrl, this.authService);

  Future<UserExperienceInfo> getUserExpInfo() async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/me/exp-info'),
      headers: {
        'Content-Type': 'application/json',
        'x-session-id': authService.getSessionId(),
      },
    );

    if (response.statusCode == 200) {
      return UserExperienceInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user experience info');
    }
  }

  Future<UserExperienceInfo?> getUserExpInfoById(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/accounts/id/$id/exp-info'),
      headers: {
        'Content-Type': 'application/json',
        'x-session-id': authService.getSessionId(),
      },
    );

    if (response.statusCode == 200) {
      return UserExperienceInfo.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}

final userLevelServiceProvider = Provider<UserLevelService>((ref) {
  final baseUrl = ref.read(apiUrlProvider);
  final authService = ref.read(authServiceProvider);
  return UserLevelService(baseUrl, authService);
});

final userLevelProvider = FutureProvider<UserExperienceInfo?>((ref) async {
  final service = ref.read(userLevelServiceProvider);
  return await service.getUserExpInfo();
});

final userLevelByIdProvider =
    FutureProvider.family<UserExperienceInfo?, String>((ref, id) async {
  final service = ref.read(userLevelServiceProvider);
  return await service.getUserExpInfoById(id);
});