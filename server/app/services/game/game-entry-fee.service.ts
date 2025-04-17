import { Service } from 'typedi';
import { UserDataManager } from '../data/user-data-manager.service';
import { BotPlayer } from '@app/classes/bot-player';
import { Player } from '@app/interfaces/users/player';

@Service({ transient: true })
export class GameEntryFeeService {

    potWinner?: Player;
    wasCanceled = false;

    private pot: number = 0;

    getEntryFee() {
        return this.entryFee;
    }

    constructor(
        private entryFee: number,
        private readonly userDataService: UserDataManager,
    ) {}

    addBot() {
        this.pot += this.entryFee;
    }

    removeBot() {
        this.pot -= this.entryFee;
    }

    getWinningPrice() {
        return this.entryFee ? Math.ceil(this.pot * (2/3)) : 0;
    }

    getConsolationPrice(playerCount: number) {
        return this.entryFee ? Math.ceil((this.pot * (1/3)) / playerCount) : 0;
    }

    async attemptToJoin(player: Player) {
        if (!this.entryFee || player instanceof BotPlayer) return true;

        const success = await this.userDataService.attemptToRemoveUserCurrency(player.id, this.entryFee);
        if (success) this.pot += this.entryFee;
        return success;
    }

    leaveGame(player: Player) {
        if (!this.entryFee || player instanceof BotPlayer) return;

        this.pot -= this.entryFee;
        this.userDataService.addUserCurrency(player.id, this.entryFee, false);
    }
}