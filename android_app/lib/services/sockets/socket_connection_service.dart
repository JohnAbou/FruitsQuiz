import 'package:android_app/providers/uri_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final socketConnectionServiceProvider =
    Provider<SocketConnectionService>((ref) {
  final socketsUrl = ref.read(socketsUrlProvider);
  return SocketConnectionService(socketsUrl);
});

class SocketConnectionService {
  final String _baseUrl;
  io.Socket? _socket;

  SocketConnectionService(this._baseUrl);

  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = io.io(_baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'path': '/websocket',
      'autoConnect': true,
    });
  }

  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  void emitWithAck(String event, Function(dynamic) ack, [dynamic data]) {
    _socket?.emitWithAck(event, data, ack: ack);
  }

  void on(String event, void Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void onUnique(String event, void Function(dynamic) callback) {
    _socket?.off(event);
    on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void offCallback(String event, void Function(dynamic) callback) {
    _socket?.off(event, callback);
  }
}
