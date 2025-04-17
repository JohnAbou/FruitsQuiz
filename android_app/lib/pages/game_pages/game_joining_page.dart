import 'package:android_app/generated/l10n.dart';
import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/services/games/game_joining_service.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/quick_join.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_view_rating_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/game_info.dart';

class GameJoiningPage extends ConsumerStatefulWidget {
  const GameJoiningPage({super.key});

  @override
  ConsumerState<GameJoiningPage> createState() => _GameJoiningPageState();
}

class _GameJoiningPageState extends ConsumerState<GameJoiningPage> {
  void _joinGame(GameInfo game) {
    ref.read(gameJoiningServiceProvider).joinGame(game.gameId, context);
  }

  @override
  Widget build(BuildContext context) {
    final games = ref.watch(gameJoiningStateProvider).filteredGames;
    final primaryColor = Theme.of(context).colorScheme.primary;

    var content = SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 64,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              // Header Card with QuickJoin
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.15,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      QuickJoin(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Body Card with games list
              Card(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.15,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      scrollbarTheme: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(primaryColor),
                        radius: const Radius.circular(6),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: games.isNotEmpty
                          ? _createGamesTable(games)
                          : _createGameText(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return buildDefaultPage(content);
  }

  Widget _createGamesTable(List<GameInfo> games) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    var column = Column(
      children: [
        // Table Header
        const SizedBox(height: 8),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_game_id,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_rating,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_type,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_players,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_creation_entry_price,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    S.of(context).game_joining_status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: primaryColor,
          thickness: 2,
        ),
        // Table Body
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return GestureDetector(
                  onTap: () => _joinGame(game),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: index == games.length - 1
                              ? Colors.transparent
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(game.gameId.toString()),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getGameTitle(game, context)),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QuizViewRatingLine(quizId: game.quizToPlay.id),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(getGameType(game, context)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(game.playersNb.toString()),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${game.entryFee}'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                game.isLocked ? Icons.lock : Icons.lock_open,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );

    return Padding(padding: const EdgeInsets.all(8.0), child: column);
  }

  _createGameText(BuildContext context) {
    final accentColor = Theme.of(context).colorScheme.secondary;
    return GestureDetector(
      onTap: () => context.go('/game-creation'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Text(S.of(context).game_joining_no_game_currently),
          const SizedBox(height: 8),
          Text(
            S.of(context).game_joining_create_one,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String getGameTitle(GameInfo game, BuildContext context) {
    final title = game.quizToPlay.title;
    return title == "system-special-quiz"
        ? S.of(context).game_joining_header_random_quiz_title
        : title;
  }

  String getGameType(GameInfo game, BuildContext context) {
    switch (game.gameType) {
      case GameType.normalGame:
        return S.of(context).game_mode_classical;
      case GameType.randomGame:
        return S.of(context).game_mode_elimination;
      default:
        return S.of(context).game_mode_survival;
    }
  }
}
