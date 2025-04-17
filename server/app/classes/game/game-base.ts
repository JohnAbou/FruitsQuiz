import { Player } from '@app/interfaces/users/player';
import { GameConfig } from '@app/interfaces/game-config';
import { Quiz } from '@common/interfaces/quiz';
import { Subject } from 'rxjs';
import { UserRemoved } from '@app/interfaces/users/user-removed';
import { UserGameState } from '@common/enums/user-game-state';
import { GamePlaySocketEvent } from '@common/enums/socket-event/game-play-socket-event';
import { UserGameRole } from '@common/enums/user-game-role';
import { BotPlayer } from '../bot-player';
import { MockClient } from '../mock-client';

export class GameBase {
    removedGameSubject: Subject<void> = new Subject();
    removedUserSubject: Subject<UserRemoved> = new Subject();
    gameInfoChangedSubject: Subject<void> = new Subject();

    organizer: Player;
    players: Player[];
    gameId: number;
    quiz: Quiz;

    constructor(config: GameConfig) {
        this.organizer = config.organizer;
        this.gameId = config.gameId;
        this.quiz = config.quiz;
        this.players = [];
    }

    get users(): Player[] {
        return [this.organizer, ...this.players].filter((user) => user);
    }

    get realUsers(): Player[] {
        return this.users.filter((user) => !(user instanceof BotPlayer) && !(user instanceof MockClient));
    }

    get realPlayers(): Player[] {
        return this.players.filter((player) => !(player instanceof BotPlayer) && !(player instanceof MockClient));
    }

    getUser(userId: string) {
        return this.users.find((user) => user.id === userId);
    }

    setPlayers(players: Player[]) {
        this.players = players;
    }

    getGameConfig(): GameConfig {
        return { gameId: this.gameId, organizer: this.organizer, quiz: this.quiz };
    }

    removePlayer(playerToRemove: Player, reason?: number) {
        const removedPlayer = this.findPlayerByName(playerToRemove.name);
        if (!removedPlayer) return;

        this.players = this.players.filter((player) => player.name !== playerToRemove.name);
        this.removedUserSubject.next({ user: playerToRemove, reason: reason ?? 0 });
        this.gameInfoChangedSubject.next();
    }

    onOrganizerLeft() {
        this.removeOrganizer();
        this.players.forEach((player) => this.removePlayer(player, 21000));
        this.clearGame();
    }

    clearGame() {
        this.removedGameSubject.next();
    }

    protected findPlayerByName(playerName: string) {
        return this.players.find((player) => player.name === playerName);
    }

    protected areTherePlayerLeft() {
        return !!this.players.length;
    }

    protected updateUsersState(state: UserGameState) {
        this.users.forEach((user) => this.updateUserState(user, state));
    }

    protected updateUserState(user: Player, state: UserGameState) {
        user.emitToUser(GamePlaySocketEvent.UpdateGameState, state);
    }

    protected updateUserRole(user: Player, role: UserGameRole) {
        user.emitToUser(GamePlaySocketEvent.UpdateGameRole, role);
    }

    protected removeOrganizer(reason?: number) {
        if (this.organizer instanceof MockClient) return;
        this.removedUserSubject.next({ user: this.organizer, reason: reason ?? 0 });
        this.organizer = new MockClient();
    }
}
