import 'package:android_app/services/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/widgets/timer.dart';

class OrganizerTimer extends ConsumerStatefulWidget {
  const OrganizerTimer({super.key});

  @override
  ConsumerState<OrganizerTimer> createState() => _TimerState();
}

class _TimerState extends ConsumerState<OrganizerTimer> {
  bool isPaused = false;

  void startPanic() {
    ref.read(timerStateProvider.notifier).startPanic();
    setState(() {
      isPaused = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerStateProvider);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Timer(),
            const SizedBox(width: 16),
            
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: timerState.canTogglePause
                      ? () {
                          ref.read(timerStateProvider.notifier).togglePause();
                          setState(() {
                            isPaused = !isPaused;
                          });
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Image.asset(
                    isPaused ? 'assets/images/play_icon.png' : 'assets/images/pause_icon1.png',
                    width: 30,
                    height: 30,
                  ),
                ),
                
                const SizedBox(height: 10),
                
                ElevatedButton(
                  onPressed: timerState.canStartPanic
                      ? () => startPanic()
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/panic_icon1.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
