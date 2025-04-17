import { Container, Service } from 'typedi';
import { GameManagerService } from '@app/services/game/game-manager.service';
import { Response } from '@common/interfaces/response/response';
import { GameBase } from '@app/classes/game/game-base';
import { BaseHandlerState } from './base-handler-state.service';
import { createUnsuccessfulResponse } from '@app/utils/responses.utils';
import { GameLobby } from '@app/classes/game/game-lobby';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { GamePlayerState } from './game-player-state.service';
import { GameOrganizerState } from './game-organizer-state.service';
import { UsersSessionsService } from '@app/services/users/user-sessions.service';
import { GameInfo } from '@common/interfaces/game-info';
import { User } from '@app/interfaces/users/user';

@Service({ transient: true })
export class DefaultState extends BaseHandlerState {
    private gameManagerService: GameManagerService;
    private usersSessionService: UsersSessionsService;

    clearState(): void {
        [
            GameManagementSocketEvent.JoinGameLobby,
            GameManagementSocketEvent.GetGamesInfo,
            GameManagementSocketEvent.CreateGameLobby,
            GameManagementSocketEvent.CreateGameSurvival,
        ].forEach((event) => this.client.removeEventListeners(event));
    }

    protected initializeState() {
        this.client.resetState();

        this.gameManagerService = Container.get(GameManagerService);
        this.usersSessionService = Container.get(UsersSessionsService);

        this.client.onUserEvent(GameManagementSocketEvent.JoinGameLobby, async (data: { gameId: number; sessionId: string }, callback) => {
            callback(await this.joinGame(data.gameId, data.sessionId));
        });

        this.client.onUserEvent(GameManagementSocketEvent.GetGamesInfo, async (callback: (callbackArg: unknown) => void) =>
            callback(this.getGamesInfo()),
        );

        this.client.onUserEvent(GameManagementSocketEvent.CreateGameLobby,
            async (data: { quizId: string, sessionId: string, isFriendsOnly: boolean, questionCount: number, entryFee: number }) =>
                await this.createGameLobby(data.quizId, data.sessionId, data.isFriendsOnly, data.questionCount, data.entryFee)
        );

        this.client.onUserEvent(GameManagementSocketEvent.CreateGameSurvival,
            async (data: { quizId: string, sessionId: string, questionCount: number }) => await this.createGameSurvival(data.quizId, data.sessionId, data.questionCount)
        );
    }

    private async joinGame(gameId: number, sessionId: string): Promise<Response> {
        const game: GameLobby = this.gameManagerService.getGameById(gameId) as GameLobby;
        if (!game) return createUnsuccessfulResponse(10000);
        if (!(game instanceof GameLobby)) return createUnsuccessfulResponse(10002);

        const user: User = await this.usersSessionService.getUser(sessionId);
        if (!user) return createUnsuccessfulResponse(100);

        this.client.name = user.username;
        this.client.id = user.id;
        const response = await game.addPlayer(this.client);
        if (!response.success) return response;

        this.clientHandlerService.game = game;
        this.clientHandlerService.updateState(new GamePlayerState());

        return response;
    }

    private getGamesInfo(): GameInfo[] {
        return this.gameManagerService.getGamesInfo();
    }

    private async createGameLobby(quizId: string, sessionId: string, isFriendsOnly: boolean, questionCount: number, entryFee: number) {
        const user: User = await this.usersSessionService.getUser(sessionId);
        if (!user) return;

        this.client.name = user.username;
        this.client.id = user.id;
        const createdGame: GameBase = await this.gameManagerService.createGameLobby(this.client, quizId, isFriendsOnly, questionCount, entryFee);
        if (!createdGame) return;

        this.clientHandlerService.game = createdGame;
        this.clientHandlerService.updateState(new GameOrganizerState());
    }

    private async createGameSurvival(quizId: string, sessionId: string, questionCount: number) {
        const user: User = await this.usersSessionService.getUser(sessionId);
        if (!user) return;

        this.client.name = user.username;
        this.client.id = user.id;
        const createdGame: GameBase = await this.gameManagerService.createSurvivalGame(this.client, quizId, questionCount);
        if (!createdGame) return;

        this.clientHandlerService.game = createdGame;
        this.clientHandlerService.updateState(new GamePlayerState());
    }
}
