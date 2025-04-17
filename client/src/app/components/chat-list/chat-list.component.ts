import { Component, EventEmitter, Input, Output } from '@angular/core';
import { ChatsService } from '@app/services/chat-services/chats-service';
import { Chat } from '@common/interfaces/chat/chat';
import { ConfirmationModalComponent } from '@app/components/modal/confirmation-modal/confirmation-modal.component';
import { MatDialog } from '@angular/material/dialog';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-chat-list',
    templateUrl: './chat-list.component.html',
    styleUrls: ['./chat-list.component.scss'],
})
export class ChatListComponent {
    @Input() chats: Chat[];
    @Input() selectedChat: string | null;
    @Input() username: string;
    @Output() onSetJoinChatPage = new EventEmitter<void>();
    @Output() onSetCreateChatPage = new EventEmitter<void>();

    constructor(
        private chatsService: ChatsService,
        private dialog: MatDialog,
        private translate: TranslateService,
    ) {}

    orderChats() {
        return this.chats.sort((a, b) => {
            // eslint-disable-next-line @typescript-eslint/no-magic-numbers
            if (a.name === 'Global') return -1;
            if (b.name === 'Global') return 1;
            // eslint-disable-next-line @typescript-eslint/no-magic-numbers
            if (a.name === 'Partie' || a.name === 'Game') return -1;
            if (b.name === 'Partie' || a.name === 'Game') return 1;
            return a.name.toLocaleLowerCase().localeCompare(b.name.toLocaleLowerCase());
        });
    }
    onChatClick(chatId: string) {
        this.chatsService.setSelected(chatId);
    }

    setCreateChatPage() {
        this.onSetCreateChatPage.emit();
    }

    setJoinChatPage() {
        this.onSetJoinChatPage.emit();
    }

    onDeleteChat(chatId: string, chatName: string) {
        const message = this.translate.instant('ChatListComponent.ConfirmDeleteChat', {
            chatName: chatName,
        });

        const dialogRef = this.dialog.open(ConfirmationModalComponent, { data: message, autoFocus: false });
        dialogRef.afterClosed().subscribe((result: boolean) => {
            if (result) {
                this.chatsService.deleteChat(chatId);
            }
        });
    }

    onLeaveChat(chatId: string, chatName: string) {
        const message = this.translate.instant('ChatListComponent.ConfirmLeaveChat', {
            chatName: chatName,
        });

        const dialogRef = this.dialog.open(ConfirmationModalComponent, { data: message, autoFocus: false });
        dialogRef.afterClosed().subscribe((result: boolean) => {
            if (result) {
                this.chatsService.leaveChat(chatId);
            }
        });
    }
}
