import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Player } from '@app/interfaces/users/player';
import { AnswerToCorrect } from '@common/interfaces/answers/answer-to-correct';
import { Service } from 'typedi';
import { AnswerManagerBase } from './answer-manager-base.service';
import { HUNDRED_PERCENT } from '@app/consts/game.const';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { BotPlayer } from '@app/classes/bot-player';
import { BotAnswerService } from '../../answer/bot-answer.service';
import { GameMessage } from '@app/interfaces/game-message';

@Service({ transient: true })
export class AnswerManagerQRL extends AnswerManagerBase {
    private playerSubmissions: Map<Player, string>;
    private incorrectPlayers: Player[];

    constructor(
        game: GameSessionBase,
        private botAnswerService: BotAnswerService,
    ) {
        super(game);
        this.initializeCorrector(this.organizer);
    }

    correctAnswerSubmissions(): void {
        const answersToCorrect = this.getAnswersToCorrect(this.sortByPlayerName);
        if (answersToCorrect.length) {
            this.organizer.emitToUser(GameAnswerSocketEvent.SendAnswerToCorrect, answersToCorrect);
            this.users.forEach((user) => user.emitToUser(GameAnswerSocketEvent.QrlCorrectionStarted));
        } else {
            const parsedAnswers: AnswerToCorrect[] = [];
            this.playerSubmissions.forEach((_, player) => {
                if (!(player instanceof BotPlayer)) return;
                parsedAnswers.push(this.botAnswerService.getBotQRLAnswer(player));
            });
            this.receiveCorrectedAnswers(parsedAnswers);
        }
    }

    getIncorrectPlayers(): Player[] {
        return this.incorrectPlayers;
    }

    getPlayersWhoInteracted(): Set<Player> {
        return new Set(this.playerSubmissions.keys());
    }

    protected setUpPlayerSocket(player: Player): void {
        player.onUserEvent(GameAnswerSocketEvent.UpdateAnswerResponse, (updatedResponse: string) => this.updateResponse(player, updatedResponse));
    }

    protected clearPlayerSocket(player: Player): void {
        player?.removeEventListeners(GameAnswerSocketEvent.UpdateAnswerResponse);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.removedGameSubject.subscribe(() => this.clearUsersSocket());
        game.removedUserSubject.subscribe((userRemoved) => this.clearPlayerSocket(userRemoved.user as Player));
    }

    protected resetAnswer(): void {
        this.playerSubmissions = new Map();
        this.incorrectPlayers = [];
    }

    private clearUsersSocket() {
        this.players.forEach((player) => this.clearPlayerSocket(player));
        this.organizer.removeEventListeners(GameAnswerSocketEvent.SendAnswersCorrected);
    }

    updateResponse(player: Player, response: string) {
        this.playerSubmissions.set(player, response);
    }

    private initializeCorrector(corrector: Player) {
        corrector.onUserEvent(GameAnswerSocketEvent.SendAnswersCorrected, (correctedAnswers: string) => {
            const parsedAnswers: AnswerToCorrect[] = JSON.parse(correctedAnswers);
            this.playerSubmissions.forEach((_, player) => {
                if (!(player instanceof BotPlayer)) return;
                parsedAnswers.push(this.botAnswerService.getBotQRLAnswer(player));
            });
            this.receiveCorrectedAnswers(parsedAnswers);
        });
    }

    private getAnswersToCorrect(sortFunction: (answers: AnswerToCorrect[]) => AnswerToCorrect[]) {
        const answersToCorrect: AnswerToCorrect[] = [];

        this.playerSubmissions.forEach((answer, player) => {
            if (!(player instanceof BotPlayer)) {
                answersToCorrect.push(this.createAnswerToCorrect(answer, player));
            }
        });
        return sortFunction(answersToCorrect);
    }

    private sortByPlayerName(answers: AnswerToCorrect[]) {
        return answers.sort((a, b) => a.playerName.localeCompare(b.playerName));
    }

    private receiveCorrectedAnswers(correctedAnswers: AnswerToCorrect[]) {
        correctedAnswers.forEach(this.scoreAnswer.bind(this));

        this.game.users.forEach((user) => user.emitToUser(GameAnswerSocketEvent.QrlCorrectionFinished));
        this.onCorrectionfinished();
    }

    private scoreAnswer(correctedAnswer: AnswerToCorrect) {
        const players = Array.from(this.playerSubmissions.keys());

        const playerWhoSentRequest = players.find((player) => player.name === correctedAnswer.playerName);
        if (!playerWhoSentRequest) return;

        if (correctedAnswer.score === 0) this.incorrectPlayers.push(playerWhoSentRequest);

        playerWhoSentRequest.score += this.question.points * correctedAnswer.score;
        this.sendCorrectionMessage(playerWhoSentRequest, correctedAnswer.score);
    }

    private sendCorrectionMessage(player: Player, score: number) {
        const message: GameMessage = {
            code: 20010,
            values: { percent: score * HUNDRED_PERCENT, points: this.question.points * score },
        }
        player.emitToUser(GameAnswerSocketEvent.SendCorrectionMessage, message);
    }

    private createAnswerToCorrect(answer: string, player: Player) {
        return { playerName: player.name, answer, score: 0 };
    }
}
