import { Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { ChatSocketEvent } from '@common/enums/socket-event/chat-socket-event';
import { ChatMessage } from '@common/interfaces/chat/chat-message';
import { ChatService } from './chat.service';
import { ChatsService } from './chats-service';
import { UserActionMessage } from '@common/interfaces/chat/user-action-message';

@Injectable({
    providedIn: 'root',
})
export class ChatMessageService {
    private socketService: SocketService;

    constructor(
        socketFactory: SocketFactoryService,
        private chatService: ChatService,
        private chatsService: ChatsService,
    ) {
        this.socketService = socketFactory.getSocket();
        this.setUpSocket();
    }

    get username() {
        return this.chatService.username;
    }

    sendMessage(message: string) {
        if (!message.trim()) return;
        this.socketService.emit(ChatSocketEvent.PostMessage, this.createMessage(message));
    }

    private setUpSocket() {
        this.socketService.on(ChatSocketEvent.GetMessage, ((
            message: ChatMessage,
            ack: (response: { username: string; chatSelected: boolean }) => void,
        ) => {
            this.addMessage(message);
            ack({ username: this.username, chatSelected: this.chatsService.getSelected() === message.chatId });
        }) as (...args: any[]) => void);

        this.socketService.on(ChatSocketEvent.UserLeft, ((
            message: UserActionMessage,
            ack: (response: { username: string; chatSelected: boolean }) => void,
        ) => {
            this.onUserLeft(message);
            ack({
                username: this.username,
                chatSelected: this.chatsService.getSelected() === message.chatId,
            });
        }) as (...args: any[]) => void);
    }

    private onUserLeft(message: UserActionMessage) {
        this.addMessage(message);
    }

    private addMessage(message: ChatMessage) {
        this.chatsService.addChatMessage(message);
    }

    private createMessage(content: string): ChatMessage {
        return { chatId: this.chatsService.getSelected()!, user: this.username, content, time: new Date() };
    }
}
