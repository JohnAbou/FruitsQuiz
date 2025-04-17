import { ChatMessage } from '@common/interfaces/chat/chat-message';
import { ChatUserInfo } from '@common/interfaces/chat/chat-user-info';
import { UpdateChatUsername } from '@common/interfaces/chat/update-chat-username';
import { Socket } from 'socket.io';
import Container, { Service } from 'typedi';
import { BaseSocketHandler } from './base-socket-handler';
import { ChatSocketEvent } from '@common/enums/socket-event/chat-socket-event';
import { ChatManager } from '@app/services/chat-manager.service';
import { EMPTY_CHAT_INFO, GAME_CHAT_ID_LENGTH } from '@app/consts/chat.consts';
import { UserChatsService } from '@app/services/user-chats.service';
import { UserActionMessage, UserAction } from '@common/interfaces/chat/user-action-message';
import { FriendsManagerService } from '../users/friends-manager.service';
import { Chat } from '@common/interfaces/chat/chat';
import { GameManagerService } from '../game/game-manager.service';

@Service()
export class ChatSocket extends BaseSocketHandler {
    private gameChats: Map<string, string> = new Map();

    constructor(
        private chatManager: ChatManager,
        private userChatsService: UserChatsService,
    ) {
        super();
    }
    onConnection(socket: Socket) {
        let socketUsername = '';
        let currentGameChatId = '';

        socket.on(ChatSocketEvent.JoinGameChat, (chatUserInfo: ChatUserInfo) => {
            currentGameChatId = chatUserInfo.chatId;
            const chat = this.userChatsService.createGameChat(chatUserInfo);

            this.gameChats.set(chatUserInfo.username, currentGameChatId);

            this.onJoinChat(socket, { chatId: chatUserInfo.chatId, username: chatUserInfo.username });
            socket.emit(ChatSocketEvent.OnChatJoined, chat);
        });

        socket.on(ChatSocketEvent.JoinChat, (chatUserInfo: ChatUserInfo) => {
            this.userChatsService.getChat(chatUserInfo.chatId).then(async (chat) => {
                if (chat.isFriendsOnly) {
                    const allowedFriends = await Container.get(FriendsManagerService).getUserFriends(chat.creatorUsername);
                    if (!allowedFriends.find((friendName) => friendName === chatUserInfo.username)) {
                        socket.emit(ChatSocketEvent.NotFriendError, chat.creatorUsername);
                        return;
                    }
                }
                this.joinChatRoom(socket, chatUserInfo, chat, chat.creatorUsername);
            });
        });

        socket.on(ChatSocketEvent.PostMessage, async (message: ChatMessage) => {
            await this.userChatsService.addChatMessage(message);

            const usersWithChatOpen = await this.sendMessageAndCollectUsersWithChatOpen(ChatSocketEvent.GetMessage, message, message.chatId);

            await this.userChatsService.updateNotificationUsersInChat(message.chatId, usersWithChatOpen);
        });

        socket.on(ChatSocketEvent.BanUser, (username: string) => this.onBanUser({ chatId: currentGameChatId, username }));
        socket.on(ChatSocketEvent.UpdateUsername, (updateUsername: UpdateChatUsername) => this.updateUserName(EMPTY_CHAT_INFO, updateUsername));

        socket.on(ChatSocketEvent.LeaveChat, async (chatUserInfo: ChatUserInfo) => {
            await this.handleLeaveChat(socket, chatUserInfo.chatId, chatUserInfo.username);
        });

        socket.on('disconnect', () => {
            this.onLeaveChat(socket, { chatId: currentGameChatId, username: socketUsername });
            this.userChatsService.getUserChats(socketUsername).then((chats) => {
                for (const chat of chats) {
                    this.disconnectFromChat(socket, { chatId: chat.id, username: socketUsername });
                }
            });
        });

        socket.on(ChatSocketEvent.JoinChats, async (username: string) => {
            socketUsername = username;
            let userChats = await this.userChatsService.getUserChats(username);
            let gameChatId = this.gameChats.get(username);
            if (gameChatId && Container.get(GameManagerService).isUsernameInGame(username, parseInt(gameChatId))) {
                const gameChat = this.userChatsService.getGameChat(gameChatId);
                if (gameChat) userChats.push(gameChat);
            }
            socket.emit(ChatSocketEvent.InitializeChats, userChats);
            userChats.forEach((chat) => {
                this.onJoinChat(socket, { chatId: chat.id, username });
            });
        });

        socket.on(ChatSocketEvent.UpdateUserChats, async (data: { gameId: string; username: string }, callback: (chats: Chat[]) => void) => {
            try {
                const userChats = await this.userChatsService.getUserChats(data.username);
                const gameChat = this.userChatsService.getGameChat(data.gameId);

                const allChats = gameChat ? [gameChat, ...userChats] : [...userChats];
                callback(allChats);
            } catch (error) {
                callback([]);
            }
        });

        socket.on(ChatSocketEvent.CreateChat, (data: { chatName: string; isFriendsOnly: boolean; username: string }) => {
            this.userChatsService.createChatRoom(data.chatName, data.username, data.isFriendsOnly).then((chat) => {
                this.joinChatRoom(socket, { chatId: chat.id, username: data.username }, chat, data.username);
                this.socketManager.emit(ChatSocketEvent.OnChatCreated, chat);
            });
        });

        socket.on(ChatSocketEvent.GetNonUserChats, (username: string) => {
            this.userChatsService.getNonUserChats(username).then((chats) => {
                socket.emit(ChatSocketEvent.OnNonUserChats, chats);
            });
        });

        socket.on(ChatSocketEvent.DeleteChat, (data: { chatId: string; username: string }) => {
            this.userChatsService.removeUsersFromChat(data.chatId).then(() => {
                this.userChatsService.deleteChatRoom(data.chatId);
                this.socketManager.emit(ChatSocketEvent.OnChatDeleted, data.chatId);
            });
        });

        socket.on(ChatSocketEvent.ChatExists, async ({ chatName }, callback) => {
            try {
                const chatExists = await this.userChatsService.chatExists(chatName);
                callback(chatExists);
            } catch (error) {
                callback(error);
            }
        });

        socket.on(ChatSocketEvent.CleanupFriendOnlyChats, async (data: { username: string; friendUsername: string }) => {
            await this.cleanupFriendOnlyChats(socket, data.username, data.friendUsername);
        });

        socket.on(ChatSocketEvent.ResetUserNotifications, async ({ chatId, username }) => {
            await this.userChatsService.resetUserNotifications(chatId, username);
        });

        socket.on(ChatSocketEvent.GetUserNotifications, async ({ username }, callback) => {
            try {
                const userChats = await this.userChatsService.getUserNotifications(username);
                callback(userChats);
            } catch (error) {
                callback(error);
            }
        });
    }

