import 'package:android_app/services/popup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final popupState = ref.watch(popupProvider);
    final popup = popupState.widget;
    final opacity = popupState.opacity;

    return Scaffold(
      body: Stack(
        children: [
          child,
          if (popup != null)
            IgnorePointer(
              ignoring: opacity == 0,
              child: Material(
                type: MaterialType.transparency,
                child: GestureDetector(
                  onTap: () {
                    ref.read(popupProvider.notifier).hide();
                  },
                  child: Container(
                    color: Colors.black.withAlpha((255 * opacity).toInt()),
                    width: double.infinity,
                    height: double.infinity,
                    child: Stack(
                      children: [popup],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
