import { EventEmitter, Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { ChatSocketEvent } from '@common/enums/socket-event/chat-socket-event';
import { ChatsService } from './chats-service';
import { BehaviorSubject, map } from 'rxjs';
import { UserInfoService } from '../user-info.service';
import { UserAuthenticationService } from '../user-authentication.service';

@Injectable({
    providedIn: 'root',
})
export class ChatService {
    username: string;
    leftChatEvent: EventEmitter<void>;
    private isChatMinimizedSubject = new BehaviorSubject<boolean>(true);
    private socketService: SocketService;
    private isChatDetachedSubject = new BehaviorSubject<boolean>(false);

    constructor(
        socketFactory: SocketFactoryService,
        private userService: UserInfoService,
        private chatsService: ChatsService,
        private authService: UserAuthenticationService,
    ) {
        this.leftChatEvent = new EventEmitter();
        this.socketService = socketFactory.getSocket();
        this.authService.connectionEvent.subscribe((username) => (this.username = username));
        this.setUpObservable();
    }

    detachChat(): void {
        this.isChatDetachedSubject.next(true);
        this.chatsService.isChatDetached = true;
    }

    attachChat(): void {
        this.isChatDetachedSubject.next(false);
        this.chatsService.isChatDetached = false;
    }

    getChatDetachedStateObservable() {
        return this.isChatDetachedSubject.asObservable();
    }

    toggleChatMinimized() {
        if (this.isChatMinimizedSubject.value) {
            this.socketService.emit(ChatSocketEvent.ResetUserNotifications, { chatId: this.chatsService.getGameChatId(), username: this.username });
        }
        this.isChatMinimizedSubject.next(!this.isChatMinimizedSubject.value);
    }

    getChatMinimizedStateObservable() {
        return this.isChatMinimizedSubject.asObservable();
    }

    banUser(username: string) {
        this.socketService.emit(ChatSocketEvent.BanUser, username);
    }

    leaveChat() {
        this.socketService.emit(ChatSocketEvent.LeaveChat, { chatId: this.chatsService.getGameChatId(), username: this.username });
        this.chatsService.setSelected(null);
        this.leftChatEvent.emit();
    }

    private setUpObservable() {
        this.userService.userObservable.pipe(map((user) => user.username)).subscribe((username) => this.onUsernameUpdate(username));
    }

    private onUsernameUpdate(newUsername: string) {
        this.socketService.emit(ChatSocketEvent.UpdateUsername, { newUsername, oldUsername: this.username });
        this.username = newUsername;
    }
}