    private async sendMessageAndCollectUsersWithChatOpen<T>(event: string, data: T, chatId: string): Promise<string[]> {
        const usersWithChatOpen: string[] = [];
        const ackPromises: Promise<void>[] = [];

        this.emitToRoomWithAck<T, { username: string; chatSelected: boolean }>(event, data, chatId, (response) => {
            const ackPromise = new Promise<void>((resolve) => {
                if (response.chatSelected) {
                    usersWithChatOpen.push(response.username);
                }
                resolve();
            });
            ackPromises.push(ackPromise);
        });

        await Promise.all(ackPromises);
        return usersWithChatOpen;
    }

    private async cleanupFriendOnlyChats(socket: Socket, username: string, friendUsername: string) {
        const chats = await this.userChatsService.getFriendChats(username, friendUsername);
        chats.forEach(async (chatId) => {
            await this.handleLeaveChat(socket, chatId, username);
        });
    }

    private async handleLeaveChat(socket: Socket, chatId: string, username: string) {
        if (chatId) {
            if (chatId.length !== GAME_CHAT_ID_LENGTH) {
                await this.userChatsService.removeUserFromChat(chatId, username);
            } else {
                this.gameChats.delete(username);
            }
        }

        socket.emit(ChatSocketEvent.RemoveChat, chatId);
        this.onLeaveChat(socket, { chatId: chatId, username: username });
    }

    // eslint-disable-next-line max-params
    private joinChatRoom(socket: Socket, chatUserInfo: ChatUserInfo, chat: Chat, creatorUsername: string) {
        this.onJoinChat(socket, chatUserInfo);
        this.userChatsService.addUserToChat(chatUserInfo);
        socket.emit(ChatSocketEvent.OnChatJoined, chat);
    }

    private onJoinChat(socket: Socket, chatUserInfo: ChatUserInfo) {
        if (!chatUserInfo.chatId) return;
        socket.join(this.getRoomName(chatUserInfo.chatId));
        this.chatManager.registerChatUser(chatUserInfo, socket);
    }

    private async onLeaveChat(socket: Socket, chatInfo: ChatUserInfo) {
        const message: UserActionMessage = {
            chatId: chatInfo.chatId,
            user: '',
            content: '',
            time: new Date(),
            affectedUser: chatInfo.username,
            action: UserAction.Left,
        };
        await this.userChatsService.addLeavingMessage(message);

        const usersWithChatOpen = await this.sendMessageAndCollectUsersWithChatOpen(ChatSocketEvent.UserLeft, message, message.chatId);

        await this.userChatsService.updateNotificationUsersInChat(message.chatId, usersWithChatOpen);

        this.disconnectFromChat(socket, chatInfo);
    }

    private disconnectFromChat(socket: Socket, chatInfo: ChatUserInfo) {
        socket.leave(this.getRoomName(chatInfo.chatId));
        this.chatManager.unregisterChatUser(chatInfo);
    }

    private onBanUser(chatInfo: ChatUserInfo) {
        const banUserSocket = this.chatManager.findUserSocket(chatInfo);
        banUserSocket?.emit(ChatSocketEvent.OnUserBanned, this.chatManager.toggleUserBan(chatInfo));
    }

    private updateUserName(chatInfo: ChatUserInfo, updateUsername: UpdateChatUsername) {
        if (!chatInfo.chatId) return;
        chatInfo.username = updateUsername.newUsername;
        this.chatManager.updateUserName(chatInfo.chatId, updateUsername);
    }

    // private emitToRoom<ValueType>(eventName: string, value: ValueType, chatId: string) {
    //     this.socketManager.emitToRoom(this.getRoomName(chatId), eventName, value);
    // }

    private emitToRoomWithAck<ValueType, CallBackArgType>(
        eventName: string,
        value: ValueType,
        chatId: string,
        onResponse: (response: CallBackArgType, socketId: string) => void,
    ) {
        this.socketManager.emitToRoomWithAck<ValueType, CallBackArgType>(this.getRoomName(chatId), eventName, value, onResponse);
    }

    private getRoomName(chatId: string) {
        return `chat-${chatId}`;
    }
}
