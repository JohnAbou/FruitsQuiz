import { Service } from 'typedi';
import { Chat } from '@common/interfaces/chat/chat';
import { ChatUserInfo } from '@common/interfaces/chat/chat-user-info';
import { DataManagerService } from './data/data-manager.service';
import { randomUUID } from 'crypto';
import { CHAT_COLLECTION, USER_COLLECTION } from '@app/consts/database.consts';
import { GAME_CHAT_ID_LENGTH } from '@app/consts/chat.consts';
import { User, UserChat } from '@app/interfaces/users/user';
import { ChatMessage } from '@common/interfaces/chat/chat-message';
import { UsernameModificationService } from './users/username-modification.service';
import { UsernameModifiedEvent } from '@app/interfaces/users/username-modified-event';
import { UserActionMessage } from '@common/interfaces/chat/user-action-message';
import { DataModifiedSocket } from './sockets/data-modified-socket.service';
import { createUserChat } from '@app/utils/default-user-chat.utils';

@Service()
export class UserChatsService {
    gameChats: Chat[] = [];

    constructor(
        private userDataManagerService: DataManagerService<User>,
        private chatDataManagerService: DataManagerService<Chat>,
        private dataModified: DataModifiedSocket,
        private readonly usernameModificationService: UsernameModificationService,
    ) {
        this.userDataManagerService.setCollection(USER_COLLECTION);
        this.chatDataManagerService.setCollection(CHAT_COLLECTION);

        this.usernameModificationService.usernameModifiedEvent.subscribe((usernameModification) =>
            this.updateDataOnUsernameChange(usernameModification),
        );
    }

    async getChat(chatId: string): Promise<Chat> {
        const chat = await this.chatDataManagerService.getElementById(chatId);
        if (chat) return chat;
        throw new Error('Chat not found');
    }

    getGameChat(chatId: string): Chat {
        const chat = this.gameChats.find((gameChat) => gameChat.id === chatId);
        if (chat) return chat;
        return null;
    }

    async createChatRoom(chatName: string, creatorUsername: string, isFriendsOnly: boolean): Promise<Chat> {
        const chatId = randomUUID();

        const chat: Chat = {
            id: chatId,
            name: chatName,
            creatorUsername,
            messages: [],
            isFriendsOnly,
        };

        const success = await this.chatDataManagerService.addElement(chat);

        return success ? chat : null;
    }

    deleteChatRoom(chatId: string) {
        this.chatDataManagerService.deleteElement(chatId);
    }

    createGameChat(chatInfo: ChatUserInfo): Chat {
        let chat = this.gameChats.find((gameChat) => gameChat.id === chatInfo.chatId);

        if (!chat) {
            chat = {
                id: chatInfo.chatId,
                name: 'Partie',
                creatorUsername: 'Système',
                messages: [],
                isFriendsOnly: false,
            };
            this.gameChats.push(chat);
        }

        return chat;
    }

    deleteGameChat(chatId: string) {
        this.gameChats = this.gameChats.filter((gameChat) => gameChat.id !== chatId);
    }

    async addLeavingMessage(message: UserActionMessage): Promise<void> {
        if (message.chatId) {
            if (message.chatId.length == GAME_CHAT_ID_LENGTH) {
                const chat = this.gameChats.find((gameChat) => gameChat.id === message.chatId);
                if (chat) {
                    chat.messages ??= [];
                    chat.messages.push(message);
                }
            } else {
                const chat = await this.chatDataManagerService.getElementById(message.chatId);
                if (chat) {
                    chat.messages ??= [];
                    chat.messages.push(message);
                    await this.chatDataManagerService.replaceElement(chat);
                }
            }
        }
    }

    async addChatMessage(message: ChatMessage): Promise<void> {
        let chat;
        if (message.chatId.length == GAME_CHAT_ID_LENGTH) {
            chat = this.gameChats.find((gameChat) => gameChat.id === message.chatId);
            if (chat) {
                chat.messages ??= [];
                chat.messages.push(message);
            }
        } else {
            chat = await this.chatDataManagerService.getElementById(message.chatId);
            if (chat) {
                chat.messages ??= [];
                chat.messages.push(message);
                await this.chatDataManagerService.replaceElement(chat);
            }
        }
    }

    async addUserToChat(chatInfo: ChatUserInfo): Promise<void> {
        const user = await this.userDataManagerService.getElementByUsername(chatInfo.username);
        if (!user) return;

        user.chats ??= [];

        if (!user.chats?.some((chat) => chat.id == chatInfo.chatId)) {
            user.chats.push(createUserChat(chatInfo.chatId));
        }

        await this.userDataManagerService.replaceElement(user);
    }

    async removeUserFromChat(chatId: string, username: string) {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return;

        if (user.chats && user.chats.some((chat) => chat.id === chatId)) {
            user.chats = user.chats.filter((chat) => chat.id !== chatId);
            await this.userDataManagerService.replaceElement(user);
        }
    }

