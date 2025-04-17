import { ClientHandlerService } from '@app/services/client/client-handler.service';

export abstract class BaseClientHandlerComponent {
    constructor(protected clientHandlerService: ClientHandlerService) {}

    protected get game() {
        return this.clientHandlerService.game;
    }

    protected get client() {
        return this.clientHandlerService.client;
    }

    protected emitToClient<ValuType>(eventName: string, eventValue?: ValuType) {
        this.clientHandlerService.client.emitToUser(eventName, eventValue);
    }

    abstract initializeComponent(): void;
    abstract clearComponent(): void;
}
