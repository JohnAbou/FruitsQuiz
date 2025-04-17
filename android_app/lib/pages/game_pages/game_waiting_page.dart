import 'package:android_app/models/bot_player.dart';
import 'package:android_app/models/enums/user_game_role.dart';
import 'package:android_app/services/games/game_challenge_service.dart';
import 'package:android_app/services/games/game_lobby_service.dart';
import 'package:android_app/services/games/game_players_service.dart';
import 'package:android_app/services/games/game_state_service.dart';
import 'package:android_app/widgets/challenge_presentation_widget.dart';
import 'package:android_app/widgets/game_lobby_control.dart';
import 'package:android_app/widgets/game_lobby_header.dart';
import 'package:android_app/widgets/game_waiting_player_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_app/generated/l10n.dart';

class GameWaitingPage extends ConsumerWidget {
  const GameWaitingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOrganizer =
        ref.read(gameStateProvider).userRole == UserGameRole.organizer;
    final gameLobbyService = ref.read(gameLobbyServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    final challengeState = ref.watch(gameChallengeStateProvider);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const GameLobbyHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column
                  Expanded(
                    flex: 60,
                    child: Column(
                      children: [
                        // Player list card
                        Expanded(
                          flex: 12,
                          child: GamePlayerWaitingList(
                            banOption: isOrganizer,
                            inWaitPage: true,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: (challengeState.code != 0) ? Center(
                            child: SizedBox(
                              width: 600,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                    child: ChallengePresentationWidget(),
                                  ),
                                ),
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Right column (25% width)
                  Expanded(
                    flex: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Waiting card with spinner
                        SizedBox(
                          width: 300, // Fixed width for right column elements
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    S.of(context).waiting_for_players,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  CircularProgressIndicator(
                                    color: colorScheme.primary,
                                    strokeWidth: 3,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Admin controls card (only for organizer)
                        if (isOrganizer)
                          SizedBox(
                            width: 300, // Fixed width for right column elements
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const GameLobbyControl(),
                                    const SizedBox(height: 16),
                                    Consumer(
                                      builder: (context, ref, _) {
                                        final playerState =
                                            ref.watch(gamePlayersStateProvider);
                                        final nBots = playerState.players
                                            .whereType<BotPlayer>()
                                            .length;
                                        final canAddBot = nBots < 6;
                                        return ElevatedButton.icon(
                                          onPressed: canAddBot
                                              ? () => gameLobbyService.addBot()
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            fixedSize: const Size(250, 48),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          icon: const Icon(Icons.smart_toy),
                                          label: Text(S.of(context).add_bot),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
