import 'package:android_app/services/games/game_creation_service.dart';
import 'package:android_app/services/notification_service.dart';
import 'package:android_app/services/quizzes/quizzes_services.dart';
import 'package:android_app/services/questions_services.dart';
import 'package:android_app/utils/build_default_page.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_details.dart';
import 'package:android_app/widgets/quiz_widgets/quiz_view_rating.dart';
import 'package:android_app/widgets/quiz_widgets/random_quiz_details.dart';
import 'package:android_app/widgets/quiz_widgets/survival_quiz_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:android_app/generated/l10n.dart';
import 'package:android_app/theme/custom_colors.dart';

class GameCreationPage extends ConsumerStatefulWidget {
  const GameCreationPage({super.key});

  @override
  ConsumerState<GameCreationPage> createState() => _GameCreationPageState();
}

class _GameCreationPageState extends ConsumerState<GameCreationPage> {
  String? selectedGameMode;
  bool isFriendsOnly = false;

  void selectGameMode(String mode) {
    final questionCount = ref.read(questionsStateProvider.select((state) => state.specialQuestionCount));
    if ((mode == 'elimination' || mode == 'survival') && questionCount < 5) {
      return;
    }

    setState(() {
      selectedGameMode = mode;
      if (mode == 'elimination') {
        ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(randomQuiz);
      } else if (mode == 'survival') {
        ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(survivalQuiz);
      }
    });
  }

  void resetGameMode() {
    setState(() {
      selectedGameMode = null;
      ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(emptyQuiz);
    });
  }


  late final GameCreationService gameCreationService;
  late final QuizzesService quizzesService;

  @override
  void initState() {
    super.initState();
    gameCreationService = ref.read(gameCreationServiceProvider);
    quizzesService = ref.read(quizzesStateProvider.notifier);
    quizzesService.addCustomListener(_handleQuizModification);
  }

  void _handleQuizModification() {
    final selectedQuiz = ref.read(quizzesStateProvider).selectedQuiz;
    if (selectedQuiz.id == 'empty-quiz-id') return;

    final lastId = selectedQuiz.id;
    final updatedQuizzes = quizzesService.getAllQuizzes();
    final quizExists = updatedQuizzes.firstWhere((quiz) => quiz.id == lastId, orElse: () => emptyQuiz);

    if (quizExists.id != lastId) {
      ref.read(notificationServiceProvider).showInformationCardPopup(message: S.of(context).game_creation_unavailable_quiz);
    }
    
    quizzesService.updateSelectedQuiz(quizExists);
  }


  void createGame(BuildContext context) {
    final quizId = ref.read(quizzesStateProvider).selectedQuiz.id;
    final result = gameCreationService.createGame(quizId, isFriendsOnly);
    if (result == true) {
      context.go('/game-view');
    }
  }

  @override
  void dispose() {
    quizzesService.removeCustomListener(_handleQuizModification);
    super.dispose();
  }

  Widget buildGameModeCard(String mode, IconData icon, String title, String description) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final customColors = theme.extension<CustomColors>();
    final questionCount = ref.watch(questionsStateProvider.select((state) => state.specialQuestionCount));
    final isDisabled = (mode == 'elimination' || mode == 'survival') && questionCount < 5;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: isDisabled ? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).special_quiz_activate_condition),
              backgroundColor: theme.colorScheme.error,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        } : () => selectGameMode(mode),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 300,
          height: 300,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: isDisabled ? Colors.grey : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Icon(
                icon,
                size: 48,
                color: isDisabled ? Colors.grey : primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDisabled ? Colors.grey : customColors?.sidebarText,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuizGrid() {
    final selectedQuiz = ref.watch(quizzesStateProvider.select((state) => state.selectedQuiz));
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    if (selectedQuiz.id != 'empty-quiz-id') {
      return const QuizDetails();
    }

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => resetGameMode(),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.1,
              vertical: 24,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.2,
              mainAxisSpacing: 24,
              crossAxisSpacing: 24,
            ),
            itemCount: ref.watch(quizzesStateProvider.select((state) => state.quizzes.length)),
            itemBuilder: (context, index) {
              final quiz = ref.watch(quizzesStateProvider.select((state) => state.quizzes[index]));
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(quiz),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          quiz.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${quiz.questions.length} ${S.of(context).quiz_questions}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        QuizViewRating(
                          quizId: quiz.id,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildGameModeSelection() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildGameModeCard(
                'classic',
                Icons.extension,
                S.of(context).game_creation_select_game,
                S.of(context).game_creation_classic_description,
              ),
              const SizedBox(width: 24),
              buildGameModeCard(
                'elimination',
                Icons.format_list_numbered,
                S.of(context).game_creation_elimination_mode,
                S.of(context).game_creation_elimination_description,
              ),
              const SizedBox(width: 24),
              buildGameModeCard(
                'survival',
                Icons.timer,
                S.of(context).game_creation_survival_mode,
                S.of(context).game_creation_survival_description,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getQuizDetails(selectedQuiz) {
    if (selectedGameMode == 'elimination' || selectedQuiz.id == 'random-quiz-id') {
      return RandomQuizDetails(
        onBackPressed: resetGameMode,
      );
    }
    if (selectedQuiz.id == 'survival-quiz-id') {
      return SurvivalQuizDetails(
        onBackPressed: resetGameMode,
      );
    }
    return const QuizDetails();
  }

  @override
  Widget build(BuildContext context) {
    final selectedQuiz = ref.watch(quizzesStateProvider.select((state) => state.selectedQuiz));

    final primaryColor = Theme.of(context).colorScheme.primary;

    return buildDefaultPage(
      selectedGameMode == null 
        ? buildGameModeSelection() 
        : Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
          child: Stack(
            children: [
              if (selectedGameMode == 'classic')
                selectedQuiz.id != 'empty-quiz-id'
                  ? Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.08,
                      ),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: const QuizDetails(),
                          ),
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back, color: primaryColor),
                                  onPressed: () => resetGameMode(),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.1,
                              vertical: 24,
                            ),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio: 1.2,
                              mainAxisSpacing: 24,
                              crossAxisSpacing: 24,
                            ),
                            itemCount: ref.watch(quizzesStateProvider.select((state) => state.quizzes.length)),
                            itemBuilder: (context, index) {
                              final quiz = ref.watch(quizzesStateProvider.select((state) => state.quizzes[index]));
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: InkWell(
                                  onTap: () => ref.read(quizzesStateProvider.notifier).updateSelectedQuiz(quiz),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          quiz.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: primaryColor,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${quiz.questions.length} ${S.of(context).quiz_questions}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        QuizViewRating(
                                          quizId: quiz.id,
                                          backgroundColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
              else
                Card(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.08,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: getQuizDetails(selectedQuiz),
                  ),
                ),
            ],
          ),
        ),
    );
  }
}
