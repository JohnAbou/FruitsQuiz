import { Injectable } from '@angular/core';
import { SocketFactoryService } from '@app/services/socket-service/socket-factory.service';
import { GameBaseService } from './base-classes/game-base.service';
import { Response } from '@common/interfaces/response/response';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { GameStateService } from './game-state.service';
import { UserGameState } from '@common/enums/user-game-state';
import { UserAuthenticationService } from '@app/services/user-authentication.service';
import { GameInfo } from '@common/interfaces/game-info';
import { BehaviorSubject } from 'rxjs';
import { DataSocketEvent } from '@common/enums/socket-event/data-socket-event';

@Injectable({
    providedIn: 'root',
})
export class GameJoiningService extends GameBaseService {
    filteredGamesInfo = new BehaviorSubject<GameInfo[]>([]);

    private gamesInfo: GameInfo[] = [];

    constructor(
        socketFactory: SocketFactoryService,
        private gameStateService: GameStateService,
        private userAuthService: UserAuthenticationService,
    ) {
        super(socketFactory);
        socketFactory.getSocket().on(DataSocketEvent.GameInfoChangedNotification, (infos: GameInfo[]) => this.getGameInfos(infos));
        this.loadGamesInfo();
    }

    async findGameById(gameId: number): Promise<GameInfo | undefined> {
        return this.gamesInfo.find((game) => game.gameId === gameId);
    }

    async joinGame(game: GameInfo): Promise<Response> {
        this.gameStateService.setState(UserGameState.AttemptingToJoin);
        const sessionId = this.userAuthService.getSessionId();
        return this.emitToSocketAsPromise(GameManagementSocketEvent.JoinGameLobby, { gameId: game.gameId, sessionId });
    }

    private loadGamesInfo() {
        this.emitToSocketAsPromise<GameInfo[]>(GameManagementSocketEvent.GetGamesInfo)
            .then((infos) => this.getGameInfos(infos));
    }

    private async emitToSocketAsPromise<AckReturnType>(event: string, data?: unknown): Promise<AckReturnType> {
        return new Promise<AckReturnType>((resolve) => {
            this.socketService.emit(event, data, (success: AckReturnType) => resolve(success));
        });
    }

    private updateFilteredGamesInfo() {
        this.filteredGamesInfo.next(this.gamesInfo.filter((gameInfo) => this.applyFilter(gameInfo)));
    }

    private applyFilter(gameInfo: GameInfo): boolean {
        return true;
    }

    private getGameInfos(gameInfos: GameInfo[]) {
        this.gamesInfo = gameInfos;
        this.updateFilteredGamesInfo();
    }
}
