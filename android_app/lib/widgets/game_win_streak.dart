import 'package:android_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_results_service.dart';
import 'package:android_app/models/win_streak_update.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GameWinStreak extends ConsumerWidget {
  const GameWinStreak({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final winStreakUpdate =
        ref.watch(gameResultProvider.select((state) => state.winStreakUpdate));

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: _getBackgroundColor(winStreakUpdate.wsState),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: _getIconColor(winStreakUpdate.wsState),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconColor(winStreakUpdate.wsState),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: _getIcon(winStreakUpdate.wsState),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStatusText(winStreakUpdate.wsState, context),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.fire, size: 20),
                    SizedBox(width: 4),
                    Text(
                      '${winStreakUpdate.current}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(WinStreakState state) {
    switch (state) {
      case WinStreakState.lost:
        return Color(0xFFFFF0F0);
      case WinStreakState.improved:
        return Color(0xFFF0FFF4);
      case WinStreakState.best:
        return Color(0xFFFFFBEA);
    }
  }

  Color _getIconColor(WinStreakState state) {
    switch (state) {
      case WinStreakState.lost:
        return Color(0xFFFF6B6B);
      case WinStreakState.improved:
        return Color(0xFF48BB78);
      case WinStreakState.best:
        return Color(0xFFECC94B);
    }
  }

  Icon _getIcon(WinStreakState state) {
    switch (state) {
      case WinStreakState.lost:
        return Icon(FontAwesomeIcons.xmark, color: Colors.white);
      case WinStreakState.improved:
        return Icon(FontAwesomeIcons.arrowUp, color: Colors.white);
      case WinStreakState.best:
        return Icon(FontAwesomeIcons.trophy, color: Colors.white);
    }
  }

  String _getStatusText(WinStreakState state, BuildContext context) {
    switch (state) {
      case WinStreakState.lost:
        return S.of(context).game_win_streak_streak_lost;
      case WinStreakState.improved:
        return S.of(context).game_win_streak_streak_improved;
      case WinStreakState.best:
        return S.of(context).game_win_streak_streak_best;
    }
  }
}
