import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Player } from '@app/interfaces/users/player';
import { AnswerQRECorrectorService } from '@app/services/game/answer/answer-qre-corrector.service';
import { Service } from 'typedi';
import { AnswerManagerBase } from './answer-manager-base.service';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';

@Service({ transient: true })
export class AnswerManagerQRE extends AnswerManagerBase {
    private playerSubmissions: Map<Player, number>;
    private incorrectPlayers: Player[];
    private playerWhoClaimedBonus: Player;

    constructor(
        game: GameSessionBase,
        private answerCorrector: AnswerQRECorrectorService,
    ) {
        super(game);
    }

    submitNumericAnswer(player: Player, value: number) {
        if (!this.validateNumericAnswer(value)) return;

        this.playerSubmissions.set(player, value);
    }

    submitPlayerAnswer(player: Player) {
        this.playerWhoClaimedBonus ??= player;
    }

    protected setUpPlayerSocket(player: Player): void {
        player.onUserEvent(GameAnswerSocketEvent.UpdateNumericAnswer, (value: number) => this.submitNumericAnswer(player, value));
    }

    protected clearPlayerSocket(player: Player) {
        player?.removeEventListeners(GameAnswerSocketEvent.UpdateNumericAnswer);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.questionStartedSubject.subscribe(() => this.startQuestion());
        game.removedGameSubject.subscribe(() => this.players.forEach((player) => this.clearPlayerSocket(player)));
        game.removedUserSubject.subscribe((userRemoved) => this.clearPlayerSocket(userRemoved.user as Player));
    }

    private startQuestion() {
        this.answerCorrector.setQuestion(this.question);
    }

    correctAnswerSubmissions() {
        this.incorrectPlayers = [];
        this.players.forEach((player) => this.scorePlayerAnswer(player));
        this.onCorrectionfinished();
    }

    getIncorrectPlayers(): Player[] {
        return this.incorrectPlayers;
    }

    getPlayersWhoInteracted(): Set<Player> {
        return new Set(this.playerSubmissions.keys());
    }

    protected finalizeAnswerSubmissionsIntern() {
        this.correctAnswerSubmissions();
    }

    protected resetAnswer() {
        this.playerSubmissions = new Map();
        this.incorrectPlayers = [];
        this.playerWhoClaimedBonus = undefined;
    }

    private validateNumericAnswer(value: number): boolean {
        return typeof value === 'number' && !isNaN(value);
    }

    private scorePlayerAnswer(player: Player): void {
        const bonusEligible = true;
        const playerSubmission = this.playerSubmissions.get(player) ?? 0;
        this.answerCorrector.scorePlayerAnswer(player, playerSubmission, bonusEligible);
        if (!this.answerCorrector.isAnswerCorrect(playerSubmission)) {
            this.incorrectPlayers.push(player);
        }
    }
}
