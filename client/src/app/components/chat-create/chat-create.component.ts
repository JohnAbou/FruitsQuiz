import { Component, EventEmitter, Output } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { ChatsService } from '@app/services/chat-services/chats-service';
import { Chat } from '@common/interfaces/chat/chat';
import { noSpacesValidator } from '@app/utils/no-spaces-validator';
import { TranslateService } from '@ngx-translate/core';

@Component({
    selector: 'app-chat-create',
    templateUrl: './chat-create.component.html',
    styleUrls: ['./chat-create.component.scss'],
})
export class CreateChatComponent {
    @Output() createChat = new EventEmitter<Partial<{ chatName: string | null; isFriendsOnly: boolean | null }>>();
    chatList: Chat[] = [];

    chatForm = new FormGroup({
        chatName: new FormControl('', [Validators.required, noSpacesValidator]),
        isFriendsOnly: new FormControl(false),
    });

    constructor(
        private chatsService: ChatsService,
        private translate: TranslateService,
    ) {}

    get chatNameErrors() {
        const chatNameControl = this.chatForm.get('chatName');
        if (chatNameControl?.hasError('required') || chatNameControl?.hasError('noSpaces')) {
            return this.translate.instant('AddChatComponent.NoEmptyName');
        }
        if (chatNameControl?.hasError('chatNameTaken')) {
            return this.translate.instant('AddChatComponent.ChatNameTaken');
        }
        if (chatNameControl?.hasError('chatNameRestricted')) {
            return this.translate.instant('AddChatComponent.ChatNameRestricted');
        }
        return null;
    }

    async onCreateChat() {
        if (this.chatForm.invalid) {
            this.chatForm.markAllAsTouched();
            this.chatForm.get('chatName')?.markAsDirty();
            return;
        }

        let chatName = this.chatForm.value.chatName?.trim();
        if (!chatName) return;
        if (chatName === 'Partie' || chatName === 'Game') {
            this.chatForm.get('chatName')?.setErrors({ chatNameRestricted: true });
            return;
        }

        try {
            const exists = await this.chatsService.checkChatNameExists(chatName);
            if (exists) {
                this.chatForm.get('chatName')?.setErrors({ chatNameTaken: true });
            } else {
                this.createChat.emit(this.chatForm.value);
            }
        } catch (error) {}
    }
}
