import { Subscription } from 'rxjs';
import { BaseClientHandlerComponent } from './base-client-handler-components';
import { UserRemoved } from '@app/interfaces/users/user-removed';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { Player } from '@app/interfaces/users/player';
import { translatePlayer } from '@app/utils/translate.utils';

export class UserRemovedClientHandlerComponent extends BaseClientHandlerComponent {
    private userRemovedSubscription: Subscription;

    initializeComponent(): void {
        this.userRemovedSubscription = this.game.removedUserSubject.subscribe((userRemoved: UserRemoved) => this.onPlayerRemoved(userRemoved));
    }

    clearComponent(): void {
        this.userRemovedSubscription?.unsubscribe();
    }

    private onPlayerRemoved(userRemoved: UserRemoved) {
        const playerRemoved = userRemoved.user as Player;
        if (!playerRemoved) return;

        this.emitPlayerLeft(playerRemoved);
        if (userRemoved.user !== this.client) return;

        this.onClientRemoved(userRemoved);
    }

    private onClientRemoved(userRemoved: UserRemoved) {
        this.emitToClient(GamePlayerSocketEvent.PlayerRemovedFromGame, userRemoved.reason);
        this.clientHandlerService.resetState();
    }

    private emitPlayerLeft(player: Player) {
        this.emitToClient(GamePlayerSocketEvent.SendPlayerLeft, translatePlayer(player));
    }
}
