import { Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { ChatSocketEvent } from '@common/enums/socket-event/chat-socket-event';
import { BehaviorSubject } from 'rxjs';
import { ChatService } from './chat.service';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { TranslateService } from '@ngx-translate/core';

@Injectable({
    providedIn: 'root',
})
export class ChatBannedStateService {
    private isUserBanned: BehaviorSubject<boolean>;
    private socketService: SocketService;

    constructor(
        socketFactory: SocketFactoryService,
        private chatService: ChatService,
        private modalService: DialogModalService,
        private translate: TranslateService,
    ) {
        this.socketService = socketFactory.getSocket();
        this.setUpSocket();

        this.chatService.leftChatEvent.subscribe(() => this.resetState());
        this.isUserBanned = new BehaviorSubject(false);
    }

    getIsUserBannedObservable() {
        return this.isUserBanned.asObservable();
    }

    private resetState() {
        this.isUserBanned.next(false);
    }

    private setUpSocket() {
        this.socketService.on(ChatSocketEvent.OnUserBanned, (isUserBanned: boolean) => {
            this.sendBannedStateMessage(isUserBanned);
            this.isUserBanned.next(isUserBanned);
        });
    }

    private sendBannedStateMessage(isUserBanned: boolean) {
        this.modalService.openSnackBar(
            `${this.translate.instant('ChatBannedService.Organizer')} ${
                isUserBanned ? this.translate.instant('ChatBannedService.Removed') : this.translate.instant('ChatBannedService.Added')
            } ${this.translate.instant('ChatBannedService.ChatRight')}`,
        );
    }
}
