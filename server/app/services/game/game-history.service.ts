import { Service } from 'typedi';
import { DataManagerService } from '@app/services/data/data-manager.service';
import { GameBase } from '@app/classes/game/game-base';
import { GAME_LOG_COLLECTION } from '@app/consts/database.consts';
import { GameSessionBase } from '@app/classes/game/game-session-base';
import { GameLog } from '@app/interfaces/game-log';
import { randomUUID } from 'crypto';


interface GameLogInfo {
    startDate: Date,
    startingUsersId: string[];
    doneUsersId: string[];
    organizerLeft: boolean;
}

@Service()
export class GameHistoryService {
    private registeredGames: Map<number, GameLogInfo>;

    constructor(
        private dataManagerService: DataManagerService<GameLog>,
    ) {
        this.dataManagerService.setCollection(GAME_LOG_COLLECTION);
        this.registeredGames = new Map();
    }

    registerToHistory(gameToRegister: GameSessionBase) {
        const info: GameLogInfo = {
            startDate: new Date(),
            startingUsersId: this.getRealUsers(gameToRegister),
            doneUsersId: [],
            organizerLeft: false,
        }

        this.registeredGames.set(gameToRegister.gameId, info);
    }

    unregisterFromHistory(gameToUnregister: GameSessionBase) {
        this.registeredGames.delete(gameToUnregister.gameId);
    }

    userLeftGame(game: GameSessionBase, userId: string) {
        const info = this.getGameLogInfo(game);
        if (!info) return;

        info.doneUsersId.push(userId);
        this.dataManagerService.addElement({
            id: randomUUID(),
            userId: userId,
            date: info.startDate,
            hasAbandon: true,
            hasWon: false,
        });
    }

    organizerLeftGame(game: GameSessionBase) {
        const info = this.getGameLogInfo(game);
        if (!info) return;
        info.organizerLeft = true;
    }

    onGameRemoved(game: GameSessionBase) {
        const info = this.getGameLogInfo(game);
        if (!info) return;

        this.unregisterFromHistory(game);
        const currentUsersId = new Set(this.getRealUsers(game));

        const organizerId = game.organizer.id;


        info.startingUsersId.forEach((userId) => {
            if (info.doneUsersId.includes(userId)) return;
            this.dataManagerService.addElement({
                id: randomUUID(),
                userId: userId,
                date: info.startDate,
                hasAbandon: userId === organizerId ? info.organizerLeft : !info.organizerLeft && !currentUsersId.has(userId),
                hasWon: false,
            });
        });
    }

    async saveGameToHistory(gameToSave: GameSessionBase) {
        const info = this.getGameLogInfo(gameToSave);
        if (!info) return;

        this.unregisterFromHistory(gameToSave);
        const winnerId = gameToSave.getGameResult().winner?.id;
        const currentUsersId = new Set(this.getRealUsers(gameToSave));

        info.startingUsersId.forEach((userId) => {
            this.dataManagerService.addElement({
                id: randomUUID(),
                userId: userId,
                date: info.startDate,
                hasAbandon: !currentUsersId.has(userId),
                hasWon: winnerId === userId,
            });
        });
    }

    async getUserHistory(userId: string) {
        return this.dataManagerService.getElementsByFilter({ userId });
    }

    private getGameLogInfo(game: GameBase) {
        const gameId = game.gameId;
        return this.registeredGames.get(gameId);
    }
    
    private getRealUsers(game: GameSessionBase) {
        return game.realUsers.map((user) => user.id);
    }
}
