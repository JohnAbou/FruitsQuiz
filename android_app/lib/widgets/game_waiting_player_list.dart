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

class GamePlayerWaitingList extends ConsumerWidget {
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

  const GamePlayerWaitingList({
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
    final theme = Theme.of(context);

    if (!isOrganizer && inWaitPage) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.8,
            padding: const EdgeInsets.all(12.0),
            child: showCard
                ? Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _buildPlayerList(
                          sortedPlayers, ref, context, isOrganizer),
                    ),
                  )
                : _buildPlayerList(
                    sortedPlayers, ref, context, isOrganizer),
          ),
        ),
      );
    } else {
      return Center(
        child: Container(
          width: inWaitPage
              ? MediaQuery.of(context).size.width / 1.8
              : MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12.0),
          child: showCard
              ? Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildPlayerList(
                        sortedPlayers, ref, context, isOrganizer),
                  ),
                )
              : _buildPlayerList(sortedPlayers, ref, context, isOrganizer),
        ),
      );
    }
  }

  Widget _buildPlayerList(List<Player> players, WidgetRef ref,
      BuildContext context, bool isOrganizer) {
    final theme = Theme.of(context);

    return Column(
      children: [
        if (showText)
          Text(
            S.of(context).player_list_title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        if (showText)
          Divider(
            thickness: 2,
            color: theme.colorScheme.primary.withOpacity(0.3),
            height: 20,
          ),
        if (displayHeader)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(S.of(context).player,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  if (showBonus)
                    Expanded(
                      flex: 2,
                      child: Text('Bonus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  if (showRound)
                    Expanded(
                      flex: 3,
                      child: Text(S.of(context).player_list_round_survived,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  if (banOption && inWaitPage) const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        const SizedBox(height: 8),
        Container(
          height: inResultPage ? 320 : (inWaitPage ? 260 : 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              scrollbarTheme: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(
                  theme.colorScheme.primary.withOpacity(0.6),
                ),
                trackColor: MaterialStateProperty.all(
                  theme.colorScheme.primary.withOpacity(0.1),
                ),
                thickness: MaterialStateProperty.all(8.0),
                radius: const Radius.circular(10),
                thumbVisibility: MaterialStateProperty.all(true),
                trackVisibility: MaterialStateProperty.all(true),
              ),
            ),
            child: Scrollbar(
              thickness: 8,
              radius: const Radius.circular(10),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: players.length,
                separatorBuilder: (context, index) => Divider(
                  height: 24,
                  color: theme.colorScheme.primary.withOpacity(0.1),
                ),
                itemBuilder: (context, index) {
                  final player = players[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: index % 2 == 0
                          ? theme.colorScheme.primary.withOpacity(0.05)
                          : Colors.transparent,
                    ),
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
                                size: 45,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                player.name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
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
                                      : _buildBotDifficultyText(
                                          player, context))
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
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${player.score}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        if (showBonus)
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${player.bonusCount}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.secondary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        if (showRound)
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.tertiary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${player.roundSurvived}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.tertiary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        if (banOption && inWaitPage)
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              onPressed: () => ref
                                  .read(gameLobbyServiceProvider)
                                  .banPlayer(player.name),
                              icon: Icon(
                                Icons.block,
                                color: Colors.redAccent,
                                size: 24,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBotDifficultyDropdown(
      BotPlayer player, WidgetRef ref, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getDifficultyColor(player.difficulty).withOpacity(0.5),
          width: 1.5,
        ),
        color: _getDifficultyColor(player.difficulty).withOpacity(0.1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<BotDifficulty>(
        value: player.difficulty,
        underline: Container(),
        icon: Icon(
          Icons.arrow_drop_down,
          color: _getDifficultyColor(player.difficulty),
        ),
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
              style: TextStyle(
                color: _getDifficultyColor(value),
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBotDifficultyText(BotPlayer player, BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getDifficultyColor(player.difficulty).withOpacity(0.7),
          width: 1.5,
        ),
        color: _getDifficultyColor(player.difficulty).withOpacity(0.1),
      ),
      child: Text(
        BotDifficultyExtension.translateDifficulty(context, player.difficulty),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _getDifficultyColor(player.difficulty),
          fontWeight: FontWeight.bold,
          fontSize: 15,
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
        return const Color.fromARGB(255, 0, 151, 0);
    }
  }
}
