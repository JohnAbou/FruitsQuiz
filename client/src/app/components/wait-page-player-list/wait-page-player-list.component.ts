import { Component, Input } from '@angular/core';
import { BAN_ICON, NOT_BAN_ICON } from '@app/consts/file-consts';
import { ChatBanManagerService } from '@app/services/chat-services/chat-ban-manager.service';
import { GameLobbyService } from '@app/services/game-services/game-lobby.service';
import { GamePlayersStatService } from '@app/services/game-services/game-players-stat.service';
import { UsersService } from '@app/services/users.service';
import { BotDifficulty, isBotPlayer } from '@common/interfaces/bot-player';
import { Player } from '@common/interfaces/player';
import { TranslateService } from '@ngx-translate/core';
import { map } from 'rxjs';

@Component({
    selector: 'app-wait-page-player-list',
    templateUrl: './wait-page-player-list.component.html',
    styleUrls: ['./wait-page-player-list.component.scss'],
})
export class WaitPagePlayerListComponent {
    @Input() canBanPlayer: boolean = false;
    @Input() sortFunction = (players: Player[]) => players;

    difficulties = Object.values(BotDifficulty);

    isBotPlayer = isBotPlayer;

    get players() {
        return this.playersService.getPlayersObservable().pipe(map(this.sortFunction));
    }

    constructor(
        private readonly gameLobbyService: GameLobbyService,
        private readonly translate: TranslateService,
        private readonly chatBanService: ChatBanManagerService,
        private readonly playersService: GamePlayersStatService,
        private readonly userService: UsersService,
    ) {}

    getPlayerUser(player: Player) {
        return this.userService.getUserByUsername(player.name);
    }

    getIconPath(player: Player) {
        return this.chatBanService.isUserBanned(player.name) ? BAN_ICON : NOT_BAN_ICON;
    }

    removePlayer(player: Player) {
        if (isBotPlayer(player)) {
            this.gameLobbyService.removeBot(player.name);
            return;
        }
        this.gameLobbyService.banPlayer(player.name);
    }

    banPlayer(player: Player) {
        if (!this.canBanPlayer) return;
        this.chatBanService.banUser(player.name);
    }

    onDifficultyChange(player: any): void {
        this.gameLobbyService.updateBotDifficulty(player.name, player.difficulty);
    }

    translateDifficulty(difficulty: BotDifficulty): string {
        return this.translate.instant('BotDifficulty.' + difficulty);
    }
}
