import { Component } from '@angular/core';
import { GameResultsService } from '@app/services/game-services/game-results.service';

@Component({
	selector: 'app-game-win-streak',
	templateUrl: './game-win-streak.component.html',
	styleUrls: ['./game-win-streak.component.scss']
})
export class GameWinStreakComponent {
	get winStreakUpdate() {
		return this.gameResultsService.winStreakUpdate;
	}

	constructor(private readonly gameResultsService: GameResultsService) {}
}
