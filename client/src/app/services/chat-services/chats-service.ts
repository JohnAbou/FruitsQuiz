import { EventEmitter, Injectable } from '@angular/core';
import { Chat } from '@common/interfaces/chat/chat';
import { ChatMessage } from '@common/interfaces/chat/chat-message';
import { BehaviorSubject, map } from 'rxjs';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { SocketService } from '@app/services/socket-service/socket.service';
import { ChatSocketEvent } from '@common/enums/socket-event/chat-socket-event';
import { TranslateService } from '@ngx-translate/core';
import { UserAuthenticationService } from '../user-authentication.service';
import { DialogModalService } from '../dialog-modal.service';
import { UserAction, UserActionMessage } from '@common/interfaces/chat/user-action-message';
import { UserInfoService } from '../user-info.service';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';

@Injectable({
    providedIn: 'root',
})
export class ChatsService {
    cleanUpFriendOnlyChats = new EventEmitter<string>();
    isChatDetached = false;

    private userChatsSubject: BehaviorSubject<Chat[]> = new BehaviorSubject<Chat[]>([]);
    private nonUserChatsSubject: BehaviorSubject<Chat[]> = new BehaviorSubject<Chat[]>([]);
    private selectedChatSubject: BehaviorSubject<string | null> = new BehaviorSubject<string | null>('1');
    public socketService: SocketService;
    private username: string;

    private readonly boundHandlers = {
        onChatJoined: this.addChat.bind(this),
        initializeChats: this.updateChats.bind(this),
        removeChat: this.removeChat.bind(this),
        onChatCreated: this.onChatCreated.bind(this),
        onNonUserChats: this.getNonUserChats.bind(this),
        onChatDeleted: this.onChatDeleted.bind(this),
        notFriendError: this.showNotFriendError.bind(this),
        onUsernameModified: this.onUsernameModified.bind(this),
    };
    ipcRenderer: any;

    constructor(
        socketFactory: SocketFactoryService,
        private translate: TranslateService,
        private authService: UserAuthenticationService,
        private modalService: DialogModalService,
        private userInfoService: UserInfoService,
    ) {
        this.socketService = socketFactory.getSocket();
        if ((window as any).require) {
            this.ipcRenderer = (window as any).require('electron').ipcRenderer;
        }
        this.authService.connectionEvent.subscribe((username) => this.init(username));
        this.authService.disconnectEvent.subscribe(() => this.destroy());

        this.userInfoService.userObservable.pipe(map((user) => user.username)).subscribe((username) => this.onUsernameUpdate(username));
    }

    private init(username: string) {
        this.socketService.on(ChatSocketEvent.OnChatJoined, this.boundHandlers.onChatJoined);
        this.socketService.on(ChatSocketEvent.InitializeChats, this.boundHandlers.initializeChats);
        this.socketService.on(ChatSocketEvent.RemoveChat, this.boundHandlers.removeChat);
        this.socketService.on(ChatSocketEvent.OnChatCreated, this.boundHandlers.onChatCreated);
        this.socketService.on(ChatSocketEvent.OnNonUserChats, this.boundHandlers.onNonUserChats);
        this.socketService.on(ChatSocketEvent.OnChatDeleted, this.boundHandlers.onChatDeleted);
        this.socketService.on(ChatSocketEvent.NotFriendError, this.boundHandlers.notFriendError);
        this.socketService.on(DataSocketEvent.ChatUsernameChangedNotification, this.boundHandlers.onUsernameModified);

        this.fetchUserChats(username);
    }

    private destroy() {
        this.socketService.off(ChatSocketEvent.OnChatJoined, this.boundHandlers.onChatJoined);
        this.socketService.off(ChatSocketEvent.InitializeChats, this.boundHandlers.initializeChats);
        this.socketService.off(ChatSocketEvent.RemoveChat, this.boundHandlers.removeChat);
        this.socketService.off(ChatSocketEvent.OnChatCreated, this.boundHandlers.onChatCreated);
        this.socketService.off(ChatSocketEvent.OnNonUserChats, this.boundHandlers.onNonUserChats);
        this.socketService.off(ChatSocketEvent.OnChatDeleted, this.boundHandlers.onChatDeleted);
        this.socketService.off(ChatSocketEvent.NotFriendError, this.boundHandlers.notFriendError);
        this.socketService.off(DataSocketEvent.ChatUsernameChangedNotification, this.boundHandlers.onUsernameModified);
    }

    onUsernameModified() {
        this.socketService.emit(
            ChatSocketEvent.UpdateUserChats,
            { gameId: this.getGameChatId()?.toString(), username: this.username },
            (chats: Chat[]) => {
                this.userChatsSubject.next(chats);
            },
        );
    }

    getSelectedObservable() {
        return this.selectedChatSubject.asObservable();
    }

    getSelected() {
        return this.selectedChatSubject.value;
    }

    setSelected(chatId: string | null) {
        this.selectedChatSubject.next(chatId);
        this.socketService.emit(ChatSocketEvent.ResetUserNotifications, { chatId, username: this.username });
    }