    async removeUsersFromChat(chatId: string) {
        const users = await this.userDataManagerService.getElements();
        for (const user of users) {
            if (user.chats && user.chats.some((chat) => chat.id === chatId)) {
                user.chats = user.chats.filter((chat) => chat.id !== chatId);
                await this.userDataManagerService.replaceElement(user);
            }
        }
    }

    async getUserChats(username: string): Promise<Chat[]> {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return [];

        if (!user.chats?.some((chat) => chat.id === '1')) {
            user.chats.push(createUserChat('1'));
            await this.userDataManagerService.replaceElement(user);
        }

        if (user.chats && user.chats.length > 0) {
            const chats: Chat[] = [];
            for (const userChat of user.chats) {
                const chat = await this.chatDataManagerService.getElementById(userChat.id);
                if (chat) {
                    chats.push(chat);
                } else if (userChat.id !== '1') {
                    user.chats = user.chats.filter((chat) => chat.id !== userChat.id);
                    await this.userDataManagerService.replaceElement(user);
                }
            }
            return chats;
        }
        return [];
    }

    async getNonUserChats(username: string): Promise<Chat[]> {
        const chats = await this.chatDataManagerService.getElements();
        const user = await this.userDataManagerService.getElementByUsername(username);

        if (!user || !chats) return [];

        return chats.filter((chat) => !user.chats?.some((userChat) => userChat.id === chat.id));
    }

    async cleanupGameChats(username: string): Promise<UserChat[]> {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return [];

        if (user.chats && user.chats.length > 0) {
            user.chats = user.chats.filter((chat) => chat.id.length !== GAME_CHAT_ID_LENGTH);

            await this.userDataManagerService.replaceElement(user);
            return user.chats;
        }

        return [];
    }

    async chatExists(chatName: string): Promise<boolean> {
        const chats = await this.chatDataManagerService.getElements();
        return chats.some((chat) => chat.name === chatName);
    }

    async getFriendChats(username: string, friendUsername: string): Promise<string[]> {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return [];

        const chatIds = await Promise.all(
            user.chats.map(async (userChat) => {
                const chat = await this.chatDataManagerService.getElementById(userChat.id);
                return chat && chat.isFriendsOnly && chat.creatorUsername === friendUsername ? userChat.id : null;
            }),
        );

        return chatIds.filter((chatId) => chatId !== null);
    }

    async getUserNotifications(username: string): Promise<UserChat[]> {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return [];
        return user.chats;
    }

    async resetUserNotifications(chatId: string, username: string) {
        const user = await this.userDataManagerService.getElementByUsername(username);
        if (!user) return;

        const chat = user.chats.find((userChat) => userChat.id === chatId);
        if (chat) {
            chat.nUnreadMessages = 0;
            await this.userDataManagerService.replaceElement(user);
        }
    }

    async updateNotificationUsersInChat(chatId: string, usersWithChatOpen: string[]) {
        const users = await this.userDataManagerService.getElements();
        const chatUsers = users.filter((user) => user.chats?.some((userChat) => userChat.id === chatId));

        for (const user of chatUsers) {
            const hasChatOpen = usersWithChatOpen.includes(user.username);
            user.chats = user.chats.map((userChat) => {
                if (userChat.id === chatId) {
                    return {
                        id: userChat.id,
                        nUnreadMessages: hasChatOpen ? 0 : userChat.nUnreadMessages + 1,
                    };
                }
                return userChat;
            });

            await this.userDataManagerService.replaceElement(user);
        }
    }

    private async updateDataOnUsernameChange(usernameModification: UsernameModifiedEvent) {
        this.updateGameChatsOnUsernameChange(usernameModification);
        await this.updateDataBaserOnUsernameChange(usernameModification);
        this.dataModified.emitChatUsernameChangedNotification();
    }

    private async updateGameChatsOnUsernameChange(usernameModification: UsernameModifiedEvent) {
        for (const chat of this.gameChats) {
            for (const message of chat.messages) {
                if ('user' in message && message.user === usernameModification.oldUsername) {
                    message.user = usernameModification.newUsername;
                }
                if ('affectedUser' in message && message.affectedUser === usernameModification.oldUsername) {
                    message.affectedUser = usernameModification.newUsername;
                }
            }
        }
    }

    private async updateDataBaserOnUsernameChange(usernameModification: UsernameModifiedEvent) {
        await this.chatDataManagerService.updateElements(
            { creatorUsername: usernameModification.oldUsername },
            { creatorUsername: usernameModification.newUsername },
        );

        await this.chatDataManagerService['getCollection']().updateMany(
            { 'messages.user': usernameModification.oldUsername },
            { $set: { 'messages.$[elem].user': usernameModification.newUsername } },
            { arrayFilters: [{ 'elem.user': usernameModification.oldUsername }] },
        );

        await this.chatDataManagerService['getCollection']().updateMany(
            { 'messages.affectedUser': usernameModification.oldUsername },
            {
                $set: { 'messages.$[elem].affectedUser': usernameModification.newUsername },
            },
            {
                arrayFilters: [{ 'elem.affectedUser': usernameModification.oldUsername }],
            },
        );
    }
}
