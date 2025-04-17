import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameTimerSocketEvent } from '@common/enums/socket-event/game-timer-socket-event';
import { QUARTER_SECOND } from '@app/consts/timer.consts';
import { QuestionType } from '@common/enums/question-type';
import { TIME_LIMIT_PANIC_MODE_QCM, TIME_LIMIT_PANIC_MODE_QRL, TIME_LIMIT_PANIC_MODE_QRE } from '@app/consts/game.const';
import { BotAnswerService } from '../answer/bot-answer.service';

@Service({ transient: true })
export class TimerController extends BaseGameObserver {
    constructor(
        game: GameSessionBase,
        private botAnswerService: BotAnswerService,
    ) {
        super(game);
        this.initializeController();
    }

    private get timerService() {
        return this.game.getTimer();
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.removedGameSubject.subscribe(() => this.clearControllerSocket());
        game.questionStartedSubject.subscribe(() => this.onQuestionStarted());
        game.questionEndedSubject.subscribe(() => this.onQuestionEnded());
    }

    private onQuestionStarted() {
        this.organizer.emitToUser(GameTimerSocketEvent.CanTogglePause, true);
        this.organizer.emitToUser(GameTimerSocketEvent.CanStartPanic, true);
        this.setPanicModeTimeLimit();
    }

    private onQuestionEnded() {
        this.timerService.clearSpecificCallback();
        this.organizer?.emitToUser(GameTimerSocketEvent.CanTogglePause, false);
        this.organizer?.emitToUser(GameTimerSocketEvent.CanStartPanic, false);
    }

    private initializeController() {
        this.organizer.onUserEvent(GameTimerSocketEvent.TogglePause, () => this.toggleTimerPause());
        this.organizer.onUserEvent(GameTimerSocketEvent.StartPanic, () => this.startTimerPanic());
    }

    private clearControllerSocket() {
        this.organizer?.removeEventListeners(GameTimerSocketEvent.TogglePause);
        this.organizer?.removeEventListeners(GameTimerSocketEvent.StartPanic);
    }

    private toggleTimerPause() {
        const paused = this.timerService.togglePause();
        if (paused) {
            this.botAnswerService.pauseBotTimers(this.game.gameId.toString());
        } else {
            this.botAnswerService.resumeBotTimers(this.game.gameId.toString());
        }
    }

    private startTimerPanic() {
        this.timerService.updateDelay(QUARTER_SECOND);
        this.botAnswerService.activatePanicMode(this.game.gameId.toString());
        this.organizer.emitToUser(GameTimerSocketEvent.CanStartPanic, false);
        this.users.forEach((user) => user.emitToUser(GameTimerSocketEvent.OnPanicModeStarted));
    }

    private setPanicModeTimeLimit() {
        let timeLimit;
        switch (this.question.type) {
            case QuestionType.QCM:
                timeLimit = TIME_LIMIT_PANIC_MODE_QCM;
                break;
            case QuestionType.QRL:
                timeLimit = TIME_LIMIT_PANIC_MODE_QRL;
                break;
            case QuestionType.QRE:
                timeLimit = TIME_LIMIT_PANIC_MODE_QRE;
                break;
            default:
                timeLimit = TIME_LIMIT_PANIC_MODE_QCM;
        }
        this.timerService.setSpecificCallback(timeLimit, () => this.organizer.emitToUser(GameTimerSocketEvent.CanStartPanic, false));
    }
}
