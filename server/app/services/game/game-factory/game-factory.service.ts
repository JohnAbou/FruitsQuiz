import { GameLobby } from '@app/classes/game/game-lobby';
import { Container, Service } from 'typedi';
import { GameConfig } from '@app/interfaces/game-config';
import { Player } from '@app/interfaces/users/player';
import { GameType } from '@common/enums/game-type';
import { GameSurvivalBuilderService } from './game-survival-builder.service';
import { GameMultiplayerBuilderService } from './game-multiplayer-builder.service';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameModifiedService } from '@app/services/game/game-listeners/game-modified.service';
import { GameChatDeleter } from '@app/services/game/game-listeners/game-chat-deleter';
import { Challenge } from '@app/classes/challenges/challenge';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';

@Service()
export class GameFactoryService {
    buildGame(gameConfig: GameConfig, gameType: GameType, players?: Player[], challenges?: Map<string, Challenge>, entryFeeManager?: GameEntryFeeService) {
        switch (gameType) {
            case GameType.LobbyGame:
                throw new Error();
            case GameType.SurvivalGame:
                return this.buildGameSessionSurvival(gameConfig);
            case GameType.NormalGame:
            case GameType.EliminationGame:
                return this.buildGameSessionMultiplayer(gameType, gameConfig, players, challenges, entryFeeManager);
        }
    }

    buildGameSessionLobby(gameConfig: GameConfig, isFriendsOnly: boolean, entryFee: number) {
        const gameLobby = new GameLobby(gameConfig, isFriendsOnly, entryFee);
        Container.set(GameSessionBase, gameLobby);
        Container.get(GameModifiedService);
        Container.get(GameChatDeleter);
        return gameLobby;
    }

    private buildGameSessionSurvival(gameConfig: GameConfig) {
        return new GameSurvivalBuilderService().buildGame(gameConfig);
    }

    private buildGameSessionMultiplayer(gameType: GameType, gameConfig: GameConfig, players: Player[], challenges: Map<string, Challenge>, entryFeeManager?: GameEntryFeeService) {
        return new GameMultiplayerBuilderService().buildGame(gameType, gameConfig, players, challenges, entryFeeManager);
    }
}
