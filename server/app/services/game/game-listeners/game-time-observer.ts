import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { Player } from '@app/interfaces/users/player';
import { UsersStatsService } from '@app/services/users/user-stats-service';
import { Subscription } from 'rxjs';

@Service({ transient: true })
export class GameTimeObserver extends BaseGameObserver {
    private usersSet: Set<Player>;
    private startTime?: Date;
    private endTime?: Date;

    constructor(
        game: GameSessionBase,
        private readonly userStatsService: UsersStatsService,
    ) {
        super(game);
    }

    protected setUpGameObserver(game: GameSessionBase): void {
        let subscriptions: Subscription[] = [
            game.quizStartedSubject.subscribe(() => this.start()),
            game.quizEndedSubject.subscribe(() => this.end()),
            game.removedUserSubject.subscribe((removed) => this.removedUser(removed.user)),
            game.removedGameSubject.subscribe(() => subscriptions.forEach((s: Subscription) => s?.unsubscribe())),
        ];
    }

    private start() {
        this.startTime = new Date();
        this.usersSet = new Set(this.game.realUsers);
    }

    private end() {
        this.endTime = new Date();
        const timeDiffInSeconds = (this.endTime.getTime() - this.startTime.getTime()) / 1000;
        this.usersSet.forEach(async (user) => {
            const stat = await this.userStatsService.incrementGameTime(user.id, timeDiffInSeconds);
            user.emitToUser('gameTimeUpdated', { currentTime: stat.totalGameTime, addedTime: timeDiffInSeconds });
        });
        this.usersSet.clear();
    }

    private removedUser(user: Player) {
        if (!this.startTime || !this.usersSet.has(user)) return;
        this.usersSet.delete(user);

        const endTime = this.endTime ?? new Date();
        const timeDiffInSeconds = (endTime.getTime() - this.startTime.getTime()) / 1000;
        this.userStatsService.incrementGameTime(user.id, timeDiffInSeconds);
    }
}
