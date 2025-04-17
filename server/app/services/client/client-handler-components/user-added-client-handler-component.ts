import { Subscription } from 'rxjs';
import { BaseClientHandlerComponent } from './base-client-handler-components';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { Player } from '@app/interfaces/users/player';
import { translatePlayer } from '@app/utils/translate.utils';
import { GameLobby } from '@app/classes/game/game-lobby';

export class UserAddedClientHandlerComponent extends BaseClientHandlerComponent {
    private userAddedSubscription: Subscription;

    initializeComponent(): void {
        const gameLobby = this.game as GameLobby;
        this.userAddedSubscription = gameLobby?.addedPlayerSubject?.subscribe((userAdded: Player) => this.onPlayerAdded(userAdded));
    }

    clearComponent(): void {
        this.userAddedSubscription?.unsubscribe();
    }

    private onPlayerAdded(player: Player) {
        if (player === this.client) return;
        this.emitPlayerJoined(player);
    }

    private emitPlayerJoined(player: Player) {
        this.emitToClient(GamePlayerSocketEvent.SendPlayerJoined, translatePlayer(player));
    }
}
