import 'package:android_app/models/enums/game_type.dart';
import 'package:android_app/models/quizzes/quiz.dart';

const defaultQuiz = Quiz(
  id: '0',
  title: '',
  description: '',
  duration: 0,
  isPublic: false,
  owner: '',
  questions: [],
);

class GameInfoState {
  final int gameId;
  final Quiz quiz;
  final GameType gameType;

  const GameInfoState({
    this.gameId = 0,
    this.quiz = defaultQuiz,
    this.gameType = GameType.lobbyGame,
  });

  GameInfoState copyWith({
    int? gameId,
    Quiz? quiz,
    GameType? gameType,
  }) {
    return GameInfoState(
      gameId: gameId ?? this.gameId,
      quiz: quiz ?? this.quiz,
      gameType: gameType ?? this.gameType,
    );
  }
}