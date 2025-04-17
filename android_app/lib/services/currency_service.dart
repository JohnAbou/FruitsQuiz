import 'package:android_app/providers/uri_provider.dart';
import 'package:android_app/services/auth_service.dart';
import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CurrencyNotifier extends StateNotifier<int> {
  final String currencyApiUrl;
  final AuthService authService;  
  final SocketConnectionService socketService;

  CurrencyNotifier({
    required this.currencyApiUrl,
    required this.authService,
    required this.socketService,
  }) : super(0) {
    authService.onConnectionSubject.subscribe((_) { init(); });
  }

  get balance => state;

  void init() {
    socketService.onUnique('currency-socket:newBalance', (data) {
      _updateBalance(data['balance'] as int);
    });

    socketService.emit('currency-socket:join', authService.getSessionId());
  }

  _updateBalance(int newBalance) {
    state = newBalance;
  }
}

final currencyProvider = StateNotifierProvider<CurrencyNotifier, int>((ref) {
  final authService = ref.read(authServiceProvider);
  final socketService = ref.read(socketConnectionServiceProvider);
  final currencyApiUrl = ref.read(apiUrlProvider);

  return CurrencyNotifier(currencyApiUrl: currencyApiUrl, authService: authService, socketService: socketService);
});