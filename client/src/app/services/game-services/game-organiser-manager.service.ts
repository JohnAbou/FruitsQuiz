import { Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GameListenerService } from './base-classes/game-listener.service';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';

@Injectable({
    providedIn: 'root',
})
export class GameOrganiserManagerService extends GameListenerService {
    private canGoToNextQuestion: boolean;

    constructor(socketFactory: SocketFactoryService) {
        super(socketFactory);
    }

    isNextQuestionButtonActive() {
        return this.canGoToNextQuestion;
    }

    goToNextQuestion() {
        this.canGoToNextQuestion = false;
        this.socketService.emit(GameManagementSocketEvent.NextQuestion);
    }

    protected initializeState(): void {
        this.canGoToNextQuestion = false;
    }

    protected setUpSocket(): void {
        this.socketService.on(GameManagementSocketEvent.CanGoToNextQuestion, () => (this.canGoToNextQuestion = true));
    }
}
