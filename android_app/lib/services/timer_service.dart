import 'package:android_app/services/sockets/socket_connection_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';


class TimerState {
  final int timer;
  final bool canTogglePause;
  final bool canStartPanic;

  const TimerState({
    this.timer = 0,
    this.canTogglePause = false,
    this.canStartPanic = false,
  });

  TimerState copyWith({
    int? timer,
    bool? canTogglePause,
    bool? canStartPanic,
  }) {
    return TimerState(
      timer: timer ?? this.timer,
      canTogglePause: canTogglePause ?? this.canTogglePause,
      canStartPanic: canStartPanic ?? this.canStartPanic,
    );
  }
}

class TimerStateNotifier extends StateNotifier<TimerState> {
  final SocketConnectionService socketService;
  final AudioPlayer _audioPlayer = AudioPlayer();

  TimerStateNotifier({required this.socketService}) : super(const TimerState()) {
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    socketService.on('timerTicked', (data) {
      if (data is int) {
        state = state.copyWith(timer: data);
      }
    });

    socketService.on('canToggleTimerPause', (data) {
      if (data is bool) {
        state = state.copyWith(canTogglePause: data);
      }
    });

    socketService.on('canStartTimerPanic', (data) {
      if (data is bool) {
        state = state.copyWith(canStartPanic: data);
      }
    });

    socketService.on('startTimerPanic', (data) {
      if (data is bool) {
        state = state.copyWith(canStartPanic: data);
      }
    });

    socketService.on('onPanicModeStarted', (_) {
      _playPanicSound();
    });
  }

  void togglePause() {
    if (state.canTogglePause) {
      socketService.emit('toggleTimerPause');
    }
  }

  void startPanic() {
    if (state.canStartPanic) {
      socketService.emit('startTimerPanic');
    }
  }

  Future<void> _playPanicSound() async {
    _audioPlayer.play(AssetSource('sounds/panic-sound.mp3'));
  }
}

final timerStateProvider = StateNotifierProvider<TimerStateNotifier, TimerState>((ref) {
  final socketService = ref.watch(socketConnectionServiceProvider);
  return TimerStateNotifier(socketService: socketService);
});

final timerProvider = Provider<int>((ref) {
  return ref.watch(timerStateProvider).timer;
});