import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/timer_service.dart';

class Timer extends ConsumerWidget {
  final double radius;

  const Timer({
    super.key,
    this.radius = 100.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = ref.watch(timerProvider);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        color: primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$time',
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.4, // Make font size relative to radius
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
