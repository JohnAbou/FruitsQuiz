import { Player } from '@app/interfaces/users/player';
import { BotPlayer } from '@app/classes/bot-player';
import { GameBase } from './game-base';
import { Response } from '@common/interfaces/response/response';
import { createSuccessfulResponse, createUnsuccessfulResponse } from '@app/utils/responses.utils';
import { GameConfig } from '@app/interfaces/game-config';
import { Subject } from 'rxjs';
import { GameSessionBase } from './game-session-base';
import { UserGameState } from '@common/enums/user-game-state';
import { GameInfo } from '@common/interfaces/game-info';
import { translatePlayers } from '@app/utils/translate.utils';
import { GameType } from '@common/enums/game-type';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { GameManagementSocketEvent } from '@common/enums/socket-event/game-management-socket-event';
import { UserGameRole } from '@common/enums/user-game-role';
import Container from 'typedi';
import { FriendsManagerService } from '@app/services/users/friends-manager.service';
import { Challenge } from '@app/classes/challenges/challenge';
import { AnswerStreakChallenge } from '../challenges/answer-streak-challenge';
import { AnswerTimeChallenge } from '../challenges/answer-time-challenge';
import { BonusChallenge } from '../challenges/bonus-challenge';
import { QCMMasterChallenge, QREMasterChallenge, QRLMasterChallenge } from '../challenges/question-master-challenge';
import { LastToAnswerChallenge } from '../challenges/last-to-answer-challenge';
import { GameEntryFeeService } from '@app/services/game/game-entry-fee.service';
import { UserDataManager } from '@app/services/data/user-data-manager.service';

export class GameLobby extends GameBase {
    gameStartedSubject: Subject<GameSessionBase> = new Subject();
    addedPlayerSubject: Subject<Player> = new Subject();

    futureGameType: GameType;
    challenges: Map<string, Challenge> = new Map();
    entryFeeManager: GameEntryFeeService;

    private isLocked: boolean = false;
    private isFriendsOnly: boolean = false;
    private bannedPlayer: Set<string> = new Set();

    constructor(config: GameConfig, isFriendsOnly: boolean, entryFee: number) {
        super(config);
        this.isFriendsOnly = isFriendsOnly;
        this.entryFeeManager = new GameEntryFeeService(entryFee, Container.get(UserDataManager));
        this.futureGameType = config.futureGameType;

        this.initializeUser(this.organizer, UserGameRole.Organizer);
        if (this.futureGameType === GameType.EliminationGame) this.initializeChallenge(this.organizer);
    }

    isGameLocked() {
        return this.isLocked;
    }

    canStartGame(): boolean {
        if (!this.isLocked) return false;

        let neededPlayers = this.futureGameType === GameType.NormalGame ? 1 : 0;
        if (this.entryFeeManager.getEntryFee() > 0) neededPlayers++;

        return this.players.length >= neededPlayers;
    }

    async canJoinGame(player: Player): Promise<Response> {
        if (this.isFriendsOnly) {
            let allowedFriends = await Container.get(FriendsManagerService).getUserFriends(this.organizer.name);
            if (!allowedFriends.find((friendName) => friendName === player.name)) return createUnsuccessfulResponse(10015);
        }

        if (this.isLocked) return createUnsuccessfulResponse(10005);

        const canJoin = await this.entryFeeManager.attemptToJoin(player);
        if (!canJoin) return createUnsuccessfulResponse(10016);

        return createSuccessfulResponse();
    }

    gameStarted(game: GameSessionBase) {
        this.gameStartedSubject.next(game);
        this.removedGameSubject.complete();
    }

    toggleLock(): boolean {
        this.isLocked = !this.isLocked;
        this.gameInfoChangedSubject.next();
        this.sendCanStartGameInfo();
        return this.isLocked;
    }

    toggleFriendsOnly(): boolean {
        this.isFriendsOnly = !this.isFriendsOnly;
        this.gameInfoChangedSubject.next();
        return this.isFriendsOnly;
    }

    async addPlayer(player: Player): Promise<Response> {
        if (this.bannedPlayer.has(player.name)) return createUnsuccessfulResponse(10010);
        const canJoingGameResponse = await this.canJoinGame(player);
        if (!canJoingGameResponse.success) return canJoingGameResponse;


        this.players.push(player);

        this.initializeUser(player);
        this.initializeChallenge(player);
        this.addedPlayerSubject.next(player);

        player.emitToUser(GamePlayerSocketEvent.SendPlayerStats, translatePlayers(this.players));
        this.gameInfoChangedSubject.next();
        this.sendCanStartGameInfo();
        return createSuccessfulResponse();
    }

    removePlayer(playerToRemove: Player, reason?: number): void {
        super.removePlayer(playerToRemove, reason);
        this.challenges.delete(playerToRemove.id);
        this.entryFeeManager.leaveGame(playerToRemove);
        this.sendCanStartGameInfo();
    }

    banPlayer(playerName: string) {
        const playerToBan = this.findPlayerByName(playerName);
        if (!playerToBan) return;

        this.removePlayer(playerToBan, 21010);
        this.bannedPlayer.add(playerName);
    }

    addBot(): void {
        const botPlayer = new BotPlayer();
        this.players.push(botPlayer);
        this.addedPlayerSubject.next(botPlayer);
        this.entryFeeManager.addBot();
        this.gameInfoChangedSubject.next();
        this.sendCanStartGameInfo();
    }

    removeBot(playerName: string): void {
        const botToRemove = this.findPlayerByName(playerName);
        if (botToRemove) {
            this.removePlayer(botToRemove);
            this.entryFeeManager.removeBot();
        }
    }

    updateBotDifficulty(playerName: string, difficulty: string): void {
        const botPlayer = this.findPlayerByName(playerName);
        if (botPlayer) {
            (botPlayer as any).difficulty = difficulty;
            this.gameInfoChangedSubject.next();
            this.users.forEach((user) => {
                user.emitToUser(GamePlayerSocketEvent.SendPlayerStats, translatePlayers(this.players));
            });
        }
    }

    private sendCanStartGameInfo() {
        this.organizer?.emitToUser(GameManagementSocketEvent.CanStartGame, this.canStartGame());
    }

    private initializeUser(player: Player, role: UserGameRole = UserGameRole.Player) {
        const gameInfo: GameInfo = {
            gameId: this.gameId,
            quizToPlay: this.quiz,
            gameType: this.futureGameType,
            isLocked: false,
            playersNb: this.players.length,
            entryFee: this.entryFeeManager.getEntryFee(),
        };
        player.emitToUser(GamePlaySocketEvent.SendGameInfo, gameInfo);
        this.updateUserState(player, UserGameState.InLobby);
        this.updateUserRole(player, role);
    }

    private initializeChallenge(player: Player) {
        const availableChallenges = this.getAvailableChallenges();
        const challenge = availableChallenges[Math.floor(Math.random() * availableChallenges.length)];

        player.emitToUser(GamePlayerSocketEvent.SendChallenge, challenge.getInfo());
        this.challenges.set(player.id, challenge);
    }

    private getAvailableChallenges(): Challenge[] {
        return ChallengeTypes.map((challengeType) => new challengeType()).filter((challenge) => challenge.isAvailable(this));
    }
}

const ChallengeTypes = [
    AnswerStreakChallenge,
    AnswerTimeChallenge,
    BonusChallenge,
    QCMMasterChallenge,
    QRLMasterChallenge,
    QREMasterChallenge,
    LastToAnswerChallenge,
];
