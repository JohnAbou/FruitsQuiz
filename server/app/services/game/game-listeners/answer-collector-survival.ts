import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Service } from 'typedi';
import { AnswerManagerQCM } from './answer-managers/answer-manager-qcm.service';
import { AnswerManagerQRL } from './answer-managers/answer-manager-qrl.service';
import { AnswerManagerQRE } from './answer-managers/answer-manager-qre.service';
import { AnswerCollector } from './answer-collector';
import { GameSessionSurvival } from '@app/classes/game/game-session-survival';
import { BotAnswerService } from '../answer/bot-answer.service';
import { AnswerTimerService } from '../answer/answer-timer.service';

@Service({ transient: true })
export class AnswerCollectorSurvival extends AnswerCollector {

    private get survivalGame() {
        return this.game as GameSessionSurvival;
    }

    constructor(
        game: GameSessionBase,
        answerManagerQRL: AnswerManagerQRL,
        answerManagerQCM: AnswerManagerQCM,
        answerManagerQRE: AnswerManagerQRE,
        botAnswerService: BotAnswerService,
        answerTimerService: AnswerTimerService,
    ) {
        super(game, answerManagerQRL, answerManagerQCM, answerManagerQRE, botAnswerService, answerTimerService);
    }

    protected onCorrectionFinished() {
        if (this.answerManager.getIncorrectPlayers().length)
            this.survivalGame.failedRound()
        else
            this.survivalGame.survivedRound();

        super.onCorrectionFinished();
    }

    protected verifyIfIsLastAnswer() {
        this.game.allPlayerHaveSubmited();
    }
}
