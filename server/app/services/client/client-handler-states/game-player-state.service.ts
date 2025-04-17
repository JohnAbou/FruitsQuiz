import { Service } from 'typedi';
import { GameBaseState } from './game-base-state.service';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';

@Service({ transient: true })
export class GamePlayerState extends GameBaseState {
    clearState(): void {
        this.clearGameBaseState();

        this.client.removeEventListeners(GamePlayerSocketEvent.PlayerLeftGame);
        this.client.removeEventListeners(GamePlayerSocketEvent.Disconnect);
    }

    protected initializeState() {
        this.initializeGameBaseState();

        this.client.onUserEvent(GamePlayerSocketEvent.PlayerLeftGame, () => this.leaveGame());
        this.client.onUserEvent(GamePlayerSocketEvent.Disconnect, () => this.leaveGame());
    }

    private leaveGame() {
        this.game?.removePlayer(this.client);
        this.clientHandlerService.resetState();
    }
}
