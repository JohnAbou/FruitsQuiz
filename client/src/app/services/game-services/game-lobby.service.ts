import { Injectable } from '@angular/core';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GameInfoService } from './game-info.service';
import { BehaviorSubject } from 'rxjs';
import { GameBaseService } from './base-classes/game-base.service';

@Injectable({
    providedIn: 'root',
})
export class GameLobbyService extends GameBaseService{
    isLobbyLocked: boolean = false;
    isFriendsOnly: boolean = false;
    canStartGame: BehaviorSubject<boolean>;

    constructor(
        socketFactoryService: SocketFactoryService,
        private gameInfoService: GameInfoService,
        
    ) {
        super(socketFactoryService);
        this.canStartGame ??= new BehaviorSubject(false);
        this.socketService.on(GameManagementSocketEvent.CanStartGame, (canStart: boolean) => this.canStartGame.next(canStart));
    }

    get gameId() {
        return this.gameInfoService.getGameId();
    }

    toggleLobbyLock(): void {
        this.socketService.emit(GameManagementSocketEvent.ToggleLock, undefined,
            (isLocked: boolean) => (this.isLobbyLocked = isLocked));
    }

    startGame() {
        this.socketService.emit(GameManagementSocketEvent.StartGame);
    }

    banPlayer(playerName: string) {
        this.socketService.emit(GameManagementSocketEvent.BanPlayer, playerName);
    }

    addBot() {
        this.socketService.emit(GameManagementSocketEvent.AddBot);
    }

    removeBot(playerName: string) {
        this.socketService.emit(GameManagementSocketEvent.RemoveBot, playerName);
    }

    updateBotDifficulty(playerName: string, difficulty: string) {
        this.socketService.emit(GameManagementSocketEvent.UpdateBotDifficulty, { playerName, difficulty });
    }

    resetState() {
        this.canStartGame.next(false);
        this.isLobbyLocked = false;
    }
}
