import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Player } from '@app/interfaces/users/player';
import { AnswerQCMCorrectorService } from '@app/services/game/answer/answer-qcm-corrector.service';
import Container, { Service } from 'typedi';
import { AnswerManagerBase } from './answer-manager-base.service';
import { GameAnswerSocketEvent } from '@common/enums/socket-event/game-answer-socket-event';
import { getInvaliAnswers } from '@app/utils/question.utils';
import { UserDataManager } from '@app/services/data/user-data-manager.service';

const NOT_FOUND_INDEX = -1;

@Service({ transient: true })
export class AnswerManagerQCM extends AnswerManagerBase {
    private playerSubmissions: Map<Player, number[]> = new Map();
    private incorrectPlayers: Player[];
    private playerWhoClaimedBonus: Player;

    constructor(
        game: GameSessionBase,
        private answerCorrector: AnswerQCMCorrectorService,
    ) {
        super(game);
    }

    toggleAnswerChoice(player: Player, choiceIndex: number) {
        if (!this.validateChoiceIndex(choiceIndex)) return;

        const currentSelection = this.updatePlayerSelection(player, choiceIndex);
        this.playerSubmissions.set(player, currentSelection);
    }

    submitPlayerAnswer(player: Player) {
        if (this.playerWhoClaimedBonus || !this.answerCorrector.validateAnswer(this.playerSubmissions.get(player)))
            return;
        
        this.playerWhoClaimedBonus = player;
    }

    protected setUpPlayerSocket(player: Player): void {
        player.onUserEvent(GameAnswerSocketEvent.ToggleAnswerChoices, (choiceIndex: number) => this.toggleAnswerChoice(player, choiceIndex - 1));
        player.onUserEvent(GameAnswerSocketEvent.BuyHint, () => this.buyUserHints(player))
    }

    protected clearPlayerSocket(player: Player) {
        player?.removeEventListeners(GameAnswerSocketEvent.ToggleAnswerChoices);
        player?.removeEventListeners(GameAnswerSocketEvent.BuyHint);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.questionStartedSubject.subscribe(() => this.answerCorrector.setQuestion(this.question));
        game.removedGameSubject.subscribe(() => this.players.forEach((player) => this.clearPlayerSocket(player)));
        game.removedUserSubject.subscribe((userRemoved) => this.clearPlayerSocket(userRemoved.user as Player));
    }

    correctAnswerSubmissions() {
        this.players.forEach((player) => this.scorePlayerAnswer(player));

        this.onCorrectionfinished();
    }

    getIncorrectPlayers(): Player[] {
        return this.incorrectPlayers;
    }

    getPlayersWhoInteracted(): Set<Player> {
        return new Set(this.playerSubmissions.keys());
    }

    protected resetAnswer() {
        this.playerSubmissions = new Map();
        this.incorrectPlayers = [];
        this.playerWhoClaimedBonus = undefined;
    }

    private validateChoiceIndex(choiceIndex: number) {
        return choiceIndex || choiceIndex === 0;
    }

    private updatePlayerSelection(player: Player, choiceIndex: number): number[] {
        let currentSelection = this.playerSubmissions.get(player);
        currentSelection ??= [];

        const currentIndex = currentSelection.indexOf(choiceIndex);
        if (currentIndex === NOT_FOUND_INDEX) currentSelection.push(choiceIndex);
        else currentSelection.splice(currentIndex, 1);

        return currentSelection;
    }

    private scorePlayerAnswer(player: Player) {
        const getBonus = this.doesPlayerGetbonus(player);
        const playerSubmission = this.playerSubmissions.get(player) ?? [];

        if (!this.answerCorrector.scorePlayerAnswers(player, playerSubmission, getBonus)) this.incorrectPlayers.push(player);
    }

    private doesPlayerGetbonus(player: Player): boolean {
        return player === this.playerWhoClaimedBonus || (!this.playerWhoClaimedBonus && this.players.length === 1);
    }

    private async buyUserHints(player: Player) {
        if (this.question.choices.length <= 2) return;

        const hintCost = Math.ceil(this.game.quiz.questions.length * 5 / 2);
        
        const success = await Container.get(UserDataManager).attemptToRemoveUserCurrency(player.id, hintCost);
        if (!success) return;

        const choices = getInvaliAnswers(this.question);
        const randomElement = choices[Math.floor(Math.random() * choices.length)];

        player.emitToUser(GameAnswerSocketEvent.SendHint, randomElement+1);
    }
}
