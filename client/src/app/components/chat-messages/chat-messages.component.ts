import { AfterViewInit, Component, DoCheck, ElementRef, Input, OnDestroy, ViewChild } from '@angular/core';
import { ChatMessage } from '@common/interfaces/chat/chat-message';
import { Subscription } from 'rxjs';
import { ChatMessageService } from '@app/services/chat-services/chat-message.service';
import { TranslateService } from '@ngx-translate/core';
import { GAME_CHAT_ID_LENGTH } from '@app/consts/chat.consts';
import { UsersService } from '@app/services/users.service';
import { UserAction, UserActionMessage } from '@common/interfaces/chat/user-action-message';

@Component({
    selector: 'app-chat-messages',
    templateUrl: './chat-messages.component.html',
    styleUrls: ['./chat-messages.component.scss'],
})
export class ChatMessagesComponent implements DoCheck, OnDestroy, AfterViewInit {
    @Input() messages: ChatMessage[];
    @Input() username: string;
    @Input() isBanned: boolean;
    @ViewChild('scrollContainer') private scrollContainer: ElementRef;

    newMessage: string = '';
    private previousMessageCount: number = 0;
    private messagesSubscription: Subscription;

    constructor(
        private readonly chatMessageService: ChatMessageService,
        private translate: TranslateService,
        private userService: UsersService,
    ) {}

    getFriendUser(username: string) {
        return this.userService.getUserByUsername(username);
    }

    ngAfterViewInit() {
        setTimeout(() => this.scrollToBottom(), 0);
    }

    ngDoCheck() {
        if (this.messages && this.messages.length !== this.previousMessageCount) {
            const shouldScroll = this.isUserNearBottom();
            this.previousMessageCount = this.messages.length;

            if (shouldScroll) {
                setTimeout(() => this.scrollToBottom(), 0);
            }
        }
    }

    private isUserNearBottom(): boolean {
        if (!this.scrollContainer) return false;
        const threshold = 300;
        const scrollContainer = this.scrollContainer.nativeElement;
        const position = scrollContainer.scrollTop + scrollContainer.offsetHeight;
        const height = scrollContainer.scrollHeight;
        return position > height - threshold;
    }

    sendMessage() {
        this.chatMessageService.sendMessage(this.newMessage);
        this.newMessage = '';
    }

    keepFocus(inputElement: HTMLInputElement) {
        inputElement.focus();
    }

    ngOnDestroy() {
        if (this.messagesSubscription) this.messagesSubscription.unsubscribe();
    }

    getMessageClass(message: ChatMessage): string {
        if (message.user === this.username) {
            return 'me';
        }

        if ((message.user === 'Système' || message.user === 'System') && 'action' in message) {
            return 'system' + '-' + message.action;
        }

        return 'other';
    }

    translateMessages(messages: ChatMessage[]): ChatMessage[] {
        return messages.map((message) =>
            'affectedUser' in message || message.user == 'System' || message.user == 'Systeme'
                ? this.translateUserActionMessage(message as UserActionMessage)
                : message,
        );
    }

    private translateUserActionMessage(message: UserActionMessage): UserActionMessage {
        return {
            chatId: message.chatId,
            user: this.translate.instant('ChatMessageService.System'),
            content: this.getMessageContent(message),
            time: message.time,
            affectedUser: message.affectedUser,
            action: message.action,
        };
    }

    private getMessageContent(message: UserActionMessage): string {
        return `${message.affectedUser} ${
            message.action === UserAction.Left
                ? this.translate.instant('ChatMessageService.Quit')
                : this.translate.instant('ChatMessageService.Joined')
        } ${
            message.chatId.length === GAME_CHAT_ID_LENGTH
                ? this.translate.instant('ChatMessageService.Game')
                : this.translate.instant('ChatMessageService.Canal')
        }`;
    }

    private scrollToBottom(): void {
        try {
            this.scrollContainer.nativeElement.scrollTop = this.scrollContainer.nativeElement.scrollHeight;
        } catch (err) {
            // no need to do anything on error
        }
    }
}
