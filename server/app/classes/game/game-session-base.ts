import { UserGameState } from '@common/enums/user-game-state';
import { ANSWER_TIME_QRL, GAME_INTERMISSION_TIME, GAME_LOADING_SCREEN_TIME } from '@app/consts/game.const';
import { GameConfig } from '@app/interfaces/game-config';
import { GameQuizHandlerService } from '@app/services/game/game-quiz-handler.service';
import { TimerService } from '@app/services/timer.service';
import { Subject } from 'rxjs';
import { Question, QuestionWithIndex } from '@common/interfaces/question';
import { GameBase } from './game-base';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { QuestionType } from '@common/enums/question-type';
import { Player } from '@app/interfaces/users/player';
import { translatePlayer } from '@app/utils/translate.utils';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';

export abstract class GameSessionBase extends GameBase {
    questionEndedSubject: Subject<Question> = new Subject();
    questionStartedSubject: Subject<Question> = new Subject();
    quizEndedSubject: Subject<void> = new Subject();
    quizStartedSubject: Subject<void> = new Subject();

    constructor(
        protected timerService: TimerService,
        protected quizHandler: GameQuizHandlerService,
        public entryFeeManager: GameEntryFeeService,
        gameConfig: GameConfig,
    ) {
        super(gameConfig);
    }

    getQuestion(): QuestionWithIndex {
        return this.quizHandler.getQuestion();
    }

    getTimer() {
        return this.timerService;
    }

    setUp(): void {
        this.quizStartedSubject.next();
        this.timerService.setOnTickCallBack(this.sendTimerTickValue.bind(this));
    }

    continueQuiz() {
        this.quizHandler.goToNextQuestion();
        if (!this.quizHandler.isQuizFinished()) this.nextQuestionTransition();
        else this.onFinishedAllQuestions();
    }

    allPlayerHaveSubmited() {
        this.timerService.stopTimer();
        this.questionTimerExpired();
    }

    correctionWasFinished() {
        this.updateUsersState(UserGameState.InGame);
    }

    removePlayer(playerToRemove: Player, reason?: number) {
        super.removePlayer(playerToRemove, reason);
        if (this.areTherePlayerLeft()) return;

        this.removeOrganizer(21005);
        this.clearGame();
    }

    clearGame(): void {
        super.clearGame();
        this.timerService.stopTimer();
    }

    protected showLoading() {
        this.updateUsersState(UserGameState.Loading);
        this.setLoadingTimer();
    }

    protected showIntermission() {
        this.updateUsersState(UserGameState.Intermission);
        this.setIntermissionTimer();
    }

    protected showNextQuestion() {
        this.questionStartedSubject.next(this.getQuestion());
        this.setQuestionAnsweringTimer();
        this.updateUsersState(UserGameState.InGame);
    }

    protected shouldGoToCorrectionState() {
        return this.getQuestion().type === QuestionType.QRL;
    }

    protected questionTimerExpired() {
        this.timerService.resetStopCondition();
        this.questionEndedSubject.next(this.getQuestion());
    }

    protected nextQuestionTransition() {
        this.timerService.setOnTimerEndedCallback(() => this.showNextQuestion()).startTimer(GAME_INTERMISSION_TIME);
    }

    protected onFinishedAllQuestions() {
        this.timerService.setOnTimerEndedCallback(() => this.onFinishedGame()).startTimer(GAME_INTERMISSION_TIME);
    }

    protected onFinishedGame() {
        this.quizEndedSubject.next();
        this.updateUsersState(UserGameState.Leaderboard);
        this.sendGameResult();
        this.clearGame();
    }

    private setLoadingTimer() {
        this.timerService.setOnTimerEndedCallback(this.showNextQuestion.bind(this)).startTimer(GAME_LOADING_SCREEN_TIME);
    }

    private setIntermissionTimer() {
        this.timerService.setOnTimerEndedCallback(this.showNextQuestion.bind(this)).startTimer(GAME_INTERMISSION_TIME);
    }

    private setQuestionAnsweringTimer() {
        this.timerService.setOnTimerEndedCallback(this.questionTimerExpired.bind(this)).startTimer(this.getTimerDuration());
    }

    private getTimerDuration() {
        return this.getQuestion().type === QuestionType.QRL ? ANSWER_TIME_QRL : this.quiz.duration;
    }

    private sendTimerTickValue(tickValue: number) {
        this.users.forEach((user) => {
            user.emitToUser(GamePlaySocketEvent.TimerTicked, tickValue);
        });
    }

    private sendGameResult() {
        const gameResult = this.getGameResult();
        const winner = gameResult.winner ? translatePlayer(gameResult.winner) : undefined;
        this.users.forEach((user) => user.emitToUser('sendGameResult', { winner, wasTie: gameResult.wasTie }));
    }

    abstract getGameResult(): { winner?: Player; wasTie: boolean };
}
