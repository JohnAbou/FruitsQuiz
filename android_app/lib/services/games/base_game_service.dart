import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class BaseGameService<T> extends StateNotifier<T> {
  final SocketConnectionService socketService;
  final Map<String, List<void Function(dynamic)>> _socketListeners = {};

  BaseGameService(this.socketService, T initialState) : super(initialState) {
    initializeSocket();
  }

  void initializeState();

  void initializeSocket() {
    addSocketListener('kickedOutFromGame', (_) {
      initializeState();
    });
    setUpSocketListener();
  }

  void addSocketListener(String listener, void Function(dynamic) callback) {
    if (_socketListeners[listener] == null){
      _socketListeners[listener] = [callback];
    } else {
      _socketListeners[listener]!.add(callback);
    }

    socketService.on(listener, (data) {
      Future.microtask(() => callback(data));
    });
  }

  @protected
  void setUpSocketListener();

  @override
  void dispose() {
    for (var entry in _socketListeners.entries) {
      String listener = entry.key;
      for (var callback in entry.value) {
        socketService.offCallback(listener, callback);
      }
    }
    super.dispose();
  }
}
