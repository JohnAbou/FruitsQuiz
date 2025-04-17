import { GameSessionBase } from '@app/classes/game/game-session-base';
import { Service } from 'typedi';
import { BaseGameObserver } from './base-observer';
import { Player } from '@app/interfaces/users/player';
import { UsersStatsService } from '@app/services/users/user-stats-service';
import { Subscription } from 'rxjs';
import { WinStreakUpdate } from '@app/interfaces/win-streak-update';
import { GameMetricsUpdate } from '@app/interfaces/game-metrics-update';
import { UserRemoved } from '@app/interfaces/users/user-removed';

@Service({ transient: true })
export class GameResultObserver extends BaseGameObserver {
    private playersId: Set<string>;

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
            game.removedUserSubject.subscribe((removed) => this.removedPlayer(removed)),
            game.removedGameSubject.subscribe(() => subscriptions.forEach((s: Subscription) => s?.unsubscribe())),
        ];
    }

    private start() {
        this.playersId = new Set(this.game.realPlayers.map((user) => user.id));
        this.game.realUsers.forEach((user) => this.userStatsService.incrementGamePlayed(user.id));
    }

    private end() {
        const winnerId = this.game.getGameResult().winner?.id;
        this.playersId.forEach((id) => this.updateResultById(id, winnerId === id));
        this.playersId.clear();
    }

    private removedPlayer(reason: UserRemoved) {
        // 21000 means the organizer cleared the game, therefore its not counted as a loss nor a win
        reason.reason === 21000 ? this.updateStats(reason.user) : this.updateResult(reason.user, false);
    }

    private updateResultById(id: string, wonGame: boolean) {
        let player = this.game.getUser(id);
        if (!player) return;

        this.updateResult(player, wonGame);
    }


    private async updateResult(player: Player, wonGame: boolean) {
        if (!this.playersId.has(player.id)) return;
        this.playersId.delete(player.id);

        const newStats =await this.userStatsService.updateGameResults(player.id, wonGame, 0, player.score)

        const winStreakUpdate: WinStreakUpdate = !wonGame ? { wsState: 1, current: 0, winCount: newStats.totalGameWon }
            : { wsState: newStats.bestWinStreak === newStats.currentWinStreak ? 3 : 2, current: newStats.currentWinStreak + 1, winCount: newStats.totalGameWon };
        
            
        player.emitToUser('gameWinStreakUpdated', winStreakUpdate);

        const gameMetricsUpdate: GameMetricsUpdate = {
            newPoints: newStats.totalPoints + player.score,
            gainedPoints: player.score, 
            newSurvivedQuestion: 0,
            gainedSurvivedQuestion: 0,
        }

        player.emitToUser('gameMetricsUpdated', gameMetricsUpdate);
    }

    private async updateStats(player: Player) {
        if (!this.playersId.has(player.id)) return;
        this.playersId.delete(player.id);

        await this.userStatsService.updateGameStats(player.id, 0, player.score);
    }
}