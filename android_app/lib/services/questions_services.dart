import 'dart:convert';

import 'package:android_app/providers/uri_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/models/question.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/states/questions_state.dart';
import 'package:http/http.dart' as http;

final questionsStateProvider =
    StateNotifierProvider<QuestionsService, QuestionsState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final apiUrl = ref.read(apiUrlProvider);
  return QuestionsService(socketService, apiUrl);
});

class QuestionsService extends StateNotifier<QuestionsState> {
  final SocketConnectionService _socket;
  final String _apiUrl;

  QuestionsService(this._socket, this._apiUrl) : super(const QuestionsState()) {
    _socket.on('questionChangedNotification', (_) => _loadQuestions());
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final response = await http.get(Uri.parse('$_apiUrl/question'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final questions = data.map((json) => Question.fromJson(json)).toList();
      state = state.copyWith(questions: questions);
    }
  }

  @override
  void dispose() {
    _socket.off('questionChangedNotification');
    super.dispose();
  }
}
