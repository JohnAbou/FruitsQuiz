import { Component } from '@angular/core';
import { ChatService } from '@app/services/chat-services/chat.service';
import { combineLatest, map } from 'rxjs';

@Component({
  selector: 'app-default-page-template',
  templateUrl: './default-page-template.component.html',
  styleUrls: ['./default-page-template.component.scss']
})
export class DefaultPageTemplateComponent {

    get isChatDetached() {
        return this.chatService.getChatDetachedStateObservable();
    }

    get isChatHidden() {
        return combineLatest([
            this.chatService.getChatMinimizedStateObservable(),
            this.chatService.getChatDetachedStateObservable(),
        ]).pipe(map(([isMinimized, isDetached]) => isMinimized || isDetached));
    }

  constructor(private chatService: ChatService) {}
}
