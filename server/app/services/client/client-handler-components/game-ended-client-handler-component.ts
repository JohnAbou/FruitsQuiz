import { Subscription } from 'rxjs';
import { BaseClientHandlerComponent } from './base-client-handler-components';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameLeaderboardState } from '@app/services/client/client-handler-states/game-leaderboard-state.service';

export class GameEndedClientHandlerComponent extends BaseClientHandlerComponent {
    private gameEndedSubscription: Subscription;

    initializeComponent(): void {
        const gameSession = this.game as GameSessionBase;
        this.gameEndedSubscription = gameSession?.quizEndedSubject?.subscribe(() =>
            this.clientHandlerService.updateState(new GameLeaderboardState()),
        );
    }

    clearComponent(): void {
        this.gameEndedSubscription?.unsubscribe();
    }
}
