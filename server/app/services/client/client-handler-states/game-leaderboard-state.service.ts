import { Service } from 'typedi';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { BaseHandlerState } from './base-handler-state.service';

@Service({ transient: true })
export class GameLeaderboardState extends BaseHandlerState {
    clearState(): void {
        this.client.removeEventListeners(GamePlayerSocketEvent.PlayerLeftGame);
        this.client.removeEventListeners(GamePlayerSocketEvent.Disconnect);
    }

    protected initializeState() {
        this.client.onUserEvent(GamePlayerSocketEvent.PlayerLeftGame, () => this.leaveGame());
        this.client.onUserEvent(GamePlayerSocketEvent.Disconnect, () => this.leaveGame());
    }

    private leaveGame() {
        this.emitToClient(GamePlayerSocketEvent.PlayerRemovedFromGame, 0);
        this.clientHandlerService.resetState();
    }
}
