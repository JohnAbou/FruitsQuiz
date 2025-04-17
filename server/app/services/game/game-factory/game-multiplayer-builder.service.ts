import { GameConfig } from '@app/interfaces/game-config';
import { Container } from 'typedi';
import { GameQuizHandlerService } from '@app/services/game/game-quiz-handler.service';
import { TimerService } from '@app/services/timer.service';
import { AnswerCollector } from '@app/services/game/game-listeners/answer-collector';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { QuestionManager } from '@app/services/game/game-listeners/question-manager';
import { Player } from '@app/interfaces/users/player';
import { TimerController } from '@app/services/game/game-listeners/timer-controller';
import { HistoryObserver } from '@app/services/game/game-listeners/history-observer.service';
import { GameModifiedService } from '@app/services/game/game-listeners/game-modified.service';
import { GameChatDeleter } from '@app/services/game/game-listeners/game-chat-deleter';
import { ExperienceAdder } from '../game-listeners/experience-adder';
import { AnswerCollectorElimination } from '../game-listeners/answer-collector-elimination';
import { GameType } from '@common/enums/game-type';
import { GameSessionElimination } from '@app/classes/game/game-session-elimination';
import { GameSessionNormal } from '@app/classes/game/game-session-normal';
import { GameTimeObserver } from '../game-listeners/game-time-observer';
import { GameResultObserver } from '../game-listeners/game-result-observer';
import { Challenge } from '@app/classes/challenges/challenge';
import { GameChallengesValidator } from '../game-listeners/game-challenges-validator';
import { GameMoneyObserver } from '../game-listeners/game-money-observer';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';

export class GameMultiplayerBuilderService {
    buildGame(gameType: GameType, gameConfig: GameConfig, players: Player[], challenges: Map<string, Challenge>, entryFeeManager?: GameEntryFeeService) {
        const gameQuizHandler = new GameQuizHandlerService(gameConfig.quiz);

        const gameConstructor = this.getGameConstructor(gameType);
        const gameNormal = new gameConstructor(new TimerService(), gameQuizHandler, entryFeeManager, gameConfig);

        gameNormal.setPlayers(players);

        this.setUpGameObservers(gameNormal);

        let answerCollector = Container.get(this.getAnswerCollectorConstructor(gameType));
        new GameChallengesValidator(gameNormal, answerCollector, challenges);

        gameNormal.setUp();
        return gameNormal;
    }

    private setUpGameObservers(gameNormal: GameSessionBase) {
        Container.set(GameSessionBase, gameNormal);
        Container.get(QuestionManager);
        Container.get(TimerController);
        Container.get(HistoryObserver);
        Container.get(GameModifiedService);
        Container.get(GameChatDeleter);
        Container.get(ExperienceAdder);
        Container.get(GameTimeObserver);
        Container.get(GameResultObserver);
        Container.get(GameMoneyObserver);
    }

    private getGameConstructor(gameType: GameType) {
        switch (gameType) {
            case GameType.NormalGame:
                return GameSessionNormal;
            case GameType.EliminationGame:
                return GameSessionElimination;
        }
        throw new Error('Unsupported game type');
    }

    private getAnswerCollectorConstructor(gameType: GameType) {
        switch (gameType) {
            case GameType.NormalGame:
                return AnswerCollector;
            case GameType.EliminationGame:
                return AnswerCollectorElimination;
        }
        throw new Error('Unsupported game type');
    }
}
