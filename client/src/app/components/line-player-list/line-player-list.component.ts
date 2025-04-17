import { Component, ElementRef, Input, OnChanges, ViewChild } from '@angular/core';
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
    selector: 'app-line-playerlist',
    templateUrl: './line-player-list.component.html',
    styleUrls: ['./line-player-list.component.scss'],
})
export class LinePlayerListComponent implements OnChanges {
    @Input() showScore: boolean = false;
    @Input() showBonus: boolean = false;
    @Input() showRoundSurvived: boolean = false;
    @Input() canBanPlayer: boolean = false;
    @Input() canMutePlayer: boolean = false;
    @Input() sortFunction = (players: Player[]) => players;
    @Input() reducedView: boolean = false;
    @Input() displayHeader: boolean = false;
    @Input() maxHeight: string = 'auto';

    @ViewChild('difficultyContainer') difficultyContainer: ElementRef | undefined;

    gridTemplateColumns = 'minmax(100px, auto) auto';

    difficulties = Object.values(BotDifficulty);

    isBotPlayer = isBotPlayer;

    get players() {
        return this.playersService.getPlayersObservable().pipe(map(this.sortFunction)).pipe(map((players) => {
            return players;
        }));
    }

    constructor(
        private readonly gameLobbyService: GameLobbyService,
        private readonly translate: TranslateService,
        private readonly chatBanService: ChatBanManagerService,
        private readonly playersService: GamePlayersStatService,
        private readonly userService: UsersService,
    ) {}

    ngOnChanges() {
        this.updateGridColumns();
    }

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
        if (!this.canMutePlayer) return;
        this.chatBanService.banUser(player.name);
    }

    onDifficultyChange(player: any): void {
        this.gameLobbyService.updateBotDifficulty(player.name, player.difficulty);
    }

    translateDifficulty(difficulty: BotDifficulty): string {
        return this.translate.instant('BotDifficulty.' + difficulty);
    }

    private updateGridColumns(): void {
        let nameColumn = '2fr';
        let regularColumn = '1fr';
        let columns = [nameColumn];

        if (this.showScore && !this.showBonus) columns.push(`${regularColumn}`);
        if (this.showScore && this.showBonus) columns.push(`${regularColumn} ${regularColumn}`);
        if (this.showRoundSurvived) columns.push(regularColumn);
        if (this.canBanPlayer) columns.push('0.3fr');
        if (this.canMutePlayer) columns.push('1fr');

        this.gridTemplateColumns = columns.join(' ');
    }
}
