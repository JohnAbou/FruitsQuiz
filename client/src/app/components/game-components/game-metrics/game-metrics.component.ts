import { Component } from '@angular/core';
import { GameResultsService } from '@app/services/game-services/game-results.service';
import { formatTime } from '@app/utils/format-time';

@Component({
	selector: 'app-game-metrics',
	templateUrl: './game-metrics.component.html',
	styleUrls: ['./game-metrics.component.scss']
})
export class GameMetricsComponent {
	get gameMetricsUpdate() {
		return this.gameResultsService.gameMetricsUpdate;
	}

	get gameTimesUpdate() {
		return this.gameResultsService.gameTimeUpdate;
	}

	get gameWinStreakUpdate() {
		return this.gameResultsService.winStreakUpdate;
	}

	constructor(private readonly gameResultsService: GameResultsService) {}

	formatTimeUtil(time: number) {
		return formatTime(time);
	}
}
