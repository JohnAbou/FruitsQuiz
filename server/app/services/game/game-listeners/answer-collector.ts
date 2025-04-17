import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Player } from '@app/interfaces/users/player';
import { translatePlayers } from '@app/utils/translate.utils';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { QuestionType } from '@common/enums/question-type';
import Container, { Service } from 'typedi';
import { AnswerManagerBase } from './answer-managers/answer-manager-base.service';
import { AnswerManagerQCM } from './answer-managers/answer-manager-qcm.service';
import { AnswerManagerQRL } from './answer-managers/answer-manager-qrl.service';
import { AnswerManagerQRE } from './answer-managers/answer-manager-qre.service';
import { BaseGameObserver } from './base-observer';
import { BotPlayer } from '@app/classes/bot-player';
import { BotAnswerService } from '../answer/bot-answer.service';
import { AnswerTimerService } from '../answer/answer-timer.service';
import { Subject } from 'rxjs';
import { UsersStatsService } from '@app/services/users/user-stats-service';

@Service({ transient: true })
export class AnswerCollector extends BaseGameObserver {
    answerCorrectedSubject: Subject<void> = new Subject();
    protected playersWhichSubmited: Set<Player>;
    protected lastToAnswer: Player = null;

    constructor(
        game: GameSessionBase,
        private answerManagerQRL: AnswerManagerQRL,
        private answerManagerQCM: AnswerManagerQCM,
        private answerManagerQRE: AnswerManagerQRE,
        private botAnswerService: BotAnswerService,
        private answerTimerService: AnswerTimerService,
    ) {
        super(game);
        this.initialize();
    }

    protected get answerManager(): AnswerManagerBase {
        switch (this.question.type) {
            case QuestionType.QCM:
                return this.answerManagerQCM;
            case QuestionType.QRL:
                return this.answerManagerQRL;
            case QuestionType.QRE:
                return this.answerManagerQRE;
            default:
                return this.answerManagerQCM;
        }
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.questionEndedSubject.subscribe(() => this.questionEnded());
        game.questionStartedSubject.subscribe(() => this.questionStarted());

        game.removedGameSubject.subscribe(() => this.players.forEach((player) => this.clearPlayerSocket(player)));
        game.removedUserSubject.subscribe((userRemoved) => this.onPlayerRemoved(userRemoved.user));
    }

    protected questionStarted() {
        this.answerTimerService.onQuestionStart();
    }

    protected questionEnded() {
        this.answerManager.correctAnswerSubmissions();
        const unsubmittedPlayers = this.players.filter((player) => !this.playersWhichSubmited.has(player));
        this.answerTimerService.onQuestionEnded(unsubmittedPlayers);
    }

    protected onCorrectionFinished() {
        this.updateUserStats();
        this.game.correctionWasFinished();
        this.answerCorrectedSubject.next();
        this.resetAnswer();

        this.informPlayerOfCorrection();
    }

    protected verifyIfIsLastAnswer() {
        if (this.playersWhichSubmited.size === this.players.length) this.game.allPlayerHaveSubmited();
    }

    protected verifyIfIsLastNonBotAnswer() {
        const nonBotPlayers = this.players.filter((player) => !(player instanceof BotPlayer));
        this.botAnswerService.allNonBotsSubmitted =
            nonBotPlayers.every((player) => this.playersWhichSubmited.has(player)) || nonBotPlayers.length === 0;

        if (this.botAnswerService.allNonBotsSubmitted) {
            this.botAnswerService.handleAllNonBotsSubmitted(this.game.gameId.toString(), (player) => this.submitPlayerAnswer(player));
        }
    }

    protected resetAnswer() {
        this.playersWhichSubmited = new Set();
        this.lastToAnswer = null;
    }

    protected submitPlayerAnswer(player: Player) {
        if (!this.canPlayerSubmit(player)) return;

        this.lastToAnswer = player;

        if (this.question.type === QuestionType.QCM) {
            this.answerManagerQCM.submitPlayerAnswer(player);
        } else if (this.question.type === QuestionType.QRE) {
            this.answerManagerQRE.submitPlayerAnswer(player);
        }

        this.answerTimerService.onPlayerSubmission(player);

        if (!this.botAnswerService.allNonBotsSubmitted) {
            this.verifyIfIsLastNonBotAnswer();
        }
        this.verifyIfIsLastAnswer();
    }

    private initialize() {
        this.resetAnswer();

        this.players.forEach((player) => this.initializePlayer(player));

        this.game.questionStartedSubject.subscribe(() => this.submitBotAnswers());
        this.answerManagerQCM.setCorrectionFinishedCallback(this.onCorrectionFinished.bind(this));
        this.answerManagerQRL.setCorrectionFinishedCallback(this.onCorrectionFinished.bind(this));
        this.answerManagerQRE.setCorrectionFinishedCallback(this.onCorrectionFinished.bind(this));
    }

    private submitBotAnswers() {
        this.botAnswerService.allNonBotsSubmitted = false;
        this.botAnswerService.handleBotAnswers(
            this.players,
            this.question,
            (player, choiceIndex) => this.answerManagerQCM.toggleAnswerChoice(player, choiceIndex),
            (player, response) => this.answerManagerQRL.updateResponse(player, response),
            (player, value) => this.answerManagerQRE.submitNumericAnswer(player, value),
        );

        this.botAnswerService.startBotTimers(this.game.gameId.toString(), this.players, this.game.quiz.duration, (player) =>
            this.submitPlayerAnswer(player),
        );
        if (!this.botAnswerService.allNonBotsSubmitted) {
            this.verifyIfIsLastNonBotAnswer();
        }
    }

    private onPlayerRemoved(player: Player) {
        this.clearPlayerSocket(player);
        this.verifyIfIsLastAnswer();
    }

    private initializePlayer(player: Player) {
        player.onUserEvent(GameAnswerSocketEvent.SubmitAnswer, () => this.submitPlayerAnswer(player));
    }

    private clearPlayerSocket(player: Player) {
        player?.removeEventListeners(GameAnswerSocketEvent.SubmitAnswer);
    }

    private informPlayerOfCorrection() {
        this.players.forEach((player) => player.emitToUser(GamePlayerSocketEvent.SendPlayerScore, player.score));
        this.users.forEach((user) => user.emitToUser(GamePlayerSocketEvent.SendPlayerStats, translatePlayers(this.players)));
        this.organizer.emitToUser(GameManagementSocketEvent.CanGoToNextQuestion);
    }

    private canPlayerSubmit(player: Player): boolean {
        if (this.playersWhichSubmited.has(player)) return false;
        this.playersWhichSubmited.add(player);
        return true;
    }

    protected updateUserStats() {
        const { incorrectPlayers } = this.getPlayersAnswerResult();

        this.game.realPlayers.forEach((player) => {
            incorrectPlayers.has(player.id)
                ? Container.get(UsersStatsService).incrementFailedQuestion(player.id)
                : Container.get(UsersStatsService).incrementGottenQuestion(player.id);
        });
    }

    getPlayersAnswerResult() {
        return {
            incorrectPlayers: new Set(this.answerManager.getIncorrectPlayers().map(player => player.id)),
            playersWhoInteracted: new Set([...this.answerManager.getPlayersWhoInteracted()].map(player => player.id)),
            lastToAnswer: this.lastToAnswer?.id,
        }
    }
}
