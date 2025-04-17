import { Injectable } from '@angular/core';
import { GamePlayerSocketEvent } from '@common/enums/socket-event/game-player-socket-event';
import { Player } from '@common/interfaces/player';
import { BehaviorSubject } from 'rxjs';
import { GameListenerService } from './base-classes/game-listener.service';

export const SCORE_SORT_FUNCTION = (players: Player[]) =>
    players.sort(
        // Score -> Average Answer Time -> Name
        (a, b) => (b.score !== a.score 
            ? b.score - a.score 
            : a.averageAnswerTime !== b.averageAnswerTime 
                ? a.averageAnswerTime - b.averageAnswerTime 
                : a.name.toLocaleLowerCase().localeCompare(b.name.toLocaleLowerCase())),
    );

export const ROUND_SORT_FUNCTION = (players: Player[]) =>
    players.sort(
        // Round Survived -> Average Answer Time -> Name
        (a, b) =>
            b.roundSurvived !== a.roundSurvived
                ? b.roundSurvived - a.roundSurvived
                : a.averageAnswerTime !== b.averageAnswerTime
                    ? a.averageAnswerTime - b.averageAnswerTime
                    : a.name.toLocaleLowerCase().localeCompare(b.name.toLocaleLowerCase()),
    );

@Injectable({
    providedIn: 'root',
})
export class GamePlayersStatService extends GameListenerService {
    private playersBehaviorSubject: BehaviorSubject<Player[]>;

    getPlayersObservable() {
        return this.playersBehaviorSubject.asObservable();
    }

    protected setUpSocket() {
        this.socketService.on(GamePlayerSocketEvent.SendPlayerJoined, (player: Player) => this.addPlayer(player));
        this.socketService.on(GamePlayerSocketEvent.SendPlayerLeft, (player: Player) => this.removePlayer(player));

        this.socketService.on(GamePlayerSocketEvent.SendPlayerStats, (players: Player[]) => this.updatePlayersBehaviorSubject(players));
    }

    protected initializeState() {
        this.playersBehaviorSubject ??= new BehaviorSubject<Player[]>([]);
        this.playersBehaviorSubject.next([]);
    }

    private addPlayer(newPlayer: Player) {
        const currentPlayers = this.playersBehaviorSubject.getValue();
        const updatedPlayers = [...currentPlayers, newPlayer];
        this.updatePlayersBehaviorSubject(updatedPlayers);
    }

    private removePlayer(playerLeaving: Player) {
        const currentPlayers = this.playersBehaviorSubject.getValue().filter((player) => player.name !== playerLeaving.name);
        this.updatePlayersBehaviorSubject(currentPlayers);
    }

    private updatePlayersBehaviorSubject(updatedPlayers: Player[]) {
        this.playersBehaviorSubject.next(updatedPlayers);
    }
}
