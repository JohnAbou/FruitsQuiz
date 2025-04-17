import { GameConfig } from '@app/interfaces/game-config';
import { Container } from 'typedi';
import { GameQuizHandlerService } from '@app/services/game/game-quiz-handler.service';
import { GameSessionSurvival } from '@app/classes/game/game-session-survival';
import { TimerService } from '@app/services/timer.service';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { QuestionManager } from '@app/services/game/game-listeners/question-manager';
import { GameModifiedService } from '@app/services/game/game-listeners/game-modified.service';
import { ExperienceAdder } from '../game-listeners/experience-adder';
import { AnswerCollectorSurvival } from '../game-listeners/answer-collector-survival';
import { GameTimeObserver } from '../game-listeners/game-time-observer';
import { GameResultObserver } from '../game-listeners/game-result-observer';
import { GameMoneyObserver } from '../game-listeners/game-money-observer';
import { HistoryObserver } from '../game-listeners/history-observer.service';

export class GameSurvivalBuilderService {
    buildGame(gameConfig: GameConfig) {
        const gameQuizHandler = new GameQuizHandlerService(gameConfig.quiz);
        const gameSurvival = new GameSessionSurvival(new TimerService(), gameQuizHandler, gameConfig);

        this.setUpGameObservers(gameSurvival);

        gameSurvival.setUp();
        return gameSurvival;
    }

    private setUpGameObservers(gameTest: GameSessionSurvival) {
        Container.set(GameSessionBase, gameTest);
        Container.get(AnswerCollectorSurvival);
        Container.get(QuestionManager);
        Container.get(GameModifiedService);
        Container.get(ExperienceAdder);
        Container.get(GameMoneyObserver);
        Container.get(GameTimeObserver);
        Container.get(GameResultObserver);
        Container.get(HistoryObserver);
    }
}
