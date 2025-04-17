import { Component, OnDestroy, OnInit } from '@angular/core';
import { ChatsService } from '@app/services/chat-services/chats-service';
import { Chat } from '@common/interfaces/chat/chat';
import { Subscription } from 'rxjs';

@Component({
    selector: 'app-chat-join',
    templateUrl: './chat-join.component.html',
    styleUrls: ['./chat-join.component.scss'],
})
export class JoinChatComponent implements OnInit, OnDestroy {
    searchTerm: string = '';
    chatList: Chat[] = [];

    private nonUserChatsSubscription: Subscription;

    constructor(private chatsService: ChatsService) {}

    get chatsObservable() {
        return this.chatsService.getNonUserChatsObservable();
    }

    ngOnInit(): void {
        this.nonUserChatsSubscription = this.chatsService.getNonUserChatsObservable().subscribe((nonUserChats) => {
            this.chatList = nonUserChats;
        });
        this.chatsService.getAllChats();
    }

    ngOnDestroy(): void {
        if (this.nonUserChatsSubscription) {
            this.nonUserChatsSubscription.unsubscribe();
        }
    }

    filteredChatList() {
        return this.chatList.filter((chat) => chat.name.toLowerCase().includes(this.searchTerm.toLowerCase()));
    }

    joinChat(chatId: string) {
        this.chatsService.joinChat(chatId);
    }
}
