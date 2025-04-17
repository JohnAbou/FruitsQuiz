import { Service } from 'typedi';
import { GAME_ID_MINIMUM, GAME_ID_RANGE } from '@app/consts/game.const';
import { GameBase } from '@app/classes/game/game-base';
import { Quiz } from '@common/interfaces/quiz';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { GameFactoryService } from './game-factory/game-factory.service';
import { GameConfig } from '@app/interfaces/game-config';
import { GameType } from '@common/enums/game-type';
import { QUIZ_COLLECTION } from '@app/consts/database.consts';
import { GameLobby } from '@app/classes/game/game-lobby';
import { SpecialQuizService } from './special-quiz.service';
import { ELIMINATION_QUIZ_ID, SURVIVAL_QUIZ_ID } from '@common/config/game-config';
import { GameInfo } from '@common/interfaces/game-info';
import { DataModifiedSocket } from '@app/services/sockets/data-modified-socket.service';
import { Player } from '@app/interfaces/users/player';
import { GameSessionElimination } from '@app/classes/game/game-session-elimination';
import { GameSessionSurvival } from '@app/classes/game/game-session-survival';
import { Challenge } from '@app/classes/challenges/challenge';
import { GameEntryFeeService } from './game-entry-fee.service';

@Service()
export class GameManagerService {
    private games: Map<number, GameBase> = new Map();

    // eslint-disable-next-line max-params
    constructor(
        private dataManagerService: DataManagerService<Quiz>,
        private gameBuilderService: GameFactoryService,
        private gameRandomManagerService: SpecialQuizService,
        private dataModifiedSocket: DataModifiedSocket,
    ) {
        this.dataManagerService.setCollection(QUIZ_COLLECTION);
    }

    isUsernameInGame(username: string, gameId: number) {
        const game = this.games.get(gameId);
        if (!game) return false;

        return game.users.find(user => user.name===username);
    }

    async createNormalGame(gameLobby: GameLobby): Promise<GameBase> {
        return this.createGameIntern(gameLobby.futureGameType, gameLobby.getGameConfig(), gameLobby.players, gameLobby.challenges, gameLobby.entryFeeManager);
    }

    async createGameLobby(organiser: Player, quizId: string, isFriendsOnly: boolean, questionCount: number, entryFee: number): Promise<GameBase> {
        const futureGameType = quizId === ELIMINATION_QUIZ_ID ? GameType.EliminationGame : GameType.NormalGame;

        const config = await this.generateGameConfig(organiser, quizId, futureGameType, questionCount);
        if (!config) return undefined;

        const newLobby = this.gameBuilderService.buildGameSessionLobby(config, isFriendsOnly, entryFee);
        return this.addGame(newLobby);
    }

    async createSurvivalGame(organiser: Player, quizId: string, questionCount: number): Promise<GameBase> {
        const config = await this.generateGameConfig(organiser, quizId, GameType.SurvivalGame, questionCount);
        return await this.createGameIntern(GameType.SurvivalGame, config);
    }

    getGameById(gameId: number): GameBase {
        return this.games.get(gameId);
    }

    getGamesInfo() {
        const getGameType = (game: GameBase): GameType => {
            if (game instanceof GameLobby) return game.futureGameType;
            if (game instanceof GameSessionElimination) return GameType.EliminationGame;
            if (game instanceof GameSessionSurvival) return GameType.SurvivalGame;
            return GameType.NormalGame;
        };

        const getGameInfo = (game: GameBase): GameInfo => {
            const isLocked = !(game instanceof GameLobby) ? true : (game as GameLobby).isGameLocked();
            const entryFee = (game as any).entryFeeManager?.getEntryFee() ?? 0;
            const gameType = getGameType(game);
            const { quiz } = game.getGameConfig();

            return {
                gameId: game.gameId,
                quizToPlay: quiz,
                playersNb: game.players.length,
                isLocked,
                gameType,
                entryFee,
            };
        };

        const infos: GameInfo[] = [];
        for (const game of this.games.values()) infos.push(getGameInfo(game));

        return infos;
    }

    removeGame(gameId: number) {
        this.games.delete(gameId);
        this.dataModifiedSocket.emitGameInfoChangedNotification(this.getGamesInfo());
    }

    private async getQuizById(quizId: string) {
        return await this.dataManagerService.getElementById(quizId);
    }

    private addGame(game: GameBase): GameBase {
        this.games.set(game.gameId, game);

        const subscription = game.removedGameSubject.subscribe(() => {
            this.removeGame(game.gameId);
            subscription.unsubscribe();
        });

        this.dataModifiedSocket.emitGameInfoChangedNotification(this.getGamesInfo());
        return game;
    }

    private async createGameIntern(gameType: GameType, gameconfig: GameConfig, players?: Player[], challenges?: Map<string, Challenge>, entryFeeManager?: GameEntryFeeService) {
        if (!gameconfig) return undefined;
        const newLobby = this.gameBuilderService.buildGame(gameconfig, gameType, players, challenges, entryFeeManager);
        return this.addGame(newLobby);
    }

    private async generateGameConfig(organiser: Player, quizId: string, futureGameType: GameType, questionCount: number): Promise<GameConfig> {
        let quiz = quizId === SURVIVAL_QUIZ_ID || quizId === ELIMINATION_QUIZ_ID
            ? await this.gameRandomManagerService.createSpecialQuiz(questionCount) : await this.getQuizById(quizId);
        return quiz ? { organizer: organiser, gameId: this.generateGameId(), quiz, futureGameType } : undefined;
    }

    private generateGameId(): number {
        const newId = Math.floor(Math.random() * GAME_ID_RANGE) + GAME_ID_MINIMUM;
        return this.games.has(newId) ? this.generateGameId() : newId;
    }
}
