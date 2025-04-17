import 'package:android_app/pages/game_pages/game_intermission_page.dart';
import 'package:android_app/pages/game_pages/game_leaderboard_page.dart';
import 'package:android_app/pages/game_pages/game_play_page.dart';
import 'package:android_app/pages/game_pages/game_waiting_page.dart';
import 'package:android_app/services/games/game_service_initializer.dart';
import 'package:android_app/widgets/chat_widgets/chat.dart';
import 'package:android_app/widgets/themed_scaffold.dart';
import 'package:android_app/widgets/top_bar_widgets/game_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/games/game_state_service.dart';
import '../../models/enums/user_game_state.dart';

class GameViewPage extends ConsumerStatefulWidget {
  const GameViewPage({super.key});

  @override
  ConsumerState<GameViewPage> createState() => _GameViewState();
}

class _GameViewState extends ConsumerState<GameViewPage> {
  @override
  void initState() {
    super.initState();

    ref.read(gameServiceInitializerProvider).initializeGameState();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    Widget page;
    switch (gameState.userState) {
      case UserGameState.inLobby:
        page = const GameWaitingPage();
      case UserGameState.inGame:
        page = const GamePlayPage();
      case UserGameState.leaderboard:
        page = const GameLeaderboardPage();
      case UserGameState.intermission:
      case UserGameState.loading:
        return const GameIntermissionPage();
      default:
        page = const ThemedScaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ThemedScaffold(
      appBar: GameTopBar(),
      body: Stack(
        children: [
          Column(
            children: [
              page,
            ],
          ),
          ChatWidget(),
        ],
      ),
    );
  }
}
