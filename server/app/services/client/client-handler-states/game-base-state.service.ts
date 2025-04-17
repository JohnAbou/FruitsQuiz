import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { Subscription } from 'rxjs';
import { BaseHandlerState } from './base-handler-state.service';
import { UserRemovedClientHandlerComponent } from '@app/services/client/client-handler-components/user-removed-client-handler-component';
import { BaseClientHandlerComponent } from '@app/services/client/client-handler-components/base-client-handler-components';
import { UserAddedClientHandlerComponent } from '@app/services/client/client-handler-components/user-added-client-handler-component';
import { GameEndedClientHandlerComponent } from '@app/services/client/client-handler-components/game-ended-client-handler-component';

export abstract class GameBaseState extends BaseHandlerState {
    private components: BaseClientHandlerComponent[] = [];
    private gameStartedSubscription: Subscription;

    protected clearGameBaseState(): void {
        this.gameStartedSubscription?.unsubscribe();

        this.components.forEach((component) => component.clearComponent());
    }

    protected initializeGameBaseState() {
        this.components = [
            new UserRemovedClientHandlerComponent(this.clientHandlerService),
            new UserAddedClientHandlerComponent(this.clientHandlerService),
            new GameEndedClientHandlerComponent(this.clientHandlerService),
        ];
        this.components.forEach((component) => component.initializeComponent());

        this.gameStartedSubscription = this.gameLobby?.gameStartedSubject.subscribe((game: GameSessionBase) => this.onGameStarted(game));
    }

    private onGameStarted(game: GameSessionBase) {
        this.clientHandlerService.game = game;
        this.gameStartedSubscription?.unsubscribe();

        this.resetUserEventSubscription();

        this.emitToClient(GameManagementSocketEvent.OnGameStarted);
    }

    private resetUserEventSubscription() {
        this.components.forEach((component) => component.clearComponent());
        this.components.forEach((component) => component.initializeComponent());
    }
}
