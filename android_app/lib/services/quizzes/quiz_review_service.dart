import 'dart:convert';
import 'package:android_app/models/quizzes/quiz_review.dart';
import 'package:android_app/models/quizzes/quiz_reviews_info.dart';
import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final quizReviewServiceProvider = Provider<QuizReviewService>((ref) {
  final authState = ref.watch(authStateProvider);
  final apiUrl = ref.read(apiUrlProvider);
  final socketService = ref.read(socketConnectionServiceProvider);
  return QuizReviewService(
      socketService: socketService, authState: authState, baseUrl: apiUrl);
});

class QuizReviewService {
  final SocketConnectionService socketService;
  final AuthState authState;
  final String baseUrl;

  QuizReviewService({
    required this.socketService,
    required this.authState,
    required this.baseUrl,
  });

  Future<QuizReviewsInfo> getQuizReviewsInfo(String quizId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/quiz/$quizId/reviews'),
      headers: _getSessionIdHeaders(),
    );

    final body = jsonDecode(response.body);
    return response.statusCode == 200 && body != null
        ? QuizReviewsInfo.fromJson(body)
        : QuizReviewsInfo(quizId: quizId, averageScore: 0, reviewCount: 0);
  }

  Future<QuizReview> getQuizReview(String quizId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/quiz/$quizId/reviews/me'),
      headers: _getSessionIdHeaders(),
    );

    final body = jsonDecode(response.body);
    return response.statusCode == 200 && body != null
        ? QuizReview.fromJson(body)
        : QuizReview(quizId: quizId, score: -1);
  }

  Future<void> addQuizReview(String quizId, QuizReview review) async {
    await http.post(
      Uri.parse('$baseUrl/quiz/$quizId/reviews'),
      headers: _getSessionIdHeaders(),
      body: jsonEncode(review.toJson()),
    );
  }

  void onQuizReviewUpdated(String quizId, void Function(void) callback) {
    socketService.on(
      'quizReviewsInfoChangedNotification-$quizId',
      callback,
    );
  }

  void offQuizReviewUpdated(String quizId) {
    socketService.off('quizReviewsInfoChangedNotification-$quizId');
  }

  Map<String, String> _getSessionIdHeaders() {
    return {
      'Content-Type': 'application/json',
      'x-session-id': authState.sessionId,
    };
  }
}