    getUserChats() {
        return this.userChatsSubject.value;
    }

    getUserChatsObservable() {
        return this.userChatsSubject.asObservable();
    }

    getNonUserChatsObservable() {
        return this.nonUserChatsSubject.asObservable();
    }

    getAllChats() {
        this.socketService.emit(ChatSocketEvent.GetNonUserChats, this.username);
    }

    addChat(chat: Chat) {
        if (chat.name == 'Partie') {
            chat.name = this.translate.instant('ChatService.GameChatName');
        }
        const chats = this.userChatsSubject.value;
        chats.push(chat);
        this.userChatsSubject.next(chats);
        this.socketService.emit(ChatSocketEvent.PostMessage, this.createUserJoinedMessage(chat.id));
        this.selectedChatSubject.next(chat.id);
        if(chat.name == 'Game'|| chat.name === 'Partie' ){
            this.ipcRenderer.send('initialize-chats', {
                chats: chats,
            });
        }
    }

    createUserJoinedMessage(chatId: string): UserActionMessage {
        return {
            chatId: chatId,
            user: '',
            content: '',
            time: new Date(),
            affectedUser: this.username,
            action: UserAction.Joined,
        };
    }

    showNotFriendError(creatorUsername: string) {
        this.modalService.openSnackBar(this.translate.instant('ChatJoining.FriendsOnlyResponse', { username: creatorUsername }));
    }

    onChatCreated(chat: Chat) {
        if (chat.creatorUsername !== this.username) {
            this.addNonUserChat(chat);
        }
    }

    addNonUserChat(chat: Chat) {
        const chats = this.nonUserChatsSubject.value;
        chats.push(chat);
        this.nonUserChatsSubject.next(chats);
    }

    removeChat(chatId: string) {
        if (this.selectedChatSubject.value === chatId) {
            this.setSelected(null);
        }
        const chats = this.userChatsSubject.value.filter((chat) => chat.id !== chatId);
        this.userChatsSubject.next(chats);
    }

    removeFromNonUserChats(chatId: string) {
        const chats = this.nonUserChatsSubject.value.filter((chat) => chat.id !== chatId);
        this.nonUserChatsSubject.next(chats);
    }

    updateChats(chats: Chat[]) {
        chats = chats.map(chat => ({
            ...chat,
            name: chat.name === 'Partie' ? this.translate.instant('ChatService.GameChatName') : chat.name
        }));
        this.userChatsSubject.next(chats);
    }

    addChatMessage(message: ChatMessage) {
        const chats = this.userChatsSubject.value;
        const messageChat = chats.find((chat) => chat.id === message.chatId);
        if (messageChat) {
            messageChat.messages.push(message);
            this.userChatsSubject.next(chats);
        }
    }

    fetchUserChats(username: string) {
        this.username = username;
        this.userChatsSubject.next([]);
        this.socketService.emit(ChatSocketEvent.JoinChats, username);
    }

    getNonUserChats(chats: Chat[]) {
        this.nonUserChatsSubject.next(chats);
    }

    getGameChatId() {
        return this.userChatsSubject.value.find((chat) => chat.name === 'Partie' || chat.name === 'Game')?.id;
    }

    joinGameChat(gameId: number) {
        this.socketService.emit(ChatSocketEvent.JoinGameChat, { chatId: gameId.toString(), username: this.username });
    }

    joinChat(chatId: string) {
        this.socketService.emit(ChatSocketEvent.JoinChat, { chatId, username: this.username });
    }

    createChat(chatName: string, isFriendsOnly: boolean) {
        this.socketService.emit(ChatSocketEvent.CreateChat, { chatName, isFriendsOnly, username: this.username });
    }

    deleteChat(chatId: string) {
        this.socketService.emit(ChatSocketEvent.DeleteChat, { chatId, username: this.username });
    }

    onChatDeleted(chatId: string) {
        const userChats = this.userChatsSubject.value;
        if (userChats.some((chat) => chat.id === chatId)) {
            this.removeChat(chatId);
        } else {
            this.removeFromNonUserChats(chatId);
        }
    }

    leaveChat(chatId: string) {
        this.socketService.emit(ChatSocketEvent.LeaveChat, { chatId, username: this.username });
    }

    checkChatNameExists(chatName: string): Promise<boolean> {
        return this.socketService.emitWithAck<{ chatName: string }, boolean>(ChatSocketEvent.ChatExists, { chatName });
    }

    cleanupFriendOnlyChats(friendUsername: string) {
        this.isChatDetached
            ? this.cleanUpFriendOnlyChats.emit(friendUsername)
            : this.socketService.emit(ChatSocketEvent.CleanupFriendOnlyChats, { username: this.username, friendUsername });
    }

    private onUsernameUpdate(newUsername: string) {
        this.socketService.emit(ChatSocketEvent.UpdateUsername, { newUsername, oldUsername: this.username });
        this.username = newUsername;
    }
}
