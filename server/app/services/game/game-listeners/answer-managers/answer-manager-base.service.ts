import { Player } from '@app/interfaces/users/player';
import { BaseGameObserver } from '@app/services/game/game-listeners/base-observer';
import { GameSessionBase } from '@app/classes/game/game-session-base';

export abstract class AnswerManagerBase extends BaseGameObserver {
    private correctionFinishedCallback: () => void;

    constructor(game: GameSessionBase) {
        super(game);
        this.resetAnswer();
        this.setUpPlayers();
    }

    setCorrectionFinishedCallback(callback: () => void) {
        this.correctionFinishedCallback = callback;
    }

    protected onCorrectionfinished() {
        this.correctionFinishedCallback?.();
        this.resetAnswer();
    }

    private setUpPlayers() {
        this.players.forEach((player) => this.setUpPlayerSocket(player));
    }

    abstract correctAnswerSubmissions(): void;
    abstract getIncorrectPlayers(): Player[];
    abstract getPlayersWhoInteracted(): Set<Player>;

    protected abstract setUpPlayerSocket(player: Player): void;
    protected abstract clearPlayerSocket(player: Player): void;

    protected abstract resetAnswer(): void;
}
