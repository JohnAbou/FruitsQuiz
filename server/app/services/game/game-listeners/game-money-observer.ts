import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { UserDataManager } from '@app/services/data/user-data-manager.service';
import { UserRemoved } from '@app/interfaces/users/user-removed';
import { BotPlayer } from '@app/classes/bot-player';

@Service({ transient: true })
export class GameMoneyObserver extends BaseGameObserver {
    constructor(
        game: GameSessionBase,
        private userDataService: UserDataManager,
    ) {
        super(game);
    }

    get entryFeeManager() {
        return this.game.entryFeeManager;
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        game.quizStartedSubject.subscribe(() => this.informPlayersOffhintCost());
        game.quizEndedSubject.subscribe(() => this.payTheseBrokeAssPlayers());
        game.removedUserSubject.subscribe((user) => this.userRemoved(user));
    }

    private userRemoved(user: UserRemoved) {
        if (!this.entryFeeManager.getEntryFee()) return;
        if (user.reason === 21000 || user.user === this.game.organizer) {
            if (user.user !== this.game.organizer) this.entryFeeManager.leaveGame(user.user);
            this.entryFeeManager.wasCanceled = true;
            return;
        }

        if (this.game.players.length != 1 || this.entryFeeManager.potWinner) return;
        const winner = this.game.players[0];
        
        this.entryFeeManager.potWinner = winner;

        if (winner instanceof BotPlayer) return;

        const amount = this.entryFeeManager.getWinningPrice();
        this.userDataService.addUserCurrency(winner?.id, amount);
        winner?.emitToUser('wonTheGamePot', amount);
    }

    private informPlayersOffhintCost() {
        const hintCost = Math.ceil(this.game.quiz.questions.length * 5 / 2);
        this.game.realPlayers.forEach((user) => user.emitToUser('gameHintCost', hintCost));
    }

    private payTheseBrokeAssPlayers() {
        let compensationPrice = this.question.index + 1;
        let winningPrice = compensationPrice * 5;

        let potWinPrice = this.entryFeeManager.getWinningPrice();
        let potConsolationPrice = this.entryFeeManager.getConsolationPrice((this.game.players.length - 1) == 0 ? 1 : this.game.players.length - 1);
        
        const winner = this.game.getGameResult()?.winner;
        const entryFee = this.entryFeeManager?.getEntryFee();

        if (potWinPrice && !this.entryFeeManager.potWinner) winner?.emitToUser('wonTheGamePot', potWinPrice);

        this.game.realPlayers.forEach((user) => {
            if (!this.entryFeeManager.potWinner && !this.entryFeeManager.wasCanceled) {
                let amount = (user.id === winner?.id ? potWinPrice + winningPrice : potConsolationPrice) + compensationPrice;

                this.userDataService.addUserCurrency(user.id, amount);
                user.emitToUser('gameLootCoins', { coinGained: amount, coinPayed: entryFee });
            } else {
                let amount = (user.id === winner?.id ? winningPrice : 0) + compensationPrice;
                this.userDataService.addUserCurrency(user.id, amount);
                amount += user.id === this.entryFeeManager.potWinner.id ? potWinPrice : potConsolationPrice;
                user.emitToUser('gameLootCoins', { coinGained: amount, coinPayed: entryFee });
            }
        });
    }
}
