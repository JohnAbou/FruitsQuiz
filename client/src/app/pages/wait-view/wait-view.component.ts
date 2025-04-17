import { Component, Input, AfterViewInit } from '@angular/core';
import { GameLobbyService } from '@app/services/game-services/game-lobby.service';
import { GamePlayersStatService } from '@app/services/game-services/game-players-stat.service';
import { map } from 'rxjs';
import { isBotPlayer } from '@common/interfaces/bot-player';

@Component({
    selector: 'app-wait-view',
    templateUrl: './wait-view.component.html',
    styleUrls: ['./wait-view.component.scss'],
})
export class WaitViewComponent implements AfterViewInit {
    @Input() isOrganiser: boolean = true;

    constructor(
        private gameLobbyService: GameLobbyService,
        private readonly playersService: GamePlayersStatService,

    ) {

    }

    get roomLocked() {
        return this.gameLobbyService.isLobbyLocked;
    }

    get friendsOnly() {
        return this.gameLobbyService.isFriendsOnly;
    }

    ngAfterViewInit(): void {
        this.gameLobbyService.resetState();
      
    }

    startGame() {
        this.gameLobbyService.startGame();
    }

    canStartGame() {
        return this.gameLobbyService.canStartGame.asObservable();
    }

    toggleLobbyLock() {
        this.gameLobbyService.toggleLobbyLock();
    }

    canAddBot() {
        return this.playersService.getPlayersObservable().pipe(
            map((players) => {
                const nBots = players.filter((p) => isBotPlayer(p)).length;
                return nBots < 6;
            }),
        );
    }

    addBot() {
        this.gameLobbyService.addBot();
    }
}
