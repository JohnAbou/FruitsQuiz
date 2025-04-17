import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { ExperienceLoot, UserLevelManager } from '@app/services/users/user-level-manager.service';

@Service({ transient: true })
export class ExperienceAdder extends BaseGameObserver {
    constructor(
        game: GameSessionBase,
        private userLevelManager: UserLevelManager,
    ) {
        super(game);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        let subscriptions = [
            game.quizEndedSubject.subscribe(() => {
                this.handleGivingExp();
                subscriptions.forEach((subscription) => subscription.unsubscribe());
            }),
        ];
    }

    private handleGivingExp() {
        let gameExp = (this.question.index + 1) * 5;
        let bestPlayerName = this.game.getGameResult().winner?.name ?? "";

        this.game.realPlayers.forEach(async (users) => {
            const experienceGained = await this.giveExp(users.name, gameExp + (bestPlayerName == users.name ? 100 : 0));
            if (experienceGained) users.emitToUser('gameLootExp', experienceGained);
        });
    }

    private async giveExp(playerName: string, expValue: number): Promise<ExperienceLoot | undefined> {
        return await this.userLevelManager.addExperienceToUser(playerName, expValue);
    }
}
