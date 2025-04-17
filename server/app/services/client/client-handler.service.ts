import { Service } from 'typedi';
import { GameBase } from '@app/classes/game/game-base';
import { Client } from '@app/classes/client';
import { DefaultState } from '@app/services/client/client-handler-states/client-default-state.service';
import { BaseHandlerState } from '@app/services/client/client-handler-states/base-handler-state.service';

@Service({ transient: true })
export class ClientHandlerService {
    game: GameBase;
    private clientHandlerState: BaseHandlerState;

    constructor(public client: Client) {
        this.updateState(new DefaultState());
    }

    updateState(handlerState: BaseHandlerState) {
        this.clientHandlerState?.clearState();
        handlerState.setClientHandlerService(this);
        this.clientHandlerState = handlerState;
    }

    resetState() {
        this.game = undefined;
        this.updateState(new DefaultState());
    }
}
