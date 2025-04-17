import { Component, Input } from '@angular/core';
import { GameInfoService } from '@app/services/game-services/game-info.service';
import { ROUND_SORT_FUNCTION, SCORE_SORT_FUNCTION } from '@app/services/game-services/game-players-stat.service';
import { GameType } from '@common/enums/game-type';
import { UserGameRole } from '@common/enums/user-game-role';

@Component({
	selector: 'app-game-player-list',
	templateUrl: './game-player-list.component.html',
	styleUrls: ['./game-player-list.component.scss']
})
export class GamePlayerListComponent {
	@Input() userRole: UserGameRole = UserGameRole.None;

	get isClassicalGame() {
		return this.gameInfo.getGameType() === GameType.NormalGame;
	}

	get sortFunction() {
		return this.isClassicalGame ? SCORE_SORT_FUNCTION : ROUND_SORT_FUNCTION;
	}

	constructor(private readonly gameInfo: GameInfoService) { }
}
