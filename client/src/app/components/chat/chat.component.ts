import {  Component, NgZone, OnDestroy, OnInit } from '@angular/core';
import { ChatBannedStateService } from '@app/services/chat-services/chat-banned-state.service';
import { ChatsService } from '@app/services/chat-services/chats-service';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { combineLatest, map, Observable, Subscription } from 'rxjs';
import { IpcRenderer } from 'electron';
import { ChatService } from '@app/services/chat-services/chat.service';
import { UserInfoService } from '@app/services/user-info.service';
import { ChatPage } from '@app/enums/chat-page.enum';
import { TranslateService } from '@ngx-translate/core';
import { PreferencesService } from '@app/services/preferences.service';
import { UserPreferences } from '@common/interfaces/response/account-response';
import { GameLeavingService } from '@app/services/game-services/game-leaving.service';
import { ChangeDetectorRef } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { PublicProfileCardComponent } from '@app/components/public-profile-card/public-profile-card.component';
import { AvatarNavigationService } from '@app/services/avatar-navigation.service';
import { Router } from '@angular/router';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
@Component({
    selector: 'app-chat',
    templateUrl: './chat.component.html',
    styleUrls: ['./chat.component.scss'],
})
export class ChatComponent implements OnInit, OnDestroy {
    private ipcRenderer: IpcRenderer | undefined;
    public isChatDetached: boolean = false;
    public isMinimized: boolean = false;

    chatPage = ChatPage.ChatSelection;
    ChatPage = ChatPage;

    private subscription = new Subscription();
    private currentDialogRef: any;

    get username() {
        return this.chatService.username;
    }

    // eslint-disable-next-line max-params
    constructor(
        private authService: UserAuthenticationService,
        private chatsService: ChatsService,
        private chatService: ChatService,
        private chatBannedState: ChatBannedStateService,
        private gameInfoService: GameInfoService,
        private userInfoService: UserInfoService,
        private translate: TranslateService,
        private preferenceService: PreferencesService,
        private gameLeavingService: GameLeavingService,
        private zone: NgZone,
        private cdr: ChangeDetectorRef,
        private dialog: MatDialog,
        private router: Router,
        private avatarNavigationService: AvatarNavigationService,
        socketFactory: SocketFactoryService,
    ) {
        if ((window as any).require) {
            this.ipcRenderer = (window as any).require('electron').ipcRenderer;
        }
    }

    ngOnInit(): void {
        this.subscribeToMinimizedState();
        this.setupIpcRendererListeners();

    }

    ngOnDestroy(): void {
        this.subscription?.unsubscribe();

        if (this.ipcRenderer) {
            this.ipcRenderer.removeAllListeners('chat-data');
            this.ipcRenderer.removeAllListeners('username-changed');
            this.ipcRenderer.removeAllListeners('left-game');
            this.ipcRenderer.removeAllListeners('theme-changed');
            this.ipcRenderer.removeAllListeners('language-changed');
            this.ipcRenderer.removeAllListeners('chat-window-closed');
            this.ipcRenderer.removeAllListeners('open-profile-modal');
        }

        if (this.currentDialogRef) {
            this.currentDialogRef.close();
            this.currentDialogRef = null;
        }
    }

    private subscribeToMinimizedState(): void {
        this.chatService.getChatMinimizedStateObservable().subscribe((isMinimized) => {
            this.isMinimized = isMinimized;
        });
    }

    private setupIpcRendererListeners(): void {
        if (!this.ipcRenderer) return;
        if (!this.authService.isUserAuthenticated()) {
            this.isChatDetached = true;
            this.toggleMinimize();
            this.ipcRenderer.on('initialize-chats', (_event, data) => {
                this.chatsService.fetchUserChats(this.userInfoService.user.username)
                const gameChat = data.chats.find((chat: any) => chat.name === 'Game' || chat.name === 'Partie');
                if (gameChat) {
                        this.chatsService.setSelected(gameChat.id);
                        this.chatsService.getAllChats();
                }
            });
            this.ipcRenderer.on('chat-data', (_event, data) => this.handleChatData(data));
            this.ipcRenderer.on('username-changed', (_event, data) => this.handleUsernameChanged(data.username));
            this.ipcRenderer.on('left-game', (_event, data) => this.handleLeftGame());
            this.ipcRenderer.on('theme-changed', (_event, data) => {
                this.preferenceService.setTheme(data.theme);
              });
            this.ipcRenderer.on('language-changed', (_event, data: { language: string;}) => 
                 {
                this.translate.use(data.language);
                this.cdr.detectChanges();
              });
    
            this.subscription.add(
            this.chatsService.getSelectedObservable().subscribe(selectedChatId => {
                this.ipcRenderer?.send('selected-chat-changed', selectedChatId);
            })
            );
            this.ipcRenderer.on('clean-up-friend-only-chats', (_event, data) => {
                this.chatsService.cleanupFriendOnlyChats(data.username);
            });
        } else {
            this.subscription.add(
                this.preferenceService.themeChanges$.subscribe(theme => {
                  if (this.isChatDetached && this.ipcRenderer) {
                    this.ipcRenderer.send('theme-changed', { theme });
                  }
                })
              );
            this.subscription.add(
                this.userInfoService.userObservable
                .subscribe((user) => this.ipcRenderer?.send('username-changed', { username: user.username }))
            );
            this.subscription.add(
                this.gameLeavingService.leftGameEvent.subscribe(() => this.ipcRenderer?.send('left-game'))
            );
            this.subscription.add(
                this.authService.disconnectEvent.subscribe(() => {
                    this.isChatDetached = false
                    this.chatService.attachChat();
                    this.ipcRenderer?.send('disconnect');
                })
                
            );
            this.subscription.add(
                this.preferenceService.themeChanges$.subscribe(theme => {
                    this.ipcRenderer?.send('theme-changed', { theme });
                })
              );
              this.subscription.add(
                this.translate.onLangChange.subscribe(event => {
                  if (this.ipcRenderer) {
                    this.ipcRenderer.send('language-changed', { language: event.lang });
                  }
                })
              );
              this.subscription.add(
                this.chatsService.cleanUpFriendOnlyChats.subscribe((username: string) => {
                    this.ipcRenderer?.send('clean-up-friend-only-chats', { username });
                })
              );
        }
        this.ipcRenderer.on('chat-window-closed', (_event, data) => this.handleChatWindowClosed(data));
        this.ipcRenderer.on('open-profile-modal', (_event, data) => this.openProfileModal(data));
    }

