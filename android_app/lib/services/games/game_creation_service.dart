import 'package:android_app/generated/l10n.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/currency_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/quizzes/quizzes_services.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameCreationServiceProvider =
    ChangeNotifierProvider<GameCreationService>((ref) {
  return GameCreationService(
      ref.read(socketConnectionServiceProvider),
      ref.watch(authStateProvider),
      ref.read(currencyProvider.notifier),
      ref.read(notificationServiceProvider),
      ref.read(quizzesStateProvider.notifier));
});

class GameCreationService extends ChangeNotifier {
  final SocketConnectionService _socket;
  final CurrencyNotifier _currencyService;
  final NotificationService _notificationService;
  final AuthState _authState;
  final QuizzesService _quizzesService;

  int _questionCount = 5;
  int _entryFee = 0;
  bool _isFriendsOnly = false;

  int get questionCount => _questionCount;
  int get entryFee => _entryFee;
  bool get isFriendsOnly => _isFriendsOnly;

  set entryFee(int value) {
    _entryFee = value;
    notifyListeners();
  }

  set questionCount(int value) {
    _questionCount = value;
    notifyListeners();
  }

  set isFriendsOnly(bool value) {
    _isFriendsOnly = value;
    notifyListeners();
  }

  GameCreationService(this._socket, this._authState, this._currencyService,
      this._notificationService, this._quizzesService) {
    _quizzesService.survivalQuizSelectedSubject.subscribe((value) {
      _entryFee = 0;
      notifyListeners();
    });
  }

  bool createGame(String quizId, bool isClassicMode) {
    if (_entryFee > _currencyService.balance && quizId == randomQuiz.id) {
      _notificationService.showBottomLeftNotification(S.current.game_creation_not_enough_balance);
      return false;
    }

    String socketEventName = quizId == survivalQuiz.id ? 'createGameSurvival' : 'createGameLobby';

    _socket.emit(socketEventName, {
      'quizId': quizId,
      'sessionId': _authState.sessionId,
      'isFriendsOnly': _isFriendsOnly,
      'questionCount': _questionCount,
      'entryFee': _entryFee,
    });

    questionCount = 5;
    entryFee = 0;
    _quizzesService.updateSelectedQuiz(emptyQuiz);

    return true;
  }
}
