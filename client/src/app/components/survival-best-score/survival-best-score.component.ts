import { Component } from '@angular/core';
import { GameSurvivalService } from '@app/services/game-services/game-survival.service';

@Component({
	selector: 'app-survival-best-score',
	templateUrl: './survival-best-score.component.html',
	styleUrls: ['./survival-best-score.component.scss']
})
export class SurvivalBestScoreComponent {

	get survivalResult() {
		return this.gameSurvivalService.survivalResultObservable;
	}

	get questionSurvived() {
		return this.gameSurvivalService.questionSurvivedObservable;
	}

	constructor(
		private readonly gameSurvivalService: GameSurvivalService,
	) { }
}
