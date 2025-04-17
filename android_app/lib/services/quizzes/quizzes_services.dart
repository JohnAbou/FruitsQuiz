import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:android_app/utils/Subject.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/quizzes/quiz.dart';
import '../../../states/quizzes_state.dart';
import '../../../providers/uri_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

final quizzesStateProvider =
    StateNotifierProvider<QuizzesService, QuizzesState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  final apiUrl = ref.read(apiUrlProvider);
  final authService = ref.read(authServiceProvider);
  return QuizzesService(
      socketService, apiUrl, authService);
});

const randomQuiz = Quiz(
  id: 'random-quiz-id',
  title: '',
  description: '',
  questions: [],
  duration: 0,
  isPublic: true,
  owner: '',
);

const survivalQuiz = Quiz(
  id: 'survival-quiz-id',
  title: '',
  description: '',
  questions: [],
  duration: 0,
  isPublic: true,
  owner: '',
);

const emptyQuiz = Quiz(
  id: 'empty-quiz-id',
  title: '',
  description: '',
  questions: [],
  duration: 0,
  isPublic: true,
  owner: '',
);

class QuizzesService extends StateNotifier<QuizzesState> {
  final SocketConnectionService _socket;
  final String _apiUrl;
  final AuthService _authService;
  final List<VoidCallback> _listeners = [];
  final Subject<bool> survivalQuizSelectedSubject = Subject<bool>();

  QuizzesService(
      this._socket, this._apiUrl, this._authService)
      : super(const QuizzesState(selectedQuiz: emptyQuiz)) {
    _socket.on('quizChangedNotification', (_) => _handleQuizChange());
    _authService.onConnectionSubject.subscribe((_) => _handleQuizChange());
    _loadQuizzes();
  }

  void addCustomListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeCustomListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  List<Quiz> getAllQuizzes() {
    return state.quizzes;
  }

  Future<void> _handleQuizChange() async {
    await _loadQuizzes();
    _notifyListeners();
  }

  void updateSelectedQuiz(Quiz quiz) {
    state = state.copyWith(selectedQuiz: quiz);
    if (quiz.id == 'survival-quiz-id') {
      survivalQuizSelectedSubject.signal(true);
    }
  }

  Future<void> _loadQuizzes() async {
    final response = await http.get(
      Uri.parse('$_apiUrl/quiz'),
      headers: {'x-session-id': _authService.state.sessionId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final quizzes = data.map((json) => Quiz.fromJson(json)).toList();
      state = state.copyWith(quizzes: quizzes);
    }
  }

  @override
  void dispose() {
    _socket.off('quizChangedNotification');
    _listeners.clear();
    super.dispose();
  }
}
