import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/bot_player.dart';
import 'package:android_app/models/enums/bot_difficulty.dart';
import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/models/player.dart';
import 'package:android_app/services/games/game_lobby_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/services/users_service.dart';
import 'package:android_app/widgets/profile_avatar_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/services/games/game_players_service.dart';

class GamePlayerList extends ConsumerWidget {
  final bool showScore;
  final bool showBonus;
  final bool showRound;
  final bool banOption;
  final bool showCard;
  final bool inWaitPage;
  final bool inResultPage;
  final bool showText;
  final bool displayHeader;
  final List<Player> Function(List<Player>) sortFunction;

  const GamePlayerList({
    super.key,
    this.showScore = false,
    this.showBonus = false,
    this.banOption = false,
    this.showRound = false,
    this.showCard = true,
    this.inWaitPage = false,
    this.inResultPage = false,
    this.showText = true,
    this.displayHeader = false,
    this.sortFunction = defaultSortFunction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlayersState = ref.watch(gamePlayersStateProvider);
    final isOrganizer =
        ref.read(gameStateProvider).userRole == UserGameRole.organizer;
    final sortedPlayers = sortFunction(gamePlayersState.players);

    return Container(
      width: inWaitPage
          ? MediaQuery.of(context).size.width / 3
          : MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16.0),
      child: showCard
          ? Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child:
                    _buildPlayerList(sortedPlayers, ref, context, isOrganizer),
              ),
            )
          : _buildPlayerList(sortedPlayers, ref, context, isOrganizer),
    );
  }

  Widget _buildPlayerList(List<Player> players, WidgetRef ref,
      BuildContext context, bool isOrganizer) {
    return Column(
      children: [
        if (showText) Text(
          S.of(context).player_list_title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (showText) Divider(
          color: Theme.of(context).colorScheme.primary,
          thickness: 1.5,
        ),
        if (displayHeader)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(S.of(context).player,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  if (inResultPage)
                    Expanded(
                      flex: 2,
                      child: Center(),
                    ),
                  if (showScore)
                    Expanded(
                      flex: 2,
                      child: Text(S.of(context).player_list_score,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  if (showBonus)
                    Expanded(
                      flex: 2,
                      child: Text('Bonus',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  if (showRound)
                    Expanded(
                      flex: 3,
                      child: Text(S.of(context).player_list_round_survived,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  if (banOption && inWaitPage) const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        const SizedBox(height: 4),
        SizedBox(
          height: inResultPage ? 260 : 200,
          child: SingleChildScrollView(
            child: Column(
              children: players.map((player) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            ProfileAvatarIconWidget(
                              user: player is! BotPlayer
                                  ? ref.watch(
                                      userProviderByUsername(player.name))
                                  : null,
                              bot: player is BotPlayer ? player : null,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              player.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (inWaitPage)
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: player is BotPlayer
                                ? (isOrganizer
                                    ? _buildBotDifficultyDropdown(
                                        player, ref, context)
                                    : _buildBotDifficultyText(player, context))
                                : const SizedBox.shrink(),
                          ),
                        ),
                      if (inResultPage)
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: player is BotPlayer
                                ? _buildBotDifficultyText(player, context)
                                : const SizedBox.shrink(),
                          ),
                        ),
                      if (showScore)
                        Expanded(
                          flex: 2,
                          child: Text('${player.score}',
                              textAlign: TextAlign.center),
                        ),
                      if (showBonus)
                        Expanded(
                          flex: 2,
                          child: Text('${player.bonusCount}',
                              textAlign: TextAlign.center),
                        ),
                      if (showRound)
                        Expanded(
                          flex: 3,
                          child: Text('${player.roundSurvived}',
                              textAlign: TextAlign.center),
                        ),
                      if (banOption && inWaitPage)
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            onPressed: () => ref
                                .read(gameLobbyServiceProvider)
                                .banPlayer(player.name),
                            icon: const Icon(Icons.block),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotDifficultyDropdown(
      BotPlayer player, WidgetRef ref, BuildContext context) {
    return DropdownButton<BotDifficulty>(
      value: player.difficulty,
      onChanged: (newDifficulty) {
        if (newDifficulty != null) {
          ref
              .read(gameLobbyServiceProvider)
              .updateBotDifficulty(player.name, newDifficulty.displayName);
        }
      },
      items: BotDifficulty.values
          .map<DropdownMenuItem<BotDifficulty>>((BotDifficulty value) {
        return DropdownMenuItem<BotDifficulty>(
          value: value,
          child: Text(
            BotDifficultyExtension.translateDifficulty(context, value),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBotDifficultyText(BotPlayer player, BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
        color: Colors.grey[200],
      ),
      child: Text(
        BotDifficultyExtension.translateDifficulty(context, player.difficulty),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _getDifficultyColor(player.difficulty),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getDifficultyColor(BotDifficulty difficulty) {
    switch (difficulty) {
      case BotDifficulty.expert:
        return const Color(0xFFFF0000);
      case BotDifficulty.intermediate:
        return const Color.fromARGB(255, 160, 160, 0);
      case BotDifficulty.beginner:
        return const Color(0xFF009700);
    }
  }
}