    private handleChatData(data: { sessionId: string; username: string; chats: any[]; selectedChat: string, userPreference: UserPreferences }): void {
        this.authService.connectionEvent.emit(data.username);
        this.chatsService.updateChats(data.chats);
        this.preferenceService.loadUserPreferences(data.userPreference);
        if(data.selectedChat){
           this.chatsService.setSelected(data.selectedChat);
            }
        else{
            this.chatsService.setSelected(null);
        }
    }

    private handleUsernameChanged(username: string): void {
        this.userInfoService.updateUsernameSubject(username);
    }

    private handleChatWindowClosed(data: {selectedChatId: string}): void {
        this.isChatDetached = false;
        this.chatService.attachChat();
        const chatIdToSelect = data?.selectedChatId;
        if(chatIdToSelect){
            this.subscription.add(
                this.chatsObservable.subscribe(chats => {
                        this.chatsService.setSelected(chatIdToSelect);
                    }
        ));
        }
        else{
            this.chatsService.setSelected(null);
        }

        this.chatsService.fetchUserChats(this.userInfoService.user.username);
        this.chatsService.getAllChats();
   
    }

    private openProfileModal(data: any): void {
        this.zone.runOutsideAngular(() => {
            if (this.currentDialogRef) {
                this.currentDialogRef.close();
            }
                this.zone.run(() => {
                    if (this.avatarNavigationService.canNavigateSafely) {
                        this.router.navigate(['/real-public-profile', data.userId]);
                        return;
                    } 
                    this.currentDialogRef = this.dialog.open(PublicProfileCardComponent, {
                        data: { userId: data.userId },
                        panelClass: 'no-padding-dialog',
                        hasBackdrop: true,
                        disableClose: false
                    });
                    this.cdr.detectChanges();
                        const container = document.querySelector('.cdk-overlay-container');
                        if (container) {
                            (container as HTMLElement).focus();
                        }
                });
        });
    }

    private handleLeftGame() {
        this.chatService.leaveChat();
    }

    goBack() {
        this.chatsService.setSelected(null);
        this.chatPage = ChatPage.ChatSelection;
    }

    toggleMinimize() {
        this.chatService.toggleChatMinimized();
    }

    openChatInNewWindow() {
        const userPreference: UserPreferences = {
            theme: this.preferenceService.themeSubject.value,
            background: this.preferenceService.backgroundSubject.value,
            language: this.translate.currentLang
        }
        if (this.ipcRenderer) {
            this.chatService.detachChat();
            this.ipcRenderer.send('open-chat-window', {
                username: this.userInfoService.user.username,
                sessionId: this.authService.getSessionId(),
                chats: this.chatsService.getUserChats(),
                selectedChat: this.chatsService.getSelected(),
                userPreference: userPreference
            });
        }
    }

    get isBannedObservable() {
        return this.chatBannedState.getIsUserBannedObservable();
    }

    get selectedObservable() {
        return this.chatsService.getSelectedObservable();
    }

    get selected() {
        return this.chatsService.getSelected();
    }

    get chatsObservable() {
        return this.chatsService.getUserChatsObservable();
    }

    get chats() {
        return this.chatsService.getUserChats();
    }

    get isBannedAndSelectedChat(): Observable<boolean> {
        return combineLatest([this.isBannedObservable, this.selectedObservable, this.gameInfoService.getGameIdObservable()]).pipe(
            map(([isBanned, selectedChatId, gameId]) => isBanned && selectedChatId === gameId.toString()),
        );
    }

    getSelectedChatMessages(selected: string) {
        return this.chats.find((chat) => chat.id === selected)?.messages;
    }

    onCreateChat(data: Partial<{ chatName: string | null; isFriendsOnly: boolean | null }>) {
        if (!data.chatName) return;
        data.isFriendsOnly = data.isFriendsOnly ?? false;
        this.chatsService.createChat(data.chatName, data.isFriendsOnly);
    }

    setCreateChatPage() {
        this.chatPage = ChatPage.CreateChat;
    }

    setJoinChatPage() {
        this.chatPage = ChatPage.JoinChat;
    }

    getTitle() {
        if (this.selected === null) {
            if (this.chatPage === ChatPage.ChatSelection) {
                return this.translate.instant('AddChatComponent.SelectChatroom');
            }
            if (this.chatPage === ChatPage.JoinChat) {
                return this.translate.instant('AddChatComponent.SelectJoin');
            }
            if (this.chatPage === ChatPage.CreateChat) {
                return this.translate.instant('AddChatComponent.SelectCreate');
            }
        } else {
            const selectedChat = this.chats.find((chat) => chat.id === this.selected);
            if (selectedChat) {
                return selectedChat.name;
            }
        }
        return '';
    }
}
