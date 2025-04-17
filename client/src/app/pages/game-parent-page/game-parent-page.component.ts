import { Component, OnDestroy, OnInit } from '@angular/core';
import { UserGameState } from '@common/enums/user-game-state';
import { GameStateService } from '@app/services/game-services/game-state.service';
import { combineLatest, map, Subscription } from 'rxjs';
import { GameLeavingService } from '@app/services/game-services/game-leaving.service';
import { DialogModalService } from '@app/services/dialog-modal.service';
import { UserGameRole } from '@common/enums/user-game-role';
import { ChatService } from '@app/services/chat-services/chat.service';

@Component({
    selector: 'app-game-parent-page',
    templateUrl: './game-parent-page.component.html',
    styleUrls: ['./game-parent-page.component.scss'],
})
export class GameParentPageComponent implements OnInit, OnDestroy {
    userState: UserGameState;
    userRole: UserGameRole;
    reloadComponent: boolean = false;

    get isChatDetached() {
        return this.chatService.getChatDetachedStateObservable();
    }

    get isChatHidden() {
        return combineLatest([
            this.chatService.getChatMinimizedStateObservable(),
            this.chatService.getChatDetachedStateObservable(),
        ]).pipe(map(([isMinimized, isDetached]) => isMinimized || isDetached));
    }

    private gameStateSubscription: Subscription;
    private gameRoleSubscription: Subscription;

    constructor(
        private gameStateService: GameStateService,
        private leavingGameService: GameLeavingService,
        private dialogModalService: DialogModalService,
        private chatService: ChatService,
    ) { }

    ngOnInit(): void {
        this.gameRoleSubscription = this.gameStateService.getRoleObservable().subscribe((newRole) => this.onRoleChange(newRole));
        this.gameStateSubscription = this.gameStateService.getStateObservable().subscribe((newState) => this.onStateChange(newState));
    }

    ngOnDestroy(): void {
        this.gameRoleSubscription.unsubscribe();
        this.gameStateSubscription.unsubscribe();
        this.leavingGameService.leaveGame();
    }

    reload() {
        this.reloadComponent = true;
        setTimeout(() => (this.reloadComponent = false));
    }

    private onStateChange(newState: UserGameState): void {
        this.dialogModalService.closeModals();
        if (this.userState === newState) this.reload();
        this.userState = newState;
    }

    private onRoleChange(newRole: UserGameRole) {
        this.userRole = newRole;
    }
}
