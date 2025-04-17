import 'package:flutter/material.dart';
import 'package:android_app/services/games/game_lobby_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class GameLobbyControl extends ConsumerStatefulWidget {
  const GameLobbyControl({super.key});

  @override
  ConsumerState<GameLobbyControl> createState() => _GameLobbyControlState();
}

class _GameLobbyControlState extends ConsumerState<GameLobbyControl> {
  void startGame(GameLobbyService gameLobbyService) {
    gameLobbyService.startGame();
  }

  void toggleLock(GameLobbyService gameLobbyService) {
    gameLobbyService.toggleLobbyLock();
  }

  @override
  Widget build(BuildContext context) {
    final gameLobbyService = ref.read(gameLobbyServiceProvider);
    final gameLobbyState = ref.watch(gameLobbyStateProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: gameLobbyState.canStartGame
              ? () => startGame(gameLobbyService)
              : null,
          style: ElevatedButton.styleFrom(fixedSize: Size(250, 45)),
          child: Text(S.of(context).game_lobby_start_game),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => toggleLock(gameLobbyService),
          style: ElevatedButton.styleFrom(fixedSize: Size(250, 45)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gameLobbyState.isLobbyLocked ? Icons.lock : Icons.lock_open,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                gameLobbyState.isLobbyLocked 
                  ? S.of(context).game_lobby_unlock_game 
                  : S.of(context).game_lobby_lock_game
              ),
            ],
          ),
        ),
      ],
    );
  }
}