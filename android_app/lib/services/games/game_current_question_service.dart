import 'package:android_app/models/enums/question_type.dart';
import 'package:android_app/states/game_question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/question.dart';
import '../../services/sockets/socket_connection_service.dart';
import '../../services/image_service.dart';
import 'base_game_service.dart';

final gameCurrentQuestionProvider =
    StateNotifierProvider<GameCurrentQuestionService, GameQuestionState>((ref) {
  final socketService = ref.read(socketConnectionServiceProvider);
  return GameCurrentQuestionService(socketService);
});

final gameCurrentQuestionServiceProvider =
    Provider<GameCurrentQuestionService>(
        (ref) => ref.read(gameCurrentQuestionProvider.notifier));

final hintAvailableProvider = Provider<bool>((ref) {
  final question = ref.watch(gameCurrentQuestionProvider.select((state) => state.question));
  return question.type == QuestionType.qcm && question.choices.length > 2;
});

class GameCurrentQuestionService extends BaseGameService<GameQuestionState> {

  GameCurrentQuestionService(SocketConnectionService socketService)
      : super(socketService, const GameQuestionState());
      
  Question getCurrentQuestion() {
    return state.question;
  }

  @override
  void initializeState() {
    state = const GameQuestionState();
  }

  @override
  void setUpSocketListener() {
    addSocketListener('questionData', (dynamic data) {      
      final question = QuestionWithIndex.fromJson(data);

      state = state.copyWith(question: question);
    });
  }
}

final questionImageUrlProvider = Provider<String>((ref) {
  final imageId = ref.watch(gameCurrentQuestionProvider.select((state) => state.question.imageId));
  final imageService = ref.read(imageServiceProvider);
  return imageService.getQuestionImageUrl(imageId ?? '');
});
