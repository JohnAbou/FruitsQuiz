import { Container, Service } from 'typedi';
import { GameManagerService } from '@app/services/game/game-manager.service';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameLobby } from '@app/classes/game/game-lobby';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { GameBaseState } from './game-base-state.service';
import { GameType } from '@common/enums/game-type';
import { GamePlayerState } from './game-player-state.service';

@Service({ transient: true })
export class GameOrganizerState extends GameBaseState {
    private gameManagerService: GameManagerService;

    clearState(): void {
        this.clearGameBaseState();

        this.client.removeEventListeners(GameManagementSocketEvent.StartGame);
        this.client.removeEventListeners(GameManagementSocketEvent.NextQuestion);
        this.client.removeEventListeners(GameManagementSocketEvent.ToggleLock);
        this.client.removeEventListeners(GameManagementSocketEvent.BanPlayer);
        this.client.removeEventListeners(GameManagementSocketEvent.AddBot);
        this.client.removeEventListeners(GameManagementSocketEvent.RemoveBot);
        this.client.removeEventListeners(GameManagementSocketEvent.UpdateBotDifficulty);
        this.client.removeEventListeners(GamePlayerSocketEvent.PlayerLeftGame);
        this.client.removeEventListeners(GamePlayerSocketEvent.Disconnect);
    }

    protected initializeState() {
        this.gameManagerService = Container.get(GameManagerService);
        this.initializeGameBaseState();

        this.client.onUserEvent(GameManagementSocketEvent.StartGame, async () => this.startGame());
        this.client.onUserEvent(GameManagementSocketEvent.NextQuestion, () => this.goToNextQuestion());

        this.client.onUserEvent(GameManagementSocketEvent.ToggleLock, (callback: (success: boolean) => void) => callback(this.toggleLock()));

        this.client.onUserEvent(GameManagementSocketEvent.BanPlayer, (playerUsername: string) => this.banPlayer(playerUsername));

        this.client.onUserEvent(GameManagementSocketEvent.AddBot, () => this.addBot());

        this.client.onUserEvent(GameManagementSocketEvent.RemoveBot, (playerName: string) => this.removeBot(playerName));

        this.client.onUserEvent(GameManagementSocketEvent.UpdateBotDifficulty, (data: { playerName: string; difficulty: string }) =>
            this.updateBotDifficulty(data.playerName, data.difficulty),
        );

        this.client.onUserEvent(GamePlayerSocketEvent.PlayerLeftGame, () => this.leaveGame());
        this.client.onUserEvent(GamePlayerSocketEvent.Disconnect, () => this.leaveGame());
    }

    private async addBot() {
        this.gameLobby?.addBot();
    }

    private removeBot(playerName: string) {
        this.gameLobby?.removeBot(playerName);
    }

    private updateBotDifficulty(playerName: string, difficulty: string) {
        this.gameLobby?.updateBotDifficulty(playerName, difficulty);
    }

    private banPlayer(playerUsername: string) {
        this.gameLobby?.banPlayer(playerUsername);
    }

    private async startGame() {
        if (!this.gameLobby || !this.gameLobby.canStartGame()) return;

        const startedGame = await this.gameManagerService.createNormalGame(this.gameLobby);
        this.handleGameStartedObserver(this.gameLobby, startedGame as GameSessionBase);
    }

    private toggleLock(): boolean {
        return this.gameLobby?.toggleLock();
    }

    private goToNextQuestion() {
        this.gameSession?.continueQuiz();
    }

    private leaveGame() {
        this.game?.onOrganizerLeft();
        this.clientHandlerService.resetState();
    }

    private handleGameStartedObserver(gameLobby: GameLobby, gameSession: GameSessionBase) {
        if (gameLobby.futureGameType === GameType.EliminationGame) this.clientHandlerService.updateState(new GamePlayerState());
        gameLobby.gameStarted(gameSession as GameSessionBase);
    }
}
