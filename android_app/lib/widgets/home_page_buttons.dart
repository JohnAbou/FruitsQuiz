import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/generated/l10n.dart';

class HomePageButtons extends StatefulWidget {
  const HomePageButtons({super.key});

  @override
  State<HomePageButtons> createState() => _HomePageButtonsState();
}

class _HomePageButtonsState extends State<HomePageButtons> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Animated "Join Game" button
        ScaleTransition(
          scale: _scaleAnimation,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: Text(S.of(context).home_page_join_game),
            onPressed: () => context.go('/game-joining'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: const Size(300, 60),
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Create Game button with matching style
        ScaleTransition(
          scale: _scaleAnimation,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add_circle_outline),
            label: Text(S.of(context).home_page_create_game),
            onPressed: () => context.go('/game-creation'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: colorScheme.primary,
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: const Size(300, 60),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }
}

