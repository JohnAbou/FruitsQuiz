import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/services/games/game_players_service.dart';
import 'package:android_app/widgets/game_player_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_info_service.dart';

class ResultsStatsLeaderboard extends ConsumerWidget {
  const ResultsStatsLeaderboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNormalGame = ref.watch(gameInfoStateProvider
        .select((state) => state.gameType == GameType.normalGame));

    return GamePlayerList(
      showRound: !isNormalGame,
      showScore: isNormalGame,
      sortFunction: isNormalGame ? scoreSortFunction : roundSortFunction,
      showCard: false,
      showText: false,
      displayHeader: true,
      showBonus: isNormalGame,
      inResultPage: true,
    );
  }
}
