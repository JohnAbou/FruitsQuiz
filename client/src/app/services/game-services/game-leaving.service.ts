import { EventEmitter, Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { MatDialog } from '@angular/material/dialog';
import { InformationModalComponent } from '@app/components/modal/information-modal/information-modal.component';
import { Router } from '@angular/router';
import { GameBaseService } from './base-classes/game-base.service';
import { ChatService } from '@app/services/chat-services/chat.service';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { MessageTranslationService } from '../message-translation.service';
import { GameStateService } from './game-state.service';
import { UserGameState } from '@common/enums/user-game-state';
import { BehaviorSubject } from 'rxjs';

@Injectable({
    providedIn: 'root',
})
export class GameLeavingService extends GameBaseService {

    leftGameEvent: EventEmitter<null> = new EventEmitter();

    private canLeaveSafelySubject = new BehaviorSubject(true);

    get canLeaveSafely$() {
        return this.canLeaveSafelySubject.asObservable();
    }

    get canLeaveSafely() {
        return this.canLeaveSafelySubject.getValue();
    }

    // This service needs all of these dependency, the router and the dialog
    // to reroute out of the game page when we leave the game and the modal to show the reason
    // plus we need to update the ChatService since it does not have acces to the game socket.
    // eslint-disable-next-line max-params
    constructor(
        socketFactory: SocketFactoryService,
        private dialog: MatDialog,
        private router: Router,
        private chatService: ChatService,
        private dialogModal: DialogModalService,
        private messageTranslation: MessageTranslationService,
        private gameStateService: GameStateService,
    ) {
        super(socketFactory);
        this.setUpSocket();
        this.gameStateService.getStateObservable().subscribe((newState) => this.onStateChange(newState));
    }

    leaveGame() {
        this.socketService.emit(GamePlayerSocketEvent.PlayerLeftGame);
    }

    private setUpSocket() {
        this.socketService.on(GamePlayerSocketEvent.PlayerRemovedFromGame, this.playerRemoved.bind(this));
    }

    private playerRemoved(reason: number) {
        if (reason) {
            let message = this.messageTranslation.getTranslatedMessage(reason);
            this.dialog.open(InformationModalComponent, { data: message });
        }

        if (this.router.url == '/game-view') this.router.navigate(['/home']);
        this.updateService();
    }

    private updateService() {
        this.chatService.leaveChat();
        this.dialogModal.closeModals();
        this.leftGameEvent.emit();
    }

    private onStateChange(state: UserGameState) {
        this.canLeaveSafelySubject.next(state === UserGameState.Leaderboard || state === UserGameState.None);
    }
}
